

local tiles = require("tiles")
local setmetatable = setmetatable
local tostring = tostring
local print = print
local type = type
local string = string
local table = table

module("board")

TRIPLE_WORD = tiles.TRIPLE_WORD
DOUBLE_WORD = tiles.DOUBLE_WORD
TRIPLE_LETTER = tiles.TRIPLE_LETTER
DOUBLE_LETTER = tiles.DOUBLE_LETTER

local Board = {}

Board.__index = Board

function Board:Setup()
    self.w = 15
    self.h = 15
    self.tiles = {}
    for i=1,self.w do
        self.tiles[i]={}
        for ii=1,self.h do
            self.tiles[i][ii] = tiles.New()
        end
    end
    
    --setup triple word score tiles
    self.tiles[1][1]:SetMod(TRIPLE_WORD)
    self.tiles[8][1]:SetMod(TRIPLE_WORD)
    self.tiles[15][1]:SetMod(TRIPLE_WORD)
    self.tiles[1][8]:SetMod(TRIPLE_WORD)
    self.tiles[1][15]:SetMod(TRIPLE_WORD)
    self.tiles[8][15]:SetMod(TRIPLE_WORD)
    self.tiles[15][8]:SetMod(TRIPLE_WORD)
    self.tiles[15][15]:SetMod(TRIPLE_WORD)
    
    --setup tripple letter score tiles
    self.tiles[2][6]:SetMod(TRIPLE_LETTER)
    self.tiles[2][10]:SetMod(TRIPLE_LETTER)
    self.tiles[6][2]:SetMod(TRIPLE_LETTER)
    self.tiles[6][6]:SetMod(TRIPLE_LETTER)
    self.tiles[6][10]:SetMod(TRIPLE_LETTER)
    self.tiles[6][14]:SetMod(TRIPLE_LETTER)
    self.tiles[10][2]:SetMod(TRIPLE_LETTER)
    self.tiles[10][6]:SetMod(TRIPLE_LETTER)
    self.tiles[10][10]:SetMod(TRIPLE_LETTER)
    self.tiles[10][14]:SetMod(TRIPLE_LETTER)
    self.tiles[14][6]:SetMod(TRIPLE_LETTER)
    self.tiles[14][10]:SetMod(TRIPLE_LETTER)
    
    --setup double letter score tiles
    self.tiles[4][1]:SetMod(DOUBLE_LETTER)
    self.tiles[12][1]:SetMod(DOUBLE_LETTER)
    self.tiles[7][3]:SetMod(DOUBLE_LETTER)
    self.tiles[9][3]:SetMod(DOUBLE_LETTER)
    self.tiles[1][4]:SetMod(DOUBLE_LETTER)
    self.tiles[8][4]:SetMod(DOUBLE_LETTER)
    self.tiles[15][4]:SetMod(DOUBLE_LETTER)
    self.tiles[3][7]:SetMod(DOUBLE_LETTER)
    self.tiles[7][7]:SetMod(DOUBLE_LETTER)
    self.tiles[9][7]:SetMod(DOUBLE_LETTER)
    self.tiles[13][7]:SetMod(DOUBLE_LETTER)
    self.tiles[4][8]:SetMod(DOUBLE_LETTER)
    self.tiles[12][8]:SetMod(DOUBLE_LETTER)
    self.tiles[4][15]:SetMod(DOUBLE_LETTER)
    self.tiles[12][15]:SetMod(DOUBLE_LETTER)
    self.tiles[7][13]:SetMod(DOUBLE_LETTER)
    self.tiles[9][13]:SetMod(DOUBLE_LETTER)
    self.tiles[1][12]:SetMod(DOUBLE_LETTER)
    self.tiles[8][12]:SetMod(DOUBLE_LETTER)
    self.tiles[15][12]:SetMod(DOUBLE_LETTER)
    self.tiles[3][9]:SetMod(DOUBLE_LETTER)
    self.tiles[7][9]:SetMod(DOUBLE_LETTER)
    self.tiles[9][9]:SetMod(DOUBLE_LETTER)
    self.tiles[13][9]:SetMod(DOUBLE_LETTER)
    
    --setup double word score tiles
    self.tiles[2][2]:SetMod(DOUBLE_WORD)
    self.tiles[3][3]:SetMod(DOUBLE_WORD)
    self.tiles[4][4]:SetMod(DOUBLE_WORD)
    self.tiles[5][5]:SetMod(DOUBLE_WORD)
    
    self.tiles[2][14]:SetMod(DOUBLE_WORD)
    self.tiles[3][13]:SetMod(DOUBLE_WORD)
    self.tiles[4][12]:SetMod(DOUBLE_WORD)
    self.tiles[5][11]:SetMod(DOUBLE_WORD)
    
    self.tiles[14][14]:SetMod(DOUBLE_WORD)
    self.tiles[13][13]:SetMod(DOUBLE_WORD)
    self.tiles[12][12]:SetMod(DOUBLE_WORD)
    self.tiles[11][11]:SetMod(DOUBLE_WORD)
    
    self.tiles[14][2]:SetMod(DOUBLE_WORD)
    self.tiles[13][3]:SetMod(DOUBLE_WORD)
    self.tiles[12][4]:SetMod(DOUBLE_WORD)
    self.tiles[11][5]:SetMod(DOUBLE_WORD)
    
    self.tiles[8][8]:SetMod(DOUBLE_WORD)
end

function Board:Print()
    local lin = "     "
    for i=1,self.w do
        if i>=10 then
            lin=lin.."[ "..tostring(i).."]"
        else
            lin=lin.."[ "..tostring(i).." ]"
        end
    end
    print(lin)
    for ii=1,self.h do
        local lin
        if ii<10 then
            lin = "[ "..tostring(ii).." ]"
        else
            lin = "[ "..tostring(ii).."]"
        end
        for i=1,self.w do
            lin=lin.."("..self.tiles[i][ii]:GetDisplay()..")"
        end
        print(lin)
    end
end

function Board:SetValue(x,y,tile)
    local t = self.tiles[x][y]
    tile:SetMod(t:GetMod())
    self.tiles[x][y] = tile
end

function Board:AddWord(str,x,y,vert) --str is either a string or a list of tiles, vert is a boolean for if the word should be vertical instead of horizontal COMPLETELY UNCHECKED FOR ANYTHING
    local t
    if type(str)=="string" then --Then it should be a table of tiles
        t = {}
        for i=1,string.len(str) do
            local char = string.sub(str,i,i)
            local tile = tiles.New()
            tile:SetContents(char)
            table.insert(t,tile)
        end
    else
        t = str
    end
    
    if vert then --we go down, aka add to y, also, fuck bounds checking :D
        for i=1,#t do
            self:SetValue(x,y+i-1,t[i])
        end
    else -- we go right
        for i=1,#t do
            self:SetValue(x+i-1,y,t[i])
        end
    end
    
end



function Empty()
    local b = {}
    setmetatable(b,Board)
    b:Setup()
    return b
end