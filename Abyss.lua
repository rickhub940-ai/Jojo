
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local client = workspace:WaitForChild("Game"):WaitForChild("Fish"):WaitForChild("client")


local Fish_Name_list = { "All - ทุกตัว" }
pcall(function()
    for _, fishModel in pairs(ReplicatedStorage:WaitForChild("common"):WaitForChild("assets"):WaitForChild("fish"):GetChildren()) do
        if fishModel:IsA("Model") and fishModel.PrimaryPart then
            table.insert(Fish_Name_list, fishModel.Name)
        end
    end
end)


local ESP_ENABLED = false
local SelectedFish = {}
local ShowInfo = {
    Name = true,
    Distance = true,
    Mutation = true
}
local ESP_LIST = {}


local function createESP(fish)
    if not ESP_ENABLED then return end
    if ESP_LIST[fish] then return end

    local head = fish:FindFirstChild("Head")
    local torso = fish:FindFirstChild("UpperTorso")
    if not head or not torso then return end

    local fishName = "???"
    if head:FindFirstChild("stats") and head.stats:FindFirstChild("Fish") then
        fishName = head.stats.Fish.Text
    end

    -- ยังไม่เลือกปลา = ไม่แสดง
    if not next(SelectedFish) then return end

    -- ถ้าไม่ได้เลือก All
    if not SelectedFish["All - ทุกตัว"] then
        if not SelectedFish[fishName] then
            return
        end
    end

    -- สร้าง BillBoard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FishESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 115, 0, 34)
    billboard.StudsOffset = Vector3.new(0, 1.9, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fish

    local y = 0

    -- ชื่อปลา
    if ShowInfo.Name then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = fishName
        nameLabel.TextColor3 = torso.Color
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = billboard
        y = 0.5
    end

    -- การกลายพันธุ์ (mutation)
    local mutationText = ""
    local mutationColor = Color3.new(1, 1, 1)
    local hasMutation = false

    if head:FindFirstChild("stats") and head.stats:FindFirstChild("Mutation") then
        local m = head.stats.Mutation:FindFirstChild("Label")
        if m and m.Text ~= "" then
            mutationText = m.Text
            mutationColor = m.TextColor3
            hasMutation = true
        end
    end

    if hasMutation and ShowInfo.Mutation then
        local mut = Instance.new("TextLabel")
        mut.Size = UDim2.new(1, 0, 0.3, 0)
        mut.Position = UDim2.new(0, 0, y, 0)
        mut.BackgroundTransparency = 1
        mut.Text = "🧬 " .. mutationText
        mut.TextColor3 = mutationColor
        mut.TextStrokeTransparency = 0.2
        mut.TextScaled = true
        mut.Font = Enum.Font.SourceSansBold
        mut.Parent = billboard
        y = y + 0.3
    end

    -- ระยะทาง
    if ShowInfo.Distance then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.3, 0)
        distLabel.Position = UDim2.new(0, 0, y, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.new(1, 1, 1)
        distLabel.TextScaled = true
        distLabel.Font = Enum.Font.SourceSans
        distLabel.Parent = billboard
        task.spawn(function()
            while billboard.Parent do
                task.wait(0.2)
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local dist = math.floor((player.Character.Head.Position - head.Position).Magnitude)
                        distLabel.Text = dist .. "m"
                    end
                end)
            end
        end)
    end

    ESP_LIST[fish] = {billboard = billboard}
end


local function removeESP(fish)
    if ESP_LIST[fish] then
        ESP_LIST[fish].billboard:Destroy()
        ESP_LIST[fish] = nil
    end
end

local function refreshESP()
    for fish, data in pairs(ESP_LIST) do
        if data.billboard then
            data.billboard:Destroy()
        end
    end
    ESP_LIST = {}

    for _, fish in pairs(client:GetChildren()) do
        createESP(fish)
    end
end

client.ChildAdded:Connect(function(fish)
    task.wait(0.3)
    createESP(fish)
end)

client.ChildRemoved:Connect(function(fish)
    removeESP(fish)
end)


local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})

ESPTab:Dropdown({
    Title = "เลือกปลาที่จะมอง",
    Values = Fish_Name_list,
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedFish = {}

        if table.find(option, "All - ทุกตัว") then
            SelectedFish["All - ทุกตัว"] = true
        else
            for _, v in pairs(option) do
                SelectedFish[v] = true
            end
        end

        refreshESP()
    end
})

ESPTab:Dropdown({
    Title = "ข้อมูลที่จะแสดง",
    Values = {"ชื่อปลา", "ระยะ", "การกลายพันธุ์"},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        ShowInfo.Name = table.find(option, "ชื่อปลา") ~= nil
        ShowInfo.Distance = table.find(option, "ระยะ") ~= nil
        ShowInfo.Mutation = table.find(option, "การกลายพันธุ์") ~= nil

        refreshESP()
    end
})

ESPTab:Toggle({
    Title = "มองปลา",
    Value = false,
    Callback = function(state)
        ESP_ENABLED = state
        refreshESP()
    end
})

