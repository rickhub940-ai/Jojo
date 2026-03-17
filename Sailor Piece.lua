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
    Title = "v0.0.5",
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





local Tab = Window:Tab({Title = "MAIN", Icon = "scan-search"})

Tab:Toggle({
    Title = "ออโต้ฟาม",
    Value = AutoFarm,
    Callback = function(state) 
        AutoFarm = state
        Save("AutoFarm", state)
    end
})

Tab:Dropdown({
    Title = "เลือกโหมดการฟาม",
    Values = { "Above", "Behind", "Below" },
    Value = FarmMode,
    Callback = function(option) 
        FarmMode = option
        Save("FarmMode", option)
    end
})

Tab:Slider({
    Title = "ระยะห่างจากมอน",
    Step = 1,
    Value = { Min = 5, Max = 30, Default = FarmDistance },
    Callback = function(value)
        FarmDistance = value
        Save("FarmDistance", value)
    end
})



-- =============================================
--   FARM ZONE (วงแดง + หามอน + ตี + เข้าโซนแล้ว Tween/TP ตามระยะ)
-- =============================================

local AutoFarmZone = Get("AutoFarmZone", false)
local ZoneRadius = Get("ZoneRadius", 20)
local ZoneCircleName = "RickHub_ZoneCircle"
local TargetMobZone = nil

local ZONE_CENTER_POS = nil

-- สร้าง/อัพเดทวง + บันทึกตำแหน่งกลาง
local function CreateZoneCircleAtPlayer()
    local root = GetRoot()
    if not root then return end
    
    local oldCircle = workspace:FindFirstChild(ZoneCircleName)
    if oldCircle then oldCircle:Destroy() end
    
    local circle = Instance.new("Part")
    circle.Name = ZoneCircleName
    circle.Shape = Enum.PartType.Cylinder
    circle.Size = Vector3.new(ZoneRadius * 2, 0.4, ZoneRadius * 2)   -- ขนาดจริง = เส้นผ่านศูนย์กลาง = ZoneRadius * 2
    circle.Color = Color3.fromRGB(255, 0, 0)
    circle.Transparency = 0.70
    circle.Anchored = true
    circle.CanCollide = false
    circle.CanQuery = false
    circle.Parent = workspace
    
    local pos = root.Position - Vector3.new(0, 2.8, 0)
    circle.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
    
    ZONE_CENTER_POS = pos + Vector3.new(0, 3, 0)  -- จุดรอตรงกลางวง
end

local function DestroyZoneCircle()
    local circle = workspace:FindFirstChild(ZoneCircleName)
    if circle then circle:Destroy() end
    ZONE_CENTER_POS = nil
end

-- หา mob ใกล้ที่สุดที่อยู่ในวง (รัศมี ZoneRadius)
local function FindNearestMobInZone()
    local root = GetRoot()
    if not root or not ZONE_CENTER_POS then return nil, math.huge end
    
    local bestMob, bestDist = nil, math.huge
    
    for _, npc in ipairs(workspace.NPCs:GetChildren()) do
        local hum = npc:FindFirstChild("Humanoid")
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0.1 then
            local distToCenter = (hrp.Position - ZONE_CENTER_POS).Magnitude
            if distToCenter <= ZoneRadius then  -- อยู่ในวง
                local distToPlayer = (root.Position - hrp.Position).Magnitude
                if distToPlayer < bestDist then
                    bestDist = distToPlayer
                    bestMob = npc
                end
            end
        end
    end
    
    return bestMob, bestDist
end

-- Toggle
Tab:Toggle({
    Title = "ฟาร์มโซน (วงแดง + ตีออโต้)",
    Value = AutoFarmZone,
    Callback = function(state) 
        AutoFarmZone = state
        Save("AutoFarmZone", state)
        
        if state then
            CreateZoneCircleAtPlayer()
            TargetMobZone = nil
        else
            DestroyZoneCircle()
            TargetMobZone = nil
        end
    end
})

-- Slider ขนาดวง (รัศมี ไม่ใช่เส้นผ่านศูนย์กลาง)
Tab:Slider({
    Title = "รัศมีวงแดง (สตัด)",
    Step = 1,
    Value = { Min = 5, Max = 50, Default = ZoneRadius },
    Callback = function(value)
        ZoneRadius = value
        Save("ZoneRadius", value)
        
        if AutoFarmZone then
            local circle = workspace:FindFirstChild(ZoneCircleName)
            if circle then
                circle.Size = Vector3.new(ZoneRadius * 2, 0.4, ZoneRadius * 2)
            end
        end
    end
})

-- Loop หลัก
task.spawn(function()
    while true do
        task.wait(0.15)
        
        if not AutoFarmZone then
            TargetMobZone = nil
            continue
        end
        
        local root = GetRoot()
        if not root then continue end
        
        -- ถ้าอยากให้วงตามตัวตลอด ให้เปิดบรรทัดนี้ (แต่จะทำให้จุด Tween เปลี่ยนบ่อย)
        -- CreateZoneCircleAtPlayer()
        
        local mob, playerToMobDist = FindNearestMobInZone()
        
        if mob then
            TargetMobZone = mob
            local mobRoot = mob.HumanoidRootPart
            
            -- มีมอนในวง → ไปหา
            if playerToMobDist > 20 then
                -- ไกลเกิน 20 → Tween ไป
                if not isTweening then
                    local targetPos = mobRoot.Position + Vector3.new(0, FarmDistance + 2, 0)  -- ไปเหนือหัวหน่อย
                    TweenTo(targetPos)
                end
            else
                -- ใกล้พอแล้ว → TP ทันที + ตี
                isTweening = false
                
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
                
                ReplicatedStorage.CombatSystem.Remotes.RequestHit:FireServer()
            end
            
        else
            -- ไม่มีมอนในวง → Tween กลับไปกลางวง
            TargetMobZone = nil
            
            if ZONE_CENTER_POS and not isTweening then
                local distToCenter = (root.Position - ZONE_CENTER_POS).Magnitude
                if distToCenter > 12 then
                    TweenTo(ZONE_CENTER_POS)
                end
            end
        end
    end
end)

-- ลบวงเมื่อตัวละครหาย
player.CharacterRemoving:Connect(function()
    DestroyZoneCircle()
end)

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
    Title = "เลือกอาวุธ",
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
    Title = "รีชื่ออาวุธ",
    Callback = function()
        Dropdown:Refresh(GetTools())
    end
})
Tab:Toggle({
    Title = "Auto ถือ",
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
    Title = "เลือกสตัดที่จะอัพ",
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
    Title = "ออโต้อัพสตัด",
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
