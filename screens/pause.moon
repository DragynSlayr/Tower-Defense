export class PauseScreen extends Screen
  new: =>
    super!
    @font = Renderer\newFont 20
    @sprites = {(Sprite "player/test.tga", 16, 16, 0.29, 50 / 16), (Sprite "turret/turret.tga", 34, 16, 2, 50 / 34)}
    @icons = {
      (Sprite "ui/icons/health.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/range.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/damage.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/speed.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/attack_delay.tga", 16, 16, 1, 1)
    }
    @player_icons = @icons
    @turret_icons = {@icons[1], @icons[2], @icons[3], (Sprite "ui/icons/cooldown.tga", 16, 16, 1, 1), @icons[5]}

  update: (dt) =>
    typeof = ItemFrame
    frames = UI\filter typeof, Screen_State.inventory
    frames2 = UI\filter typeof
    for k, v in pairs frames2
      v\setItem frames[k].item
      v.sprite\setScale 2.5
      v.small_sprite = v.sprite
      v.normal_sprite = v.small_sprite

  draw: =>
    love.graphics.push "all"
    for j = 1, 2
      y = Screen_Size.height * 0.4
      stats = Stats.player
      x = Screen_Size.width * 0.05
      icons = @player_icons
      if j == 2
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
    love.graphics.pop!
