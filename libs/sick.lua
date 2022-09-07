-- SICK: Simple Indicative of Competitive sKill
-- aka libhighscore

local lume = require 'libs.lume.lume'

local h = {}
h.scores = {}

-- TODO(matija): I don't need this, I have all this info already in h.scores
h.mostRecentNames = {}

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

      h.mostRecentNames[#h.mostRecentNames + 1] = line:sub(i + 1)
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

    table.insert(h.mostRecentNames, 1, name)
end

-- For the given score, check which place it would assume
-- in a leaderboard table. Does not add the score.
function h.checkPlace(score)
    -- TODO(matija): we could use binary search here.

    for i, entry in ipairs(h.scores) do
        if entry[1] < score then
            return i
        end
    end
    return #h.scores + 1
end

function h.getMostRecentNames(n)
    local occ = {}
    local mrn = {} -- Most recent names without duplicates.
    
    for _, name in ipairs(h.mostRecentNames) do
        if not occ[name] then
            table.insert(mrn, name)
            occ[name] = true
        end
    end

    -- NOTE(matija): not supported in love 11.1
    --return table.move(mrn, 1, n, 1, {})

    local firstN = {}
    for i=1, math.min(n, #mrn) do
        table.insert(firstN, mrn[i])
    end

    return firstN
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
