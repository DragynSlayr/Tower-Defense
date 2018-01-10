do
  local _class_0
  local _parent_0 = UIElement
  local _base_0 = {
    addItem = function(self, item)
      for k, v in pairs(self.items) do
        if item.name == v.item.name then
          if item.rarity > v.item.rarity then
            if Driver.objects[EntityTypes.player] then
              for k2, p in pairs(Driver.objects[EntityTypes.player]) do
                v.item:unequip(p)
              end
            end
            local new_item = ItemFrame(v.x + (v.width / 2), v.y + (v.width / 2), item)
            new_item.draw_layer = v.draw_layer
            new_item.usable = false
            self.items[k] = new_item
            if Driver.objects[EntityTypes.player] then
              for k2, p in pairs(Driver.objects[EntityTypes.player]) do
                item:pickup(p)
              end
            end
          end
          return 
        end
      end
      local length = #self.items
      local x = self.x + (self.col_idx * ((self.box_size + self.spacing) * Scale.width))
      local y = self.y + (self.row_idx * ((self.box_size + self.spacing) * Scale.height))
      local new_item = ItemFrame(x, y, item)
      new_item.draw_layer = self.layer_idx
      new_item.usable = false
      table.insert(self.items, new_item)
      self.col_idx = self.col_idx + 1
      if self.col_idx >= self.max_cols then
        self.col_idx = 0
        self.row_idx = self.row_idx + 1
        if self.row_idx >= self.max_rows then
          self.col_idx = 0
          self.row_idx = 0
          self.layer_idx = self.layer_idx + 1
        end
      end
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          item:pickup(p)
        end
      end
    end,
    nextLayer = function(self)
      if self.current_layer + 1 <= self.layer_idx then
        self.current_layer = self.current_layer + 1
      end
    end,
    previousLayer = function(self)
      if self.current_layer - 1 >= 0 then
        self.current_layer = self.current_layer - 1
      end
    end,
    update = function(self, dt)
      for k, v in pairs(self.items) do
        if v.draw_layer == self.current_layer then
          v:update(dt)
        end
      end
    end,
    draw = function(self)
      for k, v in pairs(self.items) do
        if v.draw_layer == self.current_layer then
          v:draw()
        end
      end
      love.graphics.push("all")
      love.graphics.setFont(Renderer.hud_font)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.printf((self.current_layer + 1) .. " / " .. (self.layer_idx + 1), Screen_Size.width * 0.8, Screen_Size.height * 0.58, Screen_Size.width * 0.2, "center")
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      _class_0.__parent.__init(self, x, y)
      self.items = { }
      self.max_cols = 5
      self.max_rows = 3
      self.row_idx = 0
      self.col_idx = 0
      self.layer_idx = 0
      self.current_layer = 0
      self.box_size = 150
      self.spacing = 10
    end,
    __base = _base_0,
    __name = "ItemGrid",
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
  ItemGrid = _class_0
end
