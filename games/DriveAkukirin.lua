

--// RideXHub | Dev

--// Obsidian UI rebuild

--// Tabs: Main, Player, Scooter, Scooter Visuals, Halloween, Preview, Settings

--// RightControl toggles the menu

--// Preview is inside Obsidian, not a separate floating window



--============================================================

-- SERVICES

--============================================================



local Players = game:GetService("Players")

local Workspace = game:GetService("Workspace")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")



local LocalPlayer = Players.LocalPlayer

local GEN = getgenv()



--============================================================

-- CLEAN UP PREVIOUS RUN

--============================================================



if GEN.RideXHubRuntime and GEN.RideXHubRuntime.Destroy then

    pcall(function()

        GEN.RideXHubRuntime:Destroy()

    end)

end



if GEN.RideXHubLibrary and GEN.RideXHubLibrary.Unload then

    pcall(function()

        GEN.RideXHubLibrary:Unload()

    end)

end



local Runtime = {

    Connections = {},

    Instances = {},

    Destroyed = false,

}



GEN.RideXHubRuntime = Runtime



function Runtime:Connect(signal, callback)

    local connection = signal:Connect(callback)

    table.insert(self.Connections, connection)

    return connection

end



function Runtime:Track(instance)

    table.insert(self.Instances, instance)

    return instance

end



function Runtime:Destroy()

    if self.Destroyed then return end

    self.Destroyed = true



    for _, connection in ipairs(self.Connections) do

        pcall(function()

            connection:Disconnect()

        end)

    end



    for _, instance in ipairs(self.Instances) do

        pcall(function()

            instance:Destroy()

        end)

    end



    table.clear(self.Connections)

    table.clear(self.Instances)

end



--============================================================

-- SETTINGS

--============================================================



local Settings = {

    Main = {

        Crosshair = false,

        CrosshairRGB = false,

        CrosshairSize = 8,

        CrosshairGap = 5,

        CrosshairThickness = 2,

        CrosshairColor = Color3.fromRGB(255, 255, 255),

    },



    Player = {

        WalkSpeed = 16,

        JumpPower = 50,

        InfiniteJump = false,

        ESP = false,

        ESPNames = true,

        ESPDistance = true,

        ESPMaxDistance = 1500,

        ESPColor = Color3.fromRGB(150, 100, 255),

    },



    Scooter = {

        SpeedEnabled = false,

        Speed = 70,




        Fly = false,

        FlySpeed = 80,




        Noclip = false,



        Spin = false,

        SpinSpeed = 360,

        SpinDirection = "Clockwise",



        AutoWheelie = false,

        WheelieAngle = 18,

    },



    ScooterVisuals = {

        BodyEnabled = false,

        BodyColor = Color3.fromRGB(255, 255, 255),



        FrameEnabled = false,

        FrameColor = Color3.fromRGB(255, 255, 255),



        DeckEnabled = false,

        DeckColor = Color3.fromRGB(255, 255, 255),



        LightsEnabled = false,

        LightsColor = Color3.fromRGB(0, 170, 255),



        Glow = false,

        GlowColor = Color3.fromRGB(0, 170, 255),
        UseMaterial = false,
        Material = "Neon",
        Reflectance = 0,
        Transparency = 0,
        Rainbow = false,
        RainbowSpeed = 0.5,

    },



    Halloween = {

        PumpkinESP = false,

        PumpkinColor = Color3.fromRGB(255, 140, 35),

        PumpkinDistance = true,

        PumpkinMaxDistance = 2000,



        BoardTimer = false,

    },



    Preview = {

        Enabled = false,

        Target = "PumpkinNight",

        Spin = true,

        SpinSpeed = 24,

    },

}



--============================================================

-- HELPERS

--============================================================



local function GetCharacter()

    return LocalPlayer.Character

end



local function GetHumanoid(character)

    character = character or GetCharacter()

    return character and character:FindFirstChildOfClass("Humanoid")

end



local function GetRoot(character)

    character = character or GetCharacter()

    return character and character:FindFirstChild("HumanoidRootPart")

end



local function SafeDestroy(instance)

    if instance then

        pcall(function()

            instance:Destroy()

        end)

    end

end



local function AddConnection(connection)

    table.insert(Runtime.Connections, connection)

    return connection

end



local function GetUIParent()

    local parent



    pcall(function()

        if gethui then

            parent = gethui()

        end

    end)



    return parent or game:GetService("CoreGui")

end



--============================================================

-- SCOOTER DETECTION

--============================================================



local ScooterNames = {

    ["Ausom L1"] = true,

    ["KuKirin G2 Master"] = true,

    ["Kukirin G2"] = true,

    ["Kukirin G2 Ultra"] = true,

    ["Kukirin G3 Pro"] = true,

    ["Kukirin G4"] = true,

}



local ScooterProfiles = {

    ["Ausom L1"] = {

        Root = "DriveRoot",

        Body = {"Body", "BackBumper", "BackFender", "FrontBumper"},

        Frame = {"FrontFork", "FrontSuspension", "BackSuspension", "DriveRoot"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },



    ["KuKirin G2 Master"] = {

        Root = "Frame",

        Body = {"Body", "BackBumper", "BackFender", "FrontFender", "FrontBumper"},

        Frame = {"Frame", "FrontFork", "FrontSuspension", "BackSuspension"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },



    ["Kukirin G2"] = {

        Root = "Frame",

        Body = {"Body", "BackBumper", "BackFender", "FrontBumper"},

        Frame = {"Frame", "FrontFork", "FrontSuspension", "BackSuspension"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },



    ["Kukirin G2 Ultra"] = {

        Root = "Frame",

        Body = {"Body", "BackBumper", "BackFender", "FrontBumper"},

        Frame = {"Frame", "FrontForkModel", "FrontSuspension", "BackSuspension"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },



    ["Kukirin G3 Pro"] = {

        Root = "Frame",

        Body = {"Body", "BackBumper", "BackFender", "FrontBumper"},

        Frame = {"Frame", "FrontFork", "FrontSuspension", "BackSuspension"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },



    ["Kukirin G4"] = {

        Root = "Frame",

        Body = {"Body", "BackBumper", "BackFender", "VisualBackFender", "FrontBumper"},

        Frame = {"Frame", "FrontForkModel", "FrontSuspension", "BackSuspension"},

        Deck = {"DeckHitbox"},

        Lights = {"HeadLight", "TailLight"},

    },

}



local ScooterNamesList = {

    "Ausom L1",

    "KuKirin G2 Master",

    "Kukirin G2",

    "Kukirin G2 Ultra",

    "Kukirin G3 Pro",

    "Kukirin G4",

}



local CachedScooter

local ScooterScanClock = 0



local function FindScooterRoot(model)

    if not model then return nil end

    if model:IsA("BasePart") then return model end



    local profile = ScooterProfiles[model.Name]

    if profile and profile.Root then

        local part = model:FindFirstChild(profile.Root, true)

        if part and part:IsA("BasePart") then

            return part

        end

    end



    if model:IsA("Model") and model.PrimaryPart then

        return model.PrimaryPart

    end



    for _, name in ipairs({

        "DriveRoot", "Chassis", "Root", "Frame", "Body", "DeckHitbox",

    }) do

        local part = model:FindFirstChild(name, true)

        if part and part:IsA("BasePart") then

            return part

        end

    end



    return model:FindFirstChildWhichIsA("BasePart", true)

end



local function GetScooter()

    local character = GetCharacter()

    local humanoid = GetHumanoid(character)



    if character then

        for _, child in ipairs(character:GetChildren()) do

            if child:IsA("Model") and ScooterNames[child.Name] then

                return child

            end

        end

    end



    if humanoid and humanoid.SeatPart then

        local current = humanoid.SeatPart



        for _ = 1, 8 do

            if not current then break end



            if current:IsA("Model") and ScooterNames[current.Name] then

                return current

            end



            current = current.Parent

        end

    end



    if CachedScooter and CachedScooter.Parent then

        local root = FindScooterRoot(CachedScooter)

        local playerRoot = GetRoot(character)



        if root and playerRoot

            and (root.Position - playerRoot.Position).Magnitude < 60 then

            return CachedScooter

        end

    end



    -- Bounded-frequency discovery instead of a per-frame Workspace scan.

    local playerRoot = GetRoot(character)

    if not playerRoot then return nil end



    local nearest

    local nearestDistance = 35



    for _, object in ipairs(Workspace:GetDescendants()) do

        if object:IsA("Model") and ScooterNames[object.Name] then

            local root = FindScooterRoot(object)



            if root then

                local distance = (root.Position - playerRoot.Position).Magnitude



                if distance < nearestDistance then

                    nearest = object

                    nearestDistance = distance

                end

            end

        end

    end



    CachedScooter = nearest

    return nearest

end



local function IsUsingScooter(scooter)

    if not scooter then return false end



    local character = GetCharacter()

    if character and scooter:IsDescendantOf(character) then

        return true

    end



    local humanoid = GetHumanoid(character)

    local seat = humanoid and humanoid.SeatPart



    for _ = 1, 8 do

        if not seat then break end

        if seat == scooter then return true end

        seat = seat.Parent

    end



    -- Also permit nearby spawned scooters for local testing.

    local playerRoot = GetRoot(character)

    local scooterRoot = FindScooterRoot(scooter)



    return playerRoot and scooterRoot

        and (playerRoot.Position - scooterRoot.Position).Magnitude < 20

        or false

end



--============================================================

-- OBSIDIAN

--============================================================



local function LoadModule(url)

    return loadstring(game:HttpGet(url))()

end



local Library = LoadModule(

    "https\://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"

)



GEN.RideXHubLibrary = Library



local ThemeManager

local SaveManager



pcall(function()

    ThemeManager = LoadModule(

        "https\://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"

    )

end)



pcall(function()

    SaveManager = LoadModule(

        "https\://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"

    )

end)



pcall(function()

    Library:SetWatermark("RideXHub | Dev")

    Library:SetWatermarkVisibility(true)

end)



local Window = Library:CreateWindow({

    Title = "RideXHub",

    Footer = "Dev",

    ToggleKeybind = Enum.KeyCode.RightControl,

    Center = true,

    AutoShow = true,

    Resizable = true,

})



local Tabs = {

    Main = Window:AddTab("Main", "house"),

    Player = Window:AddTab("Player", "user"),

    Scooter = Window:AddTab("Scooter", "bike"),

    ScooterVisuals = Window:AddTab("Scooter Visuals", "palette"),

    Halloween = Window:AddTab("Halloween", "ghost"),

    Preview = Window:AddTab("Preview", "eye"),

    Settings = Window:AddTab("Settings", "settings"),

}



--============================================================

-- MAIN: CROSSHAIR

--============================================================



local CrosshairBox = Tabs.Main:AddLeftGroupbox("Crosshair")



local CrosshairGui = Instance.new("ScreenGui")

CrosshairGui.Name = "RideXHubCrosshair"

CrosshairGui.IgnoreGuiInset = true

CrosshairGui.ResetOnSpawn = false

CrosshairGui.Enabled = false

CrosshairGui.Parent = GetUIParent()

Runtime:Track(CrosshairGui)



local CrosshairRoot = Instance.new("Frame")

CrosshairRoot.Name = "Crosshair"

CrosshairRoot.AnchorPoint = Vector2.new(0.5, 0.5)

CrosshairRoot.Position = UDim2.fromScale(0.5, 0.5)

CrosshairRoot.Size = UDim2.fromOffset(100, 100)

CrosshairRoot.BackgroundTransparency = 1

CrosshairRoot.Parent = CrosshairGui



local CrosshairParts = {}



for _, name in ipairs({"Top", "Bottom", "Left", "Right"}) do

    local part = Instance.new("Frame")

    part.Name = name

    part.BorderSizePixel = 0

    part.AnchorPoint = Vector2.new(0.5, 0.5)

    part.Parent = CrosshairRoot

    CrosshairParts[name] = part

end



local function UpdateCrosshair()

    local cfg = Settings.Main

    CrosshairGui.Enabled = cfg.Crosshair



    if not cfg.Crosshair then return end



    local color = cfg.CrosshairColor



    if cfg.CrosshairRGB then

        color = Color3.fromHSV((os.clock() * 0.15) % 1, 1, 1)

    end



    local size = cfg.CrosshairSize

    local gap = cfg.CrosshairGap

    local thickness = cfg.CrosshairThickness



    CrosshairParts.Top.Size = UDim2.fromOffset(thickness, size)

    CrosshairParts.Bottom.Size = UDim2.fromOffset(thickness, size)

    CrosshairParts.Left.Size = UDim2.fromOffset(size, thickness)

    CrosshairParts.Right.Size = UDim2.fromOffset(size, thickness)



    CrosshairParts.Top.Position = UDim2.fromOffset(50, 50 - gap - size / 2)

    CrosshairParts.Bottom.Position = UDim2.fromOffset(50, 50 + gap + size / 2)

    CrosshairParts.Left.Position = UDim2.fromOffset(50 - gap - size / 2, 50)

    CrosshairParts.Right.Position = UDim2.fromOffset(50 + gap + size / 2, 50)



    for _, part in pairs(CrosshairParts) do

        part.BackgroundColor3 = color

    end

end



CrosshairBox:AddToggle("CrosshairEnabled", {

    Text = "Crosshair",

    Default = false,

    Callback = function(value)

        Settings.Main.Crosshair = value

        CrosshairGui.Enabled = value

    end,

})



CrosshairBox:AddToggle("CrosshairRGB", {

    Text = "RGB",

    Default = false,

    Callback = function(value)

        Settings.Main.CrosshairRGB = value

    end,

})



CrosshairBox:AddSlider("CrosshairSize", {

    Text = "Size",

    Default = 8,

    Min = 2,

    Max = 25,

    Rounding = 0,

    Callback = function(value)

        Settings.Main.CrosshairSize = value

    end,

})



CrosshairBox:AddSlider("CrosshairGap", {

    Text = "Gap",

    Default = 5,

    Min = 0,

    Max = 25,

    Rounding = 0,

    Callback = function(value)

        Settings.Main.CrosshairGap = value

    end,

})



CrosshairBox:AddSlider("CrosshairThickness", {

    Text = "Thickness",

    Default = 2,

    Min = 1,

    Max = 8,

    Rounding = 0,

    Callback = function(value)

        Settings.Main.CrosshairThickness = value

    end,

})



CrosshairBox:AddLabel("Color"):AddColorPicker("CrosshairColor", {

    Default = Settings.Main.CrosshairColor,

    Callback = function(value)

        Settings.Main.CrosshairColor = value

    end,

})



--============================================================

-- PLAYER: MOVEMENT + ESP

--============================================================



local PlayerMovementBox = Tabs.Player:AddLeftGroupbox("Movement")

local PlayerESPBox = Tabs.Player:AddRightGroupbox("Player ESP")



PlayerMovementBox:AddSlider("WalkSpeed", {

    Text = "Walk Speed",

    Default = 16,

    Min = 1,

    Max = 200,

    Rounding = 0,

    Callback = function(value)

        Settings.Player.WalkSpeed = value

    end,

})



PlayerMovementBox:AddSlider("JumpPower", {

    Text = "Jump Power",

    Default = 50,

    Min = 1,

    Max = 200,

    Rounding = 0,

    Callback = function(value)

        Settings.Player.JumpPower = value

    end,

})



PlayerMovementBox:AddToggle("InfiniteJump", {

    Text = "Infinite Jump",

    Default = false,

    Callback = function(value)

        Settings.Player.InfiniteJump = value

    end,

})



AddConnection(UserInputService.JumpRequest:Connect(function()

    if not Settings.Player.InfiniteJump then return end



    local humanoid = GetHumanoid()

    if humanoid then

        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    end

end))



local PlayerESPEntries = {}



local function RemovePlayerESP(player)

    local entry = PlayerESPEntries[player]

    if not entry then return end



    SafeDestroy(entry.Highlight)

    SafeDestroy(entry.Billboard)

    PlayerESPEntries[player] = nil

end



local function CreatePlayerESP(player, character)

    RemovePlayerESP(player)



    local root = GetRoot(character)

    if not root then return end



    local highlight = Instance.new("Highlight")

    highlight.Name = "RideXHubPlayerESP"

    highlight.Adornee = character

    highlight.FillColor = Settings.Player.ESPColor

    highlight.OutlineColor = Settings.Player.ESPColor

    highlight.FillTransparency = 0.8

    highlight.OutlineTransparency = 0

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent = character



    local billboard = Instance.new("BillboardGui")

    billboard.Name = "RideXHubPlayerLabel"

    billboard.Adornee = root

    billboard.Size = UDim2.fromOffset(180, 34)

    billboard.StudsOffset = Vector3.new(0, 3, 0)

    billboard.AlwaysOnTop = true

    billboard.Enabled = false

    billboard.Parent = GetUIParent()



    local label = Instance.new("TextLabel")

    label.Name = "Label"

    label.Size = UDim2.fromScale(1, 1)

    label.BackgroundTransparency = 1

    label.BorderSizePixel = 0

    label.Font = Enum.Font.GothamSemibold

    label.TextSize = 13

    label.TextColor3 = Settings.Player.ESPColor

    label.TextStrokeTransparency = 0.15

    label.TextStrokeColor3 = Color3.new(0, 0, 0)

    label.Parent = billboard



    PlayerESPEntries[player] = {

        Character = character,

        Highlight = highlight,

        Billboard = billboard,

        Label = label,

    }

end



local function RefreshPlayerESP()

    if not Settings.Player.ESP then

        for player in pairs(PlayerESPEntries) do

            RemovePlayerESP(player)

        end

        return

    end



    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer then

            local character = player.Character



            if character and character.Parent then

                local entry = PlayerESPEntries[player]



                if not entry or entry.Character ~= character then

                    CreatePlayerESP(player, character)

                end

            else

                RemovePlayerESP(player)

            end

        end

    end



    for player in pairs(PlayerESPEntries) do

        if not player.Parent then

            RemovePlayerESP(player)

        end

    end

end



PlayerESPBox:AddToggle("PlayerESP", {

    Text = "Player ESP",

    Default = false,

    Callback = function(value)

        Settings.Player.ESP = value

        if not value then

            RefreshPlayerESP()

        end

    end,

})



PlayerESPBox:AddToggle("PlayerESPNames", {

    Text = "Names",

    Default = true,

    Callback = function(value)

        Settings.Player.ESPNames = value

    end,

})



PlayerESPBox:AddToggle("PlayerESPDistance", {

    Text = "Distance",

    Default = true,

    Callback = function(value)

        Settings.Player.ESPDistance = value

    end,

})



PlayerESPBox:AddSlider("PlayerESPMaxDistance", {

    Text = "Max Distance",

    Default = 1500,

    Min = 100,

    Max = 5000,

    Rounding = 0,

    Callback = function(value)

        Settings.Player.ESPMaxDistance = value

    end,

})



PlayerESPBox:AddLabel("ESP Color"):AddColorPicker("PlayerESPColor", {

    Default = Settings.Player.ESPColor,

    Callback = function(value)

        Settings.Player.ESPColor = value



        for _, entry in pairs(PlayerESPEntries) do

            entry.Highlight.FillColor = value

            entry.Highlight.OutlineColor = value

            entry.Label.TextColor3 = value

        end

    end,

})



AddConnection(Players.PlayerRemoving:Connect(function(player)

    RemovePlayerESP(player)

end))



--============================================================

-- SCOOTER: SPEED / FLY / SPIN / WHEELIE

--============================================================



local ScooterMovementBox = Tabs.Scooter:AddLeftGroupbox("Movement")

local ScooterFlyBox = Tabs.Scooter:AddRightGroupbox("Fly")

local ScooterTricksBox = Tabs.Scooter:AddRightGroupbox("Tricks")



ScooterMovementBox:AddToggle("ScooterSpeedEnabled", {

    Text = "Speed",

    Default = false,

    Callback = function(value)

        Settings.Scooter.SpeedEnabled = value

    end,

})



ScooterMovementBox:AddSlider("ScooterSpeed", {

    Text = "Speed",

    Default = 70,

    Min = 10,

    Max = 500,

    Rounding = 0,

    Callback = function(value)

        Settings.Scooter.Speed = value

    end,

})






ScooterMovementBox:AddToggle("ScooterNoclip", {

    Text = "Noclip",

    Default = false,

    Callback = function(value)

        Settings.Scooter.Noclip = value

    end,

})



ScooterFlyBox:AddToggle("ScooterFly", {

    Text = "Fly",

    Default = false,

    Callback = function(value)

        Settings.Scooter.Fly = value

    end,

})



ScooterFlyBox:AddSlider("ScooterFlySpeed", {

    Text = "Fly Speed",

    Default = 80,

    Min = 10,

    Max = 300,

    Rounding = 0,

    Callback = function(value)

        Settings.Scooter.FlySpeed = value

    end,

})






ScooterTricksBox:AddToggle("ScooterSpin", {

    Text = "Spin",

    Default = false,

    Callback = function(value)

        Settings.Scooter.Spin = value

    end,

})



ScooterTricksBox:AddSlider("ScooterSpinSpeed", {

    Text = "Spin Speed",

    Default = 360,

    Min = 0,

    Max = 2160,

    Rounding = 0,

    Callback = function(value)

        Settings.Scooter.SpinSpeed = value

    end,

})



ScooterTricksBox:AddDropdown("ScooterSpinDirection", {

    Text = "Direction",

    Values = {"Clockwise", "Counter-clockwise"},

    Default = 1,

    Callback = function(value)

        Settings.Scooter.SpinDirection = value

    end,

})



ScooterTricksBox:AddToggle("ScooterAutoWheelie", {

    Text = "Auto Wheelie",

    Default = false,

    Callback = function(value)

        Settings.Scooter.AutoWheelie = value

    end,

})



ScooterTricksBox:AddSlider("ScooterWheelieAngle", {

    Text = "Wheelie Angle",

    Default = 18,

    Min = 0,

    Max = 45,

    Rounding = 0,

    Callback = function(value)

        Settings.Scooter.WheelieAngle = value

    end,

})



--============================================================

-- SCOOTER VISUALS

--============================================================



local ScooterColorsBox = Tabs.ScooterVisuals:AddLeftGroupbox("Colors")

local ScooterGlowBox = Tabs.ScooterVisuals:AddRightGroupbox("Glow")



local OriginalPartProperties = setmetatable({}, {__mode = "k"})

local CurrentScooterHighlight



local function GetProfileParts(scooter, names)

    local parts = {}

    local seen = {}



    if not scooter then return parts end



    for _, name in ipairs(names or {}) do

        local object = scooter:FindFirstChild(name, true)



        if object then

            if object:IsA("BasePart") and not seen[object] then

                seen[object] = true

                table.insert(parts, object)

            else

                for _, descendant in ipairs(object:GetDescendants()) do

                    if descendant:IsA("BasePart") and not seen[descendant] then

                        seen[descendant] = true

                        table.insert(parts, descendant)

                    end

                end

            end

        end

    end



    return parts

end



local function ApplyPartColors()

    local scooter = GetScooter()

    if not scooter then return end



    local profile = ScooterProfiles[scooter.Name]

    if not profile then return end



    local categories = {

        {"Body", "BodyEnabled", "BodyColor"},

        {"Frame", "FrameEnabled", "FrameColor"},

        {"Deck", "DeckEnabled", "DeckColor"},

        {"Lights", "LightsEnabled", "LightsColor"},

    }



    for _, category in ipairs(categories) do

        local names = profile[category[1]]

        local enabled = Settings.ScooterVisuals[category[2]]

        local color = Settings.ScooterVisuals[category[3]]
        if Settings.ScooterVisuals.Rainbow then
            color = Color3.fromHSV((os.clock() * Settings.ScooterVisuals.RainbowSpeed) % 1, 0.9, 1)
        end



        for _, part in ipairs(GetProfileParts(scooter, names)) do

            if not OriginalPartProperties[part] then

                OriginalPartProperties[part] = {
                    Color = part.Color,
                    Material = part.Material,
                    Reflectance = part.Reflectance,
                    Transparency = part.Transparency,
                }

            end



            if enabled then
                part.Color = color
                if Settings.ScooterVisuals.UseMaterial then
                    local chosenMaterial = Enum.Material[Settings.ScooterVisuals.Material]
                    if chosenMaterial then part.Material = chosenMaterial end
                else
                    part.Material = OriginalPartProperties[part].Material
                end
                part.Reflectance = Settings.ScooterVisuals.Reflectance
                part.Transparency = Settings.ScooterVisuals.Transparency
            else
                local original = OriginalPartProperties[part]
                part.Color = original.Color
                part.Material = original.Material
                part.Reflectance = original.Reflectance or 0
                part.Transparency = original.Transparency or 0
            end

        end

    end



    SafeDestroy(CurrentScooterHighlight)

    CurrentScooterHighlight = nil



    if Settings.ScooterVisuals.Glow then

        local highlight = Instance.new("Highlight")

        highlight.Name = "RideXHubScooterGlow"

        highlight.Adornee = scooter

        local glowColor = Settings.ScooterVisuals.GlowColor
        if Settings.ScooterVisuals.Rainbow then
            glowColor = Color3.fromHSV((os.clock() * Settings.ScooterVisuals.RainbowSpeed) % 1, 0.9, 1)
        end
        highlight.FillColor = glowColor
        highlight.OutlineColor = glowColor

        highlight.FillTransparency = 0.5

        highlight.OutlineTransparency = 0.05

        highlight.DepthMode = Enum.HighlightDepthMode.Occluded

        highlight.Parent = scooter

        CurrentScooterHighlight = highlight

    end

end



ScooterColorsBox:AddToggle("ScooterBodyColor", {

    Text = "Body",

    Default = false,

    Callback = function(value)

        Settings.ScooterVisuals.BodyEnabled = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddLabel("Body"):AddColorPicker("ScooterBodyColorPicker", {

    Default = Settings.ScooterVisuals.BodyColor,

    Callback = function(value)

        Settings.ScooterVisuals.BodyColor = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddToggle("ScooterFrameColor", {

    Text = "Frame",

    Default = false,

    Callback = function(value)

        Settings.ScooterVisuals.FrameEnabled = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddLabel("Frame"):AddColorPicker("ScooterFrameColorPicker", {

    Default = Settings.ScooterVisuals.FrameColor,

    Callback = function(value)

        Settings.ScooterVisuals.FrameColor = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddToggle("ScooterDeckColor", {

    Text = "Deck",

    Default = false,

    Callback = function(value)

        Settings.ScooterVisuals.DeckEnabled = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddLabel("Deck"):AddColorPicker("ScooterDeckColorPicker", {

    Default = Settings.ScooterVisuals.DeckColor,

    Callback = function(value)

        Settings.ScooterVisuals.DeckColor = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddToggle("ScooterLightsColor", {

    Text = "Lights",

    Default = false,

    Callback = function(value)

        Settings.ScooterVisuals.LightsEnabled = value

        ApplyPartColors()

    end,

})



ScooterColorsBox:AddLabel("Lights"):AddColorPicker("ScooterLightsColorPicker", {

    Default = Settings.ScooterVisuals.LightsColor,

    Callback = function(value)

        Settings.ScooterVisuals.LightsColor = value

        ApplyPartColors()

    end,

})



ScooterGlowBox:AddToggle("ScooterGlow", {

    Text = "Glow",

    Default = false,

    Callback = function(value)

        Settings.ScooterVisuals.Glow = value

        ApplyPartColors()

    end,

})



ScooterGlowBox:AddLabel("Glow"):AddColorPicker("ScooterGlowColor", {

    Default = Settings.ScooterVisuals.GlowColor,

    Callback = function(value)

        Settings.ScooterVisuals.GlowColor = value

        ApplyPartColors()

    end,

})



-- Extra scooter appearance controls. These apply only to profile parts that
-- are enabled in the Colors group, so the original scooter can be restored.
ScooterGlowBox:AddToggle("ScooterUseMaterial", {
    Text = "Custom Material",
    Default = false,
    Callback = function(value)
        Settings.ScooterVisuals.UseMaterial = value
        ApplyPartColors()
    end,
})

ScooterGlowBox:AddDropdown("ScooterMaterial", {
    Text = "Material",
    Values = {"Plastic", "SmoothPlastic", "Metal", "DiamondPlate", "Neon", "Glass", "ForceField"},
    Default = 5,
    Callback = function(value)
        Settings.ScooterVisuals.Material = value
        ApplyPartColors()
    end,
})

ScooterGlowBox:AddSlider("ScooterReflectance", {
    Text = "Reflectance",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(value)
        Settings.ScooterVisuals.Reflectance = value
        ApplyPartColors()
    end,
})

ScooterGlowBox:AddSlider("ScooterTransparency", {
    Text = "Part Transparency",
    Default = 0,
    Min = 0,
    Max = 0.8,
    Rounding = 2,
    Callback = function(value)
        Settings.ScooterVisuals.Transparency = value
        ApplyPartColors()
    end,
})

ScooterGlowBox:AddToggle("ScooterRainbow", {
    Text = "Rainbow Colors",
    Default = false,
    Callback = function(value)
        Settings.ScooterVisuals.Rainbow = value
        ApplyPartColors()
    end,
})

ScooterGlowBox:AddSlider("ScooterRainbowSpeed", {
    Text = "Rainbow Speed",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Callback = function(value)
        Settings.ScooterVisuals.RainbowSpeed = value
    end,
})

--============================================================

-- HALLOWEEN: PUMPKIN ESP

--============================================================



local HalloweenESPBox = Tabs.Halloween:AddLeftGroupbox("Pumpkin ESP")

local HalloweenBoardBox = Tabs.Halloween:AddRightGroupbox("Board Timer")



local PumpkinEntries = {}



local function IsModelInsideModel(model, root)

    local parent = model.Parent



    while parent and parent ~= root do

        if parent:IsA("Model") then

            return true

        end

        parent = parent.Parent

    end



    return false

end



local function FindPumpkinTargets()

    local root = Workspace:FindFirstChild("PumpkinNight")

    local targets = {}



    if not root then

        return targets

    end



    -- Only inspect the PumpkinNight hierarchy, never all Workspace descendants.

    for _, descendant in ipairs(root:GetDescendants()) do

        if descendant:IsA("Model") and not IsModelInsideModel(descendant, root) then

            table.insert(targets, descendant)

            if #targets >= 100 then break end

        end

    end



    if #targets == 0 then

        for _, descendant in ipairs(root:GetDescendants()) do

            if descendant:IsA("BasePart") then

                table.insert(targets, descendant)

                if #targets >= 100 then break end

            end

        end

    end



    return targets

end



local function GetTargetPart(target)

    if not target or not target.Parent then return nil end

    if target:IsA("BasePart") then return target end



    if target:IsA("Model") then

        if target.PrimaryPart then return target.PrimaryPart end

        return target:FindFirstChildWhichIsA("BasePart", true)

    end



    return nil

end



local function RemovePumpkinESP(target)

    local entry = PumpkinEntries[target]

    if not entry then return end



    SafeDestroy(entry.Highlight)

    SafeDestroy(entry.Billboard)

    PumpkinEntries[target] = nil

end



local function CreatePumpkinESP(target)

    local part = GetTargetPart(target)

    if not part then return end



    local highlight = Instance.new("Highlight")

    highlight.Name = "RideXHubPumpkinESP"

    highlight.Adornee = target

    highlight.FillColor = Settings.Halloween.PumpkinColor

    highlight.OutlineColor = Settings.Halloween.PumpkinColor

    highlight.FillTransparency = 0.65

    highlight.OutlineTransparency = 0

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent = target



    local billboard = Instance.new("BillboardGui")

    billboard.Name = "RideXHubPumpkinLabel"

    billboard.Adornee = part

    billboard.Size = UDim2.fromOffset(140, 24)

    billboard.StudsOffset = Vector3.new(0, 2.5, 0)

    billboard.AlwaysOnTop = true

    billboard.Enabled = false

    billboard.Parent = GetUIParent()



    local label = Instance.new("TextLabel")

    label.Name = "Label"

    label.Size = UDim2.fromScale(1, 1)

    label.BackgroundTransparency = 1

    label.BorderSizePixel = 0

    label.Font = Enum.Font.GothamSemibold

    label.TextSize = 13

    label.Text = "PumpkinNight"

    label.TextColor3 = Settings.Halloween.PumpkinColor

    label.TextStrokeTransparency = 0.15

    label.TextStrokeColor3 = Color3.new(0, 0, 0)

    label.Parent = billboard



    PumpkinEntries[target] = {

        Highlight = highlight,

        Billboard = billboard,

        Label = label,

    }

end



local function ClearPumpkinESP()

    for target in pairs(PumpkinEntries) do

        RemovePumpkinESP(target)

    end

end



local function RefreshPumpkinESP()

    if not Settings.Halloween.PumpkinESP then

        ClearPumpkinESP()

        return

    end



    local found = {}



    for _, target in ipairs(FindPumpkinTargets()) do

        found[target] = true



        if not PumpkinEntries[target] then

            CreatePumpkinESP(target)

        end

    end



    for target in pairs(PumpkinEntries) do

        if not found[target] or not target.Parent then

            RemovePumpkinESP(target)

        end

    end

end



HalloweenESPBox:AddToggle("PumpkinESP", {

    Text = "Pumpkin ESP",

    Default = false,

    Callback = function(value)

        Settings.Halloween.PumpkinESP = value

        if not value then ClearPumpkinESP() end

    end,

})



HalloweenESPBox:AddToggle("PumpkinDistance", {

    Text = "Distance",

    Default = true,

    Callback = function(value)

        Settings.Halloween.PumpkinDistance = value

    end,

})



HalloweenESPBox:AddSlider("PumpkinMaxDistance", {

    Text = "Max Distance",

    Default = 2000,

    Min = 100,

    Max = 5000,

    Rounding = 0,

    Callback = function(value)

        Settings.Halloween.PumpkinMaxDistance = value

    end,

})



HalloweenESPBox:AddLabel("Color"):AddColorPicker("PumpkinESPColor", {

    Default = Settings.Halloween.PumpkinColor,

    Callback = function(value)

        Settings.Halloween.PumpkinColor = value



        for _, entry in pairs(PumpkinEntries) do

            entry.Highlight.FillColor = value

            entry.Highlight.OutlineColor = value

            entry.Label.TextColor3 = value

        end

    end,

})



--============================================================

-- HALLOWEEN: BOARD TIMER

--============================================================



local TimerLabel = HalloweenBoardBox:AddLabel("Timer")

local SubtitleLabel = HalloweenBoardBox:AddLabel("Subtitle")

local PumpkinOneLabel = HalloweenBoardBox:AddLabel("Pumpkin 1")

local PumpkinTwoLabel = HalloweenBoardBox:AddLabel("Pumpkin 2")

local HeaderLabel = HalloweenBoardBox:AddLabel("Header")

local StatusLabel = HalloweenBoardBox:AddLabel("Status")



HalloweenBoardBox:AddToggle("HalloweenBoardTimer", {

    Text = "Read Halloween Board",

    Default = false,

    Callback = function(value)

        Settings.Halloween.BoardTimer = value

    end,

})



local function FindPath(root, names)

    local current = root



    for _, name in ipairs(names) do

        if not current then return nil end

        current = current:FindFirstChild(name)

    end



    return current

end



local function ReadText(root, names)

    local object = FindPath(root, names)

    if not object then return "--" end



    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then

        return object.Text

    end



    return "--"

end



local function UpdateHalloweenBoard()

    if not Settings.Halloween.BoardTimer then return end



    local board = Workspace:FindFirstChild("HalloweenBoard")

    if not board then

        TimerLabel:SetText("Timer: --")

        SubtitleLabel:SetText("Subtitle: --")

        PumpkinOneLabel:SetText("Pumpkin 1: --")

        PumpkinTwoLabel:SetText("Pumpkin 2: --")

        HeaderLabel:SetText("Header: --")

        StatusLabel:SetText("Status: --")

        return

    end



    local timer = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "Shell", "Timer",

    })



    local subtitle = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "Shell", "Subtitle",

    })



    local pumpkinOne = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "Shell", "Pumpkin-1",

    })



    local pumpkinTwo = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "Shell", "Pumpkin1",

    })



    local header = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "HeaderArt", "Title",

    })



    local status = ReadText(board, {

        "Screen", "HalloweenSurface", "Background", "Strip", "Status",

    })



    TimerLabel:SetText("Timer: " .. timer)

    SubtitleLabel:SetText("Subtitle: " .. subtitle)

    PumpkinOneLabel:SetText("Pumpkin-1: " .. pumpkinOne)

    PumpkinTwoLabel:SetText("Pumpkin1: " .. pumpkinTwo)

    HeaderLabel:SetText("Header: " .. header)

    StatusLabel:SetText("Status: " .. status)

end



--============================================================

-- PREVIEW: NATIVE OBSIDIAN VIEWPORT

--============================================================



local PreviewBox = Tabs.Preview:AddLeftGroupbox("ESP Preview")

local PreviewSettingsBox = Tabs.Preview:AddRightGroupbox("Preview Settings")



local Placeholder = Instance.new("Model")

Placeholder.Name = "PreviewPlaceholder"



local PlaceholderPart = Instance.new("Part")

PlaceholderPart.Name = "PreviewObject"

PlaceholderPart.Size = Vector3.new(2, 2, 2)

PlaceholderPart.Anchored = true

PlaceholderPart.CanCollide = false

PlaceholderPart.Material = Enum.Material.Neon

PlaceholderPart.Color = Color3.fromRGB(125, 85, 255)

PlaceholderPart.Parent = Placeholder



local PreviewViewport = PreviewBox:AddViewport("ESPModelPreview", {

    Object = Placeholder,

    Clone = true,

    Height = 260,

    AutoFocus = true,

    Interactive = true,

})



SafeDestroy(Placeholder)



local PreviewNotice = PreviewBox:AddLabel("")



local PreviewSource

local PreviewBasePivot

local PreviewAngle = 0

local PreviewRefreshClock = 0



local function FindPreviewTarget()

    local targetType = Settings.Preview.Target



    if targetType == "PumpkinNight" then

        local targets = FindPumpkinTargets()

        return targets[1]

    elseif targetType == "Police" then

        local folder = Workspace:FindFirstChild("Police")

        if folder then

            for _, child in ipairs(folder:GetChildren()) do

                if child:IsA("Model") then

                    return child

                end

            end

        end



        for _, child in ipairs(Workspace:GetChildren()) do

            if child:IsA("Model") then

                local name = child.Name:lower()

                if name:find("police", 1, true)

                    or name:find("cop", 1, true)

                    or name:find("sheriff", 1, true) then

                    return child

                end

            end

        end

    elseif targetType == "Player" then

        for _, player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer and player.Character then

                return player.Character

            end

        end

    end



    return nil

end



local function RemoveScriptsFromClone(model)

    for _, descendant in ipairs(model:GetDescendants()) do

        if descendant:IsA("Script")

            or descendant:IsA("LocalScript")

            or descendant:IsA("ModuleScript") then

            descendant:Destroy()

        elseif descendant:IsA("BasePart") then

            descendant.Anchored = true

            descendant.CanCollide = false

            descendant.CanTouch = false

            descendant.CanQuery = false

        end

    end

end



local function LoadPreviewModel()

    if not Settings.Preview.Enabled then

        PreviewSource = nil

        PreviewBasePivot = nil

        return

    end



    local source = FindPreviewTarget()



    if not source then

        PreviewSource = nil

        PreviewNotice:SetText("")

        return

    end



    if source == PreviewSource then return end

    PreviewSource = source



    local success, clone = pcall(function()

        return source:Clone()

    end)



    if not success or not clone then return end



    RemoveScriptsFromClone(clone)



    local oldPivot = clone:GetPivot()

    clone:PivotTo(CFrame.new(0, 0, 0) * (oldPivot - oldPivot.Position))



    local ok = pcall(function()

        PreviewViewport:SetObject(clone, false)

        PreviewViewport:Focus()

    end)



    if not ok then

        SafeDestroy(clone)

        return

    end



    -- The viewport owns the clone after SetObject.

    PreviewBasePivot = clone:GetPivot()

    PreviewAngle = 0

    PreviewNotice:SetText("")

end



PreviewSettingsBox:AddToggle("ESPPreviewEnabled", {

    Text = "Enable Preview",

    Default = false,

    Callback = function(value)

        Settings.Preview.Enabled = value

        PreviewSource = nil



        if value then

            LoadPreviewModel()

        else

            PreviewSource = nil

            PreviewBasePivot = nil

        end

    end,

})



PreviewSettingsBox:AddDropdown("ESPPreviewTarget", {

    Text = "ESP Target",

    Values = {"PumpkinNight", "Police", "Player"},

    Default = 1,

    Callback = function(value)

        Settings.Preview.Target = value

        PreviewSource = nil



        if Settings.Preview.Enabled then

            LoadPreviewModel()

        end

    end,

})



PreviewSettingsBox:AddToggle("ESPPreviewSpin", {

    Text = "Rotate Model",

    Default = true,

    Callback = function(value)

        Settings.Preview.Spin = value

    end,

})



PreviewSettingsBox:AddSlider("ESPPreviewSpinSpeed", {

    Text = "Rotation Speed",

    Default = 24,

    Min = 0,

    Max = 180,

    Rounding = 0,

    Callback = function(value)

        Settings.Preview.SpinSpeed = value

    end,

})



PreviewSettingsBox:AddButton({

    Text = "Refresh Preview",

    Func = function()

        PreviewSource = nil

        LoadPreviewModel()

    end,

})



--============================================================

-- SETTINGS / CONFIG MANAGERS

--============================================================



if ThemeManager and SaveManager then

    pcall(function()

        ThemeManager:SetLibrary(Library)

        SaveManager:SetLibrary(Library)

        SaveManager:IgnoreThemeSettings()

        SaveManager:SetIgnoreIndexes({})

        SaveManager:SetFolder("RideXHub")

        ThemeManager:SetFolder("RideXHub")

        SaveManager:BuildConfigSection(Tabs.Settings)

        ThemeManager:ApplyToTab(Tabs.Settings)

        SaveManager:LoadAutoloadConfig()

    end)

end




local Cleanup
local RideXSettingsBox = Tabs.Settings:AddLeftGroupbox("RideXHub")
RideXSettingsBox:AddButton({
    Text = "Unload RideXHub",
    Func = function()
        pcall(Cleanup)
        pcall(function() Library:Unload() end)
    end,
})
RideXSettingsBox:AddButton({
    Text = "Restore Scooter Visuals",
    Func = function()
        for part, properties in pairs(OriginalPartProperties) do
            if part and part.Parent then
                pcall(function()
                    part.Color = properties.Color
                    part.Material = properties.Material
                    part.Reflectance = properties.Reflectance or 0
                    part.Transparency = properties.Transparency or 0
                end)
            end
        end
        Settings.ScooterVisuals.BodyEnabled = false
        Settings.ScooterVisuals.FrameEnabled = false
        Settings.ScooterVisuals.DeckEnabled = false
        Settings.ScooterVisuals.LightsEnabled = false
        Settings.ScooterVisuals.Glow = false
        SafeDestroy(CurrentScooterHighlight)
        CurrentScooterHighlight = nil
    end,
})


--============================================================

-- UPDATE LOOP

--============================================================



local slowTimer = 0

local visualTimer = 0

local lastScooter

local lastSpinState = false

local spinAngle = 0

local spinBaseRotation

local spinRoot

local originalCollisions = setmetatable({}, {__mode = "k"})

local lastFlyVelocity = Vector3.zero



local function RestoreNoclip()

    for part, original in pairs(originalCollisions) do

        if part and part.Parent then

            pcall(function()

                part.CanCollide = original

            end)

        end

    end



    table.clear(originalCollisions)

end



local function UpdateNoclip(scooter)

    if not Settings.Scooter.Noclip or not scooter then

        RestoreNoclip()

        return

    end



    for _, part in ipairs(scooter:GetDescendants()) do

        if part:IsA("BasePart") then

            if originalCollisions[part] == nil then

                originalCollisions[part] = part.CanCollide

            end



            part.CanCollide = false

        end

    end

end



local function UpdateScooterMotion(scooter, dt)
    if not scooter or not IsUsingScooter(scooter) then
        spinRoot = nil
        spinBaseRotation = nil
        spinAngle = 0
        lastSpinState = false
        return
    end

    local root = FindScooterRoot(scooter)
    if not root then return end

    local camera = Workspace.CurrentCamera
    dt = math.clamp(dt, 0, 1 / 20)

    if Settings.Scooter.SpeedEnabled and not Settings.Scooter.Fly then
        root.CFrame = root.CFrame + root.CFrame.LookVector * Settings.Scooter.Speed * dt
    end

    if Settings.Scooter.Fly and camera then
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
        if direction.Magnitude > 0 then
            root.CFrame = root.CFrame + direction.Unit * Settings.Scooter.FlySpeed * dt
        end
    end

    local shouldTransform = Settings.Scooter.Spin or Settings.Scooter.AutoWheelie
    if shouldTransform and scooter:IsA("Model") then
        if spinRoot ~= root or not spinBaseRotation then
            spinRoot = root
            local initialPivot = scooter:GetPivot()
            spinBaseRotation = initialPivot - initialPivot.Position
            spinAngle = 0
        end

        if Settings.Scooter.Spin then
            local sign = Settings.Scooter.SpinDirection == "Counter-clockwise" and -1 or 1
            spinAngle = (spinAngle + math.rad(Settings.Scooter.SpinSpeed) * dt * sign) % (math.pi * 2)
        elseif lastSpinState then
            spinAngle = 0
        end
        lastSpinState = Settings.Scooter.Spin

        -- Build one absolute rotation from the captured starting orientation,
        -- then PivotTo once. Two separate writes per frame were a major source
        -- of the spin/wheelie fighting each other and visibly shaking.
        local rotation = CFrame.Angles(0, spinAngle, 0) * spinBaseRotation
        if Settings.Scooter.AutoWheelie then
            rotation = rotation * CFrame.Angles(-math.rad(Settings.Scooter.WheelieAngle), 0, 0)
        end
        local pivot = scooter:GetPivot()
        scooter:PivotTo(CFrame.new(pivot.Position) * rotation)
    else
        spinRoot = nil
        spinBaseRotation = nil
        spinAngle = 0
        lastSpinState = false
    end
end

local function UpdateRainbowVisuals()
    if not Settings.ScooterVisuals.Rainbow then return end
    local scooter = GetScooter()
    if not scooter then return end
    local profile = ScooterProfiles[scooter.Name]
    if not profile then return end
    local color = Color3.fromHSV((os.clock() * Settings.ScooterVisuals.RainbowSpeed) % 1, 0.9, 1)
    for _, category in ipairs({
        {"Body", "BodyEnabled"}, {"Frame", "FrameEnabled"},
        {"Deck", "DeckEnabled"}, {"Lights", "LightsEnabled"},
    }) do
        if Settings.ScooterVisuals[category[2]] then
            for _, part in ipairs(GetProfileParts(scooter, profile[category[1]])) do
                if part and part.Parent then part.Color = color end
            end
        end
    end
    if CurrentScooterHighlight then
        CurrentScooterHighlight.FillColor = color
        CurrentScooterHighlight.OutlineColor = color
    end
end

local function UpdatePlayerESPLabels()

    if not Settings.Player.ESP then return end



    local localRoot = GetRoot()

    if not localRoot then return end



    for player, entry in pairs(PlayerESPEntries) do

        local character = player.Character

        local targetRoot = GetRoot(character)



        if not character or not targetRoot or entry.Character ~= character then

            RemovePlayerESP(player)

        else

            local distance = (targetRoot.Position - localRoot.Position).Magnitude

            local visible = distance <= Settings.Player.ESPMaxDistance



            entry.Billboard.Enabled = visible

            entry.Highlight.Enabled = visible



            local pieces = {}



            if Settings.Player.ESPNames then

                table.insert(pieces, player.DisplayName)

            end



            if Settings.Player.ESPDistance then

                table.insert(pieces, string.format("%dm", math.floor(distance)))

            end



            entry.Label.Text = table.concat(pieces, "  ")

        end

    end

end



local function UpdatePumpkinLabels()

    if not Settings.Halloween.PumpkinESP then return end



    local localRoot = GetRoot()

    if not localRoot then return end



    for target, entry in pairs(PumpkinEntries) do

        local targetPart = GetTargetPart(target)



        if not targetPart or not target.Parent then

            RemovePumpkinESP(target)

        else

            local distance = (targetPart.Position - localRoot.Position).Magnitude

            local visible = distance <= Settings.Halloween.PumpkinMaxDistance



            entry.Billboard.Enabled = visible

            entry.Highlight.Enabled = visible



            if Settings.Halloween.PumpkinDistance then

                entry.Label.Text = "PumpkinNight  " .. math.floor(distance) .. "m"

            else

                entry.Label.Text = "PumpkinNight"

            end

        end

    end

end



AddConnection(RunService.Heartbeat:Connect(function(dt)

    if Runtime.Destroyed then return end



    slowTimer += dt

    visualTimer += dt



    if slowTimer >= 1.5 then

        slowTimer = 0



        if Settings.Halloween.PumpkinESP then

            pcall(RefreshPumpkinESP)

        end



        if Settings.Player.ESP then

            pcall(RefreshPlayerESP)

        end



        local scooter = GetScooter()



        if scooter ~= lastScooter then

            lastScooter = scooter

            pcall(ApplyPartColors)

        end

    end



    if visualTimer >= 0.05 then

        local step = math.min(visualTimer, 0.1)

        visualTimer = 0



        UpdateCrosshair()
        pcall(UpdateRainbowVisuals)

        local humanoid = GetHumanoid()

        if humanoid then

            humanoid.WalkSpeed = Settings.Player.WalkSpeed



            pcall(function()

                humanoid.UseJumpPower = true

                humanoid.JumpPower = Settings.Player.JumpPower

            end)

        end



        local scooter = lastScooter



        if scooter and scooter.Parent then

            pcall(UpdateNoclip, scooter)

        else

            RestoreNoclip()

        end



        pcall(UpdatePlayerESPLabels)

        pcall(UpdatePumpkinLabels)



        -- Refresh the preview target infrequently, not every frame.

        PreviewRefreshClock += step



        if Settings.Preview.Enabled and PreviewRefreshClock >= 1.5 then

            PreviewRefreshClock = 0

            pcall(LoadPreviewModel)

        end



        -- Rotate only the model inside the ViewportFrame.

        if Settings.Preview.Enabled

            and Settings.Preview.Spin

            and PreviewViewport

            and PreviewViewport.Object

            and PreviewViewport.Object.Parent then



            local object = PreviewViewport.Object

            PreviewAngle = (PreviewAngle

                + math.rad(Settings.Preview.SpinSpeed) * step) % (math.pi * 2)



            local pivot = object:GetPivot()

            local position = pivot.Position



            object:PivotTo(

                CFrame.new(position)

                * CFrame.Angles(0, math.rad(Settings.Preview.SpinSpeed) * step, 0)

                * (pivot - position)

            )

        end

    end

end))



-- Run scooter transforms immediately before physics simulation instead of
-- at the slower UI refresh rate. This reduces visible frame stepping.
AddConnection(RunService.PreSimulation:Connect(function(dt)
    if Runtime.Destroyed then return end
    scooterDiscoveryClock += dt
    if (not lastScooter or not lastScooter.Parent) and scooterDiscoveryClock >= 0.25 then
        scooterDiscoveryClock = 0
        lastScooter = GetScooter()
    end
    local scooter = lastScooter
    if scooter and scooter.Parent then
        pcall(UpdateScooterMotion, scooter, dt)
        pcall(UpdateNoclip, scooter)
    else
        RestoreNoclip()
    end
end))

-- Board text only updates while its toggle is enabled.


local boardClock = 0



AddConnection(RunService.Heartbeat:Connect(function(dt)

    if not Settings.Halloween.BoardTimer then return end



    boardClock += dt



    if boardClock >= 1 then

        boardClock = 0

        pcall(UpdateHalloweenBoard)

    end

end))



--============================================================

-- CLEANUP

--============================================================



Cleanup = function()

    if Runtime.Destroyed then return end



    Settings.Scooter.Fly = false

    Settings.Scooter.Spin = false

    Settings.Scooter.SpeedEnabled = false



    ClearPumpkinESP()



    for player in pairs(PlayerESPEntries) do

        RemovePlayerESP(player)

    end



    RestoreNoclip()



    for part, properties in pairs(OriginalPartProperties) do

        if part and part.Parent then

            pcall(function()

                part.Color = properties.Color

                part.Material = properties.Material
                part.Reflectance = properties.Reflectance or 0
                part.Transparency = properties.Transparency or 0

            end)

        end

    end



    SafeDestroy(CurrentScooterHighlight)



    Runtime:Destroy()

end



pcall(function()

    Library:OnUnload(Cleanup)

end)



print("[RideXHub] Obsidian edition loaded.")