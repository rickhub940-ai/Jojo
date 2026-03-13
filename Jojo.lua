local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local player = game.Players.LocalPlayer


local BLUE   = Color3.fromHex("#3BA9FF")
local SKY    = Color3.fromHex("#6FD3FF")
local YELLOW = Color3.fromHex("#FFD93B")
local WHITE  = Color3.fromHex("#FFFFFF")

local DARK_BG1 = Color3.fromHex("#0A1628")
local DARK_BG2 = Color3.fromHex("#0F223F")

local MAIN_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = BLUE, Transparency = 0},
    ["50"]  = {Color = SKY, Transparency = 0},
    ["100"] = {Color = YELLOW, Transparency = 0},
},{Rotation = 45})

local BACKGROUND_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = BLUE, Transparency = 0.35},
    ["50"]  = {Color = SKY, Transparency = 0.35},
    ["100"] = {Color = YELLOW, Transparency = 0.35},
},{Rotation = 45})

local DARK_TAB_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = DARK_BG1, Transparency = 0},
    ["100"] = {Color = DARK_BG2, Transparency = 0},
},{Rotation = 90})

--// =========================
--// THEME
--// =========================
WindUI:AddTheme({
    Name = "RickHUBTheme",

    Accent = MAIN_GRADIENT,
    Hover  = MAIN_GRADIENT,

    Background = BACKGROUND_GRADIENT,
    BackgroundTransparency = 0.35,

    Outline = YELLOW,
    Text = WHITE,
    Icon = WHITE,

    WindowBackground = BACKGROUND_GRADIENT,
    WindowShadow = Color3.fromRGB(0,0,0),

    TabBackground = DARK_TAB_GRADIENT,
    TabTitle = WHITE,
    TabIcon = WHITE,

    ElementBackground = DARK_TAB_GRADIENT,
    ElementTitle = WHITE,

    Button = MAIN_GRADIENT,
    Toggle = MAIN_GRADIENT,
    Slider = MAIN_GRADIENT,
})

WindUI:SetTheme("RickHUBTheme")

local avatar = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
..player.UserId.."&size=420x420&format=Png"

local Window = WindUI:CreateWindow({
    Title = "RICK HUB [ JoJo ] FOR 009.exe",
    Icon = "rbxassetid://108958018844079",
    Author = "Author[ 009.exe ]",
    Size = UDim2.fromOffset(730, 410),
    Theme = "RickHUBTheme",
    Transparent = true,
    Resizable = true,

    User = {
        Enabled = true,
        Custom = {
            Name = player.Name,
            Bio = "RickHUB USER",
            Image = avatar
        }
    }
})
Window:Tag({
    Title = "v0.0.0",
    Icon = "github",
    Color = Color3.fromHex("#00bfff"), -- ฟ้าสด
    Radius = 5,
})

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")


Window:EditOpenButton({ Enabled = false })

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")

ScreenGui.Name = "Rickhub_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://108958018844079"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local opened = true

local function toggle()
    opened = not opened
    if Window.UI then
        Window.UI.Enabled = opened
    else
        Window:Toggle()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    ToggleBtn:TweenSize(
        UDim2.new(0, 56, 0, 56),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.12,
        true,
        function()
            ToggleBtn:TweenSize(
                UDim2.new(0, 50, 0, 50),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.12,
                true
            )
        end
    )
    toggle()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        toggle()
    end
end)

local HttpService = game:GetService("HttpService")

local ConfigFile = "RICK HUB [ Bizarre Lineage ].json"
local Config = {}

if isfile(ConfigFile) then
	Config = HttpService:JSONDecode(readfile(ConfigFile))
end

local function Get(name,default)
	if Config[name] == nil then
		Config[name] = default
	end
	return Config[name]
end

local function Save(name,value)
	Config[name] = value
	writefile(ConfigFile,HttpService:JSONEncode(Config))
end





local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")



local root
local running = false
local autoSkill = false
local farmMode = "Under"
local farmDistance = 7
local radius = 13
local hitbox = 35
local selectedSkills = {"Z","X","C"}
local overlap = OverlapParams.new()
local circleParts = {}
local segments = 30
local dashLength = 5
local rotation = 0
------------------
-- ฟามเวลสแตน
local standFarm = false
-- --------------------


local function clearCircle()
	for _,v in ipairs(circleParts) do
		if v.part then
			v.part:Destroy()
		end
	end
	table.clear(circleParts)
end

local function createCircle()

	clearCircle()

	local char = player.Character or player.CharacterAdded:Wait()
	root = char:WaitForChild("HumanoidRootPart")

	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances = {char}

	for i = 1,segments do

		if i % 3 == 0 then

			local p = Instance.new("Part")
			p.Size = Vector3.new(0.6,0.2,dashLength)
			p.Material = Enum.Material.Neon
			p.Color = Color3.fromRGB(255,0,0)
			p.Anchored = true
			p.CanCollide = false
			p.Parent = Workspace

			table.insert(circleParts,{part=p,index=i})

		end
	end
end

RunService.Heartbeat:Connect(function(dt)

	if not running or not root then return end

	rotation += dt * 2

	for _,data in ipairs(circleParts) do

		local i = data.index
		local p = data.part

		local angle = (i/segments)*math.pi*2 + rotation
		local x = math.cos(angle)*radius
		local z = math.sin(angle)*radius

		p.CFrame =
			CFrame.new(root.Position + Vector3.new(x,-3,z))
			* CFrame.Angles(0,-angle,0)

	end

end)
task.spawn(function()

	while true do
		task.wait(0.01)

		if not running then continue end

		local char = player.Character
		if not char then continue end

		root = char:FindFirstChild("HumanoidRootPart")
		if not root then continue end

		local parts = Workspace:GetPartBoundsInRadius(root.Position,radius,overlap)

		local closest
		local closestDist = radius

		for _,part in ipairs(parts) do

			local model = part:FindFirstAncestorOfClass("Model")

			if model and model ~= char and model.Parent and model.Parent.Name == "Live" then

				if string.sub(model.Name,1,1) == "." then

					local hrp = model:FindFirstChild("HumanoidRootPart")
					local hum = model:FindFirstChildOfClass("Humanoid")

					if hrp and hum and hum.Health > 0 then

						if Players:GetPlayerFromCharacter(model) then continue end
						if model:FindFirstChildWhichIsA("ProximityPrompt",true) then continue end

						local dist = (hrp.Position-root.Position).Magnitude

						if dist < closestDist then
							closestDist = dist
							closest = model
						end

						if hrp.Size.X ~= hitbox then
							hrp.Size = Vector3.new(hitbox,hitbox,hitbox)
							hrp.Transparency = 1
							hrp.CanCollide = false
						end

					end
				end
			end
		end

		if closest then

			local e_hrp = closest:FindFirstChild("HumanoidRootPart")
			local controller = char:FindFirstChild("client_character_controller")

			if e_hrp and controller then

				local targetPos

				if farmMode == "Under" then
					targetPos = e_hrp.Position + Vector3.new(0,-farmDistance,0)

				elseif farmMode == "Above" then
					targetPos = e_hrp.Position + Vector3.new(0,farmDistance,0)

				elseif farmMode == "Behind" then
					targetPos = (e_hrp.CFrame * CFrame.new(0,0,farmDistance)).Position
				end

				root.CFrame = CFrame.lookAt(targetPos,e_hrp.Position)

				if controller:FindFirstChild("M1") then
					controller.M1:FireServer(true,false)
				end

				if autoSkill and controller:FindFirstChild("Skill") then
					for _,key in ipairs(selectedSkills) do
						controller.Skill:FireServer(key,true)
					end
				end

			end
		end

	end

end)


-- ----------
-- ฟาทเวลสแตน
-- ----------


local meditationPos = Vector3.new(1095.49,884.34,91.66)
local root

local function updateCharacter(char)
	root = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
	updateCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
	updateCharacter(char)
end)

local function getMyEntity()
	for _,v in pairs(Workspace.Live:GetChildren()) do
		if string.sub(v.Name,1,#player.Name+1) == "."..player.Name then
			return v
		end
	end
end

local function farmStandLevel()

	if not standFarm then return end
	if not root then return end

	local char = player.Character
	if not char then return end

	local controller = char:FindFirstChild("client_character_controller")
	if not controller then return end

	local entity = getMyEntity()

	-- spawn stand
	if not entity then

		local npc = Workspace.Npcs:FindFirstChild("The Self")

		if npc then

			local title = npc.HumanoidRootPart["NPC Name"].Title

			if title and title.Text == player.Name then

				root.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)

				local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt",true)

				if prompt then
					fireproximityprompt(prompt,prompt.HoldDuration)
				end

				task.wait(0.2)

				game:GetService("ReplicatedStorage").requests.character.dialogue:FireServer(
					npc,
					"Yes."
				)

			end

		else

			root.CFrame = CFrame.new(meditationPos)

			local meditation = Workspace.Map:FindFirstChild("Meditation")

			if meditation then
				for _,v in pairs(meditation:GetDescendants()) do
					if v:IsA("ProximityPrompt") then
						fireproximityprompt(v,v.HoldDuration)
						task.wait(0.2)
					end
				end
			end

			task.wait(2)

		end

		return
	end

	-- เช็ค Stand
	local standName = "."..player.Name.."'s Stand"

	if not Workspace.Effects:FindFirstChild(standName) then
		if controller:FindFirstChild("SummonStand") then
			controller.SummonStand:FireServer()
		end
		task.wait(0.2)
	end

	-- farm entity
	local e_hrp = entity:FindFirstChild("HumanoidRootPart")
	local hum = entity:FindFirstChildOfClass("Humanoid")

	if not e_hrp or not hum or hum.Health <= 0 then return end

	if e_hrp.Size.X ~= hitbox then
		e_hrp.Size = Vector3.new(hitbox,hitbox,hitbox)
		e_hrp.Transparency = 1
		e_hrp.CanCollide = false
	end

	local targetPos

	if farmMode == "Under" then
		targetPos = e_hrp.Position + Vector3.new(0,-farmDistance,0)

	elseif farmMode == "Above" then
		targetPos = e_hrp.Position + Vector3.new(0,farmDistance,0)

	elseif farmMode == "Behind" then
		targetPos = (e_hrp.CFrame * CFrame.new(0,0,farmDistance)).Position
	end

	root.CFrame = CFrame.lookAt(targetPos,e_hrp.Position)

	if controller:FindFirstChild("M1") then
		controller.M1:FireServer(true,false)
	end

	if autoSkill and controller:FindFirstChild("Skill") then
		for _,key in ipairs(selectedSkills) do
			controller.Skill:FireServer(key,true)
		end
	end

end

task.spawn(function()
	while true do
		task.wait(0.01)

		if standFarm then
			farmStandLevel()
		end
	end
end)




-- -----------
-- ออโต้สุ่มสแตน
-- -----------

local standValue = player.PlayerData.SlotData.Stand
local standName = "."..player.Name.."'s Stand"

local autoRoll = false
local targets = {}

-- ดึงชื่อ Stand
local standList = {}
local standsFolder = RS.assets.models.stands
for _,v in pairs(standsFolder:GetChildren()) do
    if v:IsA("Model") then
        table.insert(standList, v.Name)
    end
end

local function roll()
    if not autoRoll then return end
    
    local data = HttpService:JSONDecode(standValue.Value)
    if targets[data.Name] then
        
        WindUI:Notify({
            Title = "Stand Roll",
            Content = "สุ่มได้: "..data.Name.." ✅",
            Duration = 5,
            Icon = "star",
        })
autoRoll = false
return
end
     WindUI:Notify({
        Title = "Stand Roll",
        Content = "สุ่มได้: "..data.Name.."❌",
        Duration = 3,
        Icon = "dna",
    })

    local controller = player.Character and player.Character:FindFirstChild("client_character_controller")

    if controller then
        
        if Workspace.Effects:FindFirstChild(standName) then
            controller.SummonStand:FireServer()
        else
            RS.requests.character.use_item:FireServer("Stand Arrow")
        end
        
    end
end

standValue:GetPropertyChangedSignal("Value"):Connect(roll)


-- -------------
-- ออโต้ฟามเรทคิระ
-- ------------


function autoRaidKira()

    local gui = player:WaitForChild("PlayerGui")
    local main = gui:FindFirstChild("Main Menu")


    if main and main.Visible then

        local buttons = main:FindFirstChild("Buttons")
        local quickPlay = buttons and buttons:FindFirstChild("Quick Play")

        if quickPlay then
            while main.Visible do

                GuiService.SelectedObject = quickPlay

                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

                task.wait(0.2)

            end

            GuiService.SelectedObject = nil
        end
    end


    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local talkPos = CFrame.new(1020.61,875.60,-652.46)
    local lockPos = CFrame.new(1034.99,875.60,-649.95)

    if not workspace.Map:FindFirstChild("Yoshikage Kira Bites the Dust") then

        local prompt = workspace.Npcs["Yoshikage Kira"]:WaitForChild("ProximityPrompt")

        root.CFrame = talkPos
        task.wait(0.5)

        while not player.PlayerGui.Dialogue.Holder.Visible do
            fireproximityprompt(prompt)
            task.wait(0.2)
        end

        ReplicatedStorage.requests.character.dialogue:FireServer(
            workspace.Npcs["Yoshikage Kira"],
            "Raid."
        )

        repeat task.wait()
        until not player.PlayerGui.Dialogue.Holder.Visible
    end
    root.CFrame = lockPos

    local function getEnemy()

        for _,v in pairs(workspace.Live:GetChildren()) do

            if string.sub(v.Name,1,1) == "." then

                local hum = v:FindFirstChildOfClass("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")

                if hum and hrp and hum.Health > 0 then
                    return v
                end

            end
        end

    end

    while true do
        task.wait(0.03)
        local enemy = getEnemy()
        if enemy then

            local e_hrp = enemy:FindFirstChild("HumanoidRootPart")
            local controller = player.Character:FindFirstChild("client_character_controller")
            if e_hrp and controller then

                local targetPos

                if farmMode == "Under" then
                    targetPos = e_hrp.Position + Vector3.new(0,-farmDistance,0)

                elseif farmMode == "Above" then
                    targetPos = e_hrp.Position + Vector3.new(0,farmDistance,0)

                elseif farmMode == "Behind" then
                    targetPos = (e_hrp.CFrame * CFrame.new(0,0,farmDistance)).Position
                end
                root.CFrame = CFrame.lookAt(targetPos,e_hrp.Position)
                controller.M1:FireServer(true,false)
                if autoSkill then
                    for _,key in ipairs(selectedSkills) do
                        controller.Skill:FireServer(key,true)
                    end
                end

            end
        end
    end

end





local Tab = Window:Tab({Title = "MAIN", Icon = "swords"})

        
Tab:Toggle({
	Title = "ออโต้ตีมอนในวง",
	Value = Get("MobAura",false),
	Callback = function(state)
		Save("MobAura",state)
		running = state
		if state then
			createCircle()
		else
			clearCircle()
		end

	end
})


Tab:Slider({
	Title = "ปรับวงตี",
	Step = 5,
	Value = {Min = 5,Max = 250,Default = Get("Radius",13)},
	Callback = function(v)
		Save("Radius",v)
		radius = v

	end
})


Tab:Toggle({
	Title = "ฟามเวลสแตน",
	Value = Get("StandFarm",false),
	Callback = function(state)
		Save("StandFarm",state)
		standFarm = state

	end
})
Tab:Toggle({
    Title = "ออโต้หาลูกศรตามพื้น",
    Value = Get("AutoArrow",false),
    Callback = function(state)

        Save("AutoArrow",state)
        AutoArrow = state

        if AutoArrow then
            task.spawn(function()

                while AutoArrow do

                    for _,v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Stand Arrow" and v:FindFirstChild("ProximityPrompt") then

                            local player = game:GetService("Players").LocalPlayer
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")

                            if root then
                                root.CFrame = v.CFrame + Vector3.new(0,3,0)

                                task.wait(0.3)

                                while AutoArrow and v.Parent and v:FindFirstChild("ProximityPrompt") do
                                    fireproximityprompt(v.ProximityPrompt)
                                    task.wait(0.2)
                                end
                            end

                        end
                    end

                    task.wait(1)

                end

            end)
        end

    end
})


Tab:Dropdown({
	Title = "เลือกสกิว",
	Values = {"Z","X","C","V","E","R"},
	Value = Get("Skills",{"Z","X","C"}),
	Multi = true,
	Callback = function(option)
		Save("Skills",option)
		selectedSkills = option

	end
})



Tab:Toggle({
	Title = "ออโต้สกิว",
	Value = Get("AutoSkill",false),
	Callback = function(state)
		Save("AutoSkill",state)
		autoSkill = state

	end
})


Tab:Dropdown({
	Title = "เลือกโหมดการตี",
	Values = {"Under","Above","Behind"},
	Value = Get("FarmMode","Under"),
	Callback = function(option)
		Save("FarmMode",option)
		farmMode = option
	end
})

Tab:Slider({
	Title = "ปรับระยะห่างจากมอน",
	Step = 1,
	Value = {Min = 1,Max = 15,Default = Get("FarmDistance",7)},
	Callback = function(v)
		Save("FarmDistance",v)
		farmDistance = v
	end
})



local RollTab = Window:Tab({Title = "Roll", Icon = "bone"})


RollTab:Dropdown({
    Title = "Target Stand",
    Desc = "เลือก สแตน ที่ต้องการ",
    Values = standList,
    Multi = true,
    AllowNone = true,
    Value = Get("TargetStand",{}),
    Callback = function(option)
        Save("TargetStand",option)
        targets = {}
        for _,v in pairs(option) do
            targets[v] = true
        end

    end
})


RollTab:Toggle({
    Title = "Auto Roll Stand",
    Desc = "ออโต้สุ่มสแตน",
    Value = Get("AutoRoll",false),
    Callback = function(state)
        Save("AutoRoll",state)
        autoRoll = state
        if state then
            roll()
        end

    end
})

local RaidTab = Window:Tab({Title = "Raid", Icon = "bone"})


RaidTab:Toggle({
    Title = "Auto Farm Raid Kira",
	Desc = "ออโต้ฟาทเรทคิระ",
    Value = Get("AutoRaidKira",false),
    Callback = function(state)
        Save("AutoRaidKira",state)
        if state then
            task.spawn(autoRaidKira)
        end

    end
})
