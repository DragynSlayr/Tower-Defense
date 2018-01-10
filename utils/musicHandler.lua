do
  local _class_0
  local _base_0 = {
    play = function(self, idx)
      if true then
        return 
      end
      if idx > 0 then
        if self.sounds[idx].audio:isPlaying() then
          self.sounds[idx].audio:rewind()
        end
        return self.sounds[idx]:start()
      end
    end,
    toggle = function(self, idx)
      return self.sounds[idx]:toggle()
    end,
    stop = function(self, idx)
      return self.sounds[idx]:stop()
    end,
    setVolume = function(self, idx, value)
      return self.sounds[idx]:setVolume(value)
    end,
    setPitch = function(self, idx, value)
      return self.sounds[idx]:setPitch(value)
    end,
    setLooping = function(self, idx, value)
      return self.sounds[idx]:setLooping(value)
    end,
    add = function(self, sound)
      for k, v in pairs(self.sounds) do
        if v.name == sound.name then
          return k
        end
      end
      table.insert(self.sounds, sound)
      return #self.sounds
    end,
    get = function(self, idx)
      return self.sounds[idx]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.sounds = { }
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
