local Node
do
  local _base_0 = {
    addChild = function(self, node)
      if not self:hasChild(node.data) then
        return table.insert(self.children, node)
      end
    end,
    hasChild = function(self, word)
      local found = false
      for k, v in pairs(self.children) do
        if v.data == word then
          found = true
          break
        end
      end
      return found
    end,
    getChild = function(self, word)
      for k, v in pairs(self.children) do
        if v.data == word then
          return v
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, data, is_word)
      self.data = data
      self.children = { }
      self.is_word = is_word
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
    add = function(self, word)
      local length = string.len(word)
      local s = ""
      local current_node = self.head
      for i = 1, length do
        s = s .. string.sub(word, i, i)
        local new_node = Node(s, (s == word))
        if current_node:hasChild(new_node.data) then
          current_node = current_node:getChild(s)
        else
          current_node:addChild(new_node)
          current_node = new_node
        end
      end
    end,
    hasWord = function(self, word)
      local length = string.len(word)
      local s = ""
      local current_node = self.head
      for i = 1, length do
        s = s .. string.sub(word, i, i)
        local new_node = Node(s, (s == word))
        if current_node:hasChild(new_node.data) then
          current_node = current_node:getChild(s)
        else
          return false
        end
      end
      return current_node.is_word
    end,
    hasNode = function(self, word)
      local length = string.len(word)
      local s = ""
      local current_node = self.head
      for i = 1, length do
        s = s .. string.sub(word, i, i)
        local new_node = Node(s, (s == word))
        if current_node:hasChild(new_node.data) then
          current_node = current_node:getChild(s)
        else
          return false
        end
      end
      return true
    end,
    getNode = function(self, word)
      local length = string.len(word)
      local s = ""
      local current_node = self.head
      for i = 1, length do
        s = s .. string.sub(word, i, i)
        local new_node = Node(s, (s == word))
        if current_node:hasChild(new_node.data) then
          current_node = current_node:getChild(s)
        end
      end
      return current_node
    end,
    getWords = function(self, start)
      local words = { }
      if self:hasNode(start) then
        local node = self:getNode(start)
        local to_traverse = LinkedList()
        to_traverse:add(node)
        local found = LinkedList()
        found:add(node)
        while to_traverse.length > 0 do
          local current_node = to_traverse:remove()
          for k, v in pairs(current_node.children) do
            to_traverse:add(v)
            found:add(v)
          end
        end
        while found.length > 0 do
          local current_node = found:remove()
          if current_node.is_word then
            table.insert(words, current_node.data)
          end
        end
      end
      return words
    end,
    print = function(self, node)
      if node == nil then
        node = self.head
      end
      local to_traverse = LinkedList()
      to_traverse:add(node)
      local s = ""
      while to_traverse.length > 0 do
        local current_node = to_traverse:remove()
        s = s .. current_node.data
        if #current_node.children > 0 then
          s = s .. " -> "
        else
          s = s .. " ~|"
        end
        for k, v in pairs(current_node.children) do
          to_traverse:add(v)
        end
      end
      return print(s)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.head = Node("", false)
    end,
    __base = _base_0,
    __name = "Trie"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Trie = _class_0
end
