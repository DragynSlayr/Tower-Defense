do
  local _class_0
  local _base_0 = {
    fadeTo = function(self, song, in1p, out1p, in2p, out2p, outTime, inTime)
      local in1 = in1p / 100
      local out1 = out1p / 100
      local in2 = in2p / 100
      local out2 = out2p / 100
      self.next = song
      self.fadeOut = true
      self.outStep = (in1 - out1) / (outTime * 60)
      self.inStep = (out2 - in2) / (inTime * 60)
      self.outStop = out1
      self.inStop = out2
      self.outStart = in2
    end,
    update = function(self, dt)
      if self.fadeOut then
        if self.current_music:getVolume() > self.outStop then
          self.current_music:setVolume(self.current_music:getVolume() - self.outStep)
        else
          self.fadeOut = false
          self.fadeIn = true
          self.current_music:stop()
          self.current_music = self.next
          self.current_music:setVolume(self.outStart)
          self.current_music:start()
        end
      end
      if self.fadeIn then
        if self.current_music:getVolume() < self.inStop then
          return self.current_music:setVolume((function()
            local _base_1 = self.current_music
            local _fn_0 = _base_1.getVolume
            return function(...)
              return _fn_0(_base_1, ...)
            end
          end)() + self.inStep)
        else
          self.fadeIn = false
          return self.current_music:setVolume(self.inStop)
        end
      end
    end,
    play = function(self)
      return self.current_music:start()
    end,
    toggle = function(self)
      return self.current_music:toggle()
    end,
    stop = function(self)
      return self.current_music:stop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.menu_music = Sound("themes/menu.mp3", 0.5)
      self.enemy_music = Sound("themes/enemy.mp3", 0.01)
      self.current_music = self.menu_music
      self.fade_in = false
      self.fade_out = false
    end,
    __base = _base_0,
    __name = "MusicHandler"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MusicHandler = _class_0
end
