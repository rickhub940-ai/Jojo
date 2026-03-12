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

local selectedSkills = { "Z", "X", "C" } 
local overlap = OverlapParams.new()

-- [ ระบบวงกลมสีแดง (Fixed Circle Logic) ]
local circleParts = {}
local function clearCircle()
    for _, v in ipairs(circleParts) do if v.part then v.part:Destroy() end end
    table.clear(circleParts)
end

local function createCircle()
    clearCircle()
    local char = player.Character or player.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
    overlap.FilterType = Enum.RaycastFilterType.Exclude
    overlap.FilterDescendantsInstances = {char}
    
    -- สร้าง 16 ชิ้นเพื่อให้ดูเป็นวงกลมที่เนียนขึ้น
    for i = 1, 16 do
        local p = Instance.new("Part")    
        p.Size = Vector3.new(0.8, 0.2, 0.2) -- ปรับขนาดให้เป็นขีดวงกลม
        p.Material = Enum.Material.Neon    
        p.Color = Color3.fromRGB(255, 0, 0) -- สีแดง
        p.Anchored = true    
        p.CanCollide = false    
        p.Parent = Workspace
        table.insert(circleParts, {part = p, index = i})    
    end
end

-- อัปเดตวงกลมให้หมุน (Render)
RunService.Heartbeat:Connect(function()
    if not running or not root then return end
    local rotSpeed = tick() * 3 -- ความเร็วในการหมุน
    for _, data in ipairs(circleParts) do
        local i, p = data.index, data.part
        local angle = (i / 16) * math.pi * 2 + rotSpeed
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius    
        p.CFrame = CFrame.new(root.Position + Vector3.new(x, -3, z)) * CFrame.Angles(0, -angle, 0)
    end
end)

-- [ LOOP ฟาร์มหลัก ]
task.spawn(function()
    while true do
        task.wait(0.01)
        if not running then continue end
        local char = player.Character
        if not char then continue end
        root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local parts = Workspace:GetPartBoundsInRadius(root.Position, radius, overlap)    
        local closest, closestDist = nil, radius    

        for _, part in ipairs(parts) do    
            local model = part:FindFirstAncestorOfClass("Model") 
            if model and model ~= char and model.Parent and model.Parent.Name == "Live" then
                if string.sub(model.Name, 1, 1) == "." then
                    local hrp = model:FindFirstChild("HumanoidRootPart")    
                    local hum = model:FindFirstChildOfClass("Humanoid")    

                    if hrp and hum and hum.Health > 0 then    
                        if Players:GetPlayerFromCharacter(model) then continue end    
                        if model:FindFirstChildWhichIsA("ProximityPrompt", true) then continue end    

                        local dist = (hrp.Position - root.Position).Magnitude    
                        if dist < closestDist then closestDist = dist; closest = model end    

                        if hrp.Size.X ~= hitbox then
                            hrp.Size = Vector3.new(hitbox, hitbox, hitbox)
                            hrp.Transparency = 1; hrp.CanCollide = false
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
                if farmMode == "Under" then targetPos = e_hrp.Position + Vector3.new(0, -farmDistance, 0)
                elseif farmMode == "Above" then targetPos = e_hrp.Position + Vector3.new(0, farmDistance, 0)
                elseif farmMode == "Behind" then targetPos = (e_hrp.CFrame * CFrame.new(0, 0, farmDistance)).Position end
                
                root.CFrame = CFrame.lookAt(targetPos, e_hrp.Position)
                
                if controller:FindFirstChild("M1") then controller.M1:FireServer(true, false) end
                if autoSkill and controller:FindFirstChild("Skill") then
                    for _, key in ipairs(selectedSkills) do controller.Skill:FireServer(key, true) end
                end
            end
        end
    end
end)

-- [ UI SETTINGS ]



local Tab = Window:Tab({Title = "MAIN", Icon = "swords"

Tab:Toggle({
"ออโต้ตีมอนในวง",
    Callback = function(state) 
        running = state 
        if state then createCircle() else clearCircle() end
    end
})

Tab:Slider({
    Title = "ปรับวง",
    Step = 5,
    Value = { Min = 5, Max = 250, Default = 13 },
    Callback = function(v) radius = v end
})
                

Tab:Toggle({
    Title = "ออโต้สกิว",
    Callback = function(state) autoSkill = state end
})

Tab:Dropdown({
    Title = "Select Skills",
    Values = { "Z", "X", "C", "V", "E", "R" },
    Value = { "Z", "X", "C" },
    Multi = true,
    Callback = function(option) selectedSkills = option end
})

-- Standard Dropdown (เลือกโหมด) - แก้ไขตามตัวอย่าง No Multi
Tab:Dropdown({
    Title = "โหมดฟาม",
    Values = { "Under", "Above", "Behind" },
    Value = "Under", -- เป็น String โดยตรง
    Callback = function(option) 
        farmMode = option -- รับค่า String เข้าไปใช้งาน
    end
})

Tab:Slider({
    Title = "ปรับระยะห่าง",
    Step = 1,
    Value = { Min = 1, Max = 40, Default = 7 },
    Callback = function(v) farmDistance = v end
})

