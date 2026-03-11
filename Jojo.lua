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
    Folder = "RICK HUB",
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

ScreenGui.Name = "WindUI_Toggle"
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
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local root
local running = false
local autoSkill = false
local farmMode = "Under"
local farmDistance = 7
local radius = 13
local hitbox = 35

-- ตัวแปรเก็บสกิลที่เลือก (เป็น Table ตามรูปแบบ Multi Dropdown)
local selectedSkills = { "Z", "X", "C" } 

-- [ ส่วนของวงแหวน Visual ]
local segments = 16
local dashLength = 5
local rotation = 0
local circleParts = {}
local overlap = OverlapParams.new()

local function clearCircle()
    for _, v in ipairs(circleParts) do if v.part then v.part:Destroy() end end
    table.clear(circleParts)
end

local function createCircle(char)
    if #circleParts > 0 then return end
    root = char:WaitForChild("HumanoidRootPart")
    overlap.FilterType = Enum.RaycastFilterType.Exclude
    overlap.FilterDescendantsInstances = {char}
    for i = 1, segments do
        if i % 2 == 0 then    
            local p = Instance.new("Part")    
            p.Size = Vector3.new(0.6, 0.2, dashLength)    
            p.Material = Enum.Material.Neon    
            p.Color = Color3.fromRGB(255, 0, 0)
            p.Anchored = true    
            p.CanCollide = false    
            p.Parent = workspace    
            table.insert(circleParts, {part = p, index = i})    
        end
    end
end

RunService.Heartbeat:Connect(function(dt)
    if not running or not root then return end
    rotation += dt * 2
    for _, data in ipairs(circleParts) do
        local i, p = data.index, data.part
        local angle = (i/segments)*math.pi*2 + rotation    
        local x, z = math.cos(angle)*radius, math.sin(angle)*radius    
        p.CFrame = CFrame.new(root.Position + Vector3.new(x, 0.05, z)) * CFrame.Angles(0, -angle, 0)
    end
end)

-- [ LOOP หลัก: SMART FARM SYSTEM ]
task.spawn(function()
    while true do
        task.wait(0.01)
        
        if not running or not player.Character then continue end
        root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local parts = Workspace:GetPartBoundsInRadius(root.Position, radius, overlap)    
        local closest, closestDist = nil, radius    

        for _, part in ipairs(parts) do    
            local model = part:FindFirstAncestorOfClass("Model")    
            if model and model ~= player.Character then    
                local hrp = model:FindFirstChild("HumanoidRootPart")    
                local hum = model:FindFirstChildOfClass("Humanoid")    

                -- ตรวจสอบ Humanoid และข้าม ProximityPrompt
                if hrp and hum and hum.Health > 0 then    
                    if Players:GetPlayerFromCharacter(model) then continue end    
                    if model:FindFirstChildWhichIsA("ProximityPrompt", true) then continue end    

                    local dist = (hrp.Position - root.Position).Magnitude    
                    if dist < closestDist then 
                        closestDist = dist
                        closest = model 
                    end    

                    if hrp.Size.X ~= hitbox then
                        hrp.Size = Vector3.new(hitbox, hitbox, hitbox)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                    end
                end
            end
        end    

        if closest then    
            local e_hrp = closest:FindFirstChild("HumanoidRootPart")    
            local controller = player.Character:FindFirstChild("client_character_controller")
            
            if e_hrp and controller then
                -- 1. วาร์ป
                local targetPos
                if farmMode == "Under" then 
                    targetPos = e_hrp.Position + Vector3.new(0, -farmDistance, 0)
                elseif farmMode == "Above" then 
                    targetPos = e_hrp.Position + Vector3.new(0, farmDistance, 0)
                elseif farmMode == "Behind" then 
                    targetPos = (e_hrp.CFrame * CFrame.new(0, 0, farmDistance)).Position 
                end
                root.CFrame = CFrame.lookAt(targetPos, e_hrp.Position)

                -- 2. Remote M1
                if controller:FindFirstChild("M1") then
                    controller.M1:FireServer(true, false)
                end
                
                -- 3. Remote Skill (ยิงเฉพาะที่เลือกใน Multi-Dropdown)
                if autoSkill and controller:FindFirstChild("Skill") then
                    for _, key in ipairs(selectedSkills) do
                        controller.Skill:FireServer(key, true)
                    end
                end
            end
        end
    end
end)

-- [ ส่วนของ UI Menu ]






local Tab = Window:Tab({Title = "MAIN", Icon = "swords"})

Tab:Toggle({
    Title = "Auto Attack",
    Callback = function(state)
        running = state
        if state then if player.Character then createCircle(player.Character) end else clearCircle() end
    end
})

Tab:Toggle({
    Title = "Auto Skill",
    Callback = function(state) autoSkill = state end
})

-- แก้ไข Dropdown เป็นแบบ Multi ตามตัวอย่างของคุณ
Tab:Dropdown({
    Title = "Select Skills",
    Desc = "เลือกสกิลที่จะยิง",
    Values = { "Z", "X", "C", "V", "E", "R" },
    Value = { "Z", "X", "C" }, -- Default ที่เลือกไว้
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        -- option จะคืนค่ามาเป็น table เช่น { "Z", "X" }
        selectedSkills = option
    end
})

Tab:Dropdown({
    Title = "Farm Position",
    Values = {"Under", "Above", "Behind"},
    Callback = function(v) farmMode = v end
})

Tab:Slider({
    Title = "Farm Distance",
    Min = 1, Max = 30, Default = 7,
    Callback = function(v) farmDistance = v end
})

Tab:Slider({
    Title = "Attack Radius",
    Min = 5, Max = 100, Default = 13,
    Callback = function(v) radius = v end
})

