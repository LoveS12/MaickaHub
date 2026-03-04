
local Players = game:GetService("Players")


local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local FRIEND_COLOR = Color3.fromRGB(0, 170, 255)
local ENEMY_COLOR  = Color3.fromRGB(255, 60, 60) 


local UPDATE_INTERVAL = 1.5
local NAME_OFFSET = Vector3.new(0, 3, 0)


local function getColor(player)
    if LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return FRIEND_COLOR
    end
    return ENEMY_COLOR
end


local function updateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end

    local character = player.Character
    local color = getColor(player)


    local highlightName = player.Name .. "_ESP"
    local highlight = PlayerGui:FindFirstChild(highlightName)

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = highlightName
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = PlayerGui
    end

    highlight.Adornee = character
    highlight.OutlineColor = color


    local head = character:FindFirstChild("Head")
    if not head then return end

    local tagName = player.Name .. "_NAMETAG"
    local billboard = PlayerGui:FindFirstChild(tagName)

    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = tagName
        billboard.Size = UDim2.new(0, 110, 0, 28)
        billboard.StudsOffset = NAME_OFFSET
        billboard.AlwaysOnTop = true
        billboard.Parent = PlayerGui

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0
        label.Text = player.Name
        label.Parent = billboard
    end

    billboard.Adornee = head
    billboard.Label.TextColor3 = color
end


local function cleanup()
    for _, obj in pairs(PlayerGui:GetChildren()) do
        if obj:IsA("Highlight") or obj:IsA("BillboardGui") then
            local pname = obj.Name:gsub("_ESP", ""):gsub("_NAMETAG", "")
            if not Players:FindFirstChild(pname) then
                obj:Destroy()
            end
        end
    end
end


task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            updateESP(player)
        end
        cleanup()
        task.wait(UPDATE_INTERVAL)
    end
end)
