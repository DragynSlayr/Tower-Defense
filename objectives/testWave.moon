export class TestWave extends Wave
  new: (parent) =>
    super parent

  start: =>
    return

  entityKilled: (entity) =>
    return

  update: (dt) =>
    super dt
    if not @waiting
      return

  draw: =>
    super!
