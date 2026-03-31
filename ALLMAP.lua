local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local player = game.Players.LocalPlayer


--// COLORS (เทาใส)
local DARK1 = Color3.fromHex("#1E1E1E")
local DARK2 = Color3.fromHex("#2A2A2A")
local DARK3 = Color3.fromHex("#242424")
local WHITE = Color3.fromHex("#FFFFFF")

--// GRADIENT (เรียบมาก)
local BG = WindUI:Gradient({
    ["0"] = {Color = DARK1, Transparency = 0.25},
    ["100"] = {Color = DARK2, Transparency = 0.25},
},{Rotation = 90})

local TAB = WindUI:Gradient({
    ["0"] = {Color = DARK2, Transparency = 0.1},
    ["100"] = {Color = DARK3, Transparency = 0.1},
},{Rotation = 90})

--// THEME
WindUI:AddTheme({
    Name = "XenonReal",

    Accent = WHITE, -- ไม่มีสีจัด
    Hover = WHITE,

    Background = BG,
    BackgroundTransparency = 0.35,

    Outline = Color3.fromRGB(255,255,255),
    OutlineTransparency = 0.92, -- จางมาก

    Text = WHITE,
    Icon = WHITE,

    WindowBackground = BG,
    WindowShadow = Color3.fromRGB(0,0,0),

    TabBackground = TAB,
    TabTitle = WHITE,
    TabIcon = WHITE,

    ElementBackground = TAB,
    ElementTitle = WHITE,

    Button = TAB,
    Toggle = TAB,
    Slider = TAB,
})

WindUI:SetTheme("XenonReal")

local avatar = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
..player.UserId.."&size=420x420&format=Png"

local Window = WindUI:CreateWindow({
    Title = "RICK HUB [ Tools ] ",
    Icon = "rbxassetid://108958018844079",
    Author = "Author[ 009.exe ]",
    Folder = "RICK HUB",
    Size = UDim2.fromOffset(730, 410),
    Theme = "XenonReal",
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
    Title = "v0.0.1",
    Icon = "github",
    Color = Color3.fromHex("#00bfff"),
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
local player = Players.LocalPlayer

-- ค่าเริ่มต้น
local DefaultSpeed = 16
local DefaultJumpPower = 50

-- ค่าที่ปรับจาก Slider
local BoostSpeed = 70
local BoostJumpPower = 100

local SpeedEnabled = false
local JumpEnabled = false

local function apply()
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- 🏃‍♂️ Speed
    hum.WalkSpeed = SpeedEnabled and BoostSpeed or DefaultSpeed

    -- 🦘 Jump
    hum.UseJumpPower = true
    hum.JumpPower = JumpEnabled and BoostJumpPower or DefaultJumpPower
end

-- 🔁 กันโดนรีเซ็ต
task.spawn(function()
    while true do
        task.wait(0.5)
        apply()
    end
end)

-- 🔄 ตอนเกิดใหม่
player.CharacterAdded:Connect(function()
    task.wait(1)
    apply()
end)


local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local InfiniteJumpEnabled = false

-- 🦘 ทำงานตอนกดปุ่มกระโดด
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = player.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 🔘 Toggle

local MainTab = Window:Tab({Title = "Main", Icon = "user"})


MainTab:Toggle({
    Title = "walkSpeed",
    Desc = "วิ่งไว",
    Default = false,
    Callback = function(state)
        SpeedEnabled = state
        apply()
    end
})

-- 🎚️ Slider Speed
MainTab:Slider({
    Title = "Speed Value",
    Desc = "ปรับความเร็ว",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        BoostSpeed = value
        apply()
    end
})


MainTab:Toggle({
    Title = "Jump",
    Desc = "กระโดดสูง",
    Default = false,
    Callback = function(state)
        JumpEnabled = state
        apply()
    end
})
MainTab:Slider({
    Title = "Jump Value",
    Desc = "ปรับความสูงกระโดด",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 100,
    },
    Callback = function(value)
        BoostJumpPower = value
        apply()
    end
})

MainTab:Toggle({
    Title = "Infinite Jump",
    Desc = "กระโดดไม่จำกัด",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ⚙️ CONFIG (เหมือนของเดิม)
local flySpeed = 50
local rotationSpeed = 0.03
local noclip = true

local flying = false
local bv, bg, conn, noclipConn
local lastLook = Vector3.new(0,0,-1)

-- 👻 noclip
local function enableNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if not flying then return end
        local char = player.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConn then noclipConn:Disconnect() end
end

-- 🚀 เริ่มบิน (เหมือน V4)
local function startFly()
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    flying = true
    hum.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 1e4
    bg.CFrame = root.CFrame
    bg.Parent = root

    local cam = workspace.CurrentCamera

    conn = RunService.Heartbeat:Connect(function()
        if not flying then return end

        local moveDir = hum.MoveDirection
        local target = Vector3.zero

        if moveDir.Magnitude > 0 then
            local dir = cam.CFrame:VectorToWorldSpace(moveDir)
            target = dir.Unit * flySpeed
        end

        bv.Velocity = bv.Velocity:Lerp(target, 0.25)

        -- 🔄 หมุนเนียนเหมือนเดิม
        local look = cam.CFrame.LookVector
        lastLook = lastLook:Lerp(look, rotationSpeed)
        bg.CFrame = CFrame.lookAt(root.Position, root.Position + lastLook)

        if target.Magnitude == 0 then
            bv.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)

    if noclip then enableNoclip() end
end

-- 🛑 หยุดบิน
local function stopFly()
    flying = false

    if conn then conn:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    disableNoclip()

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- 🔘 Toggle (ของคุณ)
MainTab:Toggle({
    Title = "Fly",
    Desc = "normal",
    Default = false,
    Callback = function(state)
        if state then
            startFly()
        else
            stopFly()
        end
    end
})
