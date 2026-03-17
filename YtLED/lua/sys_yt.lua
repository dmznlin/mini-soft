--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： 宇通led屏
-------------------------------------------------------------------------------]]
local tag = "ytLed"
--class
local ytLED = {}

function ytLED:start()
  local cfg = require("znlib_cfg").load_default("yt", {})
  if isDebug then
    log.info(tag, utils.table_to_str(cfg))
  end

  --modbus
  local modbus = require("znlib_modbus")

  local config = {
    uart_id = cfg.link.uart_id,         --串口ID
    baud_rate = cfg.link.baud_rate,     --波特率
    data_bits = cfg.link.data_bits,     --数据位
    stop_bits = cfg.link.stop_bits,     --停止位
    parity_bits = cfg.link.parity_bits, --校验位
    byte_order = uart.LSB,              --字节顺序
    buf_size = 64,                      --接收缓冲大小
    --rs485_dir_gpio = 25,     --RS485 方向转换 GPIO 引脚
    --rs485_dir_rx_level = 0   --RS485 接收方向电平：0 为低电平，1 为高电平
  }

  local rtu = modbus:create(config)
  if not rtu then
    return
  end

  local read = {
    op_type = modbus.READ_HOLDING_REGISTERS,
    slave_id = cfg.senser.unit,   --从站标识
    start_addr = cfg.senser.addr, --开始地址
    reg_count = 1,                --读取数量
    crc_order = cfg.senser.msb,   --字节顺序
    timeout = 1 * 1000            --等待超时
  }

  local write = {
    op_type = modbus.WRITE_SINGLE_HOLDING_REGISTER,
    slave_id = cfg.led.unit,   --从站标识
    start_addr = cfg.led.addr, --开始地址
    reg_count = 1,             --寄存器数
    reg_data = {},             --待写入数据
    crc_order = cfg.led.msb,   --字节顺序
    timeout = 1 * 1000         --等待超时
  }

  while true do
    local ok, dt = rtu:execute(read) --读取
    if ok and #dt > 0 then
      write.reg_data = { dt[1] }
      rtu:execute(write) --写入
    end

    sys.wait(1 * 1000)
  end
end

return ytLED
