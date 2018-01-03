export class TestWave extends Wave
  new: (parent) =>
    super parent

  start: =>
    for i = 1, 2
      x = math.random Screen_Size.border[1], Screen_Size.border[3] + Screen_Size.border[1]
      y = math.random Screen_Size.border[2], Screen_Size.border[4] + Screen_Size.border[2]
      Driver\addObject (CloudEnemy x, y), EntityTypes.enemy

  update: (dt) =>
    super dt

  draw: =>
    super!
