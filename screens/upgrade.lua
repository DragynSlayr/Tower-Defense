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
          local height = 40
          local width = 600
          local y = 100 + (i * 65) - (height / 2) + (400 * j)
          local x = 320
          local ratio = self.player_stats[i] / self.max_skill
          if j == 1 then
            ratio = self.turret_stats[i] / self.max_skill
          end
          love.graphics.setColor(178, 150, 0, 255)
          love.graphics.rectangle("fill", x, y, width, height)
          love.graphics.setColor(255, 215, 0, 255)
          love.graphics.rectangle("fill", x + 3, y + 3, (width - 6) * ratio, height - 6)
          love.graphics.setColor(0, 0, 0, 255)
          for i = x, x + width, width / self.max_skill do
            love.graphics.line(i, y, i, y + height)
          end
          local stats = Stats.player
          if j == 1 then
            stats = Stats.turret
          end
          local message = stats[i]
          Renderer:drawHUDMessage(message, Screen_Size.width * 0.8, y)
        end
      end
      local message = "Skill Points: " .. self.skill_points
      Renderer:drawHUDMessage(message, Screen_Size.width - (Renderer.hud_font:getWidth(message)) - 5, 0)
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
          2,
          4,
          8,
          13,
          20,
          30
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
          0.4,
          0.9,
          1.4,
          2.2,
          3.2
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
          2,
          4,
          6,
          9,
          13,
          18
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
          0.025,
          0.525,
          1.025,
          1.825,
          2.825,
          3.825
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
    end,
    __base = _base_0,
    __name = "Upgrade",
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
  Upgrade = _class_0
end
