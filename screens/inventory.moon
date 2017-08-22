export class InventoryScreen extends Screen
  new: =>
    super!
    @set_message!
    @set_colors!
    @boxes = 0
    @item = nil

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

      @set_item!

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

  set_colors: (title_color = Item_Rarity[1], text_color = Item_Rarity_Text[1]) =>
    @title_color = Color title_color[1], title_color[2], title_color[3], title_color[4]
    @text_color = Color text_color[1], text_color[2], text_color[3], text_color[4]

  set_item: (item = nil) =>
    if item
      @set_message item.name, item.description
      @set_colors Item_Rarity[item.rarity], Item_Rarity_Text[item.rarity]
    else
      @set_message!
      @set_colors!

    @item = item

  draw: =>
    love.graphics.push "all"
    if @item
      stats = @item\getStats!
      y = Screen_Size.height * 0.15
      for k, v in pairs stats
        if y < Screen_Size.height
          color = @text_color
          if k == 1
            color = @title_color
          Renderer\drawAlignedMessage v, y, "center", Renderer.hud_font, color
          y += 35 * Scale.height
    else
      Renderer\drawAlignedMessage @message1, Screen_Size.height * 0.15, "center", Renderer.hud_font, @title_color
      Renderer\drawAlignedMessage @message2, Screen_Size.height * 0.19, "center", Renderer.hud_font, @text_color
    Renderer\drawHUDMessage "x " .. @boxes, 175 * Scale.width, Screen_Size.height - (100 * Scale.height), Renderer.small_font
    love.graphics.pop!
