do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    add_point = function(self, num)
      self.skill_points = self.skill_points + num
    end,
    add_skill = function(self, tree, idx)
      if self.skill_points >= 1 then
        local _exp_0 = tree
        if Upgrade_Trees.player_stats == _exp_0 then
          if self.player_stats[idx] < self.max_skill then
            self.player_stats[idx] = self.player_stats[idx] + 1
            self.skill_points = self.skill_points - 1
            Stats.player[idx] = Base_Stats.player[idx] + (self.amount[1][idx][self.player_stats[idx]])
          end
        elseif Upgrade_Trees.turret_stats == _exp_0 then
          if self.turret_stats[idx] < self.max_skill then
            self.turret_stats[idx] = self.turret_stats[idx] + 1
            self.skill_points = self.skill_points - 1
            Stats.turret[idx] = Base_Stats.turret[idx] + (self.amount[2][idx][self.turret_stats[idx]])
          end
        end
      end
      if self.skill_points >= 5 then
        local _exp_0 = tree
        if Upgrade_Trees.player_special == _exp_0 then
          if not self.player_special[idx] then
            self.player_special[idx] = true
            self.skill_points = self.skill_points - 5
          end
        elseif Upgrade_Trees.turret_special == _exp_0 then
          if not self.turret_special[idx] then
            self.turret_special[idx] = true
            self.skill_points = self.skill_points - 5
          end
        end
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      for j = 0, 1 do
        for i = 1, 4 do
          local height = 40 * Scale.height
          local width = 600 * Scale.width
          local y = (100 * Scale.height) + (i * 65 * Scale.height) - (height / 2) + (400 * j * Scale.height)
          local x = 320 * Scale.width
          local ratio = self.player_stats[i] / self.max_skill
          if j == 1 then
            ratio = self.turret_stats[i] / self.max_skill
          end
          love.graphics.setColor(178, 150, 0, 255)
          love.graphics.rectangle("fill", x, y, width, height)
          love.graphics.setColor(255, 215, 0, 255)
          love.graphics.rectangle("fill", x + (3 * Scale.width), y + (3 * Scale.height), (width - (6 * Scale.width)) * ratio, height - (6 * Scale.height))
          love.graphics.setColor(0, 0, 0, 255)
          for i = x, x + width, width / self.max_skill do
            love.graphics.line(i, y, i, y + height)
          end
          local stats = Stats.player
          if j == 1 then
            stats = Stats.turret
          end
          local message = string.format("%.2f", stats[i])
          Renderer:drawHUDMessage(message, Screen_Size.width * 0.8, y)
        end
      end
      local message = "Skill Points: " .. self.skill_points
      Renderer:drawHUDMessage(message, Screen_Size.width - (Renderer.hud_font:getWidth(message)) - (5 * Scale.width), 0)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.skill_points = 0
      self.max_skill = 6
      self.player_stats = {
        0,
        0,
        0,
        0
      }
      self.turret_stats = {
        0,
        0,
        0,
        0
      }
      self.player_special = {
        false,
        false,
        false,
        false
      }
      self.turret_special = {
        false,
        false,
        false,
        false
      }
      self.amount = { }
      self.amount[1] = {
        {
          5,
          11,
          18,
          26,
          35,
          45
        },
        {
          25,
          50,
          80,
          115,
          155,
          200
        },
        {
          0.2,
          0.5,
          1.0,
          1.5,
          2.0,
          2.8
        },
        {
          50,
          100,
          175,
          250,
          325,
          400
        }
      }
      self.amount[2] = {
        {
          4,
          8,
          13,
          18,
          24,
          32
        },
        {
          15,
          30,
          50,
          70,
          100,
          150
        },
        {
          0.25,
          0.75,
          1.25,
          2.0,
          2.8,
          3.65
        },
        {
          -2.5,
          -5.0,
          -7.5,
          -10.0,
          -12.5,
          -15.0
        }
      }
      for k = 1, #self.amount do
        for k2 = 1, #self.amount[k][2] do
          self.amount[k][2][k2] = self.amount[k][2][k2] * Scale.diag
        end
      end
      for k = 1, #self.amount[1][4] do
        self.amount[1][4][k] = self.amount[1][4][k] * Scale.diag
      end
    end,
    __base = _base_0,
    __name = "UpgradeScreen",
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
  UpgradeScreen = _class_0
end
