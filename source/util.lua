function starts_with(str, start)
   return str:sub(1, #start) == start
end

function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

function basename(str)
	return str:match("(.+)%..+")
end

function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    
    local t={}
    
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        table.insert(t, str)
    end

    return t
end

function table.length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end