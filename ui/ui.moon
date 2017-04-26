-- Class for handling UI elements
export class UI
  new: =>
    -- List of elements of the GUI
    @elements = {}

  -- Add an element to the GUI
  add: (element) =>
    @elements[#@elements + 1] = element

  -- Update all the elements of the GUI
  -- dt: Time since last update
  update: (dt) =>
    for i = 1, #@elements
      @elements[i]\update dt

  -- Draw the GUI elements
  draw: =>
    for i = 1, #@elements
      @elements[i]\draw!
