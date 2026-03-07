local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local root

-- ค่าระบบ
local running = false
local radius = 13
local hitbox = 35
local segments = 30
local dashLength = 5
local rotation = 0

local circleParts = {}
local overlap = OverlapParams.new()

-- ===== วง =====

local function clearCircle()
	for _,data in ipairs(circleParts) do
		if data.part then
			data.part:Destroy()
		end
	end
	table.clear(circleParts)
end

local function createCircle(char)

	root = char:WaitForChild("HumanoidRootPart")

	overlap.FilterType = Enum.RaycastFilterType.Blacklist
	overlap.FilterDescendantsInstances = {char}

	for i = 1,segments do
		
		if i % 4 == 0 then
			
			local p = Instance.new("Part")
			p.Size = Vector3.new(0.6,0.2,dashLength)
			p.Material = Enum.Material.Neon
			p.Color = Color3.fromRGB(255,0,0)
			p.Anchored = true
			p.CanCollide = false
			p.Parent = workspace
			
			table.insert(circleParts,{part = p,index = i})
		end
	end
end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	clearCircle()
	createCircle(char)
end)

if player.Character then
	createCircle(player.Character)
end

-- วงหมุน
RunService.RenderStepped:Connect(function(dt)

	if not root then return end

	rotation += dt * 2

	for _,data in ipairs(circleParts) do
		
		local i = data.index
		local p = data.part
		
		local angle = (i/segments)*math.pi*2 + rotation
		local x = math.cos(angle)*radius
		local z = math.sin(angle)*radius
		
		p.CFrame =
			CFrame.new(root.Position + Vector3.new(x,0.05,z))
			* CFrame.Angles(0,-angle,0)
	end

end)

-- ===== ระบบตี =====

task.spawn(function()

	while true do
		task.wait(0.01)

		if running and root then

			local parts = Workspace:GetPartBoundsInRadius(root.Position,radius,overlap)

			local closest
			local closestDist = radius

			for _,part in ipairs(parts) do

				local model = part:FindFirstAncestorOfClass("Model")

				if model and model ~= player.Character then

					local hum = model:FindFirstChildOfClass("Humanoid")
					local hrp = model:FindFirstChild("HumanoidRootPart")

					if hum and hrp then

						local plr = Players:GetPlayerFromCharacter(model)

						if not plr then

							if model:FindFirstChildWhichIsA("ProximityPrompt",true) then
								continue
							end

							local dist = (hrp.Position-root.Position).Magnitude

							if dist < closestDist then
								closestDist = dist
								closest = model
							end

							hrp.Size = Vector3.new(hitbox,hitbox,hitbox)
							hrp.Transparency = 1
							hrp.CanCollide = false

						end
					end
				end
			end

			if closest then

				local hrp = closest:FindFirstChild("HumanoidRootPart")

				if hrp then

					root.CFrame = CFrame.lookAt(
						hrp.Position + Vector3.new(0,-7,0),
						hrp.Position
					)

					local args = {true,false}

					player.Character
					:WaitForChild("client_character_controller")
					:WaitForChild("M1")
					:FireServer(unpack(args))

				end
			end

		end
	end

end)


Tab:Toggle({
	Title = "Auto Attack",
	Icon = "swords",
	Type = "Checkbox",
	Value = false,
	Callback = function(state)
		running = state
	end
})

Tab:Slider({
	Title = "Attack Radius",
	Step = 1,
	Value = {
		Min = 5,
		Max = 60,
		Default = 13,
	},
	Callback = function(value)
		radius = value
	end
})
