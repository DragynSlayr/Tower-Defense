local init
init = function()
  love.graphics.setBackgroundColor(200, 200, 200)
  return love.graphics.setDefaultFilter("nearest", "nearest")
end
return init()
