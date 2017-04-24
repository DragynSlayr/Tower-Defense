export class MusicHandler
  new: =>
    @menu_music = Sound "themes/menu.mp3", 0.5
    @enemy_music = Sound "themes/enemy.mp3", 0.01
    @current_music = @menu_music
    @fade_in = false
    @fade_out = false

  fadeTo: (song, in1p, out1p, in2p, out2p, outTime, inTime) =>
    in1 = in1p / 100
    out1 = out1p / 100
    in2 = in2p / 100
    out2 = out2p / 100

    @next = song
    @fadeOut = true
    @outStep = (in1 - out1) / (outTime * 60)
    @inStep = (out2 - in2) / (inTime * 60)
    @outStop = out1
    @inStop = out2
    @outStart = in2

  update: (dt) =>
    if @fadeOut
      if @current_music\getVolume! > @outStop
        @current_music\setVolume @current_music\getVolume! - @outStep
      else
        @fadeOut = false
        @fadeIn = true

        @current_music\stop!

        @current_music = @next
        @current_music\setVolume @outStart
        @current_music\start!

    if @fadeIn
      if @current_music\getVolume! < @inStop
        @current_music\setVolume @current_music\getVolume + @inStep
      else
        @fadeIn = false
        @current_music\setVolume @inStop

  play: =>
    @current_music\start!

  toggle: =>
    @current_music\toggle!

  stop: =>
    @current_music\stop!
