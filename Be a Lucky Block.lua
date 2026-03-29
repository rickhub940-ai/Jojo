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
    Title = "RICK HUB [ Be a Lucky Block ] ",
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
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local RANGE = 50

local TP_ESCAPE = Vector3.new(759.45, 38.71, -2136.69)
local TP_SAFE   = Vector3.new(708.67, 38.71, -2115.42)

local Enabled = false
local lastState = nil

local function onCharacterAdded(char)
    lastState = nil
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)


local function getClosestBoss()
    local bossFolder = workspace:FindFirstChild("BossSpawns")
    if not bossFolder then return nil end

    local char = player.Character
    if not char then return nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestBoss = nil
    local shortestDistance = math.huge

    for _, base in pairs(bossFolder:GetChildren()) do
        if base:IsA("Model") then
            local bossModel = base:FindFirstChildWhichIsA("Model")
            if bossModel then
                local bossHRP = bossModel:FindFirstChild("HumanoidRootPart")
                local humanoid = bossModel:FindFirstChild("Humanoid")

                if bossHRP and humanoid then
                    local dist = (hrp.Position - bossHRP.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestBoss = bossModel
                    end
                end
            end
        end
    end

    return closestBoss, shortestDistance
end
RunService.Heartbeat:Connect(function()
    if not Enabled then return end

    if not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local testFolder = workspace:FindFirstChild("robloxtestscrip_4")
    local rootPart = testFolder and testFolder:FindFirstChild("RootPart")

    local runningModels = workspace:FindFirstChild("RunningModels")
    local myModule = runningModels and runningModels:FindFirstChild(tostring(player.UserId))

    if rootPart then
        hrp.CFrame = CFrame.new(TP_ESCAPE)
        return
    end
    if testFolder and not rootPart and not myModule then
        hrp.CFrame = CFrame.new(TP_SAFE)
        return
    end
    if myModule then
        if myModule:GetAttribute("MovementSpeed") ~= 999999 then
            myModule:SetAttribute("MovementSpeed", 999999)
        end
        return
    end
    local boss, distance = getClosestBoss()
    if not boss then return end

    local bossHumanoid = boss:FindFirstChild("Humanoid")
    if not bossHumanoid then return end
    if distance <= RANGE then
        if bossHumanoid.WalkSpeed ~= 0 then
            bossHumanoid.WalkSpeed = 0
        end
    else
        if bossHumanoid.WalkSpeed == 0 then
            bossHumanoid.WalkSpeed = 16
        end
    end
end)

local Tab = Window:Tab({Title = "MAIN", Icon = "user"})

Tab:Toggle({
    Title = "Auto Farm",
    Desc = "ออโต้ฟาม",
    Default = false,
    Callback = function(state)
        Enabled = state
        if not state then
            lastState = nil
        end
    end
})
