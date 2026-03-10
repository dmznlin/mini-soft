--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： mqtt协议,支持多客户端
-------------------------------------------------------------------------------]]
local tag = "mqtt"
--class
local MQTT = {}

--[[
  date: 2025-05-07
  desc: 创建mqtt实例
--]]
function MQTT:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.client = nil
  return obj
end

---根据cfg_name连接mqtt-broker
---@param client_id string 客户端标识
---@param cfg_name string|nil 配置名称
---@return boolean
function MQTT:open(client_id, cfg_name)
  if mqtt == nil then
    log.info(tag, "本bsp未适配mqtt库,请查证")
    return false
  end

  if client_id == nil then
    log.info(tag, "open: 无效的 id 参数")
    return false
  end

  cfg_name = (cfg_name ~= nil) and cfg_name or tag
  local cfg = require("znlib_cfg").load_default(cfg_name, { enable = false })
  if not cfg.enable then
    log.info(tag, "通过配置项禁用mqtt功能")
    return false
  end

  --替换$ID$
  utils.table_replace(cfg, "%$id%$", client_id)

  --默认发布主题
  self.pub_def = ""
  for k, v in pairs(cfg.pubs) do
    log.info(tag, "pub", v.topic)
    if #self.pub_def < 1 or v.def == true then
      self.pub_def = k
    end
  end

  if #self.pub_def < 1 then
    log.info(tag, "没有可用(default)的发布主题")
    return false
  end

  for k, v in pairs(cfg.subs) do
    log.info(tag, "sub", v.topic)
  end

  self.client = mqtt.create(nil, cfg.host, cfg.port)
  if self.client == nil then
    log.error(tag, "create client failed")
    return false
  end

  self.id = cfg.client_id
  self.subs = cfg.subs
  self.pubs = cfg.pubs
  self.online = cfg.online

  self.client:auth(self.id, cfg.user_name, cfg.password) -- 鉴权
  self.client:keepalive(cfg.keep_alive)                  -- 默认值240s
  self.client:autoreconn(true, cfg.re_conn)              -- 自动重连机制

  if cfg.offline ~= nil then                             --离线通知
    local off = cfg.offline
    self.client:will(off.topic, off.msg, off.qos, off.retain)
  end

  -- 注册回调
  self.client:on(function (client, event, topic, payload)
    if event == "conack" then
      local topics = {}
      for k, v in pairs(self.subs) do
        topics[v.topic] = v.qos
      end

      client:subscribe(topics) --多主题订阅
      log.info(tag, self.id, "连接成功.")
      sys.publish(Status_Mqtt_Connected, self.id)

      if self.online ~= nil then --上线通知
        client:publish(self.online.topic, self.online.msg,
          self.online.qos, self.online.retain)
      end
    elseif event == "recv" then
      sys.publish(Status_Mqtt_SubData, topic, payload, self.id)
    elseif event == "sent" then
    elseif event == "disconnect" then
      log.info(tag, self.id, "已断开.")
    end
  end)

  log.info(tag, self.id, "连接中...")
  self.client:connect()
  sys.waitUntil(Status_Mqtt_Connected)
  return self.client:ready()
end

---发布消息
---@param topic string|nil 主题
---@param payload string 数据
---@param qos integer|nil 质量
---@return integer 消息id
function MQTT:publish(topic, payload, qos)
  if payload == nil or #payload < 1 then
    return 0
  end

  if topic == nil then
    local def = self.pubs[self.pub_def]
    topic = def.topic
    qos = def.qos
  end

  return self.client:publish(topic, payload, qos)
end

---获取topic信息
---@param topic string topic名称
---@param sub boolean|nil 订阅主题
---@return table
function MQTT:topic_info(topic, sub)
  if sub then
    return self.subs[topic]
  end

  return self.pubs[topic]
end

--- 关闭平台（不太需要）
function MQTT:close()
  if self.client ~= nil then
    self.client:close()
    self.client = nil
  end
end

--- @return boolean 状态
function MQTT:ready()
  return self.client ~= nil and self.client:ready()
end

return MQTT

--[[-----------------------------------------------------------------------------
--mqtt client
local mqttc = nil

---发送数据
---@param data string 数据
---@param topic string|nil 主题
---@param qos number|nil 消息级别
function Mqtt_send(data, topic, qos)
  if mqttc and mqttc:ready() then --mqtt connected
    qos = (qos ~= nil) and qos or 0
    mqttc:publish(topic, data, qos)
  end
end

sys.taskInit(function ()
  --等待联网
  local _, id = sys.waitUntil(Status_Net_Ready)
  --创建实例
  mqttc = require("znlib_mqtt"):new()

  if not mqttc:open(id) then
    log.info(tag, "启动 mqtt 失败")
    return
  end

  --注册日志上行
  Event:register_callback(EventType_MQTT_LOG, function (event)
    local dt = { cmd = Cmd_Run_log, log = event }
    Mqtt_send(json.encode(dt))
  end)

  sys.wait(1000)
  --日志上行OK
  sys.publish(EventType_MQTT_LOG)
end)

sys.taskInit(function ()
  while true do
    local ret, topic, data, id = sys.waitUntil(Status_Mqtt_SubData)
    log.info(tag, topic, data, id)
    -- do your work
  end
end)
-------------------------------------------------------------------------------]]
