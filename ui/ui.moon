export class UI
  new: =>
    @elements = {}

  add: (element) =>
    @elements[#@elements + 1] = element

  update: (dt) =>
    for i = 1, #@elements
      @elements[i]\update dt

  draw: =>
    for i = 1, #@elements
      @elements[i]\draw!
