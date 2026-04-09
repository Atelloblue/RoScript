-- [[ ROSCRIPT V1.0 ]] --
-- Made by the RoScripts Team --
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Flying = false,
    ESPEnabled = false,
    ShowNames = true,
    ShowHealth = true,
    AutoRejoin = true,
    Invincible = false,
    TargetPlayer = "",
    AimbotEnabled = false,
    AimSmoothness = 0.2,
    AntiAFK = true,
    -- Super Ring Config
    SuperRingEnabled = false,
    SuperRingRadius = 50,
    SuperRingHeight = 100,
    SuperRingSpeed = 10,
    SuperRingStrength = 1000
}

-- UI Setup
local RoScriptUI = Instance.new("ScreenGui")
RoScriptUI.Name = "RoScript_Lucide"
RoScriptUI.Parent = CoreGui
RoScriptUI.ResetOnSpawn = false

local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(22, 22, 22),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TabInActive = Color3.fromRGB(150, 150, 150)
}

local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = RoScriptUI
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BackgroundTransparency = 1 

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Secondary
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "RoScript"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Theme.Text
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Center

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Position = UDim2.new(0, 160, 0, 10)
ContentArea.Size = UDim2.new(1, -170, 1, -20)
ContentArea.BackgroundTransparency = 1

-- Restore Button
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Name = "RestoreBtn"
RestoreBtn.Parent = RoScriptUI
RestoreBtn.Size = UDim2.new(0, 55, 0, 30)
RestoreBtn.Position = UDim2.new(0, 20, 0.5, 0)
RestoreBtn.BackgroundColor3 = Theme.Main
RestoreBtn.Text = "OPEN"
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextColor3 = Theme.Accent
RestoreBtn.TextSize = 10
RestoreBtn.Visible = false
RestoreBtn.Draggable = true
Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RestoreBtn).Color = Theme.Accent

-- Minimize Button
local MiniBtn = Instance.new("TextButton", MainFrame)
MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(1, -45, 1, -45)
MiniBtn.BackgroundTransparency = 1
MiniBtn.Text = "-"
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextColor3 = Theme.Text
MiniBtn.TextSize = 30

MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RestoreBtn.Visible = false
end)

-- Page/Tab System
local Pages = {}
local Tabs = {}
local currentLayoutOrder = 0

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page
    return Page
end

local function CreateTab(name, iconId)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = "" 
    TabBtn.LayoutOrder = currentLayoutOrder
    currentLayoutOrder = currentLayoutOrder + 1
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local Icon
    if iconId and iconId ~= "" then
        Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Name = "ImageLabel"
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId
        Icon.ImageColor3 = Theme.TabInActive
    end

    local TabText = Instance.new("TextLabel", TabBtn)
    TabText.Name = "TextLabel"
    TabText.BackgroundTransparency = 1
    TabText.Text = name
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextColor3 = Theme.TabInActive
    TabText.TextSize = 11
    
    if Icon then
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Position = UDim2.new(0, 38, 0, 0) 
        TabText.TextXAlignment = Enum.TextXAlignment.Left
    else
        TabText.Size = UDim2.new(1, 0, 1, 0)
        TabText.Position = UDim2.new(0, 0, 0, 0) 
        TabText.TextXAlignment = Enum.TextXAlignment.Center
    end

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do 
            Tween(t, {0.3}, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
            if t:FindFirstChild("ImageLabel") then
                Tween(t.ImageLabel, {0.3}, {ImageColor3 = Theme.TabInActive})
            end
            Tween(t.TextLabel, {0.3}, {TextColor3 = Theme.TabInActive})
        end
        Pages[name].Visible = true
        Tween(TabBtn, {0.3}, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
        if Icon then
            Tween(Icon, {0.3}, {ImageColor3 = Theme.Accent})
        end
        Tween(TabText, {0.3}, {TextColor3 = Theme.Accent})
    end)
    Tabs[name] = TabBtn
    return TabBtn
end

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(1, -10, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = text
    Button.Font = Enum.Font.GothamSemibold
    Button.TextColor3 = Theme.Text
    Button.TextSize = 11
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    Button.MouseButton1Click:Connect(function()
        Tween(Button, {0.1}, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main})
        task.wait(0.1)
        Tween(Button, {0.2}, {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Theme.Text})
        callback(Button)
    end)
    return Button
end

local function CreateInput(parent, placeholder, callback)
    local Input = Instance.new("TextBox", parent)
    Input.Size = UDim2.new(1, -10, 0, 38)
    Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Input.PlaceholderText = placeholder
    Input.Text = ""
    Input.Font = Enum.Font.Gotham
    Input.TextColor3 = Theme.Text
    Input.TextSize = 11
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Input).Color = Color3.fromRGB(40, 40, 40)
    Input.FocusLost:Connect(function() callback(Input.Text) end)
end

-- [[ SUPER RING LOGIC ]] --
local superRingParts = {}
local function RetainPart(Part)
    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then return false end
        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        Part.CanCollide = false
        return true
    end
    return false
end

for _, part in pairs(workspace:GetDescendants()) do if RetainPart(part) then table.insert(superRingParts, part) end end
workspace.DescendantAdded:Connect(function(part) if RetainPart(part) then table.insert(superRingParts, part) end end)

-- [[ LOGIC SYSTEMS ]] --
local function ImprovedFling(Target)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local tchar = Target.Character
    local thrp = tchar and tchar:FindFirstChild("HumanoidRootPart")
    
    if hrp and thrp then
        local OldPos = hrp.CFrame
        local FlingForce = 50000 
        local BV = Instance.new("BodyVelocity", hrp)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Velocity = Vector3.new(FlingForce, FlingForce, FlingForce)
        local BAV = Instance.new("BodyAngularVelocity", hrp)
        BAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BAV.AngularVelocity = Vector3.new(FlingForce, FlingForce, FlingForce)
        
        local FlingLoop = RunService.Heartbeat:Connect(function()
            if not tchar or not thrp or not tchar.Parent then return end
            hrp.Velocity = Vector3.new(FlingForce, FlingForce, FlingForce)
            local rot = math.rad(math.random(0, 360))
            hrp.CFrame = thrp.CFrame * CFrame.Angles(rot, rot, rot)
            for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end)
        task.wait(3)
        FlingLoop:Disconnect(); BV:Destroy(); BAV:Destroy()
        for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = true end end
        hrp.Velocity = Vector3.new(0,0,0); hrp.RotVelocity = Vector3.new(0,0,0); hrp.CFrame = OldPos
    end
end

local function AdvancedServerHop()
    local Servers = {}
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local function GetServers(cursor)
        local url = Api .. (cursor and "&cursor=" .. cursor or "")
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success then
            local data = HttpService:JSONDecode(result)
            for _, s in pairs(data.data) do
                if s.playing < s.maxPlayers and s.playing > 0 and s.id ~= game.JobId then
                    table.insert(Servers, s)
                end
            end
            if data.nextPageCursor and #Servers < 100 then GetServers(data.nextPageCursor) end
        end
    end
    GetServers()
    table.sort(Servers, function(a, b) return a.playing > b.playing end)
    if #Servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, Servers[1].id) end
end

CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if Config.AutoRejoin and child.Name == 'ErrorPrompt' then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

local flyBV, flyBG
local function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char.Humanoid
    flyBG = Instance.new("BodyGyro", root)
    flyBG.P = 9e4; flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBV = Instance.new("BodyVelocity", root)
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    hum.PlatformStand = true
    task.spawn(function()
        while Config.Flying and char.Parent do
            local cam = workspace.CurrentCamera
            RunService.RenderStepped:Wait()
            if hum and root then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local direction = cam.CFrame:VectorToObjectSpace(moveDir)
                    local flyVec = (cam.CFrame.LookVector * -direction.Z) + (cam.CFrame.RightVector * direction.X)
                    flyBV.Velocity = flyVec.Unit * Config.FlySpeed
                else
                    flyBV.Velocity = Vector3.new(0, 0.1, 0)
                end
                flyBG.CFrame = cam.CFrame
            end
        end
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if hum then hum.PlatformStand = false end
    end)
end

local function GetClosestToMouse()
    local target, nearest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < nearest then nearest = dist; target = p end
            end
        end
    end
    return target
end

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- Intro Animation
task.spawn(function()
    MainFrame.Size = UDim2.new(0, 500, 0, 0)
    MainFrame.BackgroundTransparency = 0
    MainStroke.Transparency = 0
    Tween(MainFrame, {0.6, Enum.EasingStyle.Quart}, {Size = UDim2.new(0, 500, 0, 320)})
end)

-- Initialize Pages
local HomePage = CreatePage("Home")
local MovePage = CreatePage("Movement")
local SuperRingPage = CreatePage("Super Ring")
local CombatPage = CreatePage("Combat")
local PlayPage = CreatePage("Players")
local VisPage = CreatePage("Visuals")
local MiscPage = CreatePage("Misc")

-- [[ TAB INITIALIZATION ]] --
CreateTab("Home", nil)
local TabDivider = Instance.new("Frame", TabContainer)
TabDivider.Size = UDim2.new(0.85, 0, 0, 1)
TabDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabDivider.BorderSizePixel = 0
TabDivider.LayoutOrder = currentLayoutOrder
currentLayoutOrder = currentLayoutOrder + 1
Instance.new("UICorner", TabDivider).CornerRadius = UDim.new(0, 1)

CreateTab("Movement", "rbxassetid://10734900011")
CreateTab("Super Ring", "rbxassetid://10709819149")
CreateTab("Combat", "rbxassetid://10709752906")
CreateTab("Players", "rbxassetid://10747373176")
CreateTab("Visuals", "rbxassetid://10723346959")
CreateTab("Misc", "rbxassetid://10709819149")

-- [[ PAGE CONTENT ]] --

-- Home
local HomeTitle = Instance.new("TextLabel", HomePage)
HomeTitle.Size = UDim2.new(1, -10, 0, 30); HomeTitle.BackgroundTransparency = 1; HomeTitle.Text = "Welcome to RoScript"; HomeTitle.Font = Enum.Font.GothamBold; HomeTitle.TextColor3 = Theme.Accent; HomeTitle.TextSize = 18; HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
local HomeDesc = Instance.new("TextLabel", HomePage)
HomeDesc.Size = UDim2.new(1, -10, 0, 60); HomeDesc.BackgroundTransparency = 1; HomeDesc.Text = "RoScript V1.0 - The ultimate multi-tool for Roblox. All systems operational."; HomeDesc.Font = Enum.Font.Gotham; HomeDesc.TextColor3 = Theme.Text; HomeDesc.TextSize = 12; HomeDesc.TextWrapped = true; HomeDesc.TextXAlignment = Enum.TextXAlignment.Left
CreateButton(HomePage, "Join Discord Community", function() if setclipboard then setclipboard("https://discord.gg/roscripts") end end)

-- Movement
CreateInput(MovePage, "WalkSpeed (16)", function(t) Config.WalkSpeed = tonumber(t) or 16 end)
CreateInput(MovePage, "JumpPower (50)", function(t) Config.JumpPower = tonumber(t) or 50 end)
CreateInput(MovePage, "Fly Speed (50)", function(t) Config.FlySpeed = tonumber(t) or 50 end)
CreateButton(MovePage, "Fly: OFF", function(btn)
    Config.Flying = not Config.Flying
    btn.Text = "Fly: " .. (Config.Flying and "ON" or "OFF")
    if Config.Flying then StartFly() end
end)

-- Super Ring
CreateButton(SuperRingPage, "Super Ring: OFF", function(btn)
    Config.SuperRingEnabled = not Config.SuperRingEnabled
    btn.Text = "Super Ring: " .. (Config.SuperRingEnabled and "ON" or "OFF")
end)
CreateInput(SuperRingPage, "Radius (50)", function(t) Config.SuperRingRadius = tonumber(t) or 50 end)
CreateInput(SuperRingPage, "Height (100)", function(t) Config.SuperRingHeight = tonumber(t) or 100 end)
CreateInput(SuperRingPage, "Rotation Speed (10)", function(t) Config.SuperRingSpeed = tonumber(t) or 10 end)

-- Combat
CreateButton(CombatPage, "Aimbot: OFF", function(btn)
    Config.AimbotEnabled = not Config.AimbotEnabled
    btn.Text = "Aimbot: " .. (Config.AimbotEnabled and "ON" or "OFF")
end)
CreateButton(CombatPage, "Invincible: OFF", function(btn)
    Config.Invincible = not Config.Invincible
    btn.Text = "Invincible: " .. (Config.Invincible and "ON" or "OFF")
end)
CreateInput(CombatPage, "Aim Smoothness (0.1 - 1)", function(t) Config.AimSmoothness = tonumber(t) or 0.2 end)

-- Players
function GetPlayer(name)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1,#name) == name:lower() or p.DisplayName:lower():sub(1,#name) == name:lower() then return p end
    end
end
CreateInput(PlayPage, "Target Username", function(t) Config.TargetPlayer = t end)
CreateButton(PlayPage, "Teleport to Player", function()
    local t = GetPlayer(Config.TargetPlayer)
    if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
end)
local IsSpec = false
CreateButton(PlayPage, "Spectate: OFF", function(btn)
    local cam = workspace.CurrentCamera
    IsSpec = not IsSpec
    if IsSpec then
        local t = GetPlayer(Config.TargetPlayer)
        if t and t.Character then cam.CameraSubject = t.Character.Humanoid; btn.Text = "Spectate: ON" end
    else
        cam.CameraSubject = LocalPlayer.Character.Humanoid; btn.Text = "Spectate: OFF"
    end
end)
CreateButton(PlayPage, "Fling Player", function()
    local t = GetPlayer(Config.TargetPlayer)
    if t then ImprovedFling(t) end
end)

-- Visuals
CreateButton(VisPage, "Master ESP: OFF", function(btn)
    Config.ESPEnabled = not Config.ESPEnabled
    btn.Text = "Master ESP: " .. (Config.ESPEnabled and "ON" or "OFF")
end)
CreateButton(VisPage, "Show Names: ON", function(btn) Config.ShowNames = not Config.ShowNames; btn.Text = "Show Names: " .. (Config.ShowNames and "ON" or "OFF") end)
CreateButton(VisPage, "Show Health: ON", function(btn) Config.ShowHealth = not Config.ShowHealth; btn.Text = "Show Health: " .. (Config.ShowHealth and "ON" or "OFF") end)

-- Misc
CreateButton(MiscPage, "Anti-AFK: ON", function(btn) 
    Config.AntiAFK = not Config.AntiAFK
    btn.Text = "Anti-AFK: " .. (Config.AntiAFK and "ON" or "OFF")
end)
CreateButton(MiscPage, "Rejoin on Kick: ON", function(btn)
    Config.AutoRejoin = not Config.AutoRejoin
    btn.Text = "Rejoin on Kick: " .. (Config.AutoRejoin and "ON" or "OFF")
end)
CreateButton(MiscPage, "Server Hopper (Fullest)", function() AdvancedServerHop() end)
CreateButton(MiscPage, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
CreateButton(MiscPage, "Exit RoScript", function() RoScriptUI:Destroy() end)

-- [[ UPDATE LOOPS ]] --
RunService.Heartbeat:Connect(function()
    if Config.SuperRingEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local center = hrp.Position
            for i, part in pairs(superRingParts) do
                if part.Parent and not part.Anchored then
                    local pos = part.Position
                    local dist = (Vector3.new(pos.X, center.Y, pos.Z) - center).Magnitude
                    local angle = math.atan2(pos.Z - center.Z, pos.X - center.X)
                    local newAngle = angle + math.rad(Config.SuperRingSpeed)
                    local targetPos = Vector3.new(center.X + math.cos(newAngle) * math.min(Config.SuperRingRadius, dist), center.Y + (Config.SuperRingHeight * (math.abs(math.sin((pos.Y - center.Y) / Config.SuperRingHeight)))), center.Z + math.sin(newAngle) * math.min(Config.SuperRingRadius, dist))
                    part.Velocity = (targetPos - part.Position).unit * Config.SuperRingStrength
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then 
                    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None 
                    local high = p.Character:FindFirstChild("RoHighlight")
                    if not high then
                        high = Instance.new("Highlight", p.Character)
                        high.Name = "RoHighlight"
                        high.FillColor = Color3.new(1,1,1)
                        high.OutlineColor = Color3.new(1,1,1)
                        high.FillTransparency = 0.6
                    end
                    local tag = p.Character:FindFirstChild("RoTag")
                    if not tag then
                        tag = Instance.new("BillboardGui", p.Character)
                        tag.Name = "RoTag"
                        tag.Size = UDim2.new(0, 100, 0, 40)
                        tag.AlwaysOnTop = true
                        tag.StudsOffset = Vector3.new(0, 3, 0)
                        local nl = Instance.new("TextLabel", tag)
                        nl.Name = "N"
                        nl.Size = UDim2.new(1, 0, 0.5, 0)
                        nl.BackgroundTransparency = 1
                        nl.TextColor3 = Color3.new(1,1,1)
                        nl.Font = Enum.Font.GothamBold
                        nl.TextSize = 10
                        nl.TextStrokeTransparency = 0.5
                        local hb = Instance.new("Frame", tag)
                        hb.Name = "B"
                        hb.Size = UDim2.new(0.8, 0, 0.1, 0)
                        hb.Position = UDim2.new(0.1, 0, 0.6, 0)
                        hb.BackgroundColor3 = Color3.new(0, 0, 0)
                        hb.BorderSizePixel = 0
                        local hfill = Instance.new("Frame", hb)
                        hfill.Name = "F"
                        hfill.Size = UDim2.new(1, 0, 1, 0)
                        hfill.BackgroundColor3 = Color3.new(0, 1, 0)
                        hfill.BorderSizePixel = 0
                    end
                    tag.N.Visible = Config.ShowNames
                    tag.B.Visible = Config.ShowHealth
                    tag.N.Text = p.DisplayName
                    local hp = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
                    tag.B.F.Size = UDim2.new(hp, 0, 1, 0)
                    tag.B.F.BackgroundColor3 = Color3.new(1,0,0):Lerp(Color3.new(0,1,0), hp)
                end
            end
        end
    end
    if Config.AimbotEnabled then
        local target = GetClosestToMouse()
        if target and target.Character then
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Character.Head.Position), Config.AimSmoothness)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local hum = LocalPlayer.Character.Humanoid
            if not Config.Flying then hum.WalkSpeed = Config.WalkSpeed; hum.JumpPower = Config.JumpPower; hum.UseJumpPower = true end
            if Config.Invincible then 
                hum.Health = hum.MaxHealth 
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) 
            else
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end)
    end
end)

Pages["Home"].Visible = true
Tween(Tabs["Home"], {0.3}, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
if Tabs["Home"]:FindFirstChild("ImageLabel") then
    Tween(Tabs["Home"].ImageLabel, {0.3}, {ImageColor3 = Theme.Accent})
end
Tween(Tabs["Home"].TextLabel, {0.3}, {TextColor3 = Theme.Accent})
