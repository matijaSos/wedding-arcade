
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

return lib
