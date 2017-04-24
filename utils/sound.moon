export class Sound
  new: (name, volume = 1.0, looping = true, pitch = 1.0, static = false) =>
    if static
      @audio = love.audio.newSource("assets/sounds/" .. name, "static")
    else
      @audio = love.audio.newSource("assets/sounds/" .. name)

    @audio\setLooping looping
    @audio\setPitch pitch
    @audio\setVolume volume

  start: =>
    @audio\play!

  toggle: =>
    if @audio\isPaused!
      @audio\resume!
    else
      @audio\pause!

  stop: =>
    @audio\stop!

  setVolume: (volume) =>
    @audio\setVolume volume

  setPitch: (pitch) =>
    @audio\setPitch(pitch)

  setLooping: (looping) =>
    @audio\setLooping looping

  getVolume: =>
    return @audio\getVolume!

  getPitch: =>
    return @audio\getPitch!

  getLooping: =>
    return @audio\getLooping!
