do
  local _base_0 = {
    loadImage = function(self, path)
      if not self.images[path] then
        local flags = { }
        flags["linear"] = false
        flags["mipmaps"] = true
        self.images[path] = love.graphics.newImage(path, flags)
      end
      return self.images[path]
    end,
    loadSound = function(self, path, static)
      if static == nil then
        static = false
      end
      if static then
        if not self.sounds.static[path] then
          self.sounds.static[path] = love.audio.newSource(path, "static")
        end
        return self.sounds.static[path]
      else
        if not self.sounds.dynamic[path] then
          self.sounds.dynamic[path] = love.audio.newSource(path)
        end
        return self.sounds.dynamic[path]
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.images = { }
      self.sounds = { }
      self.sounds.static = { }
      self.sounds.dynamic = { }
    end,
    __base = _base_0,
    __name = "ResoureCacher"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ResoureCacher = _class_0
end
