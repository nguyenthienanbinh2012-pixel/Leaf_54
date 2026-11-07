local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

Library.Scheme.AccentColor = Color3.fromRGB(50, 205, 50)
if Library.UpdateColors then Library:UpdateColors() end

local Toggles = Library.Toggles
local Options = Library.Options

local Window = Library:CreateWindow({
    Title = "🌿 Leaf Hub",
    Footer = "obsidian-ui",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
    TabPadding = 3,
    MenuFadeTime = 0,
    CornerRadius = 6,
})

-- ============================================================
-- TAB MAIN (trước Protect)
-- ============================================================
local MainTab = Window:AddTab("Main", "cpu")
local GroupMainRight = MainTab:AddRightGroupbox("Games", "gamepad-2")
local GroupMainLeft = MainTab:AddLeftGroupbox("Exploits", "wrench")

-- ============================================================
-- TAB CHARACTER STATS
-- ============================================================
local Tab = Window:AddTab("Character Stats", "user")
local GroupCharacter = Tab:AddLeftGroupbox("Character", "footprints")
local GroupCollide   = Tab:AddLeftGroupbox("Collide", "package")

-- ============================================================
-- TAB PROTECT
-- ============================================================
local ProtectTab = Window:AddTab("Protect", "shield")
local GroupIntervention = ProtectTab:AddRightGroupbox("Deep Intervention", "person-standing")

-- ============================================================
-- TOGGLES MAIN TAB
-- ============================================================
GroupMainRight:AddToggle("AntiCheatBypass", {
    Text = "Anti-Cheat Bypass",
    Default = false,
    Tooltip = "Bypass anticheat khi tương tác với Thang, cho phép xuyên tường/chạy nhảy không bị phát hiện.",
})
GroupMainRight:AddToggle("PositionSpoof", {
    Text = "Position Spoof",
    Default = false,
    Tooltip = "Ẩn bản thân khỏi entity tấn công.",
})
GroupMainRight:AddDropdown("PositionSpoofMode", {
    Values = { "Always On", "Only When Entity" },
    Default = 1,
    Text = "Spoof Mode",
})
GroupMainRight:AddToggle("SemiGodMode", {
    Text = "Semi God Mode",
    Default = false,
    Tooltip = "Bypass tất cả entity nguy hiểm: Screech, Timothy, A-90, Glitch, Halt, Dread, Banana, Dupe, Gloombat Eggs.",
})

-- ============================================================
-- CHARACTER TOGGLES
-- ============================================================
GroupCharacter:AddSlider("SpeedBoostSlider", {
    Text = "Speed Boost", Min = 1, Max = 125, Default = 1, Rounding = 0, Compact = true,
})
GroupCharacter:AddToggle("SpeedBoostToggle", {
    Text = "Enable Speed Boost", Default = false,
    Tooltip = "Increases your walkspeed by the specified amount.",
})
GroupCharacter:AddToggle("SkipAcceleration", {
    Text = "Skip Acceleration", Default = false,
    Tooltip = "Removes the acceleration delay from speed boost.",
})
GroupCharacter:AddToggle("SkipRunAnimation", {
    Text = "Skip Run Animation", Default = false,
    Tooltip = "Skips the running acceleration animation.",
})
GroupCharacter:AddToggle("EnableCharacterJump", {
    Text = "Allow Jumping", Default = false, Tooltip = "Allows your character to jump.",
})
GroupCharacter:AddToggle("EnableCharacterSlide", {
    Text = "Allow Sliding", Default = false, Tooltip = "Allows your character to slide.",
})
GroupCharacter:AddToggle("InfiniteJumps", {
    Text = "Infinite Jumps", Default = false, Tooltip = "Allows you to jump while in the air.",
})
GroupCharacter:AddToggle("Fly", {
    Text = "Fly", Default = false, Tooltip = "Allows you to freely fly around the map.",
})
GroupCharacter:AddSlider("FlySpeed", {
    Text = "Fly Speed", Min = 1, Max = 200, Default = 50, Rounding = 0, Compact = true,
})
GroupCharacter:AddToggle("FakeSitting", {
    Text = "Fake Sitting", Default = false,
    Tooltip = "Creates a virtual seat, forces character to sit instantly, anchors, allows movement while seated.",
})
GroupCollide:AddToggle("NoClip", {
    Text = "No Clip", Default = false,
    Tooltip = "Disables collision for your character and all collision parts.",
})
GroupCollide:AddToggle("VelocityMove", {
    Text = "Velocity Move", Default = false, Tooltip = "Slowly moves your character forward.",
})
GroupCollide:AddToggle("DeleteCollisionBlock", {
    Text = "Delete Collision Block", Default = false,
    Tooltip = "Disables collision for all parts within 10 studs of your character.",
})

GroupIntervention:AddToggle("DeleteFigureFE", {
    Text = "Delete Figure FE", Default = false,
    Tooltip = "Multi-layer Figure deletion: FE network owner + sit anchor + grind loop.",
})
GroupIntervention:AddToggle("FigureGodmode", {
    Text = "Figure Godmode", Default = false,
    Tooltip = "Lifts collision part when Figure is nearby.",
})
GroupIntervention:AddToggle("DestroyJeff", {
    Text = "Destroy Jeff", Default = false,
    Tooltip = "Multi-layer Jeff deletion: anchor + sit + BodyGyro + grind.",
})

-- ============================================================
-- MÀU
-- ============================================================
local function PaintColor(name, color)
    local t = Options and Options[name] or (Toggles and Toggles[name])
    if not t then return end
    local label = t.TextLabel or t.Label or (t.Object and t.Object.TextLabel)
    if label and label:IsA("TextLabel") then
        local original = label.Text:gsub("<.->", "")
        label.RichText = true
        label.Text = string.format('<font color="%s">%s</font>', color, original)
    end
end

task.defer(function()
    task.wait(0.75)
    pcall(PaintColor, "FakeSitting", "#39FF14")
    pcall(PaintColor, "DeleteCollisionBlock", "#39FF14")
    pcall(PaintColor, "SkipAcceleration", "#39FF14")
    pcall(PaintColor, "SkipRunAnimation", "#39FF14")
    pcall(PaintColor, "SemiGodMode", "#39FF14")
    pcall(PaintColor, "DeleteFigureFE", "#FF2222")
    pcall(PaintColor, "FigureGodmode", "#FF2222")
    pcall(PaintColor, "DestroyJeff", "#FF2222")
    pcall(PaintColor, "AntiCheatBypass", "#FF2222")
    pcall(PaintColor, "PositionSpoof", "#FF2222")
end)

-- ============================================================
-- SERVICES & STATE
-- ============================================================
local Services = setmetatable({}, {
    __index = function(Self, Name) return game:GetService(Name) end
})

local LocalPlayer = Services.Players.LocalPlayer
local Character, Humanoid, RootPart, Camera
local CollisionModel, CollisionMainPart, CollisionCrouchPart
local CollisionClone, CollisionPartClone
local OldJump, OldSlide = false, false
local OldDefaultPhysics = nil

local Globals = {
    IsTyping = false,
    NoClipOldStates = {},
    DeletedCollisionParts = {},
    FakeSeat = nil,
    FakeSeatConnection = nil,
    DeleteCollisionConnection = nil,
    LastDeleteScan = 0,
    GodmodePart = nil,
    FlyVelocity = nil,
    FlyConnection = nil,
    DeleteFigureConnections = {},
    DestroyJeffConnections = {},
    RunAnimConnection = nil,
    AntiCheatConnections = {},
    SpoofConnection = nil,
    SemiGodConnections = {},
}

local Connections = {}
local Functions = {}

-- ============================================================
-- HELPERS
-- ============================================================
Functions.GetCollisionMainPart = function()
    if not Character then return nil end
    if CollisionMainPart and CollisionMainPart.Parent then return CollisionMainPart end
    local Col = Character:FindFirstChild("Collision")
    if Col then
        if Col:IsA("BasePart") then return Col end
        local P = Col:FindFirstChild("Collision")
        if P and P:IsA("BasePart") then return P end
        local AnyPart = Col:FindFirstChildWhichIsA("BasePart")
        if AnyPart then return AnyPart end
    end
    local CP = Character:FindFirstChild("CollisionPart")
    if CP and CP:IsA("BasePart") then return CP end
    return nil
end

Functions.IsCrouching = function()
    if not CollisionMainPart then return false end
    return CollisionMainPart.CollisionGroup == "PlayerCrouching"
end

Functions.GetInjuriesSpeed = function()
    if not Humanoid then return 0 end
    return 0.075 * (Humanoid.MaxHealth - Humanoid.Health)
end

Functions.GetCurrentSpeed = function()
    local LiveModifiers = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
    local Speed = 15
    if Character then
        Speed += Character:GetAttribute("SpeedBoost") or 0
        Speed += Character:GetAttribute("SpeedBoostBehind") or 0
        Speed += Character:GetAttribute("SpeedBoostExtra") or 0
    end
    if LiveModifiers then
        Speed += (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
        Speed += (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
        Speed += (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)
        Speed -= (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
        Speed -= (LiveModifiers:FindFirstChild("PlayerSlowHealth") and Functions.GetInjuriesSpeed() or 0)
    end
    if Functions.IsCrouching() then
        if LiveModifiers and LiveModifiers:FindFirstChild("PlayerCrouchSlow") then
            Speed -= 8
        elseif LiveModifiers and LiveModifiers:FindFirstChild("PlayerSlow") then
            Speed -= 8
        else
            Speed -= 5
        end
    end
    return Speed
end

Functions.GetValue = function(name)
    if Options and Options[name] then
        local ok, val = pcall(function() return Options[name].Value end)
        if ok and val ~= nil then return val end
    end
    if Toggles and Toggles[name] then
        local ok, val = pcall(function() return Toggles[name].Value end)
        if ok and val ~= nil then return val end
    end
    return false
end

Functions.GetSlider = function(name, default)
    if Options and Options[name] then
        local ok, val = pcall(function() return Options[name].Value end)
        if ok and val then return val end
    end
    return default or 0
end

-- ============================================================
-- SPEED BOOST
-- ============================================================
Functions.ApplySpeedBoost = function()
    if not Humanoid or not Humanoid.Parent then return end
    local Active = Functions.GetValue("SpeedBoostToggle")
    local SliderVal = Functions.GetSlider("SpeedBoostSlider", 1)
    local Target = Functions.GetCurrentSpeed() + (Active and SliderVal or 0)
    Humanoid.WalkSpeed = Target
    if Active and Target > 16 then
        Character:SetAttribute("SpeedBoost", Target - 15)
    end
end

-- ============================================================
-- SKIP ACCELERATION
-- ============================================================
Functions.ApplySkipAcceleration = function()
    if not Character or not RootPart then return end
    local Active = Functions.GetValue("SkipAcceleration")
    if Active then
        if not OldDefaultPhysics then
            OldDefaultPhysics = RootPart.CustomPhysicalProperties
        end
        local NewPhysics = PhysicalProperties.new(
            100,
            RootPart.CustomPhysicalProperties.Friction,
            RootPart.CustomPhysicalProperties.Elasticity,
            RootPart.CustomPhysicalProperties.FrictionWeight,
            RootPart.CustomPhysicalProperties.ElasticityWeight
        )
        for _, Part in Character:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.CustomPhysicalProperties = NewPhysics
            end
        end
    else
        if OldDefaultPhysics then
            for _, Part in Character:GetDescendants() do
                if Part:IsA("BasePart") then
                    Part.CustomPhysicalProperties = OldDefaultPhysics
                end
            end
        end
    end
end

-- ============================================================
-- SKIP RUN ANIMATION
-- ============================================================
Functions.ApplySkipRunAnimation = function()
    if Globals.RunAnimConnection then Globals.RunAnimConnection:Disconnect() Globals.RunAnimConnection = nil end
    if not Functions.GetValue("SkipRunAnimation") then return end
    Globals.RunAnimConnection = Services.RunService.RenderStepped:Connect(function()
        if not Humanoid or not Functions.GetValue("SkipRunAnimation") then return end
        for _, track in Humanoid:GetPlayingAnimationTracks() do
            local nameLower = track.Name:lower()
            if nameLower == "run" or nameLower:find("run") or nameLower:find("sprint") then
                pcall(function() track:Stop(0) end)
            end
        end
    end)
end

-- ============================================================
-- JUMP/SLIDE
-- ============================================================
Functions.ApplyJumpSlide = function()
    if not Character then return end
    local CanJump = Functions.GetValue("EnableCharacterJump")
    local CanSlide = Functions.GetValue("EnableCharacterSlide")
    Character:SetAttribute("CanJump", CanJump and true or OldJump)
    Character:SetAttribute("CanSlide", CanSlide and true or OldSlide)
end

-- ============================================================
-- NOCLIP
-- ============================================================
Functions.ApplyNoClip = function()
    if not Character then return end
    if Functions.GetValue("NoClip") then
        for _, Part in Character:GetDescendants() do
            if Part:IsA("BasePart") then
                if not Globals.NoClipOldStates[Part] then
                    Globals.NoClipOldStates[Part] = {
                        CanCollide = Part.CanCollide,
                        CanTouch = Part.CanTouch,
                    }
                end
                Part.CanCollide = false
                Part.CanTouch = false
            end
        end
    else
        for Part, State in Globals.NoClipOldStates do
            if Part and Part.Parent then
                Part.CanCollide = State.CanCollide
                Part.CanTouch = State.CanTouch
            end
        end
        Globals.NoClipOldStates = {}
    end
end

-- ============================================================
-- VELOCITY MOVE
-- ============================================================
Functions.ApplyVelocityMove = function()
    if not RootPart then return end
    if Functions.GetValue("VelocityMove") then
        local BV = RootPart:FindFirstChild("AbysallVelocity")
        if not BV then
            BV = Instance.new("BodyVelocity")
            BV.Name = "AbysallVelocity"
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BV.Parent = RootPart
        end
        BV.Velocity = RootPart.CFrame.LookVector * 2.25
    else
        local BV = RootPart:FindFirstChild("AbysallVelocity")
        if BV then BV:Destroy() end
    end
end

-- ============================================================
-- FLY — force mỗi frame, dùng MaxForce 1e10
-- ============================================================
Functions.ApplyFly = function()
    if not RootPart or not Humanoid then return end
    if Globals.FlyVelocity then Globals.FlyVelocity:Destroy() Globals.FlyVelocity = nil end
    if Globals.FlyConnection then Globals.FlyConnection:Disconnect() Globals.FlyConnection = nil end
    if Functions.GetValue("Fly") then
        local BV = Instance.new("BodyVelocity")
        BV.Name = "AbysallFly"
        BV.MaxForce = Vector3.new(1e10, 1e10, 1e10)
        BV.Velocity = Vector3.zero
        BV.Parent = RootPart
        Globals.FlyVelocity = BV
        Globals.FlyConnection = Services.RunService.RenderStepped:Connect(function()
            if not Functions.GetValue("Fly") or not RootPart or not Camera then return end
            Humanoid.PlatformStand = true
            local Speed = Functions.GetSlider("FlySpeed", 50)
            local Move = Humanoid.MoveDirection
            local Direction = Vector3.zero
            if Move.Magnitude > 0 then
                local Look = Camera.CFrame.LookVector
                local Right = Camera.CFrame.RightVector
                Direction = (Look * -Move.Z + Right * Move.X).Unit
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Direction += Vector3.new(0, 1, 0)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Direction -= Vector3.new(0, 1, 0)
            end
            Globals.FlyVelocity.Velocity = Direction * Speed
        end)
    else
        if Humanoid then Humanoid.PlatformStand = false end
    end
end

-- ============================================================
-- FAKE SITTING — Seat trong Workspace + force mỗi frame
-- ============================================================
Functions.ApplyFakeSitting = function()
    if Functions.GetValue("FakeSitting") then
        if not Character or not Humanoid or not RootPart then return end
        if Globals.FakeSeat and Globals.FakeSeat.Parent then return end

        local Seat = Instance.new("Seat")
        Seat.Name = "AbysallFakeSeat"
        Seat.Size = Vector3.new(2, 1, 2)
        Seat.Transparency = 1
        Seat.Anchored = true
        Seat.CanCollide = false
        Seat.CFrame = RootPart.CFrame * CFrame.new(0, -1.5, 0)
        Seat.Parent = Services.Workspace

        Humanoid.Sit = true
        RootPart.Anchored = true
        Globals.FakeSeat = Seat

        if Globals.FakeSeatConnection then Globals.FakeSeatConnection:Disconnect() end
        Globals.FakeSeatConnection = Services.RunService.RenderStepped:Connect(function()
            if not Functions.GetValue("FakeSitting") or not Globals.FakeSeat or not RootPart then return end
            if not Globals.FakeSeat.Parent then return end
            Humanoid.Sit = true
            local MoveDir = Humanoid.MoveDirection
            if MoveDir.Magnitude > 0 then
                RootPart.Anchored = false
                local Speed = Humanoid.WalkSpeed
                RootPart.CFrame = RootPart.CFrame + MoveDir * (Speed / 60)
            else
                RootPart.CFrame = Globals.FakeSeat.CFrame * CFrame.new(0, 1.5, 0)
                RootPart.Anchored = true
            end
            Globals.FakeSeat.CFrame = RootPart.CFrame * CFrame.new(0, -1.5, 0)
        end)
    else
        if Globals.FakeSeat then Globals.FakeSeat:Destroy() Globals.FakeSeat = nil end
        if Globals.FakeSeatConnection then Globals.FakeSeatConnection:Disconnect() Globals.FakeSeatConnection = nil end
        if Character and RootPart then
            RootPart.Anchored = false
            if Humanoid then Humanoid.Sit = false end
        end
    end
end

-- ============================================================
-- DELETE COLLISION BLOCK — quét Workspace, check sàn = Size.Y < 1
-- ============================================================
Functions.ApplyDeleteCollisionBlock = function()
    if Functions.GetValue("DeleteCollisionBlock") then
        if Globals.DeleteCollisionConnection then Globals.DeleteCollisionConnection:Disconnect() end
        Globals.DeleteCollisionConnection = Services.RunService.Heartbeat:Connect(function()
            if not RootPart then return end
            if tick() - Globals.LastDeleteScan < 0.25 then return end
            Globals.LastDeleteScan = tick()
            local Origin = RootPart.Position
            for _, Part in Services.Workspace:GetDescendants() do
                if Part:IsA("BasePart") and Part ~= RootPart and Part ~= CollisionMainPart then
                    if Part:IsDescendantOf(Character) then continue end
                    local dist = (Part.Position - Origin).Magnitude
                    if dist <= 10 then
                        local nameLower = Part.Name:lower()
                        local parentLower = Part.Parent and Part.Parent.Name:lower() or ""
                        local isFloor =
                                                 nameLower:find("floor") or nameLower:find("ground")
                            or nameLower:find("baseplate") or nameLower:find("terrain")
                            or nameLower:find("platform") or nameLower:find("carpet")
                            or parentLower:find("floor") or parentLower:find("ground")
                            or (Part.Size.Y < 1 and Part.Position.Y < Origin.Y - 3)
                            or Part.Position.Y < Origin.Y - 4
                        if not isFloor then
                            if not Globals.DeletedCollisionParts[Part] then
                                Globals.DeletedCollisionParts[Part] = {
                                    CanCollide = Part.CanCollide,
                                    CanTouch = Part.CanTouch,
                                }
                            end
                            Part.CanCollide = false
                            Part.CanTouch = false
                        end
                    end
                end
            end
        end)
    else
        if Globals.DeleteCollisionConnection then
            Globals.DeleteCollisionConnection:Disconnect()
            Globals.DeleteCollisionConnection = nil
        end
        for Part, State in Globals.DeletedCollisionParts do
            if Part and Part.Parent then
                Part.CanCollide = State.CanCollide
                Part.CanTouch = State.CanTouch
            end
        end
        Globals.DeletedCollisionParts = {}
    end
end

-- ============================================================
-- DELETE FIGURE FE
-- ============================================================
Functions.DeleteFigureFE = function(Figure)
    if not Figure or not Figure:IsA("Model") then return end
    if Figure:GetAttribute("AbysallFigureDeleted") then return end
    Figure:SetAttribute("AbysallFigureDeleted", true)

    task.spawn(function()
        for _, Part in Figure:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
            end
        end
        for _, Part in Figure:GetDescendants() do
            if Part:IsA("BasePart") then
                pcall(function() Part:BreakJoints() end)
                Part.Anchored = false
            end
        end
    end)

    task.spawn(function()
        task.wait(2)
        if not Figure or not Figure.Parent then return end
        for _, Part in Figure:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
            end
        end
        local hum = Figure:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Sit = true
            hum.JumpPower = 0
            hum.WalkSpeed = 0
            hum.Health = 0
        end
        for _, Part in Figure:GetDescendants() do
            if Part:IsA("BasePart") then
                local BG = Part:FindFirstChildOfClass("BodyGyro")
                if not BG then
                    BG = Instance.new("BodyGyro")
                    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    BG.P = 9e9
                    BG.D = 9e9
                    BG.Parent = Part
                end
            end
        end
        local GrindConn
        GrindConn = Services.RunService.Heartbeat:Connect(function()
            if not Functions.GetValue("DeleteFigureFE") or not Figure.Parent then
                GrindConn:Disconnect()
                return
            end
            local hum2 = Figure:FindFirstChildOfClass("Humanoid")
            if hum2 then
                hum2.Health = 0
                hum2.WalkSpeed = 0
                hum2.JumpPower = 0
                hum2.MoveDirection = Vector3.zero
            end
            for _, Part in Figure:GetDescendants() do
                if Part:IsA("BasePart") then
                    Part.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end)
        table.insert(Globals.DeleteFigureConnections, GrindConn)

        task.spawn(function()
            while Functions.GetValue("DeleteFigureFE") and Figure.Parent do
                task.wait()
                for _, Part in Figure:GetDescendants() do
                    if Part:IsA("BasePart") then
                        Part.Anchored = false
                        Part.CFrame = CFrame.new(Part.Position.X, -9999, Part.Position.Z)
                    end
                end
            end
        end)
    end)
end

-- ============================================================
-- FIGURE GODMODE
-- ============================================================
Functions.CreateGodmodePart = function()
    if Globals.GodmodePart and Globals.GodmodePart.Parent then return Globals.GodmodePart end
    if not Character then return nil end
    local part = Instance.new("Part")
    part.Name = "AbysallGodmodePart"
    part.Size = Vector3.new(4, 6, 2)
    part.Transparency = 1
    part.CanCollide = false
    part.CanTouch = false
    part.Anchored = true
    part.Parent = Character
    Globals.GodmodePart = part
    return part
end

Functions.ApplyFigureGodmode = function()
    if Functions.GetValue("FigureGodmode") then
        local part = Functions.CreateGodmodePart()
        if not part then return end
        if Globals.FigureGodmodeConnection then Globals.FigureGodmodeConnection:Disconnect() end
        Globals.FigureGodmodeConnection = Services.RunService.Heartbeat:Connect(function()
            if not Functions.GetValue("FigureGodmode") or not RootPart or not part.Parent then return end
            local nearestFigure, nearestDist = nil, math.huge
            for _, obj in Services.Workspace:GetChildren() do
                if obj:IsA("Model") and (obj.Name == "Figure" or obj.Name == "FigureRig" or obj.Name == "FigureRagdoll") then
                    if obj.PrimaryPart then
                        local d = (obj.PrimaryPart.Position - RootPart.Position).Magnitude
                        if d < nearestDist and d < 25 then
                            nearestDist = d
                            nearestFigure = obj
                        end
                    end
                end
            end
            if nearestFigure then
                part.CFrame = RootPart.CFrame * CFrame.new(0, 25, 0)
                if CollisionMainPart then
                    CollisionMainPart.CFrame = part.CFrame
                end
            else
                part.CFrame = RootPart.CFrame * CFrame.new(0, 0.18, 0)
            end
        end)
    else
        if Globals.FigureGodmodeConnection then
            Globals.FigureGodmodeConnection:Disconnect()
            Globals.FigureGodmodeConnection = nil
        end
        if Globals.GodmodePart then Globals.GodmodePart:Destroy() Globals.GodmodePart = nil end
    end
end

-- ============================================================
-- DESTROY JEFF — destroy hitbox + tắt CanQuery
-- ============================================================
Functions.DestroyJeff = function(Jeff)
    if not Jeff or not Jeff:IsA("Model") then return end
    if Jeff:GetAttribute("AbysallJeffDestroyed") then return end
    Jeff:SetAttribute("AbysallJeffDestroyed", true)

    task.spawn(function()
        for _, Part in Jeff:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
            end
        end
        for _, obj in Jeff:GetDescendants() do
            if obj.Name == "Hitbox" or obj.Name == "Damage" or obj.Name == "Hit" then
                pcall(function() obj:Destroy() end)
            end
        end
    end)

    task.spawn(function()
        task.wait(0.25)
        if not Jeff or not Jeff.Parent then return end
        for _, Part in Jeff:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
            end
        end
        local hum = Jeff:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Sit = true
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end

        local Seat = Instance.new("Seat")
        Seat.Name = "AbysallJeffSeat"
        Seat.Size = Vector3.new(2, 1, 2)
        Seat.Transparency = 1
        Seat.Anchored = true
        Seat.CanCollide = false
        Seat.CFrame = Jeff.PrimaryPart and Jeff:GetPivot() or CFrame.new(0,0,0)
        Seat.Parent = Jeff

        if Jeff.PrimaryPart then
            Jeff:PivotTo(Seat.CFrame * CFrame.new(0, 1.5, 0) + Vector3.new(0, 500, 0))
        end

        for _, Part in Jeff:GetDescendants() do
            if Part:IsA("BasePart") then
                local BG = Part:FindFirstChildOfClass("BodyGyro")
                if not BG then
                    BG = Instance.new("BodyGyro")
                    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    BG.P = 9e9
                    BG.D = 9e9
                    BG.Parent = Part
                end
            end
        end

        if hum then hum.Sit = false end
        Seat:Destroy()

        task.spawn(function()
            while Functions.GetValue("DestroyJeff") and Jeff.Parent do
                task.wait()
                local hum2 = Jeff:FindFirstChildOfClass("Humanoid")
                if hum2 then
                    hum2.WalkSpeed = 999
                    hum2.MoveDirection = Vector3.new(999999, 0, 0)
                end
                for _, Part in Jeff:GetDescendants() do
                    if Part:IsA("BasePart") then
                        Part.CanTouch = false
                        Part.CanQuery = false
                    end
                end
                if Jeff.PrimaryPart then
                    Jeff:PivotTo(Jeff:GetPivot() + Vector3.new(999999, 0, 0))
                end
            end
        end)
    end)
end

-- ============================================================
-- ANTI-CHEAT BYPASS — bypass ladder 100% giống Abysall
-- ============================================================
Functions.ApplyAntiCheatBypass = function()
    for _, conn in Globals.AntiCheatConnections do
        pcall(function() conn:Disconnect() end)
    end
    Globals.AntiCheatConnections = {}

    if not Functions.GetValue("AntiCheatBypass") then
        if Character then
            Character:SetAttribute("Climbing", false)
        end
        Globals.AnticheatDisabled = false
        return
    end

    local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
    if not RemotesFolder then return end

    local climbConn = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
        if Character:GetAttribute("Climbing") == true then
            task.wait(0.25)
            Character:SetAttribute("Climbing", false)
            Globals.AnticheatDisabled = true
            if RemotesFolder:FindFirstChild("ClimbLadder") then
                pcall(function() RemotesFolder.ClimbLadder:FireServer() end)
            end
        end
    end)
    table.insert(Globals.AntiCheatConnections, climbConn)

    if RemotesFolder:FindFirstChild("UseEnemyModule") then
        local enemyConn = RemotesFolder.UseEnemyModule.OnClientEvent:Connect(function(ModuleName)
            if ModuleName == "Void" or ModuleName == "Glitch" then
                Globals.AnticheatDisabled = false
                if RemotesFolder:FindFirstChild("ClimbLadder") then
                    pcall(function() RemotesFolder.ClimbLadder:FireServer() end)
                end
            end
        end)
        table.insert(Globals.AntiCheatConnections, enemyConn)
    end

    if RemotesFolder:FindFirstChild("Cutscene") then
        local cutsceneConn = RemotesFolder.Cutscene.OnClientEvent:Connect(function(CutsceneName)
            if Globals.AnticheatDisabled and not CutsceneName:find("SewerSeek") then
                Globals.AnticheatDisabled = false
            end
        end)
        table.insert(Globals.AntiCheatConnections, cutsceneConn)
    end

    if Globals.ClimbConnection then Globals.ClimbConnection:Disconnect() end
    Globals.ClimbConnection = Services.RunService.Heartbeat:Connect(function()
        if not Functions.GetValue("AntiCheatBypass") or not Character then return end
        if Character:GetAttribute("Climbing") == true then
            Character:SetAttribute("Climbing", false)
            Globals.AnticheatDisabled = true
            if RemotesFolder:FindFirstChild("ClimbLadder") then
                pcall(function() RemotesFolder.ClimbLadder:FireServer() end)
            end
        end
    end)
end

-- ============================================================
-- POSITION SPOOF — giống Abysall (RootPart -2.346, HipHeight 0.05)
-- ============================================================
Functions.ApplyPositionSpoof = function()
    if Globals.SpoofConnection then Globals.SpoofConnection:Disconnect() Globals.SpoofConnection = nil end
    if not RootPart or not Humanoid or not Character then return end

    local Active = Functions.GetValue("PositionSpoof")
    local Mode = "Always"
    if Options and Options.PositionSpoofMode then
        local ok, v = pcall(function() return Options.PositionSpoofMode.Value end)
        if ok and v then Mode = v end
    end

    local function GetNearestRusher()
        local RusherNames = {
            RushMoving = true, AmbushMoving = true, BashMoving = true,
            Scribbles = true, DronesStampede = true, A60 = true, A120 = true,
            BackdoorRush = true, GlitchRush = true, GlitchAmbush = true,
            CustomEntity = true,
        }
        local Nearest, NearestDist = nil, math.huge
        for _, obj in Services.Workspace:GetChildren() do
            if obj:IsA("Model") and RusherNames[obj.Name] and obj.PrimaryPart then
                local d = (obj.PrimaryPart.Position - RootPart.Position).Magnitude
                if d < NearestDist then
                    NearestDist = d
                    Nearest = obj
                end
            end
        end
        return Nearest, NearestDist
    end

    local function EnableSpoof()
        if not RootPart or not Humanoid then return end
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.346, 0)
        Humanoid.HipHeight = 0.05
        local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
        if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
            pcall(function() RemotesFolder.Crouch:FireServer(true, true) end)
        end
        Globals.SpoofActive = true
    end

    local function DisableSpoof()
        if not RootPart or not Humanoid then return end
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 2.346, 0)
        Humanoid.HipHeight = 2.396
        Globals.SpoofActive = false
    end

    if not Active then
        if Globals.SpoofActive then DisableSpoof() end
        return
    end

    if Mode == "Always On" or Mode == "Always" then
        EnableSpoof()
        Globals.SpoofConnection = Services.RunService.Heartbeat:Connect(function()
            if not Functions.GetValue("PositionSpoof") then return end
            local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
            if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
                pcall(function() RemotesFolder.Crouch:FireServer(true, true) end)
            end
        end)
    elseif Mode == "Only When Entity" then
        Globals.SpoofConnection = Services.RunService.Heartbeat:Connect(function()
            if not Functions.GetValue("PositionSpoof") or not RootPart then return end
            local Entity, Dist = GetNearestRusher()
            if Entity and Dist < 100 then
                if not Globals.SpoofActive then EnableSpoof() end
                local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
                if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
                    pcall(function() RemotesFolder.Crouch:FireServer(true, true) end)
                end
            else
                if Globals.SpoofActive then DisableSpoof() end
            end
        end)
    end
end

-- ============================================================
-- SEMI GOD MODE — gộp tất cả bypass vào 1 toggle
-- ============================================================
Functions.ApplySemiGodMode = function()
    for _, conn in Globals.SemiGodConnections do
        pcall(function() conn:Disconnect() end)
    end
    Globals.SemiGodConnections = {}

    if not Functions.GetValue("SemiGodMode") then return end
    if not Character then return end

    local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
    local Workspace = Services.Workspace

    -- Screech: destroy mỗi frame
    local screechConn = Services.RunService.Heartbeat:Connect(function()
        if not Functions.GetValue("SemiGodMode") then return end
        local Cam = Workspace:FindFirstChild("Camera")
        if Cam and Cam:FindFirstChild("Screech") then
            Cam.Screech:Destroy()
        end
    end)
    table.insert(Globals.SemiGodConnections, screechConn)

    -- Glitch: xoá module Glitch
    if Character then
        local function KillGlitch()
            local GlitchModule = Services.ReplicatedStorage:FindFirstChild("ModulesClient")
                and Services.ReplicatedStorage.ModulesClient:FindFirstChild("EntityModules")
                and Services.ReplicatedStorage.ModulesClient.EntityModules:FindFirstChild("Glitch")
            if not GlitchModule then
                GlitchModule = Services.ReplicatedStorage:FindFirstChild("ClientModules")
                    and Services.ReplicatedStorage.ClientModules:FindFirstChild("EntityModules")
                    and Services.ReplicatedStorage.ClientModules.EntityModules:FindFirstChild("Glitch")
            end
            if GlitchModule and GlitchModule.Name == "Glitch" then
                GlitchModule.Name = "Glitch_Disabled"
            end
        end
        KillGlitch()
    end

    -- Halt: fake Shade remote
    if RemotesFolder and RemotesFolder:FindFirstChild("ShadeResult") then
        local RealShade = RemotesFolder.ShadeResult
        local FakeShade = Instance.new("RemoteEvent")
        FakeShade.Name = "ShadeResult"
        FakeShade.Parent = RemotesFolder
        RealShade.Parent = nil
    end

    -- A-90: fake A90 remote
    if RemotesFolder and RemotesFolder:FindFirstChild("A90") then
        local RealA90 = RemotesFolder.A90
        local FakeA90 = Instance.new("RemoteEvent")
        FakeA90.Name = "A90"
        FakeA90.Parent = RemotesFolder
        RealA90.Parent = nil
    end

    -- Dread: ẩn Dread module
    local function HideDread()
        local UIModules = Services.ReplicatedStorage:FindFirstChild("ModulesClient")
        if not UIModules then return end
    end
    if LocalPlayer.PlayerGui:FindFirstChild("MainUI") then
        local DreadModule = LocalPlayer.PlayerGui.MainUI:FindFirstChild("Initiator")
            and LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("Dread")
        if DreadModule then DreadModule.Name = "Dread_Disabled" end
    end

    -- Banana + NannerPeel: CanTouch=false
    local bananaConn = Services.RunService.Heartbeat:Connect(function()
	        if not Functions.GetValue("SemiGodMode") then return end
        for _, obj in Workspace:GetChildren() do
            if obj.Name == "BananaPeel" or obj.Name == "NannerPeel" then
                if obj:IsA("BasePart") then obj.CanTouch = false end
            end
        end
    end)
    table.insert(Globals.SemiGodConnections, bananaConn)

    -- Dupe: tắt UnlockPrompt + Hidden touch
    local dupeConn = Services.RunService.Heartbeat:Connect(function()
        if not Functions.GetValue("SemiGodMode") then return end
        for _, obj in Workspace:GetChildren() do
            if (obj.Name == "DoorFake" or obj.Name == "FakeDoor") and obj:FindFirstChild("Hidden") then
                obj.Hidden.CanTouch = false
                if obj:FindFirstChild("Lock") and obj.Lock:FindFirstChild("UnlockPrompt") then
                    obj.Lock.UnlockPrompt.Enabled = false
                end
            end
        end
    end)
    table.insert(Globals.SemiGodConnections, dupeConn)

    -- Gloombat Eggs: tắt CanTouch
    local batConn = Services.RunService.Heartbeat:Connect(function()
        if not Functions.GetValue("SemiGodMode") then return end
        for _, obj in Workspace:GetChildren() do
            if obj.Name == "GloomPile" then
                for _, Part in obj:GetDescendants() do
                    if Part:IsA("BasePart") then Part.CanTouch = false end
                end
            end
        end
    end)
    table.insert(Globals.SemiGodConnections, batConn)

    -- Timothy (SpiderJumpscare): ẩn
    if LocalPlayer.PlayerGui:FindFirstChild("MainUI") then
        local SpiderModule = LocalPlayer.PlayerGui.MainUI:FindFirstChild("Initiator")
            and LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")
            and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("SpiderJumpscare")
        if SpiderModule then SpiderModule.Name = "SpiderJumpscare_Disabled" end
    end
end

-- ============================================================
-- HOOKS
-- ============================================================
local function HookToggle(name, fn)
    if Options and Options[name] and Options[name].OnChanged then
        Options[name]:OnChanged(function() task.spawn(fn) end)
        return
    end
    if Toggles and Toggles[name] and Toggles[name].OnChanged then
        Toggles[name]:OnChanged(function() task.spawn(fn) end)
        return
    end
    task.spawn(function()
        local last = Functions.GetValue(name)
        while true do
            task.wait(0.1)
            local now = Functions.GetValue(name)
            if now ~= last then
                last = now
                task.spawn(fn)
            end
        end
    end)
end

local function HookSlider(name, fn)
    if Options and Options[name] and Options[name].OnChanged then
        Options[name]:OnChanged(function() task.spawn(fn) end)
        return
    end
    task.spawn(function()
        local last = Functions.GetSlider(name, 0)
        while true do
            task.wait(0.1)
            local now = Functions.GetSlider(name, 0)
            if now ~= last then
                last = now
                task.spawn(fn)
            end
        end
    end)
end

HookToggle("SpeedBoostToggle", Functions.ApplySpeedBoost)
HookSlider("SpeedBoostSlider", Functions.ApplySpeedBoost)
HookToggle("SkipAcceleration", Functions.ApplySkipAcceleration)
HookToggle("SkipRunAnimation", Functions.ApplySkipRunAnimation)
HookToggle("EnableCharacterJump", Functions.ApplyJumpSlide)
HookToggle("EnableCharacterSlide", Functions.ApplyJumpSlide)
HookToggle("NoClip", Functions.ApplyNoClip)
HookToggle("VelocityMove", Functions.ApplyVelocityMove)
HookToggle("FakeSitting", Functions.ApplyFakeSitting)
HookToggle("DeleteCollisionBlock", Functions.ApplyDeleteCollisionBlock)
HookToggle("Fly", Functions.ApplyFly)
HookSlider("FlySpeed", function() end)
HookToggle("FigureGodmode", Functions.ApplyFigureGodmode)
HookToggle("AntiCheatBypass", Functions.ApplyAntiCheatBypass)
HookToggle("PositionSpoof", Functions.ApplyPositionSpoof)
HookToggle("SemiGodMode", Functions.ApplySemiGodMode)

if Options and Options.PositionSpoofMode then
    Options.PositionSpoofMode:OnChanged(function()
        task.spawn(Functions.ApplyPositionSpoof)
    end)
end

-- ============================================================
-- INPUT
-- ============================================================
Connections.InfiniteJumpsConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.Space and Functions.GetValue("InfiniteJumps") and not Globals.IsTyping and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Connections.TextBoxConnection1 = Services.UserInputService.TextBoxFocused:Connect(function()
    Globals.IsTyping = true
end)
Connections.TextBoxConnection2 = Services.UserInputService.TextBoxFocusReleased:Connect(function()
    Globals.IsTyping = false
end)

-- ============================================================
-- HANDLE CHARACTER
-- ============================================================
Functions.HandleCharacter = function(NewCharacter)
    Character = NewCharacter
    Humanoid = NewCharacter:WaitForChild("Humanoid", 9e9)
    RootPart = NewCharacter:WaitForChild("HumanoidRootPart", 9e9)
    Camera = Services.Workspace.CurrentCamera

    CollisionModel = NewCharacter:FindFirstChild("Collision")
    CollisionMainPart = Functions.GetCollisionMainPart()
    CollisionCrouchPart = CollisionModel and CollisionModel:FindFirstChild("CollisionCrouch") or nil

    local Old = NewCharacter:FindFirstChild("CollisionClone")
    if Old then Old:Destroy() end
    if CollisionMainPart then
        CollisionClone = CollisionMainPart:Clone()
        CollisionClone.Name = "CollisionClone"
        CollisionClone.CanCollide = false
        CollisionClone.CanTouch = false
        CollisionClone.Massless = true
        CollisionClone.Parent = NewCharacter
    end

    local OldP = NewCharacter:FindFirstChild("CollisionPartClone")
    if OldP then OldP:Destroy() end
    if CollisionMainPart then
        CollisionPartClone = CollisionMainPart:Clone()
        CollisionPartClone.Name = "CollisionPartClone"
        CollisionPartClone.CanCollide = false
        CollisionPartClone.CanTouch = false
        CollisionPartClone.Massless = true
        CollisionPartClone.Parent = NewCharacter
    end

    OldJump = NewCharacter:GetAttribute("CanJump") or false
    OldSlide = NewCharacter:GetAttribute("CanSlide") or false

    task.spawn(Functions.ApplyJumpSlide)
    task.spawn(Functions.ApplySpeedBoost)
    task.spawn(Functions.ApplySkipAcceleration)
    task.spawn(Functions.ApplySkipRunAnimation)
    task.spawn(Functions.ApplyNoClip)
    task.spawn(Functions.ApplyVelocityMove)
    task.spawn(Functions.ApplyFakeSitting)
    task.spawn(Functions.ApplyDeleteCollisionBlock)
    task.spawn(Functions.ApplyFly)
    task.spawn(Functions.ApplyFigureGodmode)
    task.spawn(Functions.ApplyAntiCheatBypass)
    task.spawn(Functions.ApplyPositionSpoof)
    task.spawn(Functions.ApplySemiGodMode)

    local JumpButton = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
        and LocalPlayer.PlayerGui.MainUI:FindFirstChild("MainFrame")
        and LocalPlayer.PlayerGui.MainUI.MainFrame:FindFirstChild("MobileButtons")
        and LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton")
    if JumpButton then
        if Connections.InfiniteJumpsConnection2 then Connections.InfiniteJumpsConnection2:Disconnect() end
        Connections.InfiniteJumpsConnection2 = JumpButton.MouseButton1Down:Connect(function()
            if Functions.GetValue("InfiniteJumps") and Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

task.spawn(function()
    while not LocalPlayer.Character do task.wait() end
    while not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do task.wait() end
    Functions.HandleCharacter(LocalPlayer.Character)
end)

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    task.wait(0.5)
    Functions.HandleCharacter(NewCharacter)
end)

-- ============================================================
-- ENTITY HANDLERS
-- ============================================================
Connections.EntityHandler = Services.Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Figure" or child.Name == "FigureRig" or child.Name == "FigureRagdoll" then
        if Functions.GetValue("DeleteFigureFE") then
            task.spawn(function() Functions.DeleteFigureFE(child) end)
        end
    end
    if child.Name == "JeffTheKiller" then
        if Functions.GetValue("DestroyJeff") then
            task.spawn(function() Functions.DestroyJeff(child) end)
        end
    end
end)

-- ============================================================
-- MAIN RENDER LOOP
-- ============================================================
Connections.RenderSteppedConnection = Services.RunService.RenderStepped:Connect(function()
    if not Character or not RootPart or not Humanoid then return end
    if Services.Workspace:FindFirstChild("Camera") then
        Camera = Services.Workspace:FindFirstChild("Camera")
    end

    CollisionMainPart = Functions.GetCollisionMainPart()

    if Functions.GetValue("SpeedBoostToggle") then
        local Target = Functions.GetCurrentSpeed() + Functions.GetSlider("SpeedBoostSlider", 1)
        Humanoid.WalkSpeed = Target
        if RootPart.AssemblyLinearVelocity.Magnitude < Target - 1 and Humanoid.MoveDirection.Magnitude > 0 then
            RootPart.AssemblyLinearVelocity = Humanoid.MoveDirection * Target
        end
    end

    if Functions.GetValue("SkipAcceleration") and Humanoid.MoveDirection.Magnitude > 0 then
        local Target = Functions.GetCurrentSpeed() + (Functions.GetValue("SpeedBoostToggle") and Functions.GetSlider("SpeedBoostSlider", 1) or 0)
        RootPart.AssemblyLinearVelocity = Humanoid.MoveDirection * Target
    end

    if Functions.GetValue("DeleteFigureFE") then
        for _, obj in Services.Workspace:GetChildren() do
            if obj.Name == "Figure" or obj.Name == "FigureRig" or obj.Name == "FigureRagdoll" then
                if not obj:GetAttribute("AbysallFigureDeleted") then
                    task.spawn(function() Functions.DeleteFigureFE(obj) end)
                end
            end
        end
    end

    if Functions.GetValue("DestroyJeff") then
        for _, obj in Services.Workspace:GetChildren() do
            if obj.Name == "JeffTheKiller" then
                if not obj:GetAttribute("AbysallJeffDestroyed") then
                    task.spawn(function() Functions.DestroyJeff(obj) end)
                end
            end
        end
    end
end)

-- ============================================================
-- UNLOAD
-- ============================================================
Library:OnUnload(function()
    if Globals.FakeSeat then Globals.FakeSeat:Destroy() end
    if Globals.FakeSeatConnection then Globals.FakeSeatConnection:Disconnect() end
    if Globals.DeleteCollisionConnection then Globals.DeleteCollisionConnection:Disconnect() end
    if Globals.FlyVelocity then Globals.FlyVelocity:Destroy() end
    if Globals.FlyConnection then Globals.FlyConnection:Disconnect() end
    if Globals.FigureGodmodeConnection then Globals.FigureGodmodeConnection:Disconnect() end
    if Globals.GodmodePart then Globals.GodmodePart:Destroy() end
    if Globals.RunAnimConnection then Globals.RunAnimConnection:Disconnect() end
    if Globals.SpoofConnection then Globals.SpoofConnection:Disconnect() end
    if Globals.ClimbConnection then Globals.ClimbConnection:Disconnect() end

    for _, conn in Globals.DeleteFigureConnections do
        pcall(function() conn:Disconnect() end)
    end
    for _, conn in Globals.DestroyJeffConnections do
        pcall(function() conn:Disconnect() end)
    end
    for _, conn in Globals.AntiCheatConnections do
        pcall(function() conn:Disconnect() end)
    end
    for _, conn in Globals.SemiGodConnections do
        pcall(function() conn:Disconnect() end)
    end

    for Part, State in Globals.DeletedCollisionParts do
        if Part and Part.Parent then
            Part.CanCollide = State.CanCollide
            Part.CanTouch = State.CanTouch
        end
    end
    for Part, State in Globals.NoClipOldStates do
        if Part and Part.Parent then
            Part.CanCollide = State.CanCollide
            Part.CanTouch = State.CanTouch
        end
    end

    for _, Connection in Connections do
        pcall(function() Connection:Disconnect() end)
    end

    if RootPart then
        local BV = RootPart:FindFirstChild("AbysallVelocity")
        if BV then BV:Destroy() end
    end

    if Character then
        Character:SetAttribute("CanJump", OldJump)
        Character:SetAttribute("CanSlide", OldSlide)
    end

    if Humanoid then
        Humanoid.WalkSpeed = Functions.GetCurrentSpeed()
        Humanoid.PlatformStand = false
        Humanoid.HipHeight = 2.396
    end

    if CollisionPartClone then CollisionPartClone:Destroy() end
    if CollisionClone then CollisionClone:Destroy() end

    if OldDefaultPhysics and Character then
        for _, Part in Character:GetDescendants() do
            if Part:IsA("BasePart") then
                Part.CustomPhysicalProperties = OldDefaultPhysics
            end
        end
    end

    if Globals.SpoofActive and RootPart then
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 2.346, 0)
    end
end)
