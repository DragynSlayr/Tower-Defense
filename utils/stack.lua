do
  local _class_0
  local _parent_0 = LinkedList
  local _base_0 = {
    remove = function(self)
      if self.head == nil then
        return ""
      end
      local data = ""
      if self.length == 1 then
        data = self.head.data
        self.head = nil
      else
        local n = self.head
        for i = 1, self.length - 2 do
          n = n.next
        end
        data = n.next.data
        n.next = nil
      end
      self.length = self.length - 1
      return data
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      return _class_0.__parent.__init(self)
    end,
    __base = _base_0,
    __name = "Stack",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Stack = _class_0
end
