
local setmetatable = setmetatable

module("tiles")

TRIPLE_WORD = "x3W"
DOUBLE_WORD = "x2W"
TRIPLE_LETTER = "x3L" 
DOUBLE_LETTER = "x2L"

local ptsLookup = {["a"]=1,
["b"]=3,
["c"]=3,
["d"]=2,
["e"]=1,
["f"]=4,
["g"]=2,
["h"]=4,
["i"]=1,
["j"]=8,
["k"]=5,
["l"]=1,
["m"]=3,
["n"]=1,
["o"]=1,
["p"]=3,
["q"]=10,
["r"]=1,
["s"]=1,
["t"]=1,
["u"]=1,
["v"]=4,
["w"]=4,
["x"]=8,
["y"]=4,
["z"]=10,
[" "]=0}

local Tiles = {}

Tiles.__index = Tiles

Tiles.__type = "tile"

function Tiles:GetContents()
    return self.Letter
end

function Tiles:GetMod()
    return self.Mod
end

function Tiles:SetContents(c)
    self.Letter = c
end

function Tiles:SetMod(m)
    self.Mod = m
end

function Tiles:GetScore()
    if self.Mod == DOUBLE_LETTER then
        return ptsLookup[self:GetContents() or " "] * 2
    elseif self.Mod == TRIPLE_LETTER then
        return ptsLookup[self:GetContents() or " "] * 3
    else
        return ptsLookup[self:GetContents() or " "]
    end
end

function Tiles:GetDisplay()
    if self:GetContents() then return " "..self:GetContents().." " end
    return self:GetMod() or "   "
end

function New()
    local b = {}
    setmetatable(b,Tiles)
    return b
end