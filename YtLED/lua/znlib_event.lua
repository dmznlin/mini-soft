--[[-----------------------------------------------------------------------------
  作者： dmzn@163.com 2025-05-08
  描述： 事件管理器，支持带有类型标识的回调函数注册
-------------------------------------------------------------------------------]]
local tag = "events"
local eventManager = {
  callbacks = {},           -- 存储带有类型标识的回调函数，键为类型，值为回调函数列表
  registered_callbacks = {} -- 用于记录已注册的回调函数，防止重复注册
}

--- 注册一个带有类型标识的回调函数
--- @param type string 类型标识，可以是任意字符串
--- @param cb function 回调函数
function eventManager:register_callback(type, cb)
  if self.registered_callbacks[cb] then
    log.warn(tag, "回调函数已注册")
    return
  end

  -- 将回调函数标记为已注册
  self.registered_callbacks[cb] = true

  -- 根据类型标识添加回调函数到对应的列表中
  if not self.callbacks[type] then
    self.callbacks[type] = {}
  end
  table.insert(self.callbacks[type], cb)
end

--- 取消注册某个回调函数
--- @param cb function 需要取消注册的回调函数
function eventManager:unregister_callback(cb)
  -- 从已注册表中移除
  if self.registered_callbacks[cb] then
    self.registered_callbacks[cb] = nil

    -- 从所有类型的回调列表中移除该函数
    for type, callbacks in pairs(self.callbacks) do
      for i, func in ipairs(callbacks) do
        if func == cb then
          table.remove(callbacks, i)
          -- 如果该类型对应的回调列表为空，则删除该类型
          if #callbacks == 0 then
            self.callbacks[type] = nil
          end
          break
        end
      end
    end
  end
end

--- 根据类型标识触发对应的回调函数
--- @param type string 类型标识
--- @vararg any 需要传递给回调函数的参数
function eventManager:trigger_callback(type, ...)
  if self.callbacks[type] == nil then
    log.warn(tag, string.format("类型'%s'的回调函数不存在", type))
    return
  end

  for _, cb in ipairs(self.callbacks[type]) do
    local status, error = pcall(cb, ...)
    if not status then
      log.error(tag, string.format("回调函数 '%s' 执行失败，错误信息：%s", cb, error))
    end
  end
end

return eventManager
