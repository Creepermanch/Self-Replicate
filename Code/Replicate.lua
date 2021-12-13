while true do
wait(3) -- the time taken in seconds for this block to duplicate
local cl = script.Parent:clone()
cl.Parent = game.Workspace
cl.Position = script.Parent.Position
end
