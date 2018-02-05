export class InventoryScreen extends Screen
  new: =>
    super!
    @set_message!
    @set_colors!
    @boxes = 0
    @item = nil
    @opened_item_frame = nil

  open_box: =>
    if @boxes < 1
      @set_message "", "No boxes to open"
    else
      @set_item!

      if @opened_item_frame.empty
        item = ItemPool\getItem!
        @boxes -= 1
        @opened_item_frame\setItem item
        @opened_item_frame.empty = item.__class == NullItem
        @opened_item_frame.usable = not @opened_item_frame.empty
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
    love.graphics.setFont (Renderer\newFont 30)
    limit = Screen_Size.width * 0.30
    if @item
      stats = @item\getStats!
      y = Screen_Size.height * 0.40
      for k, v in pairs stats
        color = @text_color
        if k == 1
          color = @title_color
        love.graphics.setColor color\get!
        love.graphics.printf v, 0, y, limit, "center"
        multiplier = 1
        total_width = (Renderer\newFont 30)\getWidth v
        if total_width > limit
          multiplier = math.ceil (total_width / limit)
        y += 35 * multiplier * Scale.height
    else
      love.graphics.setColor @title_color\get!
      love.graphics.printf @message1, 0, Screen_Size.height * 0.40, limit, "center"
      love.graphics.setColor @text_color\get!
      love.graphics.printf @message2, 0, Screen_Size.height * 0.44, limit, "center"
    y = Screen_Size.height * 0.15 - (20 * Scale.height)
    x = {0.15, 0.60}
    colors = {{255, 0, 0, 255}, {0, 0, 255, 255}}
    love.graphics.setLineWidth 5
    for k, v in pairs x
      love.graphics.setColor colors[k][1], colors[k][2], colors[k][3], colors[k][4]
      love.graphics.rectangle "line", (v * Screen_Size.width) - ((60 + (15 * (k - 1))) * Scale.width), y, (120 + (30 * (k - 1))) * Scale.width, 40 * Scale.height
    Renderer\drawHUDMessage "x " .. @boxes, 175 * Scale.width, Screen_Size.height - (100 * Scale.height), (Renderer\newFont 20)
    love.graphics.pop!
