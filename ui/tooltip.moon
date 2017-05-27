export class Tooltip extends Text
  new: (x, y, text, font) =>
    super x, y, text, font
    @enabled = false

  draw: =>
    if @enabled
      super!
