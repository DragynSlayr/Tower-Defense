class ScoreNode
  new: (score, name) =>
    @score = score
    @name = name
    @next = nil

class ScoreArray
  new: =>
    @elements = {}
    @size = 0
    @sorted = true

  add: (score, name) =>
    table.insert @elements, (ScoreNode (tonumber score), (tostring name))
    @size += 1
    @sorted = false

  remove: =>
    if @size > 0
      if not @sorted
        @sort!
      node = table.remove @elements, 1
      @size -= 1
      return node

  sort: =>
    for i = 1, #@elements - 1
      max = i
      for j = i + 1, #@elements
        if @elements[max].score < @elements[j].score
          max = j
      @swap i, max
    @sorted = true

  swap: (i, j) =>
    temp = @elements[i]
    @elements[i] = @elements[j]
    @elements[j] = temp

  print: =>
    if not @sorted
      @sort!
    s = ""
    for k, v in pairs @elements
      s ..= v.name .. ", " .. v.score
      if k ~= #@elements
        s ..= "\n"
    print s

export class Score
  new: =>
    @score = 0
    @score_threshold = 10000
    @shift = 128

    if not love.filesystem.exists "HIGH_SCORES"
      love.filesystem.write "HIGH_SCORES", ""

    @loadScores!

  loadScores: =>
    @high_scores = ScoreArray!
    contents, size = love.filesystem.read "HIGH_SCORES"
    if size > 0
      lines = split contents, "\n"
      for k, v in pairs lines
        line = @decode v
        splitted = split line, "\t"
        @high_scores\add splitted[2], splitted[1]

  saveScores: =>
    temp = ScoreArray!
    s = ""
    while @high_scores.size > 0
      node = @high_scores\remove!
      temp\add node.score, node.name
      s ..= @encode node.name .. "\t" .. node.score
      if @high_scores.size ~= 0
        s ..= "\n"
    love.filesystem.write "HIGH_SCORES", s
    @high_scores = temp

  encode: (str, shift = @shift) =>
    s = ""
    for i = 1, #str
      char = string.sub str, i, i
      num = string.byte char
      num += shift
      s ..= string.char num
    return s

  decode: (str) =>
    return @encode str, -@shift

  update: (dt) =>
    if @score >= @score_threshold
      score_change = @score - @score_threshold
      score_change = math.floor score_change / 10000
      score_change += 1
      @score_threshold += 10000
      Upgrade\add_point score_change

  addScore: (score) =>
    @score += score

  submitScore: (text) =>
    name = text
    score = tostring @score
    @high_scores\add score, name
