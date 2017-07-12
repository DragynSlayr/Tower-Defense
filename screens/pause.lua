do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    update = function(self, dt)
      local typeof = ItemFrame
      local frames = UI:filter(typeof, Screen_State.inventory)
      local frames2 = UI:filter(typeof)
      for k, v in pairs(frames2) do
        v:setItem(frames[k].item)
        v.sprite:setScale(2.5)
        v.small_sprite = v.sprite
        v.normal_sprite = v.small_sprite
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      for j = 1, 2 do
        local y = Screen_Size.height * 0.4
        local stats = Stats.player
        local x = Screen_Size.width * 0.05
        local icons = self.player_icons
        if j == 2 then
          stats = Stats.turret
          x = Screen_Size.width * 0.90
          icons = self.turret_icons
        end
        local bounds = self.sprites[j]:getBounds(x, y)
        for i = 1, #stats do
          y = map(i, 1, #stats, (Screen_Size.height * 0.4) + (40 * Scale.height), Screen_Size.height * 0.60)
          icons[i]:draw(x, y + (9 * Scale.height))
          Renderer:drawHUDMessage((string.format("%.2f", stats[i])), x + (10 * Scale.width) + bounds.radius, y, self.font)
        end
      end
      Renderer:drawAlignedMessage(Inventory.message1, Screen_Size.height * 0.85, "center", Renderer.hud_font)
      Renderer:drawAlignedMessage(Inventory.message2, Screen_Size.height * 0.89, "center", Renderer.hud_font)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.font = Renderer:newFont(20)
      self.sprites = {
        (Sprite("player/test.tga", 16, 16, 0.29, 50 / 16)),
        (Sprite("turret/turret.tga", 34, 16, 2, 50 / 34))
      }
      self.icons = {
        (Sprite("ui/icons/health.tga", 16, 16, 1, 1)),
        (Sprite("ui/icons/range.tga", 16, 16, 1, 1)),
        (Sprite("ui/icons/damage.tga", 16, 16, 1, 1)),
        (Sprite("ui/icons/speed.tga", 16, 16, 1, 1)),
        (Sprite("ui/icons/attack_delay.tga", 16, 16, 1, 1))
      }
      self.player_icons = self.icons
      self.turret_icons = {
        self.icons[1],
        self.icons[2],
        self.icons[3],
        (Sprite("ui/icons/cooldown.tga", 16, 16, 1, 1)),
        self.icons[5]
      }
    end,
    __base = _base_0,
    __name = "PauseScreen",
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
  PauseScreen = _class_0
end
