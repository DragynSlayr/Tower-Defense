do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    getEnemies = function(self)
      local basic = BasicEnemy(0, 0)
      local player = PlayerEnemy(0, 0)
      local spawner = SpawnerEnemy(0, 0)
      local strong = StrongEnemy(0, 0)
      local turret = TurretEnemy(0, 0)
      return {
        basic,
        player,
        spawner,
        strong,
        turret
      }
    end,
    draw = function(self)
      love.graphics.push("all")
      for j = 1, 2 do
        local y = Screen_Size.height * 0.4
        local stats = Stats.player
        local x = Screen_Size.width * 0.2
        local icons = self.player_icons
        if j == 2 then
          stats = Stats.turret
          x = Screen_Size.width * 0.8
          icons = self.turret_icons
        end
        local bounds = self.sprites2[j]:getBounds(x, y)
        for i = 1, #stats do
          y = map(i, 1, #stats, (Screen_Size.height * 0.4) + (40 * Scale.height), Screen_Size.height * 0.60)
          icons[i]:draw(x, y + (9 * Scale.height))
          Renderer:drawHUDMessage((string.format("%.2f", stats[i])), x + (10 * Scale.width) + bounds.radius, y, self.font)
        end
      end
      local enemies = self:getEnemies()
      for i = 1, #enemies do
        local x = map(i, 1, #enemies, 100 * Scale.width, Screen_Size.width - (200 * Scale.width))
        local y = Screen_Size.height * 0.8
        local bounds = self.sprites[i]:getBounds(x, y)
        for j = 1, #self.stats do
          y = map(j, 1, #self.stats, (Screen_Size.height * 0.8) + (30 * Scale.height), Screen_Size.height * 0.96)
          self.icons[j]:draw(x, y + (9 * Scale.height))
          Renderer:drawHUDMessage((string.format("%.2f", enemies[i][self.stats[j]])), x + (10 * Scale.width) + bounds.radius, y, self.font)
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
      self.stats = {
        "max_health",
        "damage",
        "speed_multiplier",
        "score_value"
      }
      self.sprites = {
        (Sprite("enemy/tracker.tga", 32, 32, 1, 50 / 32)),
        (Sprite("enemy/enemy.tga", 26, 26, 1, 50 / 26)),
        (Sprite("projectile/dart.tga", 17, 17, 1, 50 / 17)),
        (Sprite("enemy/bullet.tga", 26, 20, 1, 50 / 26)),
        (Sprite("enemy/circle.tga", 26, 26, 1, 50 / 26))
      }
      self.sprites2 = {
        (Sprite("test.tga", 16, 16, 0.29, 50 / 16)),
        (Sprite("turret.tga", 34, 16, 2, 50 / 34))
      }
      self.icons = {
        (Sprite("icons/health.tga", 16, 16, 1, 1)),
        (Sprite("icons/damage.tga", 16, 16, 1, 1)),
        (Sprite("icons/speed.tga", 16, 16, 1, 1)),
        (Sprite("icons/score.tga", 16, 16, 1, 1))
      }
      self.player_icons = {
        self.icons[1],
        (Sprite("icons/range.tga", 16, 16, 1, 1)),
        self.icons[2],
        self.icons[3],
        (Sprite("icons/attack_delay.tga", 16, 16, 1, 1))
      }
      self.turret_icons = {
        self.icons[1],
        (Sprite("icons/range.tga", 16, 16, 1, 1)),
        self.icons[2],
        (Sprite("icons/cooldown.tga", 16, 16, 1, 1)),
        (Sprite("icons/attack_delay.tga", 16, 16, 1, 1))
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
