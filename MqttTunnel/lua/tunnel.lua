--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2026-03-17
  描述： mqtt tunnel server
-------------------------------------------------------------------------------]]
local tag           = "tunnel"
--mqtt client
local mqttc         = nil

--command utils
local cmd_utils     = require("znlib_cmd"):new()
cmd_utils.ver_lower = true --验证码小写

-- tunnel config
local tunnel        = {
  name = "",    --服务名称
  host = "",    --主机地址
  key = "",     --加密秘钥
  recv = "",    --接收方
  topic = "",   --协商主题
  cmd = "cmd",  --命令通道
  down = "down" --数据通道
}

---发送数据
---@param data string 数据
---@param topic string 主题
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

  tunnel.name = mqttc.utils.name
  tunnel.key = mqttc.utils.encrypt
  tunnel.topic = mqttc.utils.topic

  --clear
  mqttc.utils = nil

  if #tunnel.key > 0 then
    tunnel.key = cmd_utils:des_decrypt(tunnel.key)
    cmd_utils.key_msg = tunnel.key
  end
end)

---------------------------------------------------------------------------------
--命令字段、别名、顺序定义
local cmd_order      = {
  { short = "c", long = "cmd" },                --命令字
  { short = "p", long = "stamp" },              --流水号
  { short = "s", long = "sender" },             --发送方
  { short = "r", long = "receiver" },           --接收方
  { short = "t", long = "topic", omit = true }, --主题
  { short = "d", long = "data", omit = true },  --数据
  { short = "v", long = "verify", omit = true } --验证
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
    stamp = os.time(),
    sender = Device_ID,
    receiver = tunnel.recv,
    topic = tunnel.topic,
    data = ""
  }

  mqtt_send(cmd_utils:encode(cmd, cmd_order), tunnel.cmd)
end

local function cmd_HintMsg(recv, msg)
  local cmd = {
    cmd = CmdHintMessage,
    stamp = os.time(),
    sender = Device_ID,
    receiver = recv,
    data = msg
  }

  mqtt_send(cmd_utils:encode(cmd, cmd_order), tunnel.cmd)
end

--处理: 服务器 -> 设备数据
sys.taskInit(function ()
  while true do
    ::continue:: --跳转坐标
    local ret, topic, data, id = sys.waitUntil(Status_Mqtt_SubData)
    local cmd = cmd_utils:decode(data, cmd_order)

    if cmd == nil then
      goto continue
    end

    --忽略自己发出的指令
    if cmd.sender == Device_ID then
      goto continue
    end

    --与请求的服务器名称不匹配
    if (cmd.receiver ~= Device_ID) and      --接收方不是自己
        (cmd.cmd ~= CmdConnHost and         --除了服务器连接指令外
          cmd.receiver ~= tunnel.name) then --连接时的服务器名称
      goto continue
    end

    --反DDOS: 该时间戳已处理
    local stamp = lastStamp[cmd.cmd]
    if stamp == cmd.stamp then
      goto continue
    end

    --记录时间戳
    lastStamp[cmd.cmd] = cmd.stamp

    -- 时间戳5秒内失效
    if math.abs(os.time() - cmd.stamp) > 5 then
      cmd_HintMsg(cmd.sender,
        string.format("time isn't sync: server(%s) client(%s)", os.date("%H:%M:%S", os.time()),
          os.date("%H:%M:%S", cmd.stamp)))
      goto continue
    end

    if cmd.cmd == CmdConnHost then --连接
      tunnel.recv = cmd.sender
      tunnel.host = cmd.data
    end

    cmd_ConnResponse()
    log.info(tag, "done")
  end
end)
