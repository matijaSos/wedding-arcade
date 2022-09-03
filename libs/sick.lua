-- SICK: Simple Indicative of Competitive sKill
-- aka libhighscore
local h = {}
h.scores = {}

function h.set(filename, places)
   h.filename = filename
   h.places = places
   if not h.load() then
      print('could not load/create a file with scores!')
   end
end

function h.load()
   local file = love.filesystem.newFile(h.filename)
   local openStatus, openErr = file:open('r')

   if not love.filesystem.getInfo(h.filename) or not openStatus then
      print('load: cant open for reading or find info')
      return
   end

   h.scores = {}
   -- TODO(matija): I could use lume to serialize/deserialize instead of
   -- using tab.
   for line in file:lines() do
      local i = line:find('\t', 1, true)
      h.scores[#h.scores+1] = {tonumber(line:sub(1, i-1)), line:sub(i+1)}
   end

   -- NOTE(matija): we're not explicitly closing the file via file:close() because
   -- it keeps returning false although everything works fine.
   -- Lua docs also mention it is not neccessary to explicitly close the file.

   return true
end

local function sortScore(a, b)
   return a[1] > b[1]
end

function h.add(name, score)
   h.scores[#h.scores+1] = {score, name}
   table.sort(h.scores, sortScore)
end

function h.save()
   local file = love.filesystem.newFile(h.filename)

   if not file:open("w") then
      print('save: cant open for writing')
      return
   end

   for i = 1, #h.scores do
      item = h.scores[i]
      file:write(item[1] .. "\t" .. item[2] .. "\n")
   end

   return file:close()
end

setmetatable(h, {__call = function(self)
		    local i = 0
		    return function()
		       i = i + 1
		       if i <= h.places and h.scores[i] then
			  return i, unpack(h.scores[i])
		       end
		    end
end})

local highscore = h

return h
