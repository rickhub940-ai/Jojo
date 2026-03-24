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
    Title = "RICK HUB [ Sailor Piece ] ",
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
    Title = "v0.1.1",
    Icon = "github",
    Color = Color3.fromHex("#00bfff"),
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

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")









local ConfigFile = "RICK HUB [ Sailor Piece ].json"
local Config = {}

if isfile(ConfigFile) then
    Config = HttpService:JSONDecode(readfile(ConfigFile))
end

local function Get(name, default)
    if Config[name] == nil then
        Config[name] = default
    end
    return Config[name]
end

local function Save(name, value)
    Config[name] = value
    writefile(ConfigFile, HttpService:JSONEncode(Config))
end


local player = Players.LocalPlayer
local TargetMob = nil
local isTweening = false
local TweenSpeed = 75
local PlatformName = "RickHub_Floor"

local AutoFarm = Get("AutoFarm", false)
local FarmMode = Get("FarmMode", "Above")
local FarmDistance = Get("FarmDistance", 10)

local QuestData = {
    {
        LV = 0,
        NPC = "QuestNPC1",
        posspow = Vector3.new(-91.99,-3.46,-240.31),
        posQ = Vector3.new(169.20,16.33,-214.33),
        NM = {"Thief1","Thief2","Thief3","Thief4","Thief5"}
    },
    {
        LV = 100,
        NPC = "QuestNPC2",
        posspow = Vector3.new(-91.99,-3.46,-240.31),
        posQ = Vector3.new(-6.37,-2.58,-200.49),
        NM = {"ThiefBoss"}
    },
    {
        LV = 250,
        NPC = "QuestNPC3",
        posspow = Vector3.new(-443.18,-3.79,370.63),
        posQ = Vector3.new(-519.88,-1.46,432.28),
        NM = {"Monkey1","Monkey2","Monkey3","Monkey4","Monkey5"}
    },
    {
        LV = 500,
        NPC = "QuestNPC4",
        posspow = Vector3.new(-443.18,-3.79,370.63),
        posQ = Vector3.new(-469.61,18.80,480.29),
        NM = {"MonkeyBoss"}
    },
    {
        LV = 750,
        NPC = "QuestNPC5",
        posspow = Vector3.new(-690.42,-3.53,-349.94),
        posQ = Vector3.new(-689.33,-2.43,-458.65),
        NM = {"DesertBandit1","DesertBandit2","DesertBandit3","DesertBandit4","DesertBandit5"}
    },
    {
        LV = 1000,
        NPC = "QuestNPC6",
        posspow = Vector3.new(-690.42,-3.53,-349.94),
        posQ = Vector3.new(-861.01,-4.22,-386.42),
        NM = {"DesertBoss"}
    },
    {
        LV = 1500,
        NPC = "QuestNPC7",
        posspow = Vector3.new(-233.31,-3.48,-976.06),
        posQ = Vector3.new(-388.83,-1.67,-947.04),
        NM = {"FrostRogue1","FrostRogue2","FrostRogue3","FrostRogue4","FrostRogue5"}
    },
    {
        LV = 2000,
        NPC = "QuestNPC8",
        posspow = Vector3.new(-233.31,-3.48,-976.06),
        posQ = Vector3.new(-552.13,22.42,-1027.08),
        NM = {"SnowBoss"}
    },
    {
        LV = 3000,
        NPC = "QuestNPC9",
        posspow = Vector3.new(1360.44,8.84,246.16),
        posQ = Vector3.new(1420.58,8.84,374.21),
        NM = {"Sorcerer1","Sorcerer2","Sorcerer3","Sorcerer4","Sorcerer5"}
    },
    {
        LV = 4000,
        NPC = "QuestNPC10",
        posspow = Vector3.new(1360.44,8.84,246.16),
        posQ = Vector3.new(1606.04,8.84,428.96),
        NM = {"PandaMiniBoss"}
    },
    {
        LV = 5000,
        NPC = "QuestNPC11",
        posspow = Vector3.new(-485.79,-3.74,938.70),
        posQ = Vector3.new(-287.02,-3.37,1040.38),
        NM = {"Hollow1","Hollow2","Hollow3","Hollow4","Hollow5"}
    },

{
        LV = 6250,
        NPC = "QuestNPC12",
        posspow = Vector3.new(362.39, -2.35, -1631.44),
        posQ = Vector3.new(627.67, 1.89, -1611.04),
        NM = {"StrongSorcerer1","StrongSorcerer2","StrongSorcerer3","StrongSorcerer4","StrongSorcerer5"}
    },
{
        LV = 7000,
        NPC = "QuestNPC13",
        posspow = Vector3.new(362.39, -2.35, -1631.44),
        posQ = Vector3.new(-19.17, 1.89, -1983.12),
        NM = {"Curse1","Curse2","Curse3","Curse4","Curse5"}
    },
{
        LV = 8000,
        NPC = "QuestNPC14",
        posspow = Vector3.new(-988.14, -3.80, 252.10),
        posQ = Vector3.new(-1186.31, 18.12, 338.01),
        NM = {"Slime1","Slime2","Slime3","Slime4","Slime5"}
    },
{
        LV = 9000,
        NPC = "QuestNPC15",
        posspow = Vector3.new(1036.72, -3.70, 1090.25),
        posQ = Vector3.new(1029.79, 1.46, 1241.60),
        NM = {"AcademyTeacher1","AcademyTeacher2","AcademyTeacher3","AcademyTeacher4","AcademyTeacher5"}
    },
{
        LV = 10000,
        NPC = "QuestNPC16",
        posspow = Vector3.new(-958.98, -2.08, -1060.27),
        posQ = Vector3.new(-1165.34, 2.50, -1191.39),
        NM = {"Swordsman1","Swordsman2","Swordsman3","Swordsman4","Swordsman5"}
    }
}


local function GetPlayerSpawn()
    local customSpawn = workspace:FindFirstChild(player.Name.."_Spawn")
    if customSpawn then return customSpawn end
    if player.RespawnLocation then return player.RespawnLocation end
    return nil
end

local function GetRoot()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end
local function ManagePlatform(state)
    local root = GetRoot()
    if not root then return end
    
    local floor = workspace:FindFirstChild(PlatformName)
    if state then
        if not floor then
            floor = Instance.new("Part")
            floor.Name = PlatformName
            floor.Size = Vector3.new(60,1,60)
            floor.Transparency = 1
            floor.Anchored = true
            floor.CanCollide = true
            floor.Parent = workspace
        end

        floor.CFrame = root.CFrame * CFrame.new(0,-3,0)

    else
        if floor then floor:Destroy() end
    end
end

local function TweenTo(pos)
    local root = GetRoot()
    if not root or isTweening then return end

    ManagePlatform(true)
    local floor = workspace:FindFirstChild(PlatformName)

    local dist = (root.Position - pos).Magnitude
    if dist < 5 then return end

    isTweening = true

    local duration = dist / TweenSpeed
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)

    local playerTween = TweenService:Create(
        root,
        info,
        {CFrame = CFrame.new(pos)}
    )

    local floorTween = TweenService:Create(
        floor,
        info,
        {CFrame = CFrame.new(pos) * CFrame.new(0,-3,0)}
    )

    playerTween:Play()
    floorTween:Play()

    playerTween.Completed:Connect(function()
        isTweening = false
        ManagePlatform(false)
    end)
end





local function AutoScanSave()
    local root = GetRoot()
    if not root then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name == "CheckpointPrompt" then
            local dist = (root.Position - obj.Parent.Position).Magnitude
            if dist < 35 then
                fireproximityprompt(obj)
            end
        end
    end
end

local function GetQuest()
    local level = player.Data.Level.Value
    local best = nil
    for _, v in ipairs(QuestData) do
        if level >= v.LV then best = v end
    end
    return best
end
task.spawn(function()
    RunService.Stepped:Connect(function()
        if (AutoFarm or isTweening) and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    RunService.RenderStepped:Connect(function()
        if AutoFarm and TargetMob and TargetMob.Parent and TargetMob:FindFirstChild("HumanoidRootPart") then
            local root = GetRoot()
            local mobRoot = TargetMob.HumanoidRootPart
            if root then
                local offset = CFrame.new(0, 0, 0)
                if FarmMode == "Above" then
                    offset = CFrame.new(0, FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                elseif FarmMode == "Behind" then
                    offset = CFrame.new(0, 0, FarmDistance)
                elseif FarmMode == "Below" then
                    offset = CFrame.new(0, -FarmDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
                end
                root.CFrame = mobRoot.CFrame * offset
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)

    while true do
        task.wait(0.1)
        if not AutoFarm then 
            TargetMob = nil
            isTweening = false
            continue 
        end

        local root = GetRoot()
        local quest = GetQuest()
        if not root or not quest then continue end
        local spawnObj = GetPlayerSpawn()
        local isSpawnCorrect = false
        
        if spawnObj then
            local dist = (spawnObj.Position - quest.posspow).Magnitude
            if dist < 60 then
                isSpawnCorrect = true
            end
        end

        if not isSpawnCorrect then
            TargetMob = nil
            if (root.Position - quest.posspow).Magnitude > 15 then
                if not isTweening then TweenTo(quest.posspow) end
            else
                isTweening = false
                AutoScanSave() 
                task.wait(1)
            end
            continue
        end

        local hasQ = player.PlayerGui:FindFirstChild("QuestUI") and player.PlayerGui.QuestUI.Quest.Visible
        if not hasQ then
            TargetMob = nil
            if (root.Position - quest.posQ).Magnitude > 12 then
                if not isTweening then TweenTo(quest.posQ + Vector3.new(0, 3, 0)) end
            else
                isTweening = false
                ReplicatedStorage.RemoteEvents.QuestAccept:FireServer(quest.NPC)
                task.wait(1.5)
            end
            continue
        end

        local monster = nil
        for _, v in pairs(workspace.NPCs:GetChildren()) do
            for _, name in pairs(quest.NM) do
                if v.Name:find(name) and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    monster = v
                    break
                end
            end
            if monster then break end
        end

        if monster then
            local mobRoot = monster.HumanoidRootPart
            if (root.Position - mobRoot.Position).Magnitude > 50 then
                TargetMob = nil
                if not isTweening then TweenTo(mobRoot.Position + Vector3.new(0, FarmDistance, 0)) end
            else
                isTweening = false
                TargetMob = monster
                ReplicatedStorage.CombatSystem.Remotes.RequestHit:FireServer()
            end
        else
            TargetMob = nil

            if (root.Position - quest.posQ).Magnitude > 15 then
                if not isTweening then
                    TweenTo(quest.posQ + Vector3.new(0,3,0))
                end
            end
        end   

    end   

end)


-- ----------
-- ฟามออร่า
-- ----------



local PlatformName = "FarmZone_Floor"

local FarmZoneEnabled = false
local FarmZoneRadius = 30
local FarmZoneDistance = 15
local FarmZoneMode = "Above"

local ZonePosition = nil
local circle
local TargetMob = nil
local isTweening = false

local function GetRoot()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function ManagePlatform(state)
    local root = GetRoot()
    if not root then return end
    local floor = workspace:FindFirstChild(PlatformName)
    if state then
        if not floor then
            floor = Instance.new("Part")
            floor.Name = PlatformName
            floor.Size = Vector3.new(60,1,60)
            floor.Transparency = 1
            floor.Anchored = true
            floor.CanCollide = true
            floor.Parent = workspace
        end
        floor.CFrame = root.CFrame * CFrame.new(0,-3,0)
    else
        if floor then floor:Destroy() end
    end
end

local function TweenTo(pos)
    local root = GetRoot()
    if not root or isTweening then return end

    local dist = (root.Position - pos).Magnitude
    if dist < 5 then return end

    isTweening = true
    ManagePlatform(true)

    local duration = dist / 75
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)

    local playerTween = TweenService:Create(root, info, {CFrame = CFrame.new(pos)})
    local floor = workspace:FindFirstChild(PlatformName)
    local floorTween
    if floor then
        floorTween = TweenService:Create(floor, info, {CFrame = CFrame.new(pos) * CFrame.new(0,-3,0)})
    end

    playerTween:Play()
    if floorTween then floorTween:Play() end

    playerTween.Completed:Connect(function()
        isTweening = false
        ManagePlatform(false)
    end)
end
local function CreateFarmZone()
    if workspace:FindFirstChild("FarmZoneCircle") then
        workspace.FarmZoneCircle:Destroy()
    end

    local root = GetRoot()
    if not root then return end

    ZonePosition = root.Position

    circle = Instance.new("Part")
    circle.Name = "FarmZoneCircle"
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(0.2, FarmZoneRadius*2, FarmZoneRadius*2)
    circle.Color = Color3.fromRGB(255,0,0)
    circle.Material = Enum.Material.Neon
    circle.Transparency = 0.5
    circle.Anchored = true
    circle.CanCollide = false
    circle.Orientation = Vector3.new(0,0,90)
    circle.Position = ZonePosition - Vector3.new(0,3,0)
    circle.Parent = workspace
end

local function RemoveFarmZone()
    if workspace:FindFirstChild("FarmZoneCircle") then
        workspace.FarmZoneCircle:Destroy()
    end
    ZonePosition = nil
    circle = nil
end

local function GetTargetInZone()
    if not ZonePosition then return end

    local closest = nil
    local shortest = math.huge

    for _, v in pairs(workspace.NPCs:GetChildren()) do
        local hum = v:FindFirstChildOfClass("Humanoid")
        local hrp = v:FindFirstChild("HumanoidRootPart")

        if hum and hrp and hum.Health > 0 then
            local dist = (hrp.Position - ZonePosition).Magnitude

            if dist <= FarmZoneRadius and dist < shortest then
                closest = v
                shortest = dist
            end
        end
    end

    return closest
end

local function FarmZoneLogic()
 if not FarmZoneEnabled then return end
   local root = GetRoot()
    if not root then return end
   local target = GetTargetInZone()
   TargetMob = target

   if target and target:FindFirstChild("HumanoidRootPart") then
       local hrp = target.HumanoidRootPart
local dist = (hrp.Position - root.Position).Magnitude

        if dist > 20 then
            TweenTo(hrp.Position)
		else
            local offset
            if FarmZoneMode == "Above" then
                offset = CFrame.new(0, FarmZoneDistance, 0)
            elseif FarmZoneMode == "Below" then
                offset = CFrame.new(0, -FarmZoneDistance, 0)
            elseif FarmZoneMode == "Behind" then
                offset = CFrame.new(0, 0, FarmZoneDistance)
			end
    root.CFrame = hrp.CFrame * offset
        root.CFrame = CFrame.new(root.Position, hrp.Position)
            task.spawn(function()
                while target and target.Parent and target:FindFirstChildOfClass("Humanoid") and target.Humanoid.Health > 0 do
                    game:GetService("ReplicatedStorage").CombatSystem.Remotes.RequestHit:FireServer()
                    task.wait(0.01)
                end
            end)
        end
	else
        if ZonePosition then
            local dist = (root.Position - ZonePosition).Magnitude
            if dist > 5 then
                TweenTo(ZonePosition)
            end
        end
    end
end
task.spawn(function()
    while task.wait(0.01) do
        FarmZoneLogic()
    end
end)





local Tab = Window:Tab({Title = "MAIN", Icon = "scan-search"})

Tab:Section({ 
    Title = "FARM Level",
})

Tab:Toggle({
    Title = "Auto Farm Level 0-MAX",
	Desc = "ออโต้ฟามเวล0ถึงเวลตัน",
    Value = AutoFarm,
    Callback = function(state) 
        AutoFarm = state
        Save("AutoFarm", state)
    end
})

Tab:Dropdown({
    Title = "Farm Level Mode",
	Desc = "เลือกโหมดการฟาม",
    Values = { "Above", "Behind", "Below" },
    Value = FarmMode,
    Callback = function(option) 
        FarmMode = option
        Save("FarmMode", option)
    end
})

Tab:Slider({
    Title = "Attack Distance (AutoFarm Lv)",
	Desc = "ระยะห่างจากมอน(ของฟามเวล)",
    Step = 1,
    Value = { Min = 5, Max = 30, Default = FarmDistance },
    Callback = function(value)
        FarmDistance = value
        Save("FarmDistance", value)
    end
})

Tab:Divider()

Tab:Section({ 
    Title = "FARM ZOME",
})

Tab:Toggle({
    Title = "Farm Zone",
	Desc = "ฟามโซน",
    Value = false,
    Callback = function(state)
        FarmZoneEnabled = state
        if state then CreateFarmZone() else RemoveFarmZone() end
    end
})

Tab:Slider({
    Title = "Zone Radius",
	Desc = "ปรับวงการฟาม",
    Step = 5,
    Value = { Min = 10, Max = 200, Default = FarmZoneRadius },
    Callback = function(value)
        FarmZoneRadius = value
        if circle then
            circle.Size = Vector3.new(0.2, FarmZoneRadius*2, FarmZoneRadius*2)
        end
    end
})

Tab:Slider({
    Title = "Attack Distance (FarmZone)",
	Desc = "ปรับระยะห่างจากมอน(ฟามโซน)",
    Step = 1,
    Value = { Min = 5, Max = 30, Default = FarmZoneDistance },
    Callback = function(value)
        FarmZoneDistance = value
    end
})

Tab:Dropdown({
    Title = "Farm Zone Mode",
	Desc = "เลือกโหมดการฟาม(ฟามโซน)",
    Values = { "Above", "Below", "Behind" },
    Value = FarmZoneMode,
    Callback = function(option)
        FarmZoneMode = option
    end
})



-- --------
-- ออโต้ถือ
-- --------


local plr = Players.LocalPlayer


local Dropdown

local function GetTools()
    local t = {}

    local bp = plr:WaitForChild("Backpack")
    for _,v in pairs(bp:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(t,v.Name)
        end
    end

    return t
end
function equipandattack(v)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local bp = plr:WaitForChild("Backpack")
    local hu = char:FindFirstChildOfClass("Humanoid")

    if not hu then return end

    local tool = bp:FindFirstChild(v)
    if tool then
        hu:EquipTool(tool)
    end
end

Dropdown = Tab:Dropdown({
    Title = "Selected Weapon",
	Desc = "เลือกอาวุธ",
    Values = GetTools(),
    Value = Config.SelectedTool,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        Config.SelectedTool = option
        SaveConfig()
    end
})

Tab:Button({
    Title = "Refresh Weapon",
	Desc = "รีเฟรชชื่ออาวุธ",
    Callback = function()
        Dropdown:Refresh(GetTools())
    end
})
Tab:Toggle({
    Title = "Auto Equip Weapon",
	Desc = "ออโต้ถืออาวุธ",
    Value = Config.AutoEquip,
    Callback = function(v)
        Config.AutoEquip = v
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoEquip and Config.SelectedTool then
            equipandattack(Config.SelectedTool)
        end
    end
end)

plr.CharacterAdded:Connect(function()
    task.wait(1)
    if Config.AutoEquip and Config.SelectedTool then
        equipandattack(Config.SelectedTool)
    end
end)



local StatTab = Window:Tab({Title = "STATS", Icon = "trending-up"})



local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.RemoteEvents.AllocateStat

local Autostats = {}
local Amount = 1
local Auto = false

StatTab:Dropdown({
    Title = "เลือกสตัด",
    Values = {"Melee","Defense","Sword","Power"},
    Multi = true,
    Callback = function(v)
        Autostats = v
    end
})

StatTab:Slider({
    Title = "ปรับจำนวนพ้อยท์ที่จะอัพ",
    Step = 1,
    Value = {
        Min = 1,
        Max = 10000,
        Default = 1
    },
    Callback = function(v)
        Amount = v
    end
})

StatTab:Toggle({
    Title = "Auto up Stat",
    Value = false,
    Callback = function(v)
        Auto = v
    end
})

task.spawn(function()
    while task.wait(0.2) do
        if Auto then
            for k,v in pairs(Autostats) do
                
                local stat = v
                if type(k) == "string" then
                    stat = k
                end

                local args = {
                    [1] = stat,
                    [2] = Amount
                }

                game:GetService("ReplicatedStorage")
                    .RemoteEvents
                    .AllocateStat
                    :FireServer(unpack(args))

            end
        end
    end
end)



local SkillTab = Window:Tab({Title = "SKILL", Icon = "biohazard"})

local Vim = game:GetService("VirtualInputManager")
local SelectedSkills = Get("SelectedSkills", {})
local AutoSkill = Get("AutoSkill", false)


local Dropdown = SkillTab:Dropdown({
    Title = "เลือกสกิล",
    Values = {"Z","X","C","V"},
    Multi = true,
    Default = SelectedSkills,
    Callback = function(option)
        SelectedSkills = option
        Save("SelectedSkills", option)
    end
})


local Toggle = SkillTab:Toggle({
    Title = "ออโต้สกิล",
    Value = AutoSkill,
    Callback = function(state)
        AutoSkill = state
        Save("AutoSkill", state)
    end
})
task.spawn(function()
    while true do
        if AutoSkill then
            for _,key in pairs(SelectedSkills) do
                Vim:SendKeyEvent(true, key, false, game)
                task.wait()
                Vim:SendKeyEvent(false, key, false, game)
                task.wait(0.4)
            end
        end
        task.wait()
    end
end)



local TeleportsTab = Window:Tab({Title = "TELEPORTS", Icon = "map-pinned"})

local Holder = player.PlayerGui.TeleportUI.MainFrame.Frame.Content.Holder
local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TeleportToPortal")

local Teleports = {}

for _,v in pairs(Holder:GetChildren()) do
	if string.find(v.Name,"Teleport_") then
		local name = v.Name:gsub("Teleport_","")
		table.insert(Teleports,name)
	end
end

for _,place in ipairs(Teleports) do
	TeleportsTab:Button({
		Title = place.." Island",
		Callback = function()
			Remote:FireServer(place)
		end
	})
end

local bossTab = Window:Tab({Title = "BOSS", Icon = "skull"})

task.wait(2)



local BossParagraph = bossTab:Paragraph({
    Title = "Boss info",
    Desc = "Loading...",
})

local BossMap = {}
local Timers = {}

local dirty = false
local lastRender = 0

local function formatText(text)
    text = tostring(text)

    if not string.match(text, "%d") then
        return "🟢 Spawned Now!!"
    end

    return "🔴 " .. text
end

for _, v in pairs(workspace:GetDescendants()) do
    if v.Name == "Timer" and v:IsA("TextLabel") then
        table.insert(Timers, v)
    end
end

local function renderUI()
    local result = ""
    for name, status in pairs(BossMap) do
        result = result .. name .. " : " .. status .. "\n"
    end
    if result == "" then
        result = "kuy..."
    end
    BossParagraph:SetDesc(result)
end
task.spawn(function()
    while true do
        dirty = false
        for _, v in pairs(Timers) do
        if v and v.Parent then
            local bossName = "Unknown"
                local parent = v.Parent
                while parent do
                    if string.find(parent.Name, "TimedBossSpawn_") then
                    bossName = parent.Name
                     bossName = bossName:gsub("TimedBossSpawn_", "")
                    bossName = bossName:gsub("Boss", "")
                 break
            end
                 parent = parent.Parent
                end
                local newValue = formatText(v.Text)
                if BossMap[bossName] ~= newValue then
                    BossMap[bossName] = newValue
                    dirty = true
                end
            end
        end
        if dirty then
            renderUI()
            lastRender = tick()
            task.wait(0.01)
        else
            task.wait(0.2)
        end
    end
end)


-- -------
-- Farm boss
-- --------
--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

--// DATA
local bossPositions = {}
local bossTimers = {}
local selectedBosses = {}
local allBosses = {}

local lockedBoss = nil
local lockedPosition = nil
local targetBoss = nil

local running = false
local lastScan = 0
local lastHit = 0

--// SETTINGS
local SPAWN_CHECK_RADIUS = 50
local SPEED = 120

--// 🎛 MODE
local FarmBossMode = "Above"
local FarmBossDistance = 5

--// 🌀 AUTO HOP (ตัวเล็ก + ไม่มี delay)
local auto_hop = false

--// 🟫 PLATFORM
local platform = Instance.new("Part")
platform.Name = "PlatformBoss"
platform.Size = Vector3.new(60,-3,60)
platform.Anchored = true
platform.CanCollide = true
platform.Transparency = 1
platform.Parent = workspace

--// parse time
local function parseTime(text)
    text = tostring(text or ""):gsub("%s+", "")
    if text == "" then return 0 end
    if text:match("%a") then return 0 end

    if text:find(":") then
        local m,s = text:match("(%d+):(%d+)")
        if m and s then
            return tonumber(m)*60 + tonumber(s)
        end
    end

    return tonumber(text) or math.huge
end

--// scan spawn
local function scanPositions()
    bossPositions = {}
    allBosses = {}

    for _, v in pairs(workspace:GetChildren()) do
        if string.find(v.Name, "TimedBossSpawn_") then
            local name = v.Name
            name = name:gsub("TimedBossSpawn_", "")
            name = name:gsub("Boss_Container", "")
            name = name:gsub("_Container", "")

            table.insert(allBosses, name)

            local pos = v:FindFirstChild("HumanoidRootPart")
            bossPositions[name] = pos and pos.Position or v:GetPivot().Position
        end
    end
end
scanPositions()

--// timer
for _, v in pairs(workspace:GetDescendants()) do
    if v.Name == "Timer" and v:IsA("TextLabel") then

        local bossName = "Unknown"
        local parent = v.Parent

        while parent do
            if string.find(parent.Name, "TimedBossSpawn_") then
                bossName = parent.Name
                bossName = bossName:gsub("TimedBossSpawn_", "")
                bossName = bossName:gsub("Boss", "")
                break
            end
            parent = parent.Parent
        end

        if not v:GetAttribute("Connected") then
            v:SetAttribute("Connected", true)

            local function update()
                bossTimers[bossName] = parseTime(v.Text)
            end

            update()
            v:GetPropertyChangedSignal("Text"):Connect(update)
        end
    end
end

--// เลือกบอส
local function getBestBoss()
    local best, lowest = nil, math.huge

    for _, name in pairs(selectedBosses) do
        local t = bossTimers[name]
        if t == 0 then return name end
        if t and t < lowest then
            lowest = t
            best = name
        end
    end
    return best
end

--// เช็คมีบอสเกิดไหม
local function hasSpawnedBoss()
    for _, name in pairs(selectedBosses) do
        if bossTimers[name] == 0 then
            return true
        end
    end
    return false
end

--// hop
local function hopServer()
    TeleportService:Teleport(game.PlaceId)
end

--// หา boss
local function findSpawnedBoss(name, pos)
    local npc = workspace:FindFirstChild("NPCs")
    if not npc then return nil end

    for _, obj in pairs(npc:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            local hum = obj:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                if (hrp.Position - pos).Magnitude <= SPAWN_CHECK_RADIUS then
                    if string.find(string.lower(obj.Name), string.lower(name)) then
                        return obj
                    end
                end
            end
        end
    end
end

--// movement
local moveConn = nil

local function tweenTo(pos)
    local hrp = char:WaitForChild("HumanoidRootPart")

    if moveConn then moveConn:Disconnect() end

    local startPos = hrp.Position
    local dist = (startPos - pos).Magnitude
    local duration = dist / SPEED
    local startTime = tick()

    moveConn = RunService.Heartbeat:Connect(function()
        local t = (tick() - startTime) / duration

        if t >= 1 then
            local final = pos + Vector3.new(0,3,0)
            hrp.CFrame = CFrame.new(final, pos)
            platform.Position = final - Vector3.new(0,3,0)
            moveConn:Disconnect()
            moveConn = nil
            return
        end

        local newPos = startPos:Lerp(pos, t)
        local final = newPos + Vector3.new(0,3,0)

        hrp.CFrame = CFrame.new(final, pos)
        platform.Position = final - Vector3.new(0,3,0)
    end)
end

--// attack
local function attack()
    if tick() - lastHit > 0.1 then
        lastHit = tick()
        ReplicatedStorage.CombatSystem.Remotes.RequestHit:FireServer()
    end
end

--// LOOP
task.spawn(function()
    while true do
        task.wait(0.05)

        if not running then continue end

        char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        if tick() - lastScan > 1 then
            lastScan = tick()
            scanPositions()
        end

        local best = getBestBoss()
        if best then
            if lockedBoss ~= best then
                lockedBoss = best
                lockedPosition = bossPositions[best]
                targetBoss = nil
            end
        end

        if lockedBoss and lockedPosition then
            
            local found = findSpawnedBoss(lockedBoss, lockedPosition)
            if found then targetBoss = found end

            if targetBoss and targetBoss:FindFirstChild("Humanoid") then
                if targetBoss.Humanoid.Health <= 0 then
                    targetBoss = nil
                    lockedBoss = nil
                    lockedPosition = nil
                    continue
                end

                attack()

            else
                if (hrp.Position - lockedPosition).Magnitude > 8 then
                    tweenTo(lockedPosition)
                end
            end
        end

        -- 🌀 AUTO HOP (ทันที)
        if auto_hop and #selectedBosses > 0 then
            if not hasSpawnedBoss() then
                hopServer()
            end
        end
    end
end)

--// 🎯 RenderStepped
RunService.RenderStepped:Connect(function()
    if running and targetBoss 
    and targetBoss.Parent 
    and targetBoss:FindFirstChild("HumanoidRootPart") then
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local mobRoot = targetBoss.HumanoidRootPart

        if root then
            local offset = CFrame.new()

            if FarmBossMode == "Above" then
                offset = CFrame.new(0, FarmBossDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            elseif FarmBossMode == "Behind" then
                offset = CFrame.new(0, 0, FarmBossDistance)
            elseif FarmBossMode == "Below" then
                offset = CFrame.new(0, -FarmBossDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
            end

            root.CFrame = mobRoot.CFrame * offset
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)

            platform.Position = root.Position - Vector3.new(0,3,0)
        end
    end
end)


bossTab:Dropdown({
    Title = "เลือกบอส",
    Values = allBosses,
    Multi = true,
    Callback = function(val)
        if typeof(val) ~= "table" then val = {val} end
        selectedBosses = val
    end
})

bossTab:Dropdown({
    Title = "Farm Boss Mode",
    Values = {"Above", "Behind", "Below"},
    Callback = function(val)
        FarmBossMode = val
    end
})

bossTab:Slider({
    Title = "Farm Boss Distance",
    Step = 1,
    Value = {Min = 2, Max = 20, Default = 5},
    Callback = function(val)
        FarmBossDistance = val
    end
})

bossTab:Toggle({
    Title = "Auto Boss",
    Callback = function(state)
        running = state
        lockedBoss = nil
        targetBoss = nil
    end
})

bossTab:Toggle({
    Title = "Auto Hop Server",
    Callback = function(state)
        auto_hop = state
    end
})

print("🔥 FULL AUTO BOSS + INSTANT HOP LOADED")
