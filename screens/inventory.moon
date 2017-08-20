export class InventoryScreen extends Screen
  new: =>
    super!
    @message1 = ""
    @message2 = ""
    @boxes = 0

  open_box: =>
    if @boxes < 1
      @set_message "", "No boxes to open"
    else
      frames = UI\filter ItemFrame
      opened_item_frame = nil
      for k, v in pairs frames
        if v.frameType == ItemFrameTypes.transfer
          opened_item_frame = v
          break

      if opened_item_frame.empty
        item = ItemPool\getItem!
        @boxes -= 1
        opened_item_frame\setItem item
        opened_item_frame.empty = item.__class == NullItem
        opened_item_frame.usable = not opened_item_frame.empty
        message = "Received " .. item.name
        if item.__class == NullItem
          message = "Received nothing"
        @set_message "Box opened", message
      else
        @set_message "Box can't be opened", "Slot not empty"

  set_message: (message1 = "", message2 = "") =>
    @message1 = message1
    @message2 = message2

  draw: =>
    love.graphics.push "all"
    Renderer\drawAlignedMessage @message1, Screen_Size.height * 0.15, "center", Renderer.hud_font
    Renderer\drawAlignedMessage @message2, Screen_Size.height * 0.19, "center", Renderer.hud_font
    Renderer\drawHUDMessage "x " .. @boxes, 175 * Scale.width, Screen_Size.height - (100 * Scale.height), Renderer.small_font
    love.graphics.pop!
