--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2026-03-17
  描述： mqtt tunnel server
-------------------------------------------------------------------------------]]
local tag       = "tunnel"
--mqtt client
local mqttc     = nil
--command utils
local cmd_utils = require("znlib_cmd"):new()

-- tunnel config
local tunnel    = {
  name = "",    --服务名称
  host = "",    --主机地址
  key = "",     --加密秘钥
  topic = "",   --协商主题
  cmd = "cmd",  --命令通道
  down = "down" --数据通道
}

---发送数据
---@param data string 数据
---@param topic string|nil 主题
---@param qos number|nil 消息级别
local function mqtt_send(data, topic, qos)
  if mqttc and mqttc:ready() then --mqtt connected
    if topic then                 --match topic name
      local tp = mqttc.pubs[topic]
      if tp then
        topic = tp.topic
        qos = (qos ~= nil) and qos or tp.qos
      end
    end

    qos = (qos ~= nil) and qos or 0
    mqttc:publish(topic, data, qos)
  end
end

--创建 mqtt 实例
sys.taskInit(function ()
  --等待联网
  local _, id = sys.waitUntil(Status_Net_Ready)

  mqttc = require("znlib_mqtt"):new()
  if not mqttc:open(id) then
    log.info(tag, "启动 mqtt 失败")
    return
  end

  --注册日志上行
  Event:register_callback(EventType_MQTT_LOG, function (event)
    local dt = { cmd = 0, log = event }
    mqtt_send(json.encode(dt))
  end)

  --日志上行计时
  znlib.remote_log_set(os.time())

  --载入配置
  local cfg = require("znlib_cfg").load_default("mqtt", {})

  --替换$ID$
  utils.table_replace(cfg, "%$id%$", id)

  tunnel.name = cfg.server.name
  tunnel.key = cfg.server.encrypt
  tunnel.topic = cfg.server.topic

  if #tunnel.key > 0 then
    tunnel.key = cmd_utils:des_encrypt(tunnel.key)
  end

  sys.publish(EventType_MQTT_LOG)
  --mqtt is ok
end)

---------------------------------------------------------------------------------
--命令字段、别名、顺序定义
local cmd_order      = {
  { short = "c", long = "cmd" },     --命令字
  { short = "s", long = "sender" },  --发送方
  { short = "p", long = "stamp" },   --流水号
  { short = "n", long = "srvName" }, --服务器
  { short = "t", long = "topic" },   --主题
  { short = "d", long = "data" },    --数据
  { short = "v", long = "verify" }   --验证
}

--命令定义
local CmdConnHost    = 5 --客户端: 向服务器发起连接请求
local CmdConnRep     = 6 --服务器: 连接结果反馈
local CmdConnBreak   = 7 --双向: tcp连接断开
local CmdBeginTrans  = 8 --客户端: 通知服务端开始传输
local CmdHintMessage = 9 --双向:发送提示消息

--反DDOS机制:命令时间戳
local lastStamp      = {}

local function cmd_ConnResponse()
  local cmd = {
    cmd = CmdConnRep,
    sender = Device_ID,
    stamp = os.time(),
    srvName = tunnel.name,
    topic = tunnel.topic,
    data = ""
  }

  mqtt_send(cmd_utils:encode(cmd, cmd_order))
end

--处理: 服务器 -> 设备数据
sys.taskInit(function ()
  --wait mqtt ok
  sys.waitUntil(EventType_MQTT_LOG)

  while true do
    local ret, topic, data, id = sys.waitUntil(Status_Mqtt_SubData)
    local cmd = cmd_utils:decode(data, cmd_order)

    if cmd == nil then
      goto continue
    end

    log.info(tag, utils.table_to_str(cmd))

    --忽略自己发出的指令
    if cmd.sender == Device_ID then
      return
    end

    --与请求的服务器名称不匹配
    if cmd.srvName ~= tunnel.name then
      return
    end

    local stamp = lastStamp[cmd.cmd]
    if stamp and os.time() - stamp > 5 then -- 时间戳5秒内失效
      return
    end


    ::continue:: --跳转坐标
  end
end)
