export class GameOverScreen extends Screen
  new: =>
    @ui_objects = {}
    @createMenu!

  createMenu: =>
    x = (Screen_Size.width / 2) - (250 * Scale.width)
    y = Screen_Size.height - (120 * Scale.height)
    width = 370 * Scale.width
    height = 50 * Scale.height
    submit_box = TextBox x, y, width, height
    submit_box.action = {}
    submit_box.active = false
    submit_box.font = Renderer\newFont 25
    submit_box.text_color = {255, 255, 255, 255}
    @add submit_box

    x = (Screen_Size.width / 2) + (190 * Scale.width)
    y = Screen_Size.height - (95 * Scale.height)
    submit_button = Button x, y, 125, 50, "Submit", () =>
      @active = false
      ScoreTracker\submitScore submit_box\getText!
      submit_box\resetText!
    @add submit_button

  add: (object) =>
    table.insert @ui_objects, object

  keypressed: (key, scancode, isrepeat) =>
    for k, v in pairs @ui_objects
      v\keypressed key, scancode, isrepeat

  keyreleased: (key) =>
    for k, v in pairs @ui_objects
      v\keyreleased key

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousereleased x, y, button, isTouch

  textinput: (text) =>
    for k, v in pairs @ui_objects
      v\textinput text

  update: (dt) =>
    for k, v in pairs @ui_objects
      v\update dt

  draw: =>
    for k, v in pairs @ui_objects
      v\draw!
    Renderer\drawAlignedMessage "Score: " .. ScoreTracker.score, 270 * Scale.height

    love.graphics.push "all"
    x_start = 400
    x = x_start * Scale.width
    y_start = 300 * Scale.height
    y = y_start
    width = Screen_Size.width - (x_start * 2 * Scale.width)
    height = 475 * Scale.height
    love.graphics.setColor 0, 0, 0, 127
    love.graphics.rectangle "fill", x, y, width, height

    love.graphics.setColor 0, 255, 255, 255
    love.graphics.setFont Renderer.hud_font

    gap = 20

    ScoreTracker.high_scores\sort!
    for k, node in pairs ScoreTracker.high_scores.elements
      if y - y_start < height
        love.graphics.printf node.name, x + (gap * Scale.width), y, width - (2 * gap * Scale.width), "left"
        love.graphics.printf node.score, x + (gap * Scale.width), y, width - (2 * gap * Scale.width), "right"
        y += Renderer.hud_font\getHeight! + (5 * Scale.height)

    love.graphics.pop!
