-- brandonisabillionare
-- 9/06/2021

-- To use it, you must create a new instance of it
-- local td = TerrainDigger.new(optionalRadius)
-- td:Enable()
-- You can always disable and enable it
-- td:Disable()

local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = game:GetService("Players").LocalPlayer
local TerrainDigger = {}
TerrainDigger.__index = TerrainDigger

local CONTEXT_ACTION_NAME = "Dig"
local INPUT_TYPES = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.Touch
}
local RAY_LENGTH = 200

-- getRayParams is a function so that you can update your params if you want
function TerrainDigger.new(radius, getRayParams)
	local self = {}
	self.radius = radius or 5.5
	self.active = false
	self.camera = Workspace.CurrentCamera
	self.getParams = getRayParams
	if not getRayParams then
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Blacklist
		params.IgnoreWater = true -- set it to "false" if you want to "dig" water too
		self.getParams = function()
			params.FilterDescendantsInstances = {LocalPlayer.Character}
			return params
		end
	end
	
	self._actionhandler = function(...)
		return self:ActionHandler(...)
	end
	
	return setmetatable(self, TerrainDigger)
end

function TerrainDigger:ContextReload()
	local isBound = ContextActionService:GetAllBoundActionInfo()[CONTEXT_ACTION_NAME]
	if self.active and isBound then
		ContextActionService:UnbindAction(CONTEXT_ACTION_NAME)
		self.active = false
	elseif not isBound then
		ContextActionService:BindAction(CONTEXT_ACTION_NAME, self._actionhandler, true, unpack(INPUT_TYPES))
		self.active = true
	else
		self.active = true
	end
end

function TerrainDigger:Enable()
	self.active = true
	self:ContextReload()
end

function TerrainDigger:Disable()
	self.active = false
	self:ContextReload()
end

function TerrainDigger:ActionHandler(actionName, inputState, inputObject)
	if actionName ~= CONTEXT_ACTION_NAME then
		return true
	end
	if inputState == Enum.UserInputState.Begin then
		self:Dig(inputObject.Position)
	end
	return true
end

function TerrainDigger:Dig(screenPosition)
	local x, y
	if not self.camera then
		return
	end
	-- In case if you want to add keycode/controller support which doesn't give you a position
	if screenPosition then
		x, y = screenPosition.X, screenPosition.Y
	else
		local viewportSize = self.camera.ViewportSize
		x, y = viewportSize.X, viewportSize.Y
	end
	
	local unitRay = self.camera:ViewportPointToRay(x, y, 0)
	local params = self:getParams()
	if not params then
		return
	end
	local raycastResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * RAY_LENGTH, params)
	
	if raycastResult then
		local hit = raycastResult.Instance
		if hit and hit:IsA("Terrain") then
			hit:FillBall(raycastResult.Position, self.radius, Enum.Material.Air)
		end
	end
end

return TerrainDigger
