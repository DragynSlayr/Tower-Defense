export class PauseScreen extends Screen
  new: =>
    super!
    @font = Renderer\newFont 20
    @sprites = {(Sprite "player/test.tga", 16, 16, 2, 50 / 16), (Sprite "turret/turret.tga", 34, 16, 2, 50 / 34)}
    @icons = {
      (Sprite "ui/icons/health.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/range.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/damage.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/speed.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/attack_delay.tga", 16, 16, 1, 1)
    }
    @player_icons = @icons
    @turret_icons = {@icons[1], @icons[2], @icons[3], (Sprite "ui/icons/cooldown.tga", 16, 16, 1, 1), @icons[5]}

    @getControls!

  getControls: =>
    export KEY_CHANGED = false
    @move_controls = {}
    @shoot_controls = {}
    @other_controls = {}
    for k, v in pairs Controls.key_names
      key = Controls.keys[v]
      value = (toTitle v, "_") .. " : " .. key
      if startsWith v, "MOVE"
        table.insert @move_controls, value
      elseif startsWith v, "SHOOT"
        table.insert @shoot_controls, value
      else
        table.insert @other_controls, value
    @controls = {@move_controls, @other_controls, @shoot_controls}

  update: (dt) =>
    typeof = ItemFrame
    frames = UI\filter typeof, Screen_State.inventory
    frames2 = UI\filter typeof
    for k, v in pairs frames2
      if frames[k].item.__class ~= v.item.__class
        v\setItem frames[k].item
        v.sprite\setScale 2.5
        v.small_sprite = v.sprite
        v.normal_sprite = v.small_sprite
    if KEY_CHANGED
      @getControls!

  draw: =>
    love.graphics.push "all"
    stats = {}
    for j = 1, 2
      y = Screen_Size.height * 0.4
      if Driver.objects[EntityTypes.player] and #Driver.objects[EntityTypes.player] > 0
        stats = Driver.objects[EntityTypes.player][1]\getStats!
      else
        stats = Stats.player
      x = Screen_Size.width * 0.05
      icons = @player_icons
      if j == 2
        if Driver.objects[EntityTypes.turret] and #Driver.objects[EntityTypes.turret] > 0
          stats = Driver.objects[EntityTypes.turret][1]\getStats!
        else
          stats = Stats.turret
        x = Screen_Size.width * 0.90
        icons = @turret_icons
      bounds = @sprites[j]\getBounds x, y
      for i = 1, #stats
        y = map i, 1, #stats, (Screen_Size.height * 0.4) + (40 * Scale.height), Screen_Size.height * 0.60
        icons[i]\draw x, y + (9 * Scale.height)
        Renderer\drawHUDMessage (string.format "%.2f", stats[i]), x + (10 * Scale.width) + bounds.radius, y, @font
    Renderer\drawAlignedMessage Inventory.message1, Screen_Size.height * 0.85, "center", Renderer.hud_font
    Renderer\drawAlignedMessage Inventory.message2, Screen_Size.height * 0.89, "center", Renderer.hud_font
    love.graphics.setFont Renderer.small_font
    love.graphics.setColor 0, 0, 0, 255
    for i = 1, 3
      y = 0.04
      if i == 2
        y /= 2
      for k, v in pairs @controls[i]
        love.graphics.printf v, (Screen_Size.width / 3) * (i - 1), Screen_Size.height * y, Screen_Size.width / 3, "center"
        y += 0.055
    love.graphics.pop!
