do
  local _base_0 = {
    start = function(self)
      return self.audio:play()
    end,
    toggle = function(self)
      if self.audio:isPaused() then
        return self.audio:resume()
      else
        return self.audio:pause()
      end
    end,
    stop = function(self)
      return self.audio:stop()
    end,
    setVolume = function(self, volume)
      return self.audio:setVolume(volume)
    end,
    setPitch = function(self, pitch)
      return self.audio:setPitch(pitch)
    end,
    setLooping = function(self, looping)
      return self.audio:setLooping(looping)
    end,
    getVolume = function(self)
      return self.audio:getVolume()
    end,
    getPitch = function(self)
      return self.audio:getPitch()
    end,
    getLooping = function(self)
      return self.audio:getLooping()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, name, volume, looping, pitch, static)
      if volume == nil then
        volume = 1.0
      end
      if looping == nil then
        looping = true
      end
      if pitch == nil then
        pitch = 1.0
      end
      if static == nil then
        static = false
      end
      local path = "assets/sounds/" .. name
      if love.filesystem.exists((PATH_PREFIX .. path)) then
        path = PATH_PREFIX .. path
      end
      if static then
        self.audio = ResoureLoader:loadSound(path, true)
      else
        self.audio = ResoureLoader:loadSound(path)
      end
      self.name = name
      self.audio:setLooping(looping)
      self.audio:setPitch(pitch)
      return self.audio:setVolume(volume)
    end,
    __base = _base_0,
    __name = "Sound"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Sound = _class_0
end
