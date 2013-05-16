
--Global Enums
TRIPLE_WORD = "x3W"
DOUBLE_WORD = "x2W"
TRIPLE_LETTER = "x3L" 
DOUBLE_LETTER = "x2L"


local tiles = require("tiles")
local board = require("board")
local dawg = require("dawg")

function loadDict()
    local d = {}
    for l in io.lines("dictionary.txt") do
        table.insert(d,string.lower(l))
    end
    return d
end

function string.ToTable(s)
    local ret = {}
    for i=1,string.len(s) do
        table.insert(ret,string.sub(s,i,i))
    end
    return ret
end

function table.CountVal(t,val)
    local i = 0
    for k,v in ipairs(t) do
        if v==val then
            i=i+1
        end
    end
    return i
end

function table.RemoveVal(t,val)
    local i
    for k,v in ipairs(t) do
        if v==val then
            i=k
            break
        end
    end
    if i then
        table.remove(t,i)
    end
end

function string.IsAnagram(s1,s2)
    local lst = string.ToTable(s1)
    for i,l in ipairs(lst) do
        if table.CountVal(lst,l)>0 then
            table.RemoveVal(lst,l)
        else
            return false
        end
    end
    
    if not lst[1] then
        return true
    else
        return false
    end
end

function table.HasValue(t,val)
    for k,v in pairs(t) do
        if v==val then return k end
    end
end

function string.hasChars(s1,has)
    local ht = string.ToTable(has)
    local st = string.ToTable(s1)
    if #has > #s1 then return false end
    for i=1,#ht do
        local c = table.HasValue(st,ht[i])
        if c then
            table.remove(st,c)
        else
            return false
        end
    end
    return true
end

local match = string.match
function string.trim(s)
  return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end

function string.Lexo(s)
    local t = string.ToTable(s)
    table.sort(t)
    return string.trim(table.concat(t,""))
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function table.print(tbl, indent)
  print(tbl, #tbl)
  if not indent then indent = 0 end
  for k,v in pairs(tbl) do
    formatting = string.rep(" ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      table.print(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end


function sortDict(t)
    local ret = dawg.New()
    for k,v in ipairs(t) do
        ret:Add(v)
        --[[if not ret[lex] then
            ret[lex] = {}
            ret[lex].subs = function(full)
                local ret = {}
                for kz,vz in pairs(full) do
                    if lex~=kz and string.hasChars(lex,kz) then
                        table.insert(ret,full[kz])
                    end
                end
                return ret
            end
        end
        table.insert(ret[lex],v)]]
    end
    return ret
end


local brd
function init()
    local s = os.time()
    local dict = loadDict() 
    print("Loading the file took "..(os.time()-s).." seconds.")
    local s = os.time()
    local d = sortDict(dict)
    local en = (os.time()-s)
    --table.print(d)
    print("Creating a sorted hashmap took "..en.." seconds.")
    
    local s = os.time()
    local sho = d:GetEnds("sho")
    local en = (os.time()-s)
    print("Finding all starting ending in 'sho' took "..en.." seconds.")
    
    brd = board.Empty()
    
    local satisfied
    repeat
        io.write("Please enter my current tiles: ")
        io.flush()
        local til = string.lower(io.read())
        local t = {}
        for i=1,string.len(til) do
            local char = string.sub(til,i,i)
            local tile = tiles.New()
            tile:SetContents(char)
            table.insert(t,tile)
        end
        
        print("Are these tiles okay?")
        local str = "["
        for k,v in ipairs(t) do
            str = str..v:GetContents()..","
        end
        str = string.sub(str,1,-2).."]"
        print(str)
        io.write("Are you satisfied? (y/n)")
        io.flush()
        local yn = string.lower(io.read())
        if yn=="y" then satisfied=true end
    until satisfied
end


function main()
    if not hasInit then
        init()
    end

    brd:AddWord("cats",3,3,true)
    brd:AddWord("concubine",3,3)
    brd:Print()
    
    io.write("Continue with the game (y/n)? ")
    io.flush()
    local ans = io.read()
    if string.lower(ans)=="y" then
        main()
    end
end

main()