-- // Constants \\ --

-- Services --
local Services = {}
Services.Players = game:GetService("Players")

-- Local Player --
local LocalPlayer = Services.Players.LocalPlayer

-- Folder --
local BuildingTools = Instance.new("Folder")
BuildingTools.Name = "BuildingTools"
BuildingTools.Parent = workspace

-- // Custom Functions \\ --
local CustomFunctions = {}
CustomFunctions.SetHidden = sethiddenproperty or set_hidden_property or set_hidden_prop
CustomFunctions.GetHidden = gethiddenproperty or get_hidden_property or get_hidden_prop
CustomFunctions.SetSimulation = setsimulationradius or set_simulation_radius

-- // Main \\ --
local Build_v2 = {}

function Build_v2.PrepareHiddenProperties()
	for i,v in ipairs(Services.Players:GetPlayers()) do
		if v ~= LocalPlayer then
			CustomFunctions.SetHidden(v, "MaximumSimulationRadius", 0.1)
			CustomFunctions.SetHidden(v, "SimulationRadius", 0.1)
		end
		CustomFunctions.SetHidden(LocalPlayer, "MaximumSimulationRadius", math.huge)
		CustomFunctions.SetSimulation(math.huge)
		LocalPlayer.ReplicationFocus = workspace
	end
end

function Build_v2.new(Object)
	local ObjectInfo = {}
	ObjectInfo.Part = Object
	ObjectInfo.BodyPosition = nil
	ObjectInfo.BodyGyro = nil
	
	Object.Parent = BuildingTools
	
	function ObjectInfo:Move(VectorPosition, Properties)
		ObjectInfo.BodyPosition = ObjectInfo.BodyPosition or Instance.new("BodyPosition")
		ObjectInfo.BodyPosition.Name = "ObjectMover"
		ObjectInfo.BodyPosition.Parent = ObjectInfo.Part
		ObjectInfo.BodyPosition.D = 100
		ObjectInfo.BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		ObjectInfo.BodyPosition.P = 1000
		
		ObjectInfo.BodyPosition.Position = VectorPosition
		
		-- Sets Properties --
		if Properties then
			for i,v in pairs(Properties) do
				if ObjectInfo.BodyPosition[i] ~= nil then
					ObjectInfo.BodyPosition[i] = v
				end
			end
		end
	end
	
	function ObjectInfo:Rotate(Orientation, Properties)
		ObjectInfo.BodyGyro = ObjectInfo.BodyGyro or Instance.new("BodyGyro")
		ObjectInfo.BodyGyro.Name = "ObjectRotator"
		ObjectInfo.BodyGyro.Parent = ObjectInfo.Part
		ObjectInfo.BodyGyro.D = 500
		ObjectInfo.BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		ObjectInfo.BodyGyro.P = 3000
		ObjectInfo.BodyGyro.CFrame = Orientation or ObjectInfo.Part.CFrame

		
		-- Sets Properties --
		if Properties then
			for i,v in pairs(Properties) do
				if ObjectInfo.BodyGyro[i] ~= nil then
					ObjectInfo.BodyGyro[i] = v
				end
			end
		end
	end

	function ObjectInfo:Clear()
		if ObjectInfo.BodyPosition then
			ObjectInfo.BodyPosition:Destroy()
		end
		if ObjectInfo.BodyGyro then
			ObjectInfo.BodyGyro:Destroy()
		end
		ObjectInfo.BodyPosition = nil
		ObjectInfo.BodyGyro = nil
	end
	
	return ObjectInfo
end

return Build_v2
