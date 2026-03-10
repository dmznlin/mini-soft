--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-07
  描述： 辅助工具类
-------------------------------------------------------------------------------]]
local tag = "utils"
local utils = {}

--本地时间与UTC差值(秒)
Time_zone_diff = 8 * 3600

--[[
  local tm = os.time({
    year = 1970, month = 1, day = 1,
    hour = 8, min = 0, sec = 0 --东8区
  })
  log.info("tm", tm)

  上面的代码,在不同的系统上输出不同:
  1、输出0: 表示 os.time 带有时区,以本地时间为参考
  2、输出28800: 表示 os.time 不带时区,以 utc 时间为参考
  3、时间戳: os.time()不带参数时,返回 utc 时间戳

  例如本地时间 22:00:00 定时休眠: tm = os.time({hour = 22, min = 0, sec = 0}})
  1、utc的休眠时间为 14:00:00 点,即 os.time() >= 14点即可休眠
  2、若带时区,则 tm 已减去时区, 则可以和 os.time() 直接比对
  3、若不带时区,则 tm 表示utc 22点,本地时间是次日6点

  使用方法:
  1、Time_make_diff 表示使用 os.time() 构建时间时, 起始 0 的大小
  2、正确的 utc 时间为: os.time() - Time_make_diff
--]]
Time_make_diff = 0

function utils.init()
  --校准时区
  Time_zone_diff = utils.time_get_zone()

  --校准构建时间的时区差值
  Time_make_diff = os.time({
    year = 1970,
    month = 1,
    day = 1,
    hour = math.floor(Time_zone_diff / 3600),
    min = math.floor((Time_zone_diff % 3600) / 60),
    sec = 0
  })
end

---------------------------------------------------------------------------------
local id_base = 0  --序列基准
local id_date = "" --时间基准
--[[
  描述: 生成业务流水号
  格式:
    1.6位设备ID: device_id 后6位
    2.6位日期: 2位年 月 日
    3.6位时间: 时 分 秒
    4.序列号
--]]
function utils.make_id()
  local str = os.date("%y%m%d%H%M%S")
  if str ~= id_date then --时间变更,重置序列
    if id_base >= 9 then
      id_base = 0
    end

    id_date = tostring(str)
  end

  id_base = id_base + 1
  return string.sub(Device_ID, #Device_ID - 5) .. str .. tostring(id_base)
end

---系统信息
function utils.sys_info()
  local info = {}
  info["sys.name"] = PROJECT
  info["sys.ver"] = VERSION
  info["sys.core"] = rtos.version()

  info["id.cpu"] = mcu.unique_id():toHex()
  info["id.dev"] = Device_ID

  info["mem.sys"] = string.format("%d,%d,%d", rtos.meminfo("sys")) -- 系统内存
  info["mem.lua"] = string.format("%d,%d,%d", rtos.meminfo("lua")) -- 虚拟机内存

  if libgnss and libgnss.isFix() then                              --已定位
    local loc = libgnss.getRmc(2) or {}
    info["gps.lat"] = loc.lat                                      --纬度, 正数为北纬, 负数为南纬
    info["gps.lng"] = loc.lng                                      --经度, 正数为东经, 负数为西经

    local gsa = libgnss.getGsa()
    info["gps.gsa"] = gsa.sats --正在使用的卫星编号
  end

  return info
end

---------------------------------------------------------------------------------
---将str转为16进制表示
---@param str string 字符串
---@return string
---@return number
function utils.str_to_hex(str)
  return string.gsub(str, "(.)", function (x)
    return string.format("%02X ", string.byte(x))
  end):gsub(" $", "") --去除末尾空格
end

---将hex转为字符串
---@param hex string 16进制字符串
---@return string
---@return number
function utils.str_from_hex(hex)
  local str = hex:gsub("[%s%p]", ""):upper()
  return str:gsub("%x%x", function (c)
    return string.char(tonumber(c, 16))
  end)
end

--计算val的异或校验值
---@param val string 数据
---@param i number|nil 开始位置
---@param j number|nil 结束位置
---@param hex boolean|nil 16进制
---@return string|number
function utils.str_bcc(val, i, j, hex)
  i = (i ~= nil) and i or 1
  j = (j ~= nil) and j or #val

  local bcc = 0
  for k = i, j do
    bcc = bcc ~ string.byte(val, k)
  end

  if (hex == nil) or hex then
    return string.format("%02x", bcc):upper()
  else
    return bcc
  end
end

---------------------------------------------------------------------------------
---拆分字节为8个位
---@param val number 数值
---@return table
function utils.byte_to_bit(val)
  if val < 0 or val > 255 then
    log.error(tag, "字节值在0-255区间")
    return {}
  end

  local bits = {}
  for i = 7, 0, -1 do
    -- 右移 i 位，并与 1 进行按位与操作
    local bit = (val >> i) & 1
    table.insert(bits, bit)
  end

  return bits
end

---组合8个位为一个值
---@param val table 位组
---@return number
function utils.byte_from_bit(val)
  if #val ~= 8 then
    log.error(tag, "构建byte需要8个位")
    return 0
  end

  local byte = 0
  for k, v in pairs(val) do
    if v ~= 0 and v ~= 1 then
      log.error(tag, "构建byte必须为0,1")
      return 0
    end

    byte = byte | v << 8 - k
  end
  return byte
end

---判断val是否在set集合中
---@param val number|string 数值
---@param set table 集合
---@return boolean
function utils.val_in_set(val, set)
  for _, value in pairs(set) do
    if val == value then
      return true
    end
  end

  return false
end

---将val转为指定长度的16进制字符串
---@param val number 数值
---@param len number|nil 有效长度(4,8)
---@param le boolean|nil 小端处理
---@return string
function utils.val_to_hex(val, len, le)
  len = (len ~= nil) and len or 8
  if not utils.val_in_set(len, { 4, 8 }) then
    return ""
  end

  local str = string.format("%08x", val):upper()
  if len < 8 then
    str = string.sub(str, 8 - len + 1, 8)
  end

  local pairs = {}
  if le then --小端
    for i = len, 2, -2 do
      table.insert(pairs, string.sub(str, i - 1, i))
    end
  else --大端
    for i = 1, #str, 2 do
      table.insert(pairs, string.sub(str, i, i + 1))
    end
  end

  return table.concat(pairs, " ")
end

---使用字节值构建一个数值
---@param le boolean 小端处理
---@param bytes table 字节值
---@return number
function utils.val_from_byte(le, bytes)
  local num_bytes = #bytes
  if not utils.val_in_set(num_bytes, { 2, 4 }) then
    return 0
  end

  local result = 0
  for i, byte in ipairs(bytes) do
    if byte < 0 or byte > 255 then
      log.error(tag, "每个字节必须是0到255之间的整数")
      return 0
    end

    byte = byte & 0xFF -- 确保只保留8位
    if le then
      result = result | byte << (8 * (i - 1))
    else
      result = result | byte << (8 * (num_bytes - i))
    end
  end

  -- 处理符号（针对有符号整数）
  if num_bytes == 2 then
    if result >= 0x8000 then
      result = result - 0x10000
    end
  elseif num_bytes == 4 then
    if result >= 0x80000000 then
      result = result - 0x100000000
    end
  end

  return result
end

---------------------------------------------------------------------------------
---将sTime转为时间
---@param sTime string 时间字符串(y-m-d h:m:s)
---@param zone boolean|nil 添加时区
---@return number
function utils.time_from_str(sTime, zone)
  local year, month, day, hour, minute, second = sTime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  local ret = os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = minute,
    sec = second
  }) - Time_make_diff

  if zone then
    return ret + Time_zone_diff
  else
    return ret
  end
end

---将sTime转为字符串
---@param sTime any
---@zone boolean|nil 添加时区
---@return string|osdate
function utils.time_to_str(sTime, zone)
  if zone then
    sTime = sTime + Time_zone_diff
  end
  return os.date("%Y-%m-%d %H:%M:%S", sTime)
end

---计算系统时区
---@param str boolean|nil 返回文本描述
---@return string|number
function utils.time_get_zone(str)
  local now = utils.time_from_str("2000-01-01 00:00:00")
  local loc = os.date("*t", now)
  local utc = os.date("!*t", now)

  local offset = os.difftime(os.time({
    year = loc.year,
    month = loc.month,
    day = loc.day,
    hour = loc.hour,
    min = loc.min,
    sec = loc.sec
  }), os.time({
    year = utc.year,
    month = utc.month,
    day = utc.day,
    hour = utc.hour,
    min = utc.min,
    sec = utc.sec
  }))

  if not str then
    return offset
  end

  -- 转换为小时和分钟
  local hours = math.floor(offset / 3600)
  local minutes = math.floor((offset % 3600) / 60)

  -- 处理半小时的情况，如+05:30
  local secs = offset % 60
  if secs ~= 0 then
    minutes = minutes + (secs / 60)
  end

  return string.format("%02d:%02d", hours, minutes)
end

---------------------------------------------------------------------------------
---字符串转table
---@param value string 字符串
---@return table|nil
---@return string|nil
function utils.table_from_str(value)
  if not value or value == "" then
    return nil, "table string empty"
  end

  -- 使用 load 安全地解析字符串
  local chunk, err = load("return " .. value)
  if not chunk then
    return nil, "table string invalid: " .. (err or "unknown error")
  end

  -- 执行并返回解析后的 table
  local success, result = pcall(chunk)
  if not success then
    return nil, "convert string failed: " .. result
  end

  return result or {}
end

---table转字符串
---@param tbl table
---@param precision number|nil 浮点精度,默认2
---@return string
function utils.table_to_str(tbl, precision)
  local to_str = function (value)
    if type(value) == 'table' then
      return utils.table_to_str(value)
    elseif type(value) == 'string' then
      return "\'" .. value .. "\'"
    else
      return tostring(value)
    end
  end

  if tbl == nil then return "" end
  local ret = "{"

  local idx = 1
  for key, value in pairs(tbl) do
    local signal = ","
    if idx == 1 then
      signal = ""
    end

    if key == idx then
      ret = ret .. signal .. to_str(value)
    else
      if type(key) == 'number' or type(key) == 'string' then
        ret = ret .. signal .. '[' .. to_str(key) .. "]=" .. to_str(value)
      else
        if type(key) == 'userdata' then
          ret = ret .. signal .. "*s" .. utils.table_to_str(getmetatable(key)) ..
              "*e" .. "=" .. to_str(value)
        else
          ret = ret .. signal .. key .. "=" .. to_str(value)
        end
      end
    end

    idx = idx + 1
  end

  ret = ret .. "}"
  return ret
end

---替换table中的内容
---@param tbl table
---@param old string 原内容 or 正则
---@param new string 新内容
function utils.table_replace(tbl, old, new)
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      tbl[k] = v:gsub(old, new)
    elseif type(v) == "table" then
      utils.table_replace(v, old, new)
    end
  end
end

---打印出所有表结构
---@param tb table 表结构
---@param desc string|nil 表名称
---@param nesting integer|nil 扫描深度
---@param via boolean|nil 直接打印,不返回
---@return string|nil
function utils.table_dump(tb, desc, nesting, via)
  if type(nesting) ~= "number" then nesting = 3 end

  local lookupTable = {}
  local result = {}

  local function _v(v)
    if type(v) == "string" then
      v = "\"" .. v .. "\""
    end
    return tostring(v)
  end

  local function _dump(value, val_desc, indent, nest, key_len)
    val_desc = val_desc or "<var>"
    local spc = ""

    if type(key_len) == "number" then
      spc = string.rep(" ", key_len - string.len(_v(val_desc)))
    end

    if type(value) ~= "table" then
      result[#result + 1] = string.format("%s%s%s = %s", indent, _v(val_desc), spc, _v(value))
    elseif lookupTable[value] then
      result[#result + 1] = string.format("%s%s%s = *REF*", indent, val_desc, spc)
    else
      lookupTable[value] = true
      if nest > nesting then
        result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, val_desc)
      else
        result[#result + 1] = string.format("%s%s = {", indent, _v(val_desc))
        local indent2 = indent .. "    "
        local keys = {}
        local keys_len = 0
        local values = {}

        for k, v in pairs(value) do
          keys[#keys + 1] = k
          local vk = _v(k)
          local vkl = string.len(vk)
          if vkl > keys_len then keys_len = vkl end
          values[k] = v
        end

        table.sort(keys, function (a, b)
          if type(a) == "number" and type(b) == "number" then
            return a < b
          else
            return tostring(a) < tostring(b)
          end
        end)

        for i, k in ipairs(keys) do
          _dump(values[k], k, indent2, nest + 1, keys_len)
        end

        result[#result + 1] = string.format("%s}", indent)
      end
    end
  end

  --dump table
  _dump(tb, desc, "- ", 1)

  if via == nil then via = true end
  local dump_str = ""
  for i, line in ipairs(result) do
    if via then
      log.info(tag, line)
    else
      dump_str = dump_str .. line .. "\n"
    end
  end

  if not via then
    return dump_str
  end
end

---------------------------------------------------------------------------------
---获取path最后一级目录
---@param path string 目录
---@return string
function utils.get_last_dir(path)
  -- 将所有反斜杆替换为斜杆
  -- path = path:gsub("\\", "/")

  -- 修剪首尾的斜杆
  path = path:gsub("^/+", "") -- 移除首的斜杆
  path = path:gsub("/+$", "") -- 移除尾的斜杆

  -- 如果路径为空，返回空字符串
  if path == "" then
    return ""
  end

  local rev_path = path:reverse()
  --最后一个斜杠位置
  local last_slash = rev_path:find("/")

  if last_slash then -- 提取最后一级目录
    return rev_path:sub(1, last_slash - 1):reverse()
  else               -- 整个路径即为目录
    return path
  end
end

---删除path及子目录和文件
---@param path string 目录
function utils.remove_all(path)
  local ret, data = io.lsdir(path, 50, 0)
  if not ret then
    return
  end

  for _, e in ipairs(data) do
    local fn = path .. e.name
    if e.type == 1 then
      utils.remove_all(fn .. "/")
      log.info(tag, "remove dir", fn)
      io.rmdir(fn)
    else
      os.remove(fn)
      log.info(tag, "remove file", fn)
    end
  end

  -- 继续遍历
  if #data == 50 then
    utils.remove_all(path)
  end
end

---获取path及子目录的文件清单
---@param path string 目录
---@param list table|nil 扫描结果
---@param offset number|nil 从第几个开始
function utils.walk(path, list, offset)
  log.info(tag, "walk")
  offset = offset or 0

  local ret, data = io.lsdir(path, 50, offset)
  if not ret then
    return
  end

  for _, e in ipairs(data) do
    local fn = path .. e.name
    if e.type == 1 then
      log.info(tag, "walk", fn)
      local last_dir = utils.get_last_dir(fn)

      if last_dir ~= "." and last_dir ~= ".." then
        utils.walk(fn .. "/", list)
      end
    else
      log.info(tag, "walk", fn, e.size)
      if list then
        table.insert(list, {
          name = fn,
          size = e.size
        })
      end
    end
  end

  -- 继续遍历
  if #data == 50 then
    utils.walk(path, list, offset + 50)
  end
end

--初始化
utils.init()

return utils
