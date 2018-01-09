local Node
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, data)
      self.data = data
      self.next = nil
    end,
    __base = _base_0,
    __name = "Node"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Node = _class_0
end
do
  local _base_0 = {
    add = function(self, object)
      local new_node = Node(object)
      if self.head == nil then
        self.head = new_node
      else
        local n = self.head
        for i = 1, self.length - 1 do
          n = n.next
        end
        n.next = new_node
      end
      self.length = self.length + 1
    end,
    remove = function(self)
      if self.head == nil then
        return ""
      end
      local data = self.head.data
      self.head = self.head.next
      self.length = self.length - 1
      return data
    end,
    print = function(self)
      local n = self.head
      local s = "Len: " .. self.length .. "; "
      while n do
        s = s .. tostring(n.data)
        if n.next then
          s = s .. ", "
        else
          s = s .. ";"
        end
        n = n.next
      end
      return print(s)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.head = nil
      self.length = 0
    end,
    __base = _base_0,
    __name = "LinkedList"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  LinkedList = _class_0
end
