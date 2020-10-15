-- // Constants \\ --

-- Local Player --
local LocalPlayer = game:GetService("Players").LocalPlayer

local LocalPlayerContents = {}

LocalPlayerContents.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(Character)
	LocalPlayerContents.Character = Character
end)

-- Tool Folder --
local BuildingTools = Instance.new("Folder")
BuildingTools.Name = "BuildingTools"
BuildingTools.Parent = game.Workspace

-- // Custom Functions \\ --
local CustomFunctions = {}
CustomFunctions.SetHidden = sethiddenproperty or set_hidden_property or set_hidden_prop
CustomFunctions.GetHidden = gethiddenproperty or get_hidden_property or get_hidden_prop
CustomFunctions.SetSimulation = setsimulationradius or set_simulation_radius


local Build_v2 = {
	ObjectFolder = BuildingTools
}

function Build_v2.PrepareHiddenProperties(Player)
	if CustomFunctions.SetSimulation then
		CustomFunctions.SetSimulation(1e308)
	else
		CustomFunctions.SetHidden(LocalPlayer, "SimulationRadius", 1e308)
	end
end

function Build_v2.new(Object)
	local ObjectInfo = {}
	ObjectInfo.Part = Object
	ObjectInfo.BodyMoverEnabled = false
	ObjectInfo.BodyGyroEnabled = false
	
	Object.Parent = BuildingTools
	
	function ObjectInfo:BodyMover(VectorPosition, Power)
		local ForceInstance = Instance.new("BodyPosition")
		ForceInstance.Parent = ObjectInfo.Part
		ForceInstance.Position = VectorPosition
		ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		ForceInstance.D = 100

		ObjectInfo.BodyMoverEnabled = true

		if Power then
			ForceInstance.P = Power    
		end

		return ForceInstance
	end
	
	function ObjectInfo:Freeze(Orientation)
		if Orientation then
			ObjectInfo.Part.Orientation = Orientation
		end
		
		local BodyGyro = Instance.new("BodyGyro", ObjectInfo.Part)
		BodyGyro.CFrame = ObjectInfo.Part.CFrame
		BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		
		ObjectInfo.BodyGyroEnabled = true
		
		return BodyGyro
	end

	function ObjectInfo:Clear()
		if ObjectInfo.BodyMoverEnabled == false and ObjectInfo.BodyGyroEnabled == false then
			return
		end
		
		for i,v in ipairs(ObjectInfo.Part:GetChildren()) do
			v:Destroy()
		end
		ObjectInfo.BodyMoverEnabled = false
		ObjectInfo.BodyGyroEnabled = false
	end
	
	return ObjectInfo
end

return Build_v2
