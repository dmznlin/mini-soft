--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： 适用于合宙4G物联网模块的基础库
-------------------------------------------------------------------------------]]
local tag = "znlib"
local znlib = {}

Status_IP_Ready = "IP_READY"
--luat发送：网络就绪

Status_Net_Ready = "net_ready"
--系统消息：网络就位

Status_Log = "print_log"
--系统消息: 打印日志

Status_low_power = "low_power"
--系统消息: 进入低功耗

Status_NTP_Ready = "NTP_UPDATE";
--系统消息: 时间同步完毕

Status_OTA_Update = "ota_update"
--系统消息：OTA在线升级

Status_Mqtt_Connected = "mqtt_conn"
--系统消息：mqtt连接成功

Status_Mqtt_SubData = "mqtt_sub"
--系统消息: mqtt收到订阅数据

Status_Mqtt_PubData = "mqtt_pub"
--系统消息: mqtt发布数据

Device_ID = mcu.unique_id():toHex()
--设备ID,联网后会更新

Device_Expire = 0
--设备过期时间(时间戳)

local pm_a, pm_b, pm_reason = pm.lastReson()
--开机原因,用于判断是从休眠模块开机,还是电源/复位开机

local options = {
  log = {
    keep = 1800, --上行日志保持(秒)
    start = 20,  --开机上行启动日志(秒)
  },
  ota = {
    enable = true,         --ota启用
    update = 3600000 * 24, --更新间隔(毫秒)
  },
  low_power = {
    enable = true,      --低功耗启用
    start = "22:00:00", --时间: 低功耗开启,
    exit = "07:00:00",  --时间: 低功耗退出
  },
  ntp = {
    enable = true,        --ntp启用
    fresh = 3600000 * 24, --刷新间隔(毫秒)
    retry = 3600000       --异常后重试间隔(毫秒)
  }
}

---------------------------------------------------------------------------------
---计算系统过期时间
---@param key string 秘钥
---@param base number 过期时间
---@return number
---@return string
function znlib.expire_check(key, base)
  local cfg = require("znlib_cfg").load_default("key", {})
  if cfg.expire == nil or cfg.key == nil then --无效配置
    Device_Expire = base
    return base, ""
  end

  local encrypt = crypto.md5(key .. cfg.expire)
  if encrypt == cfg.key then
    Device_Expire = utils.time_from_str(cfg.expire)
  else
    Device_Expire = base
  end

  return Device_Expire, encrypt
end

--[[
  跨task通讯:
  1、sys.waitUntil(topic)
  2、sys.publish(topic)
  这种方法有个缺陷: 如果 publish 先执行,后 waitUntil 将无法接收消息

  解决方法:
  1、topic 触发前调用 register_loop_topic
  2、订阅topic获取触发结果和数据
  3、循环 publish 结果和数据

  调用演示:
  znlib.register_loop_topic(Status_Net_Ready)   --网络正常
  znlib.register_loop_topic(Status_NTP_Ready)   --时间同步完成
  znlib.register_loop_topic(EventType_MQTT_LOG) --日志上行正常
  znlib.start_loop_topic()
--]]

--循环触发主题列表
local status_loop_topic = {}

---注册一个需要循环触发的主题
---@param topic string 主题名称
---@param keep integer|nil 触发时长
---@param interval integer|nil 触发间隔
function znlib.register_loop_topic(topic, keep, interval)
  local tb = {
    active = false,                                    --未触发
    keep = (keep ~= nil) and keep or 10 * 1000,        --持续触发10秒
    interval = (interval ~= nil) and interval or 1000, --触发间隔1秒
  }

  local callback = function (...)
    if not tb.active then
      tb.active = true  --已触发
      tb.last = 0       --未执行
      tb.data = { ... } --触发数据
    end
  end

  --关联回调
  tb.callback = callback
  --注册topic
  status_loop_topic[topic] = tb

  --订阅topic接收数据
  sys.subscribe(topic, tb.callback)
end

---开启循环触发主题
---@param interval integer|nil 触发间隔
function znlib.start_loop_topic(interval)
  sys.taskInit(function (ivl)
    local keep = 0
    for _, v in pairs(status_loop_topic) do
      if v.keep > keep then --keep max
        keep = v.keep
      end
    end

    local idx = 0
    while idx <= keep do
      for k, v in pairs(status_loop_topic) do
        if v.active and idx - v.last >= v.interval then --已触发
          v.last = idx
          sys.publish(k, table.unpack(v.data))
        end
      end

      sys.wait(ivl)
      idx = idx + ivl
    end

    for k, v in pairs(status_loop_topic) do
      sys.unsubscribe(k, v.callback) --取消订阅
    end

    --清空主题列表
    status_loop_topic = nil
  end, (interval ~= nil and interval > 10) and interval or 200)
end

---------------------------------------------------------------------------------
--全局消息管理
Event = require("znlib_event")

--通过mqtt发送日志
EventType_MQTT_LOG = "mqtt_log"

--远程日志超时计时
local remote_log_init = 0

---设置远程日志计时
---@param val number 时间(秒)
---@param keep boolean|nil 保持
function znlib.remote_log_set(val, keep)
  if keep then
    remote_log_init = os.time() - options.log.keep + val
  else
    remote_log_init = val
  end
end

---本地输出日志,或上行至服务器
---@param event string 日志
---@param log_tag string|nil 标识符
function znlib.show_log(event, log_tag, level)
  if (#event) < 1 then -- empty
    return
  end

  log_tag = (log_tag ~= nil) and log_tag or tag    --日志标识符
  level = (level ~= nil) and level or log.LOG_INFO --默认: info
  local remote = false

  if remote_log_init > 0 then
    local cur = os.time()
    --30分钟内有效
    remote = (cur >= remote_log_init) and (cur - remote_log_init < options.log.keep)

    if not remote then
      remote_log_init = 0
    end
  end

  if level == log.LOG_INFO then
    log.info(log_tag, event)
  end

  if level == log.LOG_WARN then
    log.warn(log_tag, event)
  end

  if level == log.LOG_ERROR then
    log.error(log_tag, event)
  end

  if remote then --mqtt
    Event:trigger_callback(EventType_MQTT_LOG, log_tag .. ": " .. event)
  end
end

---------------------------------------------------------------------------------
---低功耗唤醒
---@return boolean
function znlib.low_power_awake()
  --pm_a: 0-上电/复位开机, 1-RTC开机, 2-WakeupIn/Pad/IO开机, 3-未知原因
  --pm_b: 0-普通开机(上电/复位),3-深睡眠开机,4-休眠开机
  if pm_a == 1 and pm_b == 3 then --深度睡眠醒来后,重启系统
    --mobile.flymode(0, false)      --退出飞行模式
    rtos.reboot()
    do return true end
  end

  return false
end

--[[
  date: 2025-05-07
  desc: 检查是否进入低功耗模式
--]]
function znlib.low_power_check()
  if pm_reason == 0 then
    log.info(tag, "PM: powerkey开机")
  elseif pm_reason == 1 then
    log.info(tag, "PM: 充电或者AT指令下载完成后开机")
  elseif pm_reason == 2 then
    log.info(tag, "PM: 闹钟开机")
  elseif pm_reason == 3 then
    log.info(tag, "PM: 软件重启")
  elseif pm_reason == 4 then
    log.info(tag, "PM: 未知原因")
  elseif pm_reason == 5 then
    log.info(tag, "PM: RESET键")
  elseif pm_reason == 6 then
    log.info(tag, "PM: 异常重启")
  elseif pm_reason == 7 then
    log.info(tag, "PM: 工具控制重启")
  elseif pm_reason == 8 then
    log.info(tag, "PM: 内部看门狗重启")
  elseif pm_reason == 9 then
    log.info(tag, "PM: 外部重启")
  elseif pm_reason == 10 then
    log.info(tag, "PM: 充电开机")
  end

  if not options.low_power.enable then --不启用
    return
  end

  --等待时间同步完成
  sys.waitUntil(Status_NTP_Ready)
  znlib.show_log("开始低功耗计时", "PM")

  --低功耗开启
  local lp_enabled = true
  --低功耗开启
  local l_h, l_m, l_s = options.low_power.start:match("(%d+):(%d+):(%d+)")
  --低功耗退出
  local e_h, e_m, e_s = options.low_power.exit:match("(%d+):(%d+):(%d+)")

  while true do
    ::continue::                                             --跳转坐标
    local ret, keep = sys.waitUntil(Status_low_power, 60000) --每1分钟
    if ret then                                              --低功耗开关
      lp_enabled = (keep > 0) and true or false
      if lp_enabled then
        znlib.show_log("低功耗已启用", "PM")
      else
        znlib.show_log("低功耗已关闭", "PM")
      end
    end

    if not lp_enabled then --low-powser disabled
      goto continue
    end

    if not ret then                 --超时: 没有服务器指令
      local cur = os.time()         --当前时间
      local dt = os.date("*t", cur) --拆分
      local l_in = os.time({        --开启时间
        year = dt.year,
        month = dt.month,
        day = dt.day,
        hour = l_h,
        min = l_m,
        sec = l_s
      }) - Time_make_diff

      local l_out = os.time({ --退出时间
        year = dt.year,
        month = dt.month,
        day = dt.day,
        hour = e_h,
        min = e_m,
        sec = e_s
      }) - Time_make_diff

      if l_in > l_out then --跨天退出
        dt = os.date("*t", cur + 24 * 3600);
        l_out = os.time({
          year = dt.year,
          month = dt.month,
          day = dt.day,
          hour = e_h,
          min = e_m,
          sec = e_s
        }) - Time_make_diff
      end

      --[[log.info("PM: 计时", os.date("%y-%m-%d %H:%M:%S", cur),
            os.date("%y-%m-%d %H:%M:%S", l_in),
            os.date("%y-%m-%d %H:%M:%S", l_out))
      --]]

      if (cur < l_in) or (cur > l_out) then --未到时间,已超时
        goto continue
      end

      keep = os.difftime(l_out, cur) --距离退出的秒数
    end

    znlib.show_log("进入休眠模式,keep " .. tostring(keep), "PM")
    sys.wait(2000) --wait remote log

    --进入飞行模式
    mobile.flymode(0, true)

    --如果是插着USB测试，需要关闭USB
    pm.power(pm.USB, false)

    --关闭GPS电源
    pm.power(pm.GPS, false)

    --关闭GPS有源天线电源
    pm.power(pm.GPS_ANT, false)

    -- id = 0 或者 id = 1 是, 最大休眠时长是2.5小时
    -- id >= 2是, 最大休眠时长是740小时
    pm.dtimerStart(2, keep * 1000)

    --[[
      IDLE   正常运行,就是无休眠
      LIGHT  轻休眠, CPU停止, RAM保持, 外设保持, 可中断唤醒. 部分型号支持从休眠处继续运行
      DEEP   深休眠, CPU停止, RAM掉电, 仅特殊引脚保持的休眠前的电平, 大部分管脚不能唤醒设备.
      HIB    彻底休眠, CPU停止, RAM掉电, 仅复位/特殊唤醒管脚可唤醒设备.
    --]]
    pm.request(pm.DEEP)
  end
end

---------------------------------------------------------------------------------
--[[
  date: 2025-05-07
  desc: 联网
--]]
function znlib.conn_net()
  -----------------------------
  -- 统一联网函数
  ----------------------------
  if wlan and wlan.connect then
    -- wifi
    local ssid = "ssid"
    local password = "pwd"
    log.info(tag, ssid, password)

    -- TODO 改成自动配网
    -- LED = gpio.setup(12, 0, gpio.PULLUP)
    wlan.init()
    wlan.setMode(wlan.STATION) -- 默认也是这个模式,不调用也可以
    Device_ID = wlan.getMac()
    wlan.connect(ssid, password, 1)
  elseif mobile then
    -- Air780E/Air600E系列
    --mobile.simid(2) -- 自动切换SIM卡
    -- LED = gpio.setup(27, 0, gpio.PULLUP)
    Device_ID = mobile.imei()
  elseif w5500 then
    -- w5500 以太网, 当前仅Air105支持
    w5500.init(spi.HSPI_0, 24000000, pin.PC14, pin.PC01, pin.PC00)
    w5500.config() --默认是DHCP模式
    w5500.bind(socket.ETH0)
    -- LED = gpio.setup(62, 0, gpio.PULLUP)
  elseif socket or mqtt then
    -- 适配的socket库也OK
    -- 没有其他操作, 单纯给个注释说明
  else
    -- 其他不认识的bsp, 循环提示一下吧
    while 1 do
      sys.wait(1000)
      log.info(tag, "本bsp可能未适配网络层, 请查证")
    end
  end

  log.info(tag, "联网中,请稍后...")
  sys.waitUntil(Status_IP_Ready)
  sys.publish(Status_Net_Ready, Device_ID)
end

---------------------------------------------------------------------------------
--[[
  date: 2025-05-07
  desc: 在线更新时间

  对于Cat.1模块, 移动/电信卡,通常会下发基站时间,那么sntp就不是必要的
  联通卡通常不会下发, 就需要sntp了
  sntp内置了几个常用的ntp服务器, 也支持自选服务器
--]]
function znlib.online_ntp()
  if not options.ntp.enable then return end
  sys.waitUntil(Status_Net_Ready)
  sys.wait(1000)

  local first = true
  while true do
    -- 使用内置的ntp服务器地址, 包括阿里ntp
    log.info(tag, "NTP: 开始同步时间")
    socket.sntp()

    -- 通常只需要几百毫秒就能成功
    local ret = sys.waitUntil(Status_NTP_Ready, 5000)
    if ret then
      if first then
        first = false
        if options.log.start > 0 then --开机后保持日志上行,用于跟踪日志
          znlib.remote_log_set(options.log.start, true)
        end
      end

      znlib.show_log("时间同步成功 " .. os.date("%Y-%m-%d %H:%M:%S"), "NTP")
      --每天一次
      sys.wait(options.ntp.fresh)
    else
      znlib.show_log("时间同步失败", "NTP")
      sys.wait(options.ntp.retry) -- 1小时后重试
    end
  end
end

---------------------------------------------------------------------------------
local ota_opts = {}
local function ota_cb(ret)
  if ret == 0 then
    znlib.show_log("下载成功,升级中...", "OTA")
    sys.wait(2000)
    rtos.reboot()
  elseif ret == 1 then
    znlib.show_log("连接失败,请检查url或服务器配置(是否为内网)", "OTA")
  elseif ret == 2 then
    znlib.show_log("url错误", "OTA")
  elseif ret == 3 then
    znlib.show_log("服务器断开,检查服务器白名单配置", "OTA")
  elseif ret == 4 then
    znlib.show_log("接收报文错误,检查模块固件或升级包内文件是否正常", "OTA")
  elseif ret == 5 then
    znlib.show_log("版本号错误(xxx.yyy.zzz)", "OTA")
  else
    znlib.show_log("未定义错误 " .. tostring(ret), "OTA")
  end
end

-- 使用iot平台进行升级
function znlib.ota_online()
  if not options.ota.enable then return end
  local libfota2 = require("libfota2")
  sys.waitUntil(Status_Net_Ready)

  local first = true
  while true do
    if first then --启动时检查1次
      first = false
      sys.wait(2000)
    else
      sys.waitUntil(Status_OTA_Update, options.ota.update) --默认每天1检
    end

    znlib.show_log("开始新版本确认", "OTA")
    sys.wait(500)
    libfota2.request(ota_cb, ota_opts)
  end
end

---------------------------------------------------------------------------------
--加载配置
options = require("znlib_cfg").load_default(tag, options)
log.info(tag, "log", utils.table_to_str(options.log))
log.info(tag, "ota", utils.table_to_str(options.ota))
log.info(tag, "ntp", utils.table_to_str(options.ntp))
log.info(tag, "power", utils.table_to_str(options.low_power))

return znlib
