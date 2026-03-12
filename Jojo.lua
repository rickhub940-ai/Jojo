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




-- [[ ERROR HUB SYSTEM LOGIC - FULL INTEGRATION ]]

-- [ 1. ตัวแปรเริ่มต้น (กำหนดไว้ด้านบนสุดของสคริปต์คุณ) ]
local player = game:GetService("Players").LocalPlayer
local root
local running = false
local autoSkill = false
local farmMode = "Under"
local farmDistance = 7
local radius = 13
local hitbox = 35
local selectedSkills = { "Z", "X", "C" }
local lastSurfaceY = 0

-- [ 2. ระบบวงกลมสีแดง (Fixed Circle) ]
local circleParts = {}
local function clearCircle()
    for _, v in ipairs(circleParts) do if v.part then v.part:Destroy() end end
    table.clear(circleParts)
end

local function createCircle()
    clearCircle()
    local char = player.Character or player.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
    for i = 1, 16 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.8, 0.2, 0.2)
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(255, 0, 0)
        p.Anchored = true; p.CanCollide = false; p.Parent = workspace
        table.insert(circleParts, {part = p, index = i})
    end
end

-- อัปเดตการหมุนของวงกลม
game:GetService("RunService").Heartbeat:Connect(function()
    if not running or not root then return end
    local rotSpeed = tick() * 3
    for _, data in ipairs(circleParts) do
        local i, p = data.index, data.part
        local angle = (i / 16) * math.pi * 2 + rotSpeed
        local x, z = math.cos(angle) * radius, math.sin(angle) * radius
        p.CFrame = CFrame.new(root.Position + Vector3.new(x, -3, z)) * CFrame.Angles(0, -angle, 0)
    end
end)

-- [ 3. ระบบฟาร์มอัตโนมัติ (Main Logic) ]
task.spawn(function()
    while true do
        task.wait(0.01)
        if not running or not player.Character then continue end
        root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        -- ตั้งค่าการตรวจจับ (คัดกรองตัวละครเราออก)
        local overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        overlap.FilterDescendantsInstances = {player.Character}

        -- ค้นหาชิ้นส่วนในระยะที่กำหนด
        local parts = workspace:GetPartBoundsInRadius(root.Position, radius, overlap)
        local closest, closestDist = nil, radius

        for _, part in ipairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")
            
            -- เงื่อนไข: ต้องอยู่ในโฟลเดอร์ Live และชื่อต้องขึ้นต้นด้วยจุด "."
            if model and model ~= player.Character and model.Parent and model.Parent.Name == "Live" then
                if string.sub(model.Name, 1, 1) == "." then
                    local hrp = model:FindFirstChild("HumanoidRootPart")
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    
                    if hrp and hum and hum.Health > 0 then
                        -- ข้ามผู้เล่นจริง และสิ่งที่มีปุ่มกด (ProximityPrompt)
                        if not game:GetService("Players"):GetPlayerFromCharacter(model) and not model:FindFirstChildWhichIsA("ProximityPrompt", true) then
                            local dist = (hrp.Position - root.Position).Magnitude
                            if dist < closestDist then 
                                closestDist = dist
                                closest = model 
                            end
                            
                            -- ระบบขยาย Hitbox
                            if hrp.Size.X ~= hitbox then
                                hrp.Size = Vector3.new(hitbox, hitbox, hitbox)
                                hrp.Transparency = 1; hrp.CanCollide = false
                            end
                        end
                    end
                end
            end
        end

        -- การจัดการเป้าหมายและการโจมตี
        if closest then
            local e_hrp = closest:FindFirstChild("HumanoidRootPart")
            local controller = player.Character:FindFirstChild("client_character_controller")
            
            if e_hrp and controller then
                -- บันทึกค่า Y พื้นดิน (สำหรับระบบ Auto Surface)
                if farmMode == "Under" and math.abs(root.Position.Y - e_hrp.Position.Y) < 5 then 
                    lastSurfaceY = e_hrp.Position.Y 
                end
                
                -- คำนวณตำแหน่งวาร์ปตามโหมดที่เลือกจาก UI
                local targetPos
                if farmMode == "Under" then 
                    targetPos = e_hrp.Position + Vector3.new(0, -farmDistance, 0)
                elseif farmMode == "Above" then 
                    targetPos = e_hrp.Position + Vector3.new(0, farmDistance, 0)
                elseif farmMode == "Behind" then 
                    targetPos = (e_hrp.CFrame * CFrame.new(0, 0, farmDistance)).Position 
                end
                
                -- วาร์ปตัวละครไปหาเป้าหมาย
                root.CFrame = CFrame.lookAt(targetPos, e_hrp.Position)
                
                -- สั่งโจมตีผ่านรีโมต (M1 & Skills)
                if controller:FindFirstChild("M1") then 
                    controller.M1:FireServer(true, false) 
                end
                if autoSkill and controller:FindFirstChild("Skill") then
                    for _, key in ipairs(selectedSkills) do 
                        controller.Skill:FireServer(key, true) 
                    end
                end
            end
        else
            -- [ ระบบ Smart Surface: วาร์ปขึ้นบกอัตโนมัติเมื่อมอนตาย ]
            if farmMode == "Under" and lastSurfaceY ~= 0 and root.Position.Y < (lastSurfaceY - 2) then
                root.CFrame = CFrame.new(root.Position.X, lastSurfaceY + 3, root.Position.Z)
                task.wait(0.2)
            end
        end
    end
end)



local Tab = Window:Tab({Title = "MAIN", Icon = "swords"

-- [[ ERROR HUB | WINDUI CONTROLS INTEGRATION ]]

-- ส่วนของ Combat: ควบคุมการโจมตี
Tab:Section({ Title = "Combat & Attack" })

Tab:Toggle({
    Title = "Auto Attack",
    Desc = "เปิดระบบฟาร์ม และมุดดินอัตโนมัติ",
    Default = false,
    Callback = function(v)
        running = v
        if v then 
            createCircle() -- สร้างวงกลมเมื่อเปิด
        else 
            clearCircle()  -- ลบวงกลมเมื่อปิด
        end
    end
})

Tab:Toggle({
    Title = "Auto Skill",
    Desc = "ยิงสกิลที่เลือกจากลิสต์ด้านล่าง",
    Default = false,
    Callback = function(v) 
        autoSkill = v 
    end
})

Tab:Dropdown({
    Title = "Select Skills",
    Desc = "เลือกสกิลที่จะให้บอทใช้ (Multi-Select)",
    Multi = true,
    Options = {"Z", "X", "C", "V", "E", "R"},
    Default = {"Z", "X", "C"},
    Callback = function(v) 
        selectedSkills = v -- เก็บค่าเป็น Table ตามที่ระบบต้องการ
    end
})

-- ส่วนของ Settings: ปรับแต่งระยะและตำแหน่ง
Tab:Section({ Title = "Farming Settings" })

Tab:Dropdown({
    Title = "Farm Position",
    Desc = "เลือกโหมดการวาร์ปหาศัตรู",
    Multi = false,
    Options = {"Under", "Above", "Behind"},
    Default = "Under",
    Callback = function(v) 
        farmMode = v -- WindUI จะส่งค่าเป็น String มาให้โดยตรง
    end
})

Tab:Slider({
    Title = "Farm Distance",
    Desc = "ความห่าง/ความลึก จากตัวศัตรู",
    Step = 1,
    Value = { Min = 1, Max = 40, Default = 7 },
    Callback = function(v) 
        farmDistance = v 
    end
})

Tab:Slider({
    Title = "Attack Radius",
    Desc = "ระยะวงกลมในการสแกนหาศัตรู",
    Step = 5,
    Value = { Min = 5, Max = 300, Default = 13 },
    Callback = function(v) 
        radius = v 
    end
})

Tab:Slider({
    Title = "Hitbox Size",
    Desc = "ขยายขนาดตัวศัตรูให้ตีง่ายขึ้น (ปกติคือ 35)",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 35 },
    Callback = function(v) 
        hitbox = v 
    end
})
        
