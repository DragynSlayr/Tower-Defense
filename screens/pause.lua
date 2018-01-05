do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    nextLayer = function(self)
      if self.current_layer < self.layer_idx then
        self.lower_draw = self.lower_draw + 5
        self.higher_draw = self.higher_draw + 5
        self.current_layer = self.current_layer + 1
      end
    end,
    previousLayer = function(self)
      if self.current_layer > 0 then
        self.lower_draw = self.lower_draw - 5
        self.higher_draw = self.higher_draw - 5
        self.current_layer = self.current_layer - 1
      end
    end,
    getControls = function(self)
      KEY_CHANGED = false
      self.move_controls = { }
      self.shoot_controls = { }
      self.other_controls = { }
      for k, v in pairs(Controls.key_names) do
        local key = Controls.keys[v]
        local value = (toTitle(v, "_")) .. " : " .. key
        if startsWith(v, "MOVE") then
          table.insert(self.move_controls, value)
        elseif startsWith(v, "SHOOT") then
          table.insert(self.shoot_controls, value)
        else
          table.insert(self.other_controls, value)
        end
      end
      self.controls = {
        self.move_controls,
        self.other_controls,
        self.shoot_controls
      }
    end,
    update = function(self, dt)
      local typeof = ItemFrame
      local frames = UI:filter(typeof, Screen_State.inventory)
      local frames2 = UI:filter(typeof)
      for k, v in pairs(frames2) do
        if frames[k].item.__class ~= v.item.__class then
          v:setItem(frames[k].item)
          v.sprite:setScale(2.5)
          v.small_sprite = v.sprite
          v.normal_sprite = v.small_sprite
        end
      end
      if KEY_CHANGED then
        self:getControls()
      end
      self.layer_idx = math.floor((#self.item_grid.items / 5))
      for k, frame in pairs(self.item_grid.items) do
        if k >= self.lower_draw and k <= self.higher_draw then
          frame:update(dt)
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      local stats = { }
      for j = 1, 2 do
        local y = Screen_Size.height * 0.4
        if Driver.objects[EntityTypes.player] and #Driver.objects[EntityTypes.player] > 0 then
          stats = Driver.objects[EntityTypes.player][1]:getStats()
        else
          stats = Stats.player
        end
        local x = Screen_Size.width * 0.05
        local icons = self.player_icons
        if j == 2 then
          if Driver.objects[EntityTypes.turret] and #Driver.objects[EntityTypes.turret] > 0 then
            stats = Driver.objects[EntityTypes.turret][1]:getStats()
          else
            stats = Stats.turret
          end
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
      love.graphics.setFont(Renderer.small_font)
      love.graphics.setColor(0, 0, 0, 255)
      for i = 1, 3 do
        local y = 0.04
        if i == 2 then
          y = y / 2
        end
        for k, v in pairs(self.controls[i]) do
          love.graphics.printf(v, (Screen_Size.width / 3) * (i - 1), Screen_Size.height * y, Screen_Size.width / 3, "center")
          y = y + 0.055
        end
      end
      love.graphics.setFont(Renderer.hud_font)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.printf((self.current_layer + 1) .. " / " .. (self.layer_idx + 1), 0, Screen_Size.height * 0.74, Screen_Size.width, "center")
      local x = Screen_Size.width * 0.25
      for k, frame in pairs(self.item_grid.items) do
        if k >= self.lower_draw and k <= self.higher_draw then
          local old_x, old_y, old_center = frame.x, frame.y, frame.center
          frame.x = x + ((k - self.lower_draw) * 100)
          frame.y = Screen_Size.height * 0.8
          frame.center = Point(frame.x + (frame.width / 2), frame.y + (frame.width / 2))
          frame:draw()
          frame.x, frame.y, frame.center = old_x, old_y, old_center
          x = x + 100
        end
      end
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
        (Sprite("player/test.tga", 16, 16, 2, 50 / 16)),
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
      self.item_grid = nil
      self.lower_draw = 1
      self.higher_draw = 5
      self.layer_idx = 0
      self.current_layer = 0
      return self:getControls()
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
