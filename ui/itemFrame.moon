export class ItemFrame extends UIElement
  new: (x, y, item) =>
    super x, y
    if item
      @setItem item
      @usable = true
    else
      @setItem (NullItem 0, 0)
      @usable = false
    @width = 150 * Scale.width
    @height = 150 * Scale.height
    @center = Point @x, @y
    @x -= @width / 2
    @y -= @height / 2
    @phase = 1
    @frameType = ItemFrameTypes.default

    check_button = Button @x + (@width * 0.5) - (50 * Scale.width), @y + @height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", () =>
      if @master.frameType == ItemFrameTypes.transfer
        frames = UI\filter ItemFrame
        equipped = false
        slot = ""
        if @master.item.item_type == ItemTypes.active
          slot = "active"
          for k, f in pairs frames
            if f.frameType == ItemFrameTypes.equippedActive
              if f.empty
                f\setItem @master.item
                f.usable = false
                @master\setItem NullItem 0, 0
                @master.phase = 1
                @master.sprite = @master.normal_sprite
                @master.usable = false
                equipped = true
                break
          if not equipped
            for k, f in pairs frames
              if f.frameType == ItemFrameTypes.active
                if f.empty
                  f\setItem @master.item
                  f.usable = true
                  @master\setItem NullItem 0, 0
                  @master.phase = 1
                  @master.sprite = @master.normal_sprite
                  @master.usable = false
                  equipped = true
                  break
        else
          for k, f in pairs frames
            if f.frameType == ItemFrameTypes.equippedPassive
              if f.empty
                f\setItem @master.item
                f.usable = false
                @master\setItem NullItem 0, 0
                @master.phase = 1
                @master.sprite = @master.normal_sprite
                @master.usable = false
                equipped = true
                break
          if not equipped
            for k, f in pairs frames
              slot = "passive"
              if f.frameType == ItemFrameTypes.passive
                if f.empty
                  f\setItem @master.item
                  f.usable = true
                  @master\setItem NullItem 0, 0
                  @master.phase = 1
                  @master.sprite = @master.normal_sprite
                  @master.usable = false
                  equipped = true
                  break
        if equipped
          Inventory\set_item!
          Inventory\set_message "", "Item stored"
        else
          Inventory\set_item!
          Inventory\set_message "Item can't be stored", "No " .. slot .. " item slot available"
      else
        frames = UI\filter ItemFrame
        equipped = nil
        slot = ""
        if @master.item.item_type == ItemTypes.active
          slot = "Active"
          for k, f in pairs frames
            if f.frameType == ItemFrameTypes.equippedActive
              equipped = f
              break
        else
          slot = "Passive"
          for k, f in pairs frames
            if f.frameType == ItemFrameTypes.equippedPassive
              equipped = f
              break
        if equipped.empty
          equipped\setItem @master.item
          equipped.usable = false
          @master\setItem NullItem 0, 0
          @master.phase = 1
          @master.sprite = @master.normal_sprite
          @master.usable = false
          if Driver.objects[EntityTypes.player]
            for k, p in pairs Driver.objects[EntityTypes.player]
              equipped.item\pickup p
        else
          current_item, new_item = equipped.item, @master.item
          equipped\setItem new_item
          equipped.usable = false
          @master\setItem current_item
          @master.phase = 1
          @master.sprite = @master.normal_sprite
          @master.usable = true
          if Driver.objects[EntityTypes.player]
            for k, p in pairs Driver.objects[EntityTypes.player]
              new_item\pickup p
              current_item\unequip p
        Inventory\set_item!
        Inventory\set_message "", equipped.item.name .. " equipped in " .. slot .. " slot"
    check_button.master = @
    check_sprite = Sprite "ui/button/check.tga", 32, 32, 1, 50 / 32
    check_button\setSprite check_sprite, check_sprite

    back_button = Button @x + (@width * 0.5), @y + @height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", () =>
      @master.phase = 1
      @master.sprite = @master.normal_sprite
    back_button.master = @
    back_sprite = Sprite "ui/button/back.tga", 32, 32, 1, 50 / 32
    back_button\setSprite back_sprite, back_sprite

    trash_button = Button @x + (@width * 0.5) + (50 * Scale.width), @y + @height - (25 * Scale.height), 50 * Scale.width, 50 * Scale.height, "", () =>
      Inventory\set_item!
      Inventory\set_message "", "Destroyed " .. @master.item.name
      @master\setItem NullItem 0, 0
      @master.phase = 1
      @master.sprite = @master.normal_sprite
      @master.usable = false
    trash_button.master = @
    trash_sprite = Sprite "ui/button/trash.tga", 32, 32, 1, 50 / 32
    trash_button\setSprite trash_sprite, trash_sprite

    @buttons = {check_button, back_button, trash_button}

  setItem: (item) =>
    @empty = item.__class == NullItem
    @item = item
    @normal_sprite = @item.sprite\getCopy!
    @normal_sprite\scaleUniformly 2
    @sprite = @normal_sprite\getCopy!
    @small_sprite = @normal_sprite\getCopy!
    @small_sprite\scaleUniformly 0.75

  scaleUniformly: (scale) =>
    @sprite\scaleUniformly scale
    @normal_sprite\scaleUniformly scale
    @small_sprite\scaleUniformly scale
    @width *= scale
    @height *= scale
    @x = @center.x - (@width / 2)
    @y = @center.y - (@height / 2)
    --@center = Point @x + (@width / 2), @y + (@height / 2)

  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if @phase == 2
      for k, b in pairs @buttons
        b\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    if @phase == 2
      for k, b in pairs @buttons
        b\mousereleased x, y, button, isTouch

  update: (dt) =>
    if love.mouse.isDown 1
      if @isHovering love.mouse.getPosition!
        if @usable
          @phase = 2
          @sprite = @small_sprite
        Inventory\set_item @item
      else
        @phase = 1
        @sprite = @normal_sprite
    for k, b in pairs @buttons
      if @phase == 2
        b\update dt
      b.active = @phase == 2
    @sprite\update dt

  draw: =>
    love.graphics.push "all"
    love.graphics.setColor 200, 200, 200, 255
    love.graphics.rectangle "fill", @x, @y, @width, @height
    if not @empty
      love.graphics.setColor 0, 0, 0, 0
      switch @item.item_type
        when ItemTypes.active
          love.graphics.setColor 255, 0, 0, 255
        when ItemTypes.passive
          love.graphics.setColor 0, 0, 255, 255
      love.graphics.rectangle "fill", @x, @y, @width, @height
      names = {"Item Box", "Empty"}
      if not tableContains names, @item.name
        color = Item_Rarity[@item.rarity]
        love.graphics.setColor color[1], color[2], color[3], color[4]
        gap = 10
        love.graphics.rectangle "fill", @x + (gap * Scale.width), @y + (gap * Scale.height), @width - (2 * gap * Scale.width), @height - (2 * gap * Scale.height)
    love.graphics.setColor 0, 0, 0, 255
    love.graphics.rectangle "line", @x, @y, @width, @height
    if @phase == 1
      @sprite\draw @center.x, @center.y
    else
      @sprite\draw @center.x, @y + (@height * 0.35)
      for k, b in pairs @buttons
        b\draw!
    love.graphics.pop!
