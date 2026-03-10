--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： 板载LED配置
-------------------------------------------------------------------------------]]
local tag = "led"
local led = {}
local options = {}

--- LED初始化
function led.init()
  -- 加载配置
  options = require("znlib_cfg").load_default(tag, { enable = false })
  if options.pins == nil then
    log.info(tag, "未配置引脚(gpio)参数")
  end

  -- 初始GPIO状态
  for k, v in pairs(options.pins) do
    log.info(tag, k, utils.table_to_str(v))
    gpio.setup(v.pin, v.mode, v.init)
  end

  --不启用状态灯
  if not options.enable then return end

  if options.pins["net"] then --网络灯
    sys.subscribe("IP_READY", function ()
      led.on("net")
    end)

    sys.subscribe("IP_LOSE", function ()
      led.off("net")
    end)
  end

  if options.pins["gps"] and libgnss then --gps
    sys.subscribe("GNSS_STATE", function (event, ticks)
      -- event取值有
      -- FIXED 定位成功
      -- LOSE  定位丢失
      -- ticks是事件发生的时间,一般可以忽略

      if libgnss.isFix() then
        led.on("gps")
      else
        led.off("gps")
      end
    end)
  end

  if options.pins["ready"] then --运行灯
    led.on("ready")
  end
end

---点亮LED
---@param id string 名称
function led.on(id)
  if options.enable then
    local pin = options.pins[id]
    if pin ~= nil then
      gpio.set(pin.pin, pin.on)
    end
  end
end

---关闭LED
---@param id string 名称
function led.off(id)
  if options.enable then
    local pin = options.pins[id]
    if pin ~= nil then
      gpio.set(pin.pin, pin.off)
    end
  end
end

-- 启动
led.init()

return led
