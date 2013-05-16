
local tiles = require("tiles")
local setmetatable = setmetatable
local tostring = tostring
local print = print
local type = type
local string = string
local table = table

module('dawg')

local DawgNode = {}

DawgNode.__index = DawgNode
DawgNode.__type = "dnode"

function DawgNode:__tostring() 
    local ret = {}
    table.insert(ret, self.final and "1" or "0")
    
    for k,v in pairs(self.edges) do
        table.insert(ret, k)
        table.insert(ret, tostring(v))
    end
    
    return table.concat(ret, "_")
end

function DawgNode:__eq(other)
    return tostring(self)==tostring(other)
end

local index = 0;
local function NewNode()
    local b = {}
    setmetatable(b,DawgNode)
    
    b.id = index
    
    index = index + 1
    
    b.final = false
    b.edges = {}
    return b
end

local Dawg = {}

Dawg.__index = Dawg
Dawg.__type = "dawg"

function Dawg:insert( word )
    if self.previousWord and word < self.previousWord then
        return --must be added in order
    end
    
    local common = 0
    for i=string.len(word), string.len(self.previousWord) do
        if string.sub(word,i,i) != string.sub(self.previousWord,i,i) then break end
        common = common + 1
    end
    
    self:minimize(common)
    
    local node
    if #self.uncheckedNodes==0 then
        node = self.root
    else
        node = self.uncheckedNodes[#self.uncheckedNodes][2]
    end
    
    for i=common, string.len(word) do
        local nextn = NewNode()
        node.edges[string.sub(word,i,i)] = nextn
        table.insert(self.uncheckedNodes, {node, string.sub(word,i,i), nextn})
        node = nextNode
    end
    
    node.final = true
    self.previousWord = word
end

function Dawg:finish()
    self:minimize(0)
end

function Dawg:minimize(num)
    for i=#self.uncheckedNodes, num, -1 do
        parent, letter, child = unpack(self.uncheckedNodes[i])
        
        if self.minimizedNodes[tostring(child)] then
            parent.edges[letter] = self.minimizedNodes[tostring(child)]
        else
            self.minimizedNodes[tostring(child)] = child
        end
        
        table.remove(self.uncheckedNodes, 1)
    end
end

function Dawg:lookup(word)
    local node = self.root
    for i=1, string.len(word) do
        local letter = string.sub(word,i,i)
        if not node.edges[letter] then return end
        node = node.edges[letter]
    end
    
    return node.final
end

function Dawg:__len()
    return #self.minimizedNodes
end

function Dawg:edges()
    local c = 0
    for k,v in pairs(self.minimizedNodes) do
        count = count + #node.edges
    end
    return count
end

function New()
    local b = {}
    setmetatable(b,Tiles)
    b.root = NewNode()
    b.uncheckedNodes = {}
    b.minimizedNodes = {}
    b.previousWord = nil
    
    return b
end

function LoadDict(dict)
    local d = New()
    --table.sort(dict) --Should already be sorted
    for _,v in ipairs(dict) do
        d:insert(v)
    end
    d:finish()
    return d
end