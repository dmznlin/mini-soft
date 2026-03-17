--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-04-28
  描述： mqtt通道
-------------------------------------------------------------------------------]]
local tag = "mqtt"
--mqtt client
local mqttc = nil

log.info("启动mqtt服务")

--获取系统信息
local Cmd_Get_SysInfo = 1
--srv: {"cmd": 1}

--读取配置信息
local Cmd_load_config = 2
--srv: {"cmd": 2, "cfg": "yt"}

--写入配置信息
local Cmd_save_config = 3
--srv: {"cmd": 3, "cfg": "yt", "data":"" }

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

--创建 mqtt 实例
sys.taskInit(function ()
  if Device_ID == nil then
    return
  end

  mqttc = require("znlib_mqtt"):new()
  if not mqttc:open(Device_ID) then
    log.info(tag, "启动 mqtt 失败")
    return
  end

  --日志上行计时
  znlib.remote_log_set(os.time())

  --注册日志上行
  Event:register_callback(EventType_MQTT_LOG, function (event)
    local dt = { cmd = 0, log = event }
    Mqtt_send(json.encode(dt))
  end)

  while true do
    ::continue:: --跳转坐标
    local ret, topic, data, id = sys.waitUntil(Status_Mqtt_SubData)
    local srv, err = json.decode(data)

    if srv == nil or type(srv) ~= "table" or srv.cmd == nil then
      znlib.show_log("无效的命令格式(json)", "MQTT")
      goto continue
    end

    if srv.cmd == Cmd_Get_SysInfo then --运行信息
      local dt = { cmd = Cmd_Get_SysInfo, sys = utils.sys_info() }
      Mqtt_send(json.encode(dt))
      goto continue
    end

    if srv.cmd == Cmd_load_config then --load config
      if srv.cfg ~= nil and #srv.cfg > 0 then
        local opt = require("znlib_cfg").load_default(srv.cfg, {})
        local dt = { cmd = Cmd_save_config, cfg = srv.cfg, data = opt }
        Mqtt_send(json.encode(dt))
      end

      goto continue
    end

    if srv.cmd == Cmd_save_config then --save config
      if srv.cfg ~= nil and srv.data ~= nil then
        local _, s_file = require("znlib_cfg").save(srv.cfg, srv.data)
        local dt = { cmd = Cmd_save_config, cfg = srv.cfg, data = s_file }
        Mqtt_send(json.encode(dt))
      end

      goto continue
    end
  end
end)
