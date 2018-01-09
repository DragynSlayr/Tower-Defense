local ScoreNode
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, score, name)
      self.score = score
      self.name = name
      self.next = nil
    end,
    __base = _base_0,
    __name = "ScoreNode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ScoreNode = _class_0
end
do
  local _base_0 = {
    add = function(self, score, name)
      local node = ScoreNode((tonumber(score)), (tostring(name)))
      for k, v in pairs(self.elements) do
        if v.name == node.name and v.score == node.score then
          return 
        end
      end
      table.insert(self.elements, node)
      self.size = self.size + 1
      self.sorted = false
    end,
    remove = function(self)
      if self.size > 0 then
        if not self.sorted then
          self:sort()
        end
        local node = table.remove(self.elements, 1)
        self.size = self.size - 1
        return node
      end
    end,
    sort = function(self)
      for i = 1, #self.elements - 1 do
        local max = i
        for j = i + 1, #self.elements do
          if self.elements[max].score < self.elements[j].score then
            max = j
          end
        end
        self:swap(i, max)
      end
      self.sorted = true
    end,
    swap = function(self, i, j)
      local temp = self.elements[i]
      self.elements[i] = self.elements[j]
      self.elements[j] = temp
    end,
    print = function(self)
      if not self.sorted then
        self:sort()
      end
      local s = ""
      for k, v in pairs(self.elements) do
        s = s .. (v.name .. ", " .. v.score)
        if k ~= #self.elements then
          s = s .. "\n"
        end
      end
      return print(s)
    end,
    getTopScores = function(self, n)
      n = math.min(n, #self.elements)
      self:sort()
      local temp = ScoreArray()
      for i = 1, n do
        local node = self.elements[i]
        temp:add(node.score, node.name)
      end
      temp:sort()
      return temp
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.elements = { }
      self.size = 0
      self.sorted = true
    end,
    __base = _base_0,
    __name = "ScoreArray"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ScoreArray = _class_0
end
do
  local _base_0 = {
    tryConnection = function(self)
      self.socket = self.s.udp()
      self.socket:settimeout(0)
      self.socket:setpeername(self.server_address, self.server_port)
      self.connected = true
    end,
    disconnect = function(self)
      if self.connected then
        return self.socket:close()
      end
    end,
    retrieveScores = function(self)
      if not self.connected then
        return 
      end
      self.socket:send("update")
      local temp = ScoreArray()
      local data = ""
      while data do
        local msg
        data, msg = self.socket:receive()
        if data then
          local splitted = split(data, "\t")
          local score = tonumber(splitted[2])
          local name = splitted[1]
          temp:add(score, name)
        elseif msg ~= "timeout" then
          error("Network error: " .. tostring(msg))
        end
      end
      if #temp.elements > #self.high_scores.elements then
        temp:sort()
        self.high_scores = temp
      end
    end,
    loadScores = function(self)
      self.high_scores = ScoreArray()
      local contents, size = love.filesystem.read("HIGH_SCORES")
      if size > 0 then
        local lines = split(contents, "\n")
        for k, v in pairs(lines) do
          local line = self:decode(v)
          local splitted = split(line, "\t")
          self.high_scores:add(splitted[2], splitted[1])
        end
      end
    end,
    saveScores = function(self)
      local temp = ScoreArray()
      local s = ""
      while self.high_scores.size > 0 do
        local node = self.high_scores:remove()
        temp:add(node.score, node.name)
        s = s .. self:encode(node.name .. "\t" .. node.score)
        if self.high_scores.size ~= 0 then
          s = s .. "\n"
        end
      end
      love.filesystem.write("HIGH_SCORES", s)
      self.high_scores = temp
    end,
    encode = function(self, str, shift)
      if shift == nil then
        shift = self.shift
      end
      local s = ""
      for i = 1, #str do
        local char = string.sub(str, i, i)
        local num = string.byte(char)
        num = num + shift
        s = s .. string.char(num)
      end
      return s
    end,
    decode = function(self, str)
      return self:encode(str, -self.shift)
    end,
    update = function(self, dt)
      if self.score >= self.score_threshold then
        local score_change = self.score - self.score_threshold
        score_change = math.floor(score_change / 10000)
        score_change = score_change + 1
        self.score_threshold = self.score_threshold + 10000
      end
      if Driver.game_state == Game_State.game_over then
        self.elapsed = self.elapsed + dt
        if self.elapsed > self.update_delay then
          self.elapsed = 0
          return self:retrieveScores()
        end
      end
    end,
    addScore = function(self, score)
      self.score = self.score + score
    end,
    submitScore = function(self, text)
      if self.connected then
        local name = tostring(text)
        local score = tonumber(self.score)
        local dg = string.format("%s\t%d", name, score)
        return self.socket:send(dg)
      else
        local name = text
        local score = tostring(self.score)
        return self.high_scores:add(score, name)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.s = require("socket")
      self.score = 0
      self.score_threshold = 10000
      self.shift = 128
      if not love.filesystem.exists("HIGH_SCORES") then
        love.filesystem.write("HIGH_SCORES", "")
      end
      self.high_scores = ScoreArray()
      self.socket = nil
      self.server_address = "70.72.212.179"
      self.server_port = 19615
      self.connected = false
      self:tryConnection()
      self:loadScores()
      self.elapsed = 0
      self.update_delay = 1
    end,
    __base = _base_0,
    __name = "Score"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Score = _class_0
end
