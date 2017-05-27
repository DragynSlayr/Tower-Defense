do
  local _class_0
  local _parent_0 = Button
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      for k, v in pairs(self.tooltips) do
        v.enabled = self:isHovering(love.mouse.getPosition())
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height, text, action, font, tooltips)
      if font == nil then
        font = Renderer.hud_font
      end
      _class_0.__parent.__init(self, x, y, width, height, text, action, font)
      self.tooltips = tooltips
    end,
    __base = _base_0,
    __name = "TooltipButton",
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
  TooltipButton = _class_0
end
