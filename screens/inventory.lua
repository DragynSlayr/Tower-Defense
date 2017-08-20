do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    open_box = function(self)
      if self.boxes < 1 then
        return self:set_message("", "No boxes to open")
      else
        local frames = UI:filter(ItemFrame)
        local opened_item_frame = nil
        for k, v in pairs(frames) do
          if v.frameType == ItemFrameTypes.transfer then
            opened_item_frame = v
            break
          end
        end
        if opened_item_frame.empty then
          local item = ItemPool:getItem()
          self.boxes = self.boxes - 1
          opened_item_frame:setItem(item)
          opened_item_frame.empty = item.__class == NullItem
          opened_item_frame.usable = not opened_item_frame.empty
          local message = "Received " .. item.name
          if item.__class == NullItem then
            message = "Received nothing"
          end
          return self:set_message("Box opened", message)
        else
          return self:set_message("Box can't be opened", "Slot not empty")
        end
      end
    end,
    set_message = function(self, message1, message2)
      if message1 == nil then
        message1 = ""
      end
      if message2 == nil then
        message2 = ""
      end
      self.message1 = message1
      self.message2 = message2
    end,
    draw = function(self)
      love.graphics.push("all")
      Renderer:drawAlignedMessage(self.message1, Screen_Size.height * 0.15, "center", Renderer.hud_font)
      Renderer:drawAlignedMessage(self.message2, Screen_Size.height * 0.19, "center", Renderer.hud_font)
      Renderer:drawHUDMessage("x " .. self.boxes, 175 * Scale.width, Screen_Size.height - (100 * Scale.height), Renderer.small_font)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.message1 = ""
      self.message2 = ""
      self.boxes = 0
    end,
    __base = _base_0,
    __name = "InventoryScreen",
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
  InventoryScreen = _class_0
end
