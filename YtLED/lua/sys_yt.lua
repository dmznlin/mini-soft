--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： 宇通led屏
-------------------------------------------------------------------------------]]
local tag = "ytLed"
--class
local ytLED = {}

--config
local options = require("znlib_cfg").load_default("yt", {})
if isDebug then
  log.info(tag, utils.table_to_str(options))
end

local link = options.link
local uart_id = link.uart_id

--modbus lib
local modbus = require("modbus_rtu")

function ytLED:start()
  local config = {
    uartid = uart_id,          -- 串口ID
    baudrate = link.baud_rate, -- 波特率
    databits = link.data_bits, -- 数据位
    stopbits = link.stop_bits, -- 停止位
    parity = link.parity_bits, -- 校验位

    endianness = uart.LSB,     -- 字节序
    buffer_size = 1024,        -- 缓冲区大小
    gpio_485 = 25,             -- 485转向GPIO
    rx_level = 0,              -- 485模式下RX的GPIO电平
    tx_delay = 10000,          -- 485模式下TX向RX转换的延迟时间（us）
  }

  -- 初始化
  modbus.init(config)

  -- 定义modbus_rtu数据接收回调
  local function on_modbus_rtu_receive(frame)
    local ss = options.senser
    if frame.addr ~= ss.addr or frame.fun ~= 0x03 then --读传感器指令
      return
    end

    local temp
    local payload = frame.payload

    if ss.msb then -- 大端序解析
      temp = (payload:byte(1) * 256) + payload:byte(2)
    else
      temp = (payload:byte(2) * 256) + payload:byte(1)
    end

    if isDebug then
      log.info(tag, temp)
    end

    local led = options.led
    local dt = utils.val_to_hex(led.addr, 4) .. " " .. utils.val_to_hex(temp, 4)
    --两位数据地址,两位数据长度

    modbus.set_msb(led.msb == 1)
    --处理大小端

    local buf = utils.str_from_hex(dt)
    modbus.send_command(uart_id, led.unit, 0x06, buf)
    --转发至屏幕
  end

  -- 设置modbus_rtu数据接收回调
  modbus.set_receive_callback(uart_id, on_modbus_rtu_receive)

  -- 读取传感器温度
  local function readTemp()
    local ss = options.senser
    local dt = utils.val_to_hex(ss.addr, 4) .. " " .. utils.val_to_hex(1, 4)
    --两位数据地址,两位数据长度

    modbus.set_msb(ss.msb == 1)
    --处理大小端

    local buf = utils.str_from_hex(dt)
    modbus.send_command(uart_id, ss.unit, 0x03, buf)
  end

  while true do
    readTemp()
    sys.wait(1 * 1000)
  end
end

return ytLED
