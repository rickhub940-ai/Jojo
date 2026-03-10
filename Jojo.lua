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

local player = Players.LocalPlayer

local AutoFarm = false
local AutoSkill = false

local radius = 13
local tpDistance = 7
local FarmMode = "Below"

local selectedSkills = {
	E=true,R=true,Z=true,X=true,C=true,V=true
}

local root
local circleParts={}
local segments=30
local dashLength=5
local rotation=0

-- สร้างวงแดง
local function createCircle()

	for i=1,segments do
		
		if i%4==0 then
			
			local p=Instance.new("Part")
			p.Size=Vector3.new(0.6,0.2,dashLength)
			p.Material=Enum.Material.Neon
			p.Color=Color3.fromRGB(255,0,0)
			p.Anchored=true
			p.CanCollide=false
			p.Parent=workspace
			
			table.insert(circleParts,{part=p,index=i})
			
		end
		
	end
	
end

createCircle()

-- หมุนวง
RunService.RenderStepped:Connect(function(dt)

	if not root or not AutoFarm then
	
		for _,v in pairs(circleParts) do
			v.part.Transparency=1
		end
		
		return
	end

	rotation+=dt*2

	for _,data in ipairs(circleParts) do
		
		local p=data.part
		local i=data.index
		
		p.Transparency=0
		
		local angle=(i/segments)*math.pi*2+rotation
		
		local x=math.cos(angle)*radius
		local z=math.sin(angle)*radius
		
		p.CFrame=
		CFrame.new(root.Position+Vector3.new(x,0.05,z))
		*CFrame.Angles(0,-angle,0)
		
	end
	
end)

-- เช็คมอน
local function validTarget(m)

	if m==player.Character then return end
	
	if Players:GetPlayerFromCharacter(m) then
		return
	end
	
	local hum=m:FindFirstChildWhichIsA("Humanoid")
	if not hum then return end
	
	if m:FindFirstChildWhichIsA("ProximityPrompt",true) then return end
	
	local hrp=m:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local dist=(hrp.Position-root.Position).Magnitude
	
	if dist<=radius then
		return hrp
	end
	
end

-- ระบบฟาร์ม
task.spawn(function()

	while true do
		
		task.wait(0.01)
		
		if not AutoFarm then continue end
		
		local char=player.Character
		if not char then continue end
		
		root=char:FindFirstChild("HumanoidRootPart")
		if not root then continue end
		
		local controller=char:FindFirstChild("client_character_controller")
		if not controller then continue end
		
		local m1=controller:FindFirstChild("M1")
		local skill=controller:FindFirstChild("Skill")
		
		for _,m in pairs(workspace:GetChildren()) do
			
			local hrp=validTarget(m)
			
			if hrp then
				
				local pos
				
				if FarmMode=="Above" then
					pos=hrp.Position+Vector3.new(0,tpDistance,0)
					
				elseif FarmMode=="Below" then
					pos=hrp.Position+Vector3.new(0,-tpDistance,0)
					
				elseif FarmMode=="Behind" then
					pos=hrp.Position-hrp.CFrame.LookVector*tpDistance
					
				end
				
				root.CFrame=
				CFrame.new(pos)
				*CFrame.Angles(math.rad(-90),0,0)
				
				if m1 then
					m1:FireServer(true,false)
				end
				
				if AutoSkill and skill then
					
					local order={"E","R","Z","X","C","V"}
					
					for _,k in ipairs(order) do
						
						if selectedSkills[k] then
							skill:FireServer(k,true)
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end)









local Tab = Window:Tab({Title = "MAIN", Icon = "swords"})


Tab:Toggle({
	Title="ออโต้ฟามมอนรอบๆ",
	Type="Checkbox",
	Value=false,
	Callback=function(v)
		AutoFarm=v
	end
})

Tab:Slider({
	Title="วงในการฟามมอนรอบๆ",
	Step=1,
	Value={
		Min=5,
		Max=200,
		Default=13
	},
	Callback=function(v)
		radius=v
	end
})



Tab:Toggle({
	Title="ออโต้สกิว",
	Type="Checkbox",
	Value=false,
	Callback=function(v)
		AutoSkill=v
	end
})

Tab:Dropdown({
	Title="Select Skills",
	Values={"E","R","Z","X","C","V"},
	Multi=true,
	Default={"E","R","Z","X","C","V"},
	Callback=function(values)

		for k in pairs(selectedSkills) do
			selectedSkills[k]=false
		end
		
		for _,v in ipairs(values) do
			selectedSkills[v]=true
		end
		
	end
})

Tab:Dropdown({
	Title="โหมดการฟาม",
	Values={"Above","Below","Behind"},
	Default="Below",
	Callback=function(v)
		FarmMode=v
	end
})

Tab:Slider({
	Title="ระยะห่างการฟาม,
	Step=1,
	Value={
		Min=3,
		Max=15,
		Default=7
	},
	Callback=function(v)
		tpDistance=v
	end
})

