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

isomatrix = {
    projection = {r = 1, dx = 0.2, dy = 1.1},
    position = {x = 626, y = -12},
    tile = {width = 29, height = 29},
    selection = {col = 1, row = 1},
    size = {x = 20, y = 20}  -- number of tiles 
}

--convert iso matrix to 2d matrix
function isomatrix:isoTo2D(tx, ty)
  local x, y = 0, 0
  x = (self.projection.r * (self.projection.r + self.projection.dy) * ty + (self.projection.r + self.projection.dx) * tx) / (math.pow(self.projection.r,2) + 1)
  y = (-self.projection.r * (self.projection.r + self.projection.dx) * tx + (self.projection.r + self.projection.dy) * ty) / (math.pow(self.projection.r,2) + 1)
  return x, y
end

--convert 2d matrix to iso matrix
function isomatrix:twoDToIso(x, y)
  local tx, ty = 0, 0
  tx = ((x - y * self.projection.r) / (self.projection.r + self.projection.dx))
  ty = ((y + x * self.projection.r) / (self.projection.r + self.projection.dy))
  return tx, ty
end

--convert 2d point to specific tile row/column
function isomatrix:getTileCoordinates(x, y)
  local tx, ty = 0, 0
  tx = math.floor((x - self.position.x) / self.tile.width)
  ty = math.floor((y - self.position.y) / self.tile.height)
  return tx, ty
end

--convert specific tile row/column to 2d point
function isomatrix:get2dFromTileCoordinates(x, y)
  local tx, ty = 0, 0
  tx = self.position.x + x * self.tile.width
  ty = self.position.y + y * self.tile.height
  return tx, ty
end



function isomatrix:draw()

  
  love.graphics.setColor(0,0,0,255)
  
  for i=self.size.x, -self.size.x, -1 do
    for j=-self.size.y, self.size.y, 1 do
  --for i=0, self.size.x, 1 do
    --for j=0, self.size.y, 1 do
      
      local px = self.position.x + i * self.tile.width
      local py = self.position.y + j * self.tile.height

      local vx1, vy1 = px, py
      local vx2, vy2 = px, py + self.tile.height
      --local vx1, vy1 = self.position.x + i * self.tile.width, self.position.y + j * self.tile.height
      --local vx2, vy2 = self.position.x + i * self.tile.width, self.position.y + (j + 1) * self.tile.height
      
      local hx1, hy1 = px, py
      local hx2, hy2 = px + self.tile.width, py
      --local hx1, hy1 = self.position.x + i * self.tile.width, self.position.y + j * self.tile.height
      --local hx2, hy2 = self.position.x + (i + 1) * self.tile.width, self.position.y + j * self.tile.height
      
      --[[
      -- matrix em 2d
      love.graphics.setColor(0,0,100,255)
      love.graphics.line(vx1,vy1,vx2,vy2)
      love.graphics.line(hx1,hy1,hx2,hy2)
      ]]--

      -- matrix em iso
      love.graphics.setColor(0,0,0,255)
      vx1, vy1 = isomatrix:twoDToIso(vx1, vy1)
      vx2, vy2 = isomatrix:twoDToIso(vx2, vy2)
      
      hx1, hy1 = isomatrix:twoDToIso(hx1, hy1)
      hx2, hy2 = isomatrix:twoDToIso(hx2, hy2)
      
      love.graphics.line(vx1,vy1,vx2,vy2)
      love.graphics.line(hx1,hy1,hx2,hy2)
      
      --[[
      -- teste transformacao iso para 2d
      vx1, vy1 = isomatrix:isoTo2D(vx1, vy1)
      vx2, vy2 = isomatrix:isoTo2D(vx2, vy2)
      
      hx1, hy1 = isomatrix:isoTo2D(hx1, hy1)
      hx2, hy2 = isomatrix:isoTo2D(hx2, hy2)
      
      love.graphics.setColor(100,0,0,255)
      love.graphics.line(vx1,vy1,vx2,vy2)
      love.graphics.line(hx1,hy1,hx2,hy2)
      ]]--
    end
  end
  
  isomatrix:draw_tilemarker(self.selection.col, self.selection.row)
end  

function isomatrix:draw_tilemarker(col, row)
  
  -- Draw marker on selected tile
  local nx, ny = isomatrix:get2dFromTileCoordinates(col, row)
  nx1, ny1 = isomatrix:twoDToIso(nx, ny)
  nx2, ny2 = isomatrix:twoDToIso(nx + self.tile.width, ny)
  nx3, ny3 = isomatrix:twoDToIso(nx, ny + self.tile.height)
  nx4, ny4 = isomatrix:twoDToIso(nx + self.tile.width, ny + self.tile.height)

  -- Draw Image position Debuger
  local ix, iy = math.floor(nx3 + 0.5), math.floor(ny1 + 0.5)
  local iw, ih = math.floor(nx2 - nx3 + 0.5), math.floor(ny4 - ny1 + 0.5)
  
  love.graphics.setColor(255,255,255,100)
  love.graphics.rectangle("line", ix, iy, iw, ih)
  
  -- Draw markers
  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("fill", nx1, ny1, 5, 10)
  love.graphics.setColor(255,0,0,255)
  love.graphics.circle("fill", nx1, ny1, 3, 10)

  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("fill", nx2, ny2, 5, 10)
  love.graphics.setColor(255,0,0,255)
  love.graphics.circle("fill", nx2, ny2, 3, 10)
  
  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("fill", nx3, ny3, 5, 10)
  love.graphics.setColor(255,0,0,255)
  love.graphics.circle("fill", nx3, ny3, 3, 10)
  
  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("fill", nx4, ny4, 5, 10)
  love.graphics.setColor(255,0,0,255)
  love.graphics.circle("fill", nx4, ny4, 3, 10)
end

function isomatrix:keypressed( key, scancode, isrepeat)
  
  -- projection dist = shift + (w/s) horizontal or (a/d) vertical
  -- projection rotation = (q/e) tile size
  -- matrix position = (w/s) horizontal or (a/d) vertical
  -- tile size = shift + (q/e) tile size
  
  if love.keyboard.isDown("lshift") then
    if key == "w" then
      self.projection.dy = self.projection.dy + 0.1
    end
    if key == "s" then
      self.projection.dy = self.projection.dy - 0.1
    end
    
    if key == "d" then
      self.projection.dx = self.projection.dx + 0.1
    end
    if key == "a" then
      self.projection.dx = self.projection.dx - 0.1
    end

  if key == "e" then
      self.tile.width = self.tile.width + 1
      self.tile.height = self.tile.width
    end
    if key == "q" then
      self.tile.width = self.tile.width - 1
      self.tile.height = self.tile.width
    end
  
  else

    if key == "e" then
      self.projection.r = self.projection.r + 0.1
    end
    if key == "q" then
      self.projection.r = self.projection.r - 0.1
    end

    if key == "a" then
      self.position.x = self.position.x - 1
    end
    if key == "d" then
      self.position.x = self.position.x + 1

    end
    if key == "w" then
      self.position.y = self.position.y - 1
    end
    if key == "s" then
      self.position.y = self.position.y + 1
    end


    
  end

  print("----")
  print("tile: w="..self.tile.width.."  h="..self.tile.height)
  print("position: x="..self.position.x.." y="..self.position.y)
  print("projection: dx="..self.projection.dx.." dy="..self.projection.dy.." r:"..self.projection.r)



end

function isomatrix:mousemoved(x, y, dx, dy, istouch)

  print("----")
  print("mouse over: x="..x.. " y="..y)
  
  x, y = isomatrix:isoTo2D(x, y)
  self.selection.col, self.selection.row = isomatrix:getTileCoordinates(x, y)
  
  print("select tile: col="..self.selection.col.. " row="..self.selection.row)  
  
  -- calculate coordinates and image size to current selected tile
  -- calculate bounds
  local nx, ny = isomatrix:get2dFromTileCoordinates(self.selection.col, self.selection.row)
  nx1, ny1 = isomatrix:twoDToIso(nx, ny)
  nx2, ny2 = isomatrix:twoDToIso(nx + self.tile.width, ny)
  nx3, ny3 = isomatrix:twoDToIso(nx, ny + self.tile.height)
  nx4, ny4 = isomatrix:twoDToIso(nx + self.tile.width, ny + self.tile.height)

  -- calculate image position and size
  local ix, iy = math.floor(nx3 + 0.5), math.floor(ny1 + 0.5)
  local iw, ih = math.floor(nx2 - nx3 + 0.5), math.floor(ny4 - ny1 + 0.5)
  
  print("image tile: x="..ix.. " y="..iy.." w="..iw.. " h="..ih)  
end

return isomatrix