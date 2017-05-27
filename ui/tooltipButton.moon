export class TooltipButton extends Button
  new: (x, y, width, height, text, action, font = Renderer.hud_font, tooltips) =>
    super x, y, width, height, text, action, font
    @tooltips = tooltips

  update: (dt) =>
    super dt
    for k, v in pairs @tooltips
      v.enabled = @isHovering love.mouse.getPosition!
