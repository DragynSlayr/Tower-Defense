-- Class for handling music controls
export class MusicHandler
  new: =>
    -- Load sounds
    @menu_music = Sound "themes/menu.mp3", 0.5
    @enemy_music = Sound "themes/enemy.mp3", 0.01
    @current_music = @menu_music

    -- Set values for fading
    @fade_in = false
    @fade_out = false

  -- Fades to a new song
  -- song: The new song
  -- in1p: Starting volume of current song
  -- out1p: Ending volume of current song
  -- in2p: Starting volume of new song
  -- out2p: Ending volume of new song
  -- outTime: Time to fade out
  -- inTime: Time to fade in
  fadeTo: (song, in1p, out1p, in2p, out2p, outTime, inTime) =>
    -- Format volumes
    in1 = in1p / 100
    out1 = out1p / 100
    in2 = in2p / 100
    out2 = out2p / 100

    -- Set next sone
    @next = song

    -- Set fading variables
    @fadeOut = true
    @outStep = (in1 - out1) / (outTime * 60)
    @inStep = (out2 - in2) / (inTime * 60)
    @outStop = out1
    @inStop = out2
    @outStart = in2

  -- Fades songs if needed
  -- dt: Time since last update
  update: (dt) =>
    if @fadeOut
      if @current_music\getVolume! > @outStop
        -- Reduce volume of current sound
        @current_music\setVolume @current_music\getVolume! - @outStep
      else
        -- Stop fading out
        @fadeOut = false
        @fadeIn = true

        -- Switch songs
        @current_music\stop!
        @current_music = @next

        -- Start new songs
        @current_music\setVolume @outStart
        @current_music\start!

    if @fadeIn
      if @current_music\getVolume! < @inStop
        -- Increase volume of new song
        @current_music\setVolume @current_music\getVolume + @inStep
      else
        -- Stop fading in
        @fadeIn = false

        -- Set final volume
        @current_music\setVolume @inStop

  -- Play the current sound
  play: =>
    @current_music\start!

  -- Toggle playback of current sound
  toggle: =>
    @current_music\toggle!

  -- Stop playback
  stop: =>
    @current_music\stop!
