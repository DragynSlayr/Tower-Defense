export class Item extends GameObject
  @probability = 1
  new: (sprite) =>
    super 0, 0, sprite
    @item_type = nil
    @collectable = true
    @draw_health = false
    @contact_damage = true
    @id = EntityTypes.item
    @player = nil
    @timer = 0
    @solid = true
    @damage = 0
    @name = "No name"
    @description = "No description"
    if not @rarity
      @rarity = 5

  getRandomRarity: =>
    blackChance  = 50
    greenChance  = 26
    blueChance   = 15
    purpleChance = 8
    orangeChance = 1

    num = math.random! * 100
    if num > blackChance + greenChance + blueChance + purpleChance
      return 5
    elseif num > blackChance + greenChance + blueChance
      return 4
    elseif num > blackChance + greenChance
      return 3
    elseif num > blackChance
      return 2
    else
      return 1

  getStats: =>
    stats = {}
    table.insert stats, @name
    table.insert stats, @description
    return stats

  pickup: (player) =>
    table.insert player.equipped_items, @
    @collectable = false
    @contact_damage = false
    @solid = false
    @player = player
    print "Equipped " .. @name

  unequip: (player) =>
    successful = false
    for k, i in pairs player.equipped_items
      if i.name == @name
        table.remove player.equipped_items, k
        successful = true
        break
    if successful
      print "Unequipped " .. @name
    else
      print "Couldn't unequip " .. @name

  use: =>
    return

  update2: (dt) =>
    @timer += dt

  update: (dt) =>
    if @collectable
      super dt
    else
      @update2 dt

  draw2: =>
    return

  draw: =>
    if @collectable
      super!
    else
      @draw2!
