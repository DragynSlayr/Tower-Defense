do
  local _class_0
  local _base_0 = {
    randomSign = function(self)
      if math.random(0, 1 == 1) then
        return 1
      else
        return -1
      end
    end,
    getRandomUnitStart = function(self, radius)
      if radius == nil then
        radius = love.graphics.getHeight() / 2
      end
      local rand_num = (math.random() * 2) - 1
      local x = rand_num * radius
      local y = math.sqrt((radius * radius) - (x * x))
      if math.random(0, 1 == 1) then
        y = -y
      end
      return x, y
    end,
    clamp = function(self, x, min, max)
      if x <= min then
        return min
      elseif x >= max then
        return max
      else
        return x
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      math.randomseed(os.time())
      for i = 1, 3 do
        math.random()
      end
    end,
    __base = _base_0,
    __name = "MathHelper"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MathHelper = _class_0
end
