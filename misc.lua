
local lib = {}

lib.tablefind = function (tab, el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

lib.concatTables = function (t1, t2)
  local t3 = {unpack(t1)}
  for i=1,#t2 do
    t3[#t3+1] = t2[i]
  end
  return t3
end

lib.addToTable = function (t1, t2)
  for i=1,#t2 do
    t1[#t1+1] = t2[i]
  end
end

lib.filterArray = function (array, p)
  local filtered = {}
  for k, v in ipairs(array) do
    if p(v) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

local function clamp01(x)
    return math.min(math.max(x, 0), 1)
end

function love.math.colorFromBytes(r, g, b, a)
    if type(r) == "table" then
            r, g, b, a = r[1], r[2], r[3], r[4]
    end
    r = clamp01(math.floor(r + 0.5) / 255)
    g = clamp01(math.floor(g + 0.5) / 255)
    b = clamp01(math.floor(b + 0.5) / 255)
    a = a ~= nil and clamp01(floor(a + 0.5) / 255) or nil
    return r, g, b, a
end

return lib
