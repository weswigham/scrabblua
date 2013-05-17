
local tiles = require("tiles")
local setmetatable = setmetatable
local tostring = tostring
local print = print
local type = type
local string = string
local table = table
local ipairs = ipairs
local pairs = pairs
local unpack = unpack
local min = math.min

module('dawg')

local DawgNode = {}

DawgNode.__index = DawgNode
DawgNode.__type = "dnode"

function DawgNode:__tostring() 
    local ret = {}
    table.insert(ret, self.final and "1" or "0")
    
    for k,v in pairs(self.edges) do
        table.insert(ret, "(")
        table.insert(ret, k)
        table.insert(ret, tostring(v))
        table.insert(ret, ")")
    end
    
    return table.concat(ret, "-")
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
    for i=1, min(string.len(word), string.len(self.previousWord or "")) do
        if string.sub(word,i,i) ~= string.sub(self.previousWord,i,i) then break end
        common = common + 1
    end
    
    self:minimize(common)
    
    local node
    if #self.uncheckedNodes==0 then
        node = self.root
    else
        --local snode, char = unpack(self.uncheckedNodes[#self.uncheckedNodes])
        --node = snode.edges[char]
        --print(string.sub(word,1,common), common, word, self.previousWord)
        node = self:node(string.sub(word,1,common))
    end
    
    for i=common+1, string.len(word) do
        local nextn = NewNode()
        node.edges[string.sub(word,i,i)] = nextn

        table.insert(self.uncheckedNodes, {node, string.sub(word,i,i)})
        node = nextn
    end
    
    node.final = true
    self.previousWord = word
end

function Dawg:finish()
    self:minimize(0)
end

function Dawg:minimize(num)
    for i=#self.uncheckedNodes, num+1, -1 do
        local parent, letter = unpack(self.uncheckedNodes[i])

        local child = parent.edges[letter]
        if self.minimizedNodes[tostring(child)] then
            parent.edges[letter] = self.minimizedNodes[tostring(child)]
        else
            self.minimizedNodes[tostring(child)] = parent.edges[letter]
        end
        
        table.remove(self.uncheckedNodes)
    end
end

function Dawg:lookup(word)
    return self:node(word).final
end

function Dawg:node(prefix)
    local node = self.root
    for i=1, string.len(prefix) do
        local letter = string.sub(prefix,i,i)
        if not node.edges[letter] then print("Commonality failed", node, prefix, letter, node.edges[letter]) return end
        node = node.edges[letter]
    end
    
    return node
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

function Dawg:startsWith(prefix)
    local node = self:node(prefix)

    local fullList = {}
    local queue = {}
    table.insert(queue, {node, prefix})
    while #queue>0 do
        local node, prefix = unpack(table.remove(queue))
        for k,v in pairs(node.edges) do
            table.insert(queue, {v, prefix..k})
        end
        if node.final then table.insert(fullList, prefix) end
    end
    
    return fullList
end

function New()
    local b = {}
    setmetatable(b,Dawg)
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