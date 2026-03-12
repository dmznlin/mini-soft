--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-04-28
  描述： 主程序
-------------------------------------------------------------------------------]]
PROJECT = "yt-led"
VERSION = "1.0.1"
-- luatools needs

PRODUCT_KEY = ""
--在线升级

_G.sys = require("sys")         --standard
_G.sysplus = require("sysplus") --net needs

_G.isDebug = false
--true: 调试模式开
log.setLevel("INFO")

-- Air780E的AT固件默认会为开机键防抖, 导致部分用户刷机很麻烦
if rtos.bsp() == "EC618" and pm and pm.PWK_MODE then
  pm.power(pm.PWK_MODE, false)
end

--单元标识
local tag = "main"

--默认不联网
log.info(tag, "开始飞行模式")
mobile.flymode(0, true)

sys.taskInit(function ()
  --看门狗：3秒一喂，9秒超时
  --wdt.init(9000)
  --sys.timerLoopStart(wdt.feed, 3000)

  local dg = 28
  local air_wtd = require('air153C_wtd')

  air_wtd.init(dg)
  air_wtd.feed_dog(dg) --启动喂一次
  sys.wait(3000)

  log.info(tag, "开始喂狗")
  while true do
    air_wtd.feed_dog(dg) --28为看门狗控制引脚
    sys.wait(150 * 1000)
  end
end)

---------------------------------------------------------------------------------
_G.utils = require("znlib_utils") --global utils
_G.znlib = require("znlib")       --common lib

--休眠唤醒后,重启系统
if znlib.low_power_awake() then return end

--开始启动业务
log.info(string.format("启动中，系统:%s 内核:%s 标识:%s", VERSION, rtos.version(), Device_ID))

--板载指示灯
_G.led = require("znlib_led")

--过期检查
--local expire, encrypt = znlib.expire_check(PROJECT, utils.time_from_str("2026-05-01 10:00:00"))
--log.info("过期时间", utils.time_to_str(expire), encrypt)

sys.taskInit(function ()
  sys.waitUntil(Status_Net_Ready)
  _G.mt = require("sys_mqtt")
end)

sys.taskInit(function ()
  --时钟同步
  znlib.online_ntp()
end)

sys.taskInit(function ()
  --定时休眠
  znlib.low_power_check()
end)

sys.taskInit(function ()
  --主业务
  require("sys_yt"):start()
end)

sys.taskInit(function ()
  --开始联网
  local btn = nil
  local evt = gpio.setup(30, nil, gpio.PULLUP, gpio.FALLING)

  --等待按键
  for inc = 1, 10, 1 do --10秒内判定
    sys.wait(1000)
    if evt() == 0 then
      btn = {}
      break
    end
  end

  --有按键,开启网络
  if btn ~= nil then
    mobile.flymode(0, false)
    znlib.conn_net()
  end
end)

--代码结束
sys.run()
