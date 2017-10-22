--[[
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Author: Augusto Baffa(abaffa@inf.puc-rio.br)
]]--

local isomatrix = require "isomatrix"
  
function love.load()
  
  print("--[[")
  print("Licensed under the Apache License, Version 2.0 (the \"License\");")
  print("you may not use this file except in compliance with the License.")
  print("You may obtain a copy of the License at")
  print("")
  print("     http://www.apache.org/licenses/LICENSE-2.0")
  print("")
  print("Unless required by applicable law or agreed to in writing, software")
  print("distributed under the License is distributed on an \"AS IS\" BASIS,")
  print("WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.")
  print("See the License for the specific language governing permissions and")
  print("limitations under the License.")
  print("")
  print("Author: Augusto Baffa(abaffa@inf.puc-rio.br)")
  print("]]--")
  print("")
  print("Isometric Matrix Love2D Example")
  print("")
  print("-- projection dist = shift + (w/s) horizontal or (a/d) vertical")
  print("-- projection rotation = (q/e) tile size")
  print("-- matrix position = (w/s) horizontal or (a/d) vertical")
  print("-- tile size = shift + (q/e) tile size")
  
  love.graphics.setBackgroundColor(255,255,255,255)
  imgtest = love.graphics.newImage("isomatrix.png")
end


function love.draw()

  love.graphics.setColor(255,255,255,255)

  local fx = love.graphics.getWidth() /  imgtest:getWidth()
  local fy = love.graphics.getHeight() /  imgtest:getHeight()
  
  love.graphics.draw(imgtest,0, 0, 0, fx, fy)
  
  isomatrix:draw()

end  
  
function love.update(dt)
end

function love.keypressed(...)
  isomatrix:keypressed(...)
end

function love.mousemoved(...)
  isomatrix:mousemoved(...)
end
