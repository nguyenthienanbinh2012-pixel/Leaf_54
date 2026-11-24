local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
HidingPlaces = {
    ["Wardrobe"]="Closet", ["Rooms_Locker"]="Locker", ["Rooms_Locker_Fridge"]="Fridge",
    ["Locker_Large"]="Locker", ["Backdoor_Wardrobe"]="Closet", ["Bed"]="Bed",
    ["Double_Bed"]="Double Bed", ["Toolshed"]="Closet", ["RetroWardrobe"]="Closet",
    ["CircularVent"]="Vent",
}
Closets = {}
Interactions = {}
Stored = {}
IsMoving = false

function GetNearestHidingSpot()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, closestDist = nil, math.huge
    for _, spot in ipairs(Closets) do
        if spot.Parent and spot.PrimaryPart then
            local hidden = spot:FindFirstChild("HiddenPlayer", true)
            if not (hidden and hidden.Value) then
                local dist = (spot.PrimaryPart.Position - root.Position).Magnitude
                if dist < closestDist then closestDist = dist closest = spot end
            end
        end
    end
    return closest
end
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
repeat task.wait() until game:IsLoaded()
if game:GetService("Players").LocalPlayer:GetAttribute("LeafLoaded") then
if getgenv().Library then
getgenv().Library:Notify("Leaf Hub 『 Already Loaded 』",4)
else
print("Leaf Hub 『 Already Loaded 』")
end
return end
game:GetService("Players").LocalPlayer:SetAttribute("LeafLoaded",true)
local LibraryName = '🌿 Leaf Hub'
repeat task.wait() until LocalPlayer.Character
getgenv().ScriptLibrary = "Obsidian"
local repo = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/'
if not getgenv().Library then
	getgenv().Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
end
pcall(function()
	Library.Scheme.Font = Font.fromEnum(Enum.Font.Gotham)
end)
Library.ForceCheckbox = false
Library.Scheme.AccentColor = Color3.fromRGB(40, 220, 160) -- xanh lá dương
Library.Scheme.BackgroundColor = Color3.fromRGB(12, 18, 16)
Library.Scheme.MainColor = Color3.fromRGB(22, 32, 28)
Library.Scheme.OutlineColor = Color3.fromRGB(40, 70, 60)
Library.Scheme.FontColor = Color3.fromRGB(230, 255, 245)
if Library.UpdateColorsUsingRegistry then
	Library:UpdateColorsUsingRegistry()
elseif Library.UpdateColors then
	Library:UpdateColors()
end
pcall(function()
	Library:SetDPIScale(95)
end)
local ThemeManager, SaveManager
pcall(function() ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))() end)
pcall(function() SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))() end)
local okEsp, ESPLibrary = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()
end)
if not okEsp or type(ESPLibrary) ~= "table" then
    warn("[Leaf] ESPLibrary fail:", ESPLibrary)
    ESPLibrary = {
        AddESP = function() end, RemoveESP = function() end, Unload = function() end,
        SetShowDistance = function() end, SetTracers = function() end, SetRainbow = function() end,
        SetESPMode = function() end, SetFont = function() end, SetRenderingSpeed = function() end,
    }
end
if SaveManager then
local oldSave = SaveManager.Save
SaveManager.Save = function(self, name)
if Library.KeybindFrame then
local pos = Library.KeybindFrame.Position
local data = { pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset }
getgenv().LeafHub_KeybindPos = data
pcall(function()
if writefile and self.Folder then
writefile(self.Folder .. '/settings/' .. name .. '_keybindpos.json', HttpService:JSONEncode(data))
end
end)
end
return oldSave(self, name)
end
local oldLoad = SaveManager.Load
SaveManager.Load = function(self, name)
local result = oldLoad(self, name)
pcall(function()
if isfile and self.Folder and isfile(self.Folder .. '/settings/' .. name .. '_keybindpos.json') then
local data = HttpService:JSONDecode(readfile(self.Folder .. '/settings/' .. name .. '_keybindpos.json'))
if data and Library.KeybindFrame then
Library.KeybindFrame.Position = UDim2.new(data[1], data[2], data[3], data[4])
getgenv().LeafHub_KeybindPos = data
end
end
end)
return result
end
end
local Options = Library.Options
local Toggles = Library.Toggles
local Connections = {}
local AlmaConnection = nil
local DroneConnection = nil
local DroneWalkedIntoParents = {}
local AntiNoiseConnection = nil
local AntiMonumentConnection = nil
local LEAF_LOGO_URL = "https://raw.githubusercontent.com/nguyenthienanbinh2012-pixel/Leaf-Hub-Logo/refs/heads/main/Screenshot_2026-11-15-06-15-37-22_96b26121e545231a3c569311a54cda96.jpg"
local LeafLogoAsset = nil
pcall(function()
	if writefile and getcustomasset and isfile then
		local path = "LeafHub_Logo.jpg"
		if not isfile(path) then
			writefile(path, game:HttpGet(LEAF_LOGO_URL))
		end
		LeafLogoAsset = getcustomasset(path)
	end
end)

local Window = Library:CreateWindow({
	Title = "Leaf Hub",
	Icon = LeafLogoAsset or "leaf",
	IconSize = UDim2.fromOffset(28, 28),
	Center = true,
	ToggleKeybind = Enum.KeyCode.RightControl,
	AutoShow = true,
	NotifySide = "Right",
	ShowCustomCursor = true,
	Footer = "https://discord.gg/3eHTX99Zz | Leaf-Hub",
	CornerRadius = 12,
})
Window.MainFrame.Size = UDim2.fromOffset(690, 300)
Window:SetSidebarWidth(165)
if Library.KeybindFrame then
if getgenv().LeafHub_KeybindPos then
local p = getgenv().LeafHub_KeybindPos
Library.KeybindFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
end
table.insert(Connections, Library.KeybindFrame:GetPropertyChangedSignal("Position"):Connect(function()
local pos = Library.KeybindFrame.Position
getgenv().LeafHub_KeybindPos = { pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset }
end))
end
local Notifying = "Library"
local PlaySound = true
local function Notify(txt, duration)
Library:Notify(txt, duration)
if PlaySound then
local Sound = Instance.new("Sound", game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://101511361468852"
Sound.PlaybackSpeed = 0.77
Sound.Volume = 5
Sound:Play()
game:GetService("Debris"):AddItem(Sound, 3)
end
end
function AddESP(part,txt,color)
ESPLibrary:AddESP({
Object = part, Text = txt, Color = color })
end
function AddEntityESP(part,txt,color)
if part:IsA("Model") then
while not part.PrimaryPart do
for _, v in pairs(part:GetChildren()) do
if v:IsA("BasePart") then
part.PrimaryPart = v
end
end
task.wait()
end
if part.PrimaryPart then
part.PrimaryPart.Transparency = 0.99
end
if not part:FindFirstChildOfClass("Humanoid") then
Instance.new("Humanoid",part)
end
end
if part.Name == "FigureRig" or part.Name == "FigureRagdoll" then
part:WaitForChild("Root").Size = Vector3.new(0.001, 0.001, 0.001)
end
ESPLibrary:AddESP({
Object = part, Text = txt, Color =  color, })
end
function GetLibraryCode()
local CodeLength = game.ReplicatedStorage.GameData.Floor.Value == "Fools" and 10 or 5
local Slot = table.create(CodeLength, "_")
local Paper
for _, plr in pairs(Players:GetPlayers()) do
local char = plr.Character
if char then
Paper = char:FindFirstChild("LibraryHintPaper") or char:FindFirstChild("LibraryHintPaperHard") or
plr.Backpack:FindFirstChild("LibraryHintPaper") or plr.Backpack:FindFirstChild("LibraryHintPaperHard")
if Paper then break end
end
end
if not Paper then return table.concat(Slot) end
local Hints = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
for _, i in pairs(Paper.UI:GetChildren()) do
if i:IsA("ImageLabel") and i.Name ~= "Image" then
local Pos = tonumber(i.Name)
if Pos and Slot[Pos] then
for _, v in pairs(Hints) do
if v.Name == "Icon" and v.ImageRectOffset.X == i.ImageRectOffset.X then
local Label = v:FindFirstChild("TextLabel")
if Label then
Slot[Pos] = Label.Text
end
break
end
end
end
end
end
return table.concat(Slot)
end
if workspace:FindFirstChild("Lobby") then
local Tabs = {
Main = Window:AddTab('Game',"earth"),
Settings = Window:AddTab('Settings',"settings"),
}
local Tp = Tabs.Main:AddLeftGroupbox("Teleport")
Tp:AddLabel('Main menu appears after teleport', true)
local function FastElevator(dest, settings)
local Event = game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") and game:GetService("ReplicatedStorage").RemotesFolder:FindFirstChild("CreateElevator")
if Event then
Event:FireServer({
Mods = {},
Settings = settings or {},
Destination = dest,
FriendsOnly = false,
MaxPlayers = "1"
})
end
end
Tp:AddButton("Teleport to Hotel", function() FastElevator("Hotel") end)
Tp:AddButton("Teleport to Mines", function() FastElevator("Mines") end)
Tp:AddButton("Teleport to Rooms (PRICE)", function() FastElevator("Rooms") end)
Tp:AddButton("Teleport to Backdoors", function() FastElevator("Backdoor") end)
Tp:AddButton("Teleport to Outdoors (FREE)", function() FastElevator("Garden") end)
Tp:AddButton("Teleport to Retro Mode", function() FastElevator("Retro") end)
Tp:AddButton("Teleport to Super Hard Mode", function() FastElevator("SuperHardMode") end)
Tp:AddButton("Teleport to Endless", function() FastElevator("Endless") end)
Tp:AddButton("Teleport to Rush Mode", function() FastElevator("Fools26") end)
Tp:AddButton("Teleport to Battle Mode", function() FastElevator("Party") end)
Tp:AddButton("Teleport to Chaos", function() FastElevator("Curated", { youtube = "", twitch = "" }) end)
Tp:AddButton("Teleport to Daily Run", function() FastElevator("Daily") end)
Tp:AddButton("Teleport to Cringles Workshop", function() FastElevator("CringlesWorkshop") end)
Tp:AddButton("Teleport to Trick Or Treat", function() FastElevator("Halloween25") end)
Tp:AddButton("Teleport to Hotel-", function() FastElevator("BeforePlus") end)
local GameBox = Tabs.Main:AddRightGroupbox("Game", "circle")

GameBox:AddSlider("GameSpeed", {
    Text = "Speed",
    Min = 1,
    Max = 90,
    Default = 16,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end,
})

GameBox:AddSlider("GameFlySpeed", {
    Text = "Fly",
    Min = 1,
    Max = 90,
    Default = 16,
    Rounding = 0,
    Compact = true,
})

GameBox:AddToggle("GameNoClip", {
    Text = "No Clip",
    Default = false,
    Tooltip = "Xuyên tường",
})

GameBox:AddToggle("GameRestore", {
    Text = "Khôi phục",
    Default = false,
    Tooltip = "Reset Speed / Fly / NoClip về mặc định",
})

GameBox:AddDivider()

GameBox:AddButton("Remeber Code", function()
    if getgenv().LeafRedeemingCodes then return end
    getgenv().LeafRedeemingCodes = true
    local codes = {
        "67","54","41","CHEDDAR BALLS","XQC","PENGUINZ0","KREEKCRAFT",
        "ISHOWSPEED","DANTDM","KUBZ SCOUTS","FIND THE TROLLFACES",
        "THINKNOODLES","W","RAGDOLL UNIVERSE","RAGDOLL MAYHEM",
        "BIJUU MIKE","8BITRYAN","SCREECHSUCKS","LORE",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ","3rd","LAZYDEVS",
        "RAGDOLL COMBAT","VOCAB HAVOC","PATHSWAP","JUMP OVER THE BRICK"
    }
    local ShopCode = ReplicatedStorage:FindFirstChild("RemotesFolder")
        and ReplicatedStorage.RemotesFolder:FindFirstChild("ShopCode")
    if not ShopCode then
        Notify("Auto Enter Code: Không tìm thấy ShopCode remote", 4)
        getgenv().LeafRedeemingCodes = false
        return
    end
    Notify("Redeeming " .. #codes .. " codes...", 4)
    for _, code in ipairs(codes) do
        ShopCode:FireServer(code)
        task.wait(5.1)
    end
    getgenv().LeafRedeemingCodes = false
end)

GameBox:AddDivider()

local TitleLoopLabel = GameBox:AddLabel("Title Loop")
if TitleLoopLabel then
    pcall(function()
        local lbl = TitleLoopLabel.TextLabel or TitleLoopLabel.Object
        if lbl and lbl:IsA("TextLabel") then
            lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
            lbl.RichText = true
            lbl.Text = '<font color="rgb(0,255,0)">Title Loop</font>'
        end
    end)
end

GameBox:AddToggle("GameTitleLoop", {
    Text = "Title Loop",
    Default = false,
    Tooltip = "Giúp Chuyển các danh hiệu",
})

GameBox:AddSlider("GameTitleLoopSpeed", {
    Text = "Tốc độ lặp",
    Min = 0.1,
    Max = 2,
    Default = 0.1,
    Rounding = 2,
    Compact = true,
})

-- ===== LOGIC =====
local GameConns = {}
local GameFlyBV = nil
local LastTitleChange = tick()
local PrevTitleBadge = nil
local OrigSpeed = 16

local FlexRemote = ReplicatedStorage:FindFirstChild("RemotesFolder")
    and ReplicatedStorage.RemotesFolder:FindFirstChild("FlexAchievement")

GameConns.Fly = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if Toggles.GameNoClip and Toggles.GameNoClip.Value then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end

    local flySpeed = Options.GameFlySpeed and Options.GameFlySpeed.Value or 16
    if flySpeed > 16 and not (Toggles.GameRestore and Toggles.GameRestore.Value) then
        if not GameFlyBV or GameFlyBV.Parent ~= hrp then
            if GameFlyBV then GameFlyBV:Destroy() end
            GameFlyBV = Instance.new("BodyVelocity")
            GameFlyBV.Name = "GameFlyBV"
            GameFlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            GameFlyBV.Velocity = Vector3.zero
            GameFlyBV.Parent = hrp
        end
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
        GameFlyBV.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.zero
        hum.PlatformStand = true
    else
        if GameFlyBV then GameFlyBV:Destroy() GameFlyBV = nil end
        if hum.PlatformStand then hum.PlatformStand = false end
    end
end)

if Toggles.GameRestore then
    Toggles.GameRestore:OnChanged(function(v)
        if not v then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = OrigSpeed
            hum.PlatformStand = false
        end
        if GameFlyBV then GameFlyBV:Destroy() GameFlyBV = nil end
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        if Options.GameSpeed then Options.GameSpeed:SetValue(OrigSpeed) end
        if Options.GameFlySpeed then Options.GameFlySpeed:SetValue(16) end
        if Toggles.GameNoClip then Toggles.GameNoClip:SetValue(false) end
        Toggles.GameRestore:SetValue(false)
    end)
end

GameConns.Title = RunService.Heartbeat:Connect(function()
    if not (Toggles.GameTitleLoop and Toggles.GameTitleLoop.Value) then return end
    local delay = Options.GameTitleLoopSpeed and Options.GameTitleLoopSpeed.Value or 0.1
    if tick() - LastTitleChange < delay then return end

    local plrGui = LocalPlayer.PlayerGui
    local mainUI = plrGui:FindFirstChild("MainUI")
    local lobbyFrame = mainUI and mainUI:FindFirstChild("LobbyFrame")
    local ach = lobbyFrame and lobbyFrame:FindFirstChild("Achievements")
    local list = ach and ach:FindFirstChild("List")
    if not list then return end

    local badges = {}
    for _, f in ipairs(list:GetChildren()) do
        if f:IsA("ImageButton") and f.ImageTransparency == 0 then
            table.insert(badges, f.Name)
        end
    end
    if #badges == 0 then return end

    local badge = badges[math.random(1, #badges)]
    if badge == PrevTitleBadge and #badges > 1 then
        while true do
            local nb = badges[math.random(1, #badges)]
            if nb ~= PrevTitleBadge then badge = nb break end
            task.wait()
        end
    end

    for _, f in ipairs(list:GetChildren()) do
        if f:IsA("ImageButton") and f.ImageTransparency == 0 and f:FindFirstChild("Icons") then
            local star = f.Icons:FindFirstChild("Star")
            if star then star.Visible = false end
        end
    end

    if FlexRemote then FlexRemote:FireServer(badge) end
    PrevTitleBadge = badge

    local bf = list:FindFirstChild(badge)
    if bf and bf:FindFirstChild("Icons") and bf.Icons:FindFirstChild("Star") then
        bf.Icons.Star.Visible = true
    end
    LastTitleChange = tick()
end)

table.insert(Connections, GameConns.Fly)
table.insert(Connections, GameConns.Title)
local MenuGroup = Tabs.Settings:AddLeftGroupbox('UI Settings')
local UtilityBox = Tabs.Settings:AddRightGroupbox('Hub Utilities')
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind
MenuGroup:AddToggle("ShowKeybinds", { Text = "Show Keybinds Overlay", Default = false }):OnChanged(function()
Library.KeybindFrame.Visible = Toggles.ShowKeybinds.Value
end)
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = true,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDivider()
MenuGroup:AddToggle('PlayNotifySound',{
Text = "Play Notification Sound",
Default = true,
Callback = function(Value)
PlaySound = Value
end
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddButton('Test Notification',function()
Notify("Hello World-Test",2)
end)
MenuGroup:AddDropdown("Library", {
Values = { "Obsidian", "Linoria" },
Default = 1,
Text = "Library",
Callback = function(Value)
getgenv().ScriptLibrary = tostring(Value)
Notify('Please Unload Script and Execute Again to Take Effect',4)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%","95%","100%", "125%", "150%", "175%", "200%" },
Default = "95%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
UtilityBox:AddButton({
Text = "Unload Hub",
Func = function()
LocalPlayer:SetAttribute("LeafLoaded", nil)
if Library.KeybindFrame then
local pos = Library.KeybindFrame.Position
getgenv().LeafHub_KeybindPos = { pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset }
end
for _, con in pairs(Connections) do con:Disconnect() end
Library:Unload()
ESPLibrary:Unload()
end
})
if ThemeManager then
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("LeafHub")
end
if SaveManager then
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
SaveManager:SetFolder("LeafHub/DOORSLOBBY")
SaveManager:BuildConfigSection(Tabs['Settings'])
end
if ThemeManager then
ThemeManager:ApplyToTab(Tabs['Settings'])
-- Settings: Gaming Menu Mode
do
	local SettingsUI = Tabs.Settings:AddLeftGroupbox("UI Mode", "monitor")
	SettingsUI:AddToggle("GamingMenuMode", {
		Text = "Gaming Menu Mode",
		Default = getgenv().LeafGamingMenuMode == true,
		Tooltip = "Kích hoạt Menu Gaming,Có thể làm Cấu hình Menu Lag hơn,chậm hơn.",
		Callback = function(Value)
			getgenv().LeafGamingMenuMode = Value and true or false

			-- Áp ngay: màu + anim + font (checkbox cần reload)
			Library.ForceCheckbox = Value
			Library.Animations = {
				ToggleWindow = Value,
				TabSwitch = Value,
				Groupbox = Value,
				Dropdown = Value,
				KeyPicker = Value,
			}
			if Value then
				pcall(function()
					Library.Scheme.Font = Font.fromEnum(Enum.Font.GothamMedium)
				end)
				Library.Scheme.AccentColor = Color3.fromRGB(0, 180, 255) -- xanh lam tươi
			else
				pcall(function()
					Library.Scheme.Font = Font.fromEnum(Enum.Font.Code)
				end)
				Library.Scheme.AccentColor = Color3.fromRGB(27, 255, 20) -- xanh lá Leaf
			end
			if Library.UpdateColorsUsingRegistry then
				Library:UpdateColorsUsingRegistry()
			elseif Library.UpdateColors then
				Library:UpdateColors()
			end

			if Notify then
				Notify(
					Value
						and "Gaming Mode: màu/anim OK."
						or "Đã tắt Gaming Mode. Re-execute nếu muốn switch style cũ.",
					5
				)
			end
		end,
	})
	end
end
Notify("Successfully Loaded for Game |  DOORS Lobby ",4)
else
local function GetDistanceToPlayer(Pos)
local DisA = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position or workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or Vector3.new(0, 0, 0)
local Dis = (DisA - Pos).Magnitude
return Dis
end
local PathFolder = Instance.new("Folder",workspace)
PathFolder.Name = "PathFolder"
function PathTo(Pos)
local Character = LocalPlayer.Character
local Root = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChild("Humanoid")
if not Root or not Humanoid then return end
local p = PathfindingService:CreatePath({
AgentRadius = 2,
AgentHeight = 5,
AgentCanJump = true,
WaypointSpacing = 2,
AgentCanSprint = false,
AgentMaxSlope = 45,
AgentJumpHeight = 0
})
local AdjustedPos = Pos and Pos +Vector3.new(0, 0, 1)
p:ComputeAsync(Root.Position, AdjustedPos)
if  p.Status ~= Enum.PathStatus.Success then return end
for _, waypoint in ipairs(p:GetWaypoints()) do
if not Toggles.AutoRooms.Value or Library.Unloaded then break end
local Dist = (Root.Position - waypoint.Position).Magnitude
if Dist >= 2 then
Humanoid:MoveTo(waypoint.Position)
Humanoid.MoveToFinished:Wait()
end
end
end
InfCrucfixTable = {
RushMoving = 90,
AmbushMoving = 140,
A60 = 110,
A120 = 99,
GlitchRush = 110,
GlitchAmbush = 160,
}
local Firepp = fireproximityprompt
local Require = require
local ReplicateSignal = replicatesignal or (typeof(replicatesignal) == "function" and replicatesignal)
local FireTouch = firetouchinterest
local HookMeta = hookmetamethod
local IsNetworkOwner = isnetworkowner
local function LeafHasNet(part)
	local ok = false
	pcall(function()
		if isnetworkowner and part and isnetworkowner(part) then ok = true end
	end)
	return ok
end

local function LeafFindFigures(maxDist, root, roomWhitelist)
	local list = {}
	if not root then return list end
	local rooms = workspace:FindFirstChild("CurrentRooms")
	if rooms then
		for _, room in ipairs(rooms:GetChildren()) do
			local n = tonumber(room.Name)
			if roomWhitelist and (not n or not roomWhitelist[n]) then continue end
			for _, name in ipairs({ "FigureRig", "FigureRagdoll", "Figure" }) do
				local m = room:FindFirstChild(name, true)
				if m then
					local p = m.PrimaryPart or m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
					if p and (not maxDist or (p.Position - root.Position).Magnitude <= maxDist) then
						table.insert(list, m)
					end
				end
			end
		end
	end
	return list
end
local ItemDisplayNames = {
["Bandage"] = "Bandage",
["Flashlight"] = "Flash light",
["Battery"] = "Battery",
["BatteryPack"] = "Battery Pack",
["SkeletonKey"] = "Skeleton Key",
["Crucifix"] = "Crucifix",
["Straplight"] = "Strap Light",
["Lockpick"] = "Lockpick",
["Bulklight"] = "Bulk Light",
["Vitamins"] = "Vitamin",
["Shears"] = "Shears",
["LaserPointer"] = "Laser Pointer",
["Candle"] = "Candle",
["Smoothie"] = "Smoothie",
["StarJug"] = "Jug of Bottle",
["StardustPickup"] = "Stardust",
["ChestBoxLocked"] = "Locked Chest",
["ChestBox"] = "Chest",
["Chest_Vine"] = "Chest Vine",
["Toolbox_Locked"] = "Locked Toolbox",
["Toolshed_Small"] = "Toolshed",
["TimerLever"] = "Lever",
["HolyGrenade"] = "Holy Grenade",
["ShieldMini"] = "Mini Shield",
["ShieldBig"] = "Big Shield",
["CrucifixWall"] = "Crucifix",
["Glowsticks"] = "Glow Sticks",
["BandagePack"] = "Bandage Pack",
["AlarmClock"] = "Alarm Clock",
["MouseHole"] = "Louie Mouse",
["StarVial"] = "Star Vial",
["StarBottle"] = "Star Bottle",
["Compass"] = "Compass",
["Lantern"] = "Lantern",
["KeyIron"] = "Iron Key",
["GoldGun"] = "Golden Gun",
["Candy"] = "Candy",
["WaterPump"] = "Water Pump",
["VineGuillotine"] = "Vine Lever",
["Shakelight"] = "Shake Light",
["LibraryHintPaper"] = "Hint Paper",
["LotusPetalPickup"] = "Lotus Petal",
}
local Floor = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("Floor")
local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
local MainGame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI").Initiator:WaitForChild("Main_Game")
local RemoteListener = MainGame:WaitForChild("RemoteListener")
local RequiredMainGame
local ClientModules = ReplicatedStorage:FindFirstChild("ModulesClient") or ReplicatedStorage:FindFirstChild("ClientModules")
local RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo") and ReplicatedStorage:FindFirstChild("EntityInfo")  or ReplicatedStorage:FindFirstChild("Bricks")  and ReplicatedStorage:FindFirstChild("Bricks") or ReplicatedStorage:FindFirstChild("RemotesFolder")
local MotorReplication = RemotesFolder:WaitForChild("MotorReplication")
local CollisionClone
local CamLock = RemotesFolder:WaitForChild("CamLock")
local AnchorArgs
local PL = RemotesFolder:WaitForChild("PL")
local ClutchHeartbeat = RemotesFolder:WaitForChild("ClutchHeartbeat")
local params = RaycastParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character}
local  SeekPath = Instance.new("Folder",workspace)
SeekPath.Name = "SeekPath"
function ShowSeekPath(v)
local Part = Instance.new("Part", SeekPath)
Part.Size = Vector3.new(1.5, 1.5, 1.5)
Part.Anchored = true
Part.Shape = "Ball"
Part.Position = v.Position
Part.CanCollide = false
Part.Color = Color3.new(0, 1, 0)
Debris:AddItem(Part, 60)
end
function FixBridge(v)
for _, i in pairs(v:GetChildren()) do
if i.Name == "PlayerBarrier" and i.Rotation.X == 180 then
local Barrier = i:Clone()
Barrier.CFrame = CFrame.new(i.Position.X, i.Position.Y, i.Position.Z)
Barrier.CFrame = Barrier.CFrame * CFrame.new(0, -7, 0)
Barrier.Size = Vector3.new(40, 0.1, 40)
Barrier.Transparency = 0.5
Barrier.Color = Color3.new(0.5, 0, 0.5)
Barrier.Material = "ForceField"
Barrier.Parent = v
Barrier.Name = "BridgeBarrier"
Barrier.Anchored = true
Barrier.CanCollide = true
end
end
end
if Require then
RequiredMainGame = require(MainGame)
end
local getcons = getconnections or get_signal_cons or get_relative_connections
if getcons then
for _, con in pairs(getcons(LocalPlayer.Idled)) do
if con.Disable then
con:Disable()
end
end
end
table.insert(Connections,LocalPlayer.CharacterAdded:Connect(function()
task.wait(1.5)
if LocalPlayer.Character then
MainGame = LocalPlayer.PlayerGui.MainUI.Initiator:WaitForChild("Main_Game")
RemoteListener = MainGame.RemoteListener
params.FilterDescendantsInstances = {LocalPlayer.Character}
if Toggles.NoScenes.Value then
local Cutscene = RemoteListener:FindFirstChild("Cutscenes") or RemoteListener:FindFirstChild("Cutscenes_")
Cutscene.Name = "Cutscenes_"
end
if Require then
RequiredMainGame = require(MainGame)
end
end
if Toggles.Jamming.Value then
if  ReplicatedStorage:FindFirstChild("LiveModifiers") and ReplicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
local Jam = LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game").Health.Jam
Jam.Playing = false
local Jamming = game:GetService("SoundService").Main.Jamming
Jamming.Enabled =  false
end
end
if Toggles.Godmode.Value and RemotesFolder.Name ~= "RemotesFolder" then
LocalPlayer.Character.Collision.Position -= Vector3.new(0, 4, 0)
end
if Toggles.Dread.Value then
local Dread = LocalPlayer:FindFirstChild("Dread",true) or LocalPlayer:FindFirstChild("_Dread",true)
if Dread then
Dread.Name = "_Dread"
end
end
if Toggles.Halt.Value then
local Dread = ClientModules.EntityModules:FindFirstChild("Shade",true) or ClientModules.EntityModules:FindFirstChild("_Shade",true)
if Dread then
Dread.Name = "_Shade"
end
end
end))
local Tabs = {
	Info = Window:AddTab("Info", "crown"),
	Main = Window:AddTab("Player", "user"),
	Bypass = Window:AddTab("Bypass", "lock-keyhole"),
	Visuals = Window:AddTab("Visuals", "monitor"),
	Floor = Window:AddTab({ Name = "Floor", Icon = "building", SubTabs = true }),
	Other = Window:AddTab("Other", "drama"),
	Settings = Window:AddTab("Settings", "settings"),
	}
-- ===== Tab Info =====
local ChangeLogBox = Tabs.Info:AddLeftGroupbox("Change Logs", "scroll-text")
ChangeLogBox:AddLabel(
	'<font color="rgb(50,255,80)">Leaf 54: Người Điều hành Leaf Hub và là người Chủ đứng đầu</font>',
	true
)
ChangeLogBox:AddLabel(
	'<font color="rgb(255,160,40)">Anxin54: Tên gọi khác trong công cuộc làm Raw</font>',
	true
)
ChangeLogBox:AddLabel('<font color="rgb(200,200,200)">23/11/2026 Update:</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+Kill player Kill Players With Chairs</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+Kill Player With Figure</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+God mode Figure[MethodsV2]</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+Auto Damage Figure</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+Anti Sally[FE]</font>', true)
ChangeLogBox:AddLabel('<font color="rgb(50,255,80)">+Anti Haste[Client, failure rate]</font>', true)

local ExecBox = Tabs.Info:AddRightGroupbox("Executor Check", "cpu")
do
	local execName, execVer = "Unknown", "?"
	pcall(function()
		if identifyexecutor then
			local a, b = identifyexecutor()
			execName = tostring(a or "Unknown")
			execVer = tostring(b or "?")
		elseif getexecutorname then
			execName = tostring(getexecutorname())
		end
	end)
	ExecBox:AddLabel(
		string.format('<font color="rgb(255,60,60)">Executor: %s</font>  <font color="rgb(200,200,200)">%s</font>', execName, execVer),
		true
	)

	local checks = {
		{ "getgenv", getgenv },
		{ "fireproximityprompt", fireproximityprompt or Firepp },
		{ "firetouchinterest", firetouchinterest },
		{ "isnetworkowner", isnetworkowner },
		{ "hookmetamethod", hookmetamethod },
		{ "getnamecallmethod", getnamecallmethod },
		{ "setclipboard", setclipboard },
		{ "writefile", writefile },
		{ "readfile", readfile },
		{ "isfile", isfile },
		{ "getconnections", getconnections },
		{ "sethiddenproperty", sethiddenproperty },
		{ "setsimulationradius", setsimulationradius },
		{ "gethui", gethui },
		{ "cloneref", cloneref },
		{ "getcustomasset", getcustomasset },
		{ "Drawing", Drawing },
		{ "newcclosure", newcclosure },
		{ "checkcaller", checkcaller },
		{ "getgc", getgc },
	}
	local okCount, total = 0, #checks
	for _, c in ipairs(checks) do
		local ok = c[2] \~= nil
		if ok then okCount += 1 end
		local reason = ok and "" or " — thiếu trên executor"
		ExecBox:AddLabel(
			string.format("%s %s%s", ok and "✅" or "❌", c[1], reason),
			true
		)
	end
	local ratio = okCount / total
	if ratio < 0.35 then -- thiếu ≥65%
		local msg = string.format(
			"Executor hỗ trợ %d/%d hàm (%.0f%%). Leaf Hub yêu cầu nhiều API hơn.",
			okCount, total, ratio * 100
		)
		pcall(function()
			if Library and Library.Unload then Library:Unload() end
		end)
		task.delay(0.5, function()
			LocalPlayer:Kick(msg)
		end)
	end
	end
local PrankBox = Tabs.Other:AddLeftGroupbox("Prank","wand-sparkles")
-- Animation Twerk (mspaint id)
local TwerkAnim = Instance.new("Animation")
TwerkAnim.AnimationId = "rbxassetid://12874447851"
local TwerkTrack = nil

local function SetupTwerk()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	pcall(function()
		TwerkTrack = hum:LoadAnimation(TwerkAnim)
		if TwerkTrack then
			TwerkTrack.Looped = true
		end
	end)
end

PrankBox:AddToggle("WastefulToolOthers", {
	Text = "Wasteful Tool Other people",
	Default = false,
	Risky = true,
	Tooltip = "Làm hao tổn item phụ kiện người khác lên Sever,Có thể không hoạt động với các bản nâng cấp!",
}):AddKeyPicker("WastefulToolOthersKey", {
	Default = "V",
	Mode = "Hold",
	Text = "Wasteful Tool Others",
	SyncToggleState = false,
})

task.defer(function()
	task.wait(0.5)
	pcall(function()
		local t = Toggles.WastefulToolOthers
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,20,147)">Wasteful Tool Other people</font>'
		end
	end)
end)

PrankBox:AddToggle("UpsideDown", {
	Text = "Character upside down",
	Default = false,
	Tooltip = "làm nhân vật bạn ĐI BẰNG ĐẦU",
	Callback = function(Value)
		local char = LocalPlayer.Character
		local coll = char and char:FindFirstChild("Collision")
		if not coll then return end
		local rot = coll.Rotation
		if Value then
			coll.Rotation = Vector3.new(rot.X, rot.Y, -90)
		else
			coll.Rotation = Vector3.new(rot.X, rot.Y, 0)
		end
	end,
})

PrankBox:AddToggle("DanceTwerk", {
	Text = "Dance Twerk",
	Default = false,
	Tooltip = "Nhảy điệu nhảy hài hước",
	Callback = function(Value)
		if Value then
			SetupTwerk()
			if TwerkTrack then
				pcall(function() TwerkTrack:Play() end)
			end
		else
			if TwerkTrack then
				pcall(function() TwerkTrack:Stop() end)
			end
		end
	end,
})

-- Giữ twerk khi respawn
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if Toggles.DanceTwerk and Toggles.DanceTwerk.Value then
		SetupTwerk()
		if TwerkTrack then pcall(function() TwerkTrack:Play() end) end
	end
	if Toggles.UpsideDown and Toggles.UpsideDown.Value then
		local coll = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Collision")
		if coll then
			local rot = coll.Rotation
			coll.Rotation = Vector3.new(rot.X, rot.Y, -90)
		end
	end
end))
local BringBox = Tabs.Other:AddLeftGroupbox("Bring","magnet")
-- Helpers Bring / Orbit (Drops folder = item game đã drop)
local isBringDropsRunning = false
local OrbitDroppedItemsConnection = nil
local OrbitDroppedItemsAngle = 0
local OrbitDroppedItemsLastTeleport = 0
local OrbitDroppedItemsPauseUntil = 0

local function SafeTeleportDropItem(dropItem, targetCFrame)
	if not dropItem or not dropItem.Parent then return end
	pcall(function()
		if dropItem.PivotTo then
			dropItem:PivotTo(targetCFrame)
		elseif dropItem:IsA("BasePart") then
			dropItem.CFrame = targetCFrame
		else
			local main = dropItem:FindFirstChild("Handle")
				or dropItem.PrimaryPart
				or dropItem:FindFirstChildWhichIsA("BasePart")
			if main then
				main.CFrame = targetCFrame
			end
		end
	end)
end

local function BringDroppedItems()
	if isBringDropsRunning then return end
	isBringDropsRunning = true
	pcall(function()
		local dropsFolder = workspace:FindFirstChild("Drops")
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not dropsFolder or not root then return end
		local dropItems = dropsFolder:GetChildren()
		if #dropItems == 0 then
			if Notify then Notify("No dropped items in Drops", 2) end
			return
		end
		-- Trước mặt player, không đâm vào body
		local safeFront = root.CFrame * CFrame.new(0, -1.8, -3.0)
		local count = 0
		for _, dropItem in ipairs(dropItems) do
			if dropItem and dropItem.Parent then
				local jitter = Vector3.new(
					math.random(-8, 8) * 0.12,
					0.1,
					math.random(-8, 8) * 0.12
				)
				SafeTeleportDropItem(dropItem, CFrame.new(safeFront.Position + jitter))
				count = count + 1
				if count % 25 == 0 then
					task.wait()
				end
			end
		end
		if Notify then Notify("Brought " .. tostring(count) .. " dropped items", 2) end
	end)
	isBringDropsRunning = false
end

BringBox:AddButton({
	Text = "Bring Item Dropped",
	Func = function()
		task.spawn(BringDroppedItems)
	end,
})
-- Tooltip: gán nếu library hỗ trợ sau khi tạo button; hoặc dùng AddLabel:
BringBox:AddLabel("Bring: chỉ item trong workspace.Drops (item game đã drop)", true)

BringBox:AddToggle("OrbitDroppedItems", {
	Text = "Orbit Item",
	Default = false,
	Tooltip = "Giúp Xoay Item xung quanh người chơi",
	Callback = function(Value)
		if OrbitDroppedItemsConnection then
			OrbitDroppedItemsConnection:Disconnect()
			OrbitDroppedItemsConnection = nil
		end
		if not Value then return end
		OrbitDroppedItemsAngle = 0
		OrbitDroppedItemsLastTeleport = tick()
		OrbitDroppedItemsPauseUntil = 0
		OrbitDroppedItemsConnection = RunService.Heartbeat:Connect(function(dt)
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local dropsFolder = workspace:FindFirstChild("Drops")
			if not root or not dropsFolder then return end
			local height = (Options.OrbitDroppedItemsHeight and Options.OrbitDroppedItemsHeight.Value) or 2
			local distance = (Options.OrbitDroppedItemsDistance and Options.OrbitDroppedItemsDistance.Value) or 6
			local speed = (Options.OrbitDroppedItemsSpeed and Options.OrbitDroppedItemsSpeed.Value) or 1
			local now = tick()
			local list = {}
			for _, obj in ipairs(dropsFolder:GetChildren()) do
				if obj:IsA("Model") or obj:IsA("BasePart") then
					list[#list + 1] = obj
				end
			end
			local count = #list
			if count == 0 then return end
			-- Mỗi 10s kéo về gần để chống despawn
			if now - OrbitDroppedItemsLastTeleport >= 10 then
				OrbitDroppedItemsLastTeleport = now
				OrbitDroppedItemsPauseUntil = now + 2
				local safeCenter = root.CFrame * CFrame.new(0, -1.8, -2.5)
				for _, obj in ipairs(list) do
					local jitter = Vector3.new(math.random(-6, 6) * 0.1, 0.1, math.random(-6, 6) * 0.1)
					SafeTeleportDropItem(obj, CFrame.new(safeCenter.Position + jitter))
				end
			end
			if now < OrbitDroppedItemsPauseUntil then return end
			OrbitDroppedItemsAngle = OrbitDroppedItemsAngle + dt * speed
			for i, obj in ipairs(list) do
				local ang = OrbitDroppedItemsAngle + ((i - 1) / count) * math.pi * 2
				local offset = Vector3.new(
					math.cos(ang) * distance,
					height,
					math.sin(ang) * distance
				)
				local pos = root.Position + offset
				if obj:IsA("Model") then
					pcall(function() obj:PivotTo(CFrame.new(pos)) end)
				else
					pcall(function() obj.CFrame = CFrame.new(pos) end)
				end
			end
		end)
	end,
})

BringBox:AddSlider("OrbitDroppedItemsHeight", {
	Text = "Orbit Height",
	Default = 2,
	Min = -20,
	Max = 20,
	Rounding = 1,
	Compact = false,
	Tooltip = "Chiều cao orbit item quanh player",
})
BringBox:AddSlider("OrbitDroppedItemsDistance", {
	Text = "Orbit Distance",
	Default = 6,
	Min = 1,
	Max = 20,
	Rounding = 1,
	Compact = false,
})
BringBox:AddSlider("OrbitDroppedItemsSpeed", {
	Text = "Orbit Speed",
	Default = 1,
	Min = 0.1,
	Max = 5,
	Rounding = 1,
	Compact = false,
})
-- ===== Kill with Chair — BodyPosition x8 =====
local KillChairConn = nil
local KillChairForces = {} -- BodyPosition instances

local CHAIR_PART_NAMES = {
	"Collider", "ColliderRampFront", "ColliderWheels", "Seat",
	"Arms", "Base", "Metal", "PromptBlocker",
}

local function KillChairCleanup()
	for _, bp in ipairs(KillChairForces) do
		pcall(function()
			if bp and bp.Parent then bp:Destroy() end
		end)
	end
	table.clear(KillChairForces)
	if KillChairConn then
		if typeof(KillChairConn) == "RBXScriptConnection" then
			KillChairConn:Disconnect()
		else
			task.cancel(KillChairConn)
		end
		KillChairConn = nil
	end
end

BringBox:AddDropdown("KillChairTarget", {
	Text = "Kill Chair Target",
	Default = "Nearest",
	Values = { "Nearest" },
})

task.spawn(function()
	task.wait(0.5)
	local function refresh()
		local vals = { "Nearest" }
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr == LocalPlayer then
				table.insert(vals, "★ YOU (cẩn thận): " .. plr.Name)
			else
				table.insert(vals, plr.Name)
			end
		end
		if Options.KillChairTarget and Options.KillChairTarget.SetValues then
			Options.KillChairTarget:SetValues(vals)
		end
	end
	refresh()
	Players.PlayerAdded:Connect(refresh)
	Players.PlayerRemoving:Connect(refresh)
end)

BringBox:AddToggle("KillPlayerWithChair", {
	Text = "Kill the player With a Chair",
	Default = false,
	Risky = true,
	Tooltip = "Giết người chơi khác bằng ghế,Chỉ hoạt động Floor Achiever",
	Callback = function(Value)
		KillChairCleanup()
		if not Value then return end

		local floorVal = Floor and Floor.Value
		if floorVal ~= "Achiever" and floorVal ~= "The Achiever" and floorVal ~= "Achiver" then
			if Notify then Notify("Kill Chair: chỉ Floor Achiever!", 3) end
			if Toggles.KillPlayerWithChair then Toggles.KillPlayerWithChair:SetValue(false) end
			return
		end

		KillChairConn = RunService.Heartbeat:Connect(function()
			if not (Toggles.KillPlayerWithChair and Toggles.KillPlayerWithChair.Value) then
				KillChairCleanup()
				return
			end

			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not myRoot then return end

			local sel = Options.KillChairTarget and Options.KillChairTarget.Value or "Nearest"
			local targetPlr = nil
			if sel == "Nearest" or sel == "" then
				local best, bd = nil, 325
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer then
						local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
						if r then
							local d = (r.Position - myRoot.Position).Magnitude
							if d < bd then best, bd = plr, d end
						end
					end
				end
				targetPlr = best
			else
				local name = string.gsub(sel, "^★ YOU %(cẩn thận%): ", "")
				targetPlr = Players:FindFirstChild(name)
			end
			if not targetPlr or not targetPlr.Character then return end
			local tHum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
			local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
			if not tHum or not tRoot then return end
			if tHum.Health <= 0 then
				if Notify then Notify("Kill Player: " .. targetPlr.Name .. " Success! ✅", 4) end
				pcall(function()
					local s = Instance.new("Sound", game:GetService("SoundService"))
					s.SoundId = "rbxassetid://4612375233"
					s.Volume = 5
					s:Play()
					task.delay(2, function() s:Destroy() end)
				end)
				Toggles.KillPlayerWithChair:SetValue(false)
				KillChairCleanup()
				return
			end

			-- Mọi ghế có Prompt (không giới hạn khoảng cách)
			local chairs = {}
			local function scan(parent)
				if not parent then return end
				for _, d in ipairs(parent:GetDescendants()) do
					if d:IsA("Model") then
						local n = string.lower(d.Name)
						if string.find(n, "chair", 1, true) then
							local pr = d:FindFirstChildWhichIsA("ProximityPrompt", true)
							if pr then table.insert(chairs, d) end
						end
					end
				end
			end
			scan(workspace)
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if rooms then scan(rooms) end
			if #chairs == 0 then return end

			local fire = Firepp or fireproximityprompt
			local targetPos = tRoot.Position

			for i = 1, math.min(3, #chairs) do
				local chair = chairs[i]
				local pr = chair:FindFirstChildWhichIsA("ProximityPrompt", true)
				if fire and pr then
					for _ = 1, 5 do pcall(fire, pr) end
				end

				local used = {}
				for _, partName in ipairs(CHAIR_PART_NAMES) do
					local part = chair:FindFirstChild(partName, true)
					if part and part:IsA("BasePart") and not used[part] then
						used[part] = true
						part.Anchored = false
						local bp = part:FindFirstChild("LeafChairForce")
						if not bp then
							bp = Instance.new("BodyPosition")
							bp.Name = "LeafChairForce"
							bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							bp.P = 1e5
							bp.D = 1e3
							bp.Parent = part
							table.insert(KillChairForces, bp)
						end
						-- offset lệch nhẹ mỗi part → dao động mạnh
						local ox = (math.random() - 0.5) * 12
						local oy = (math.random() - 0.5) * 8
						local oz = (math.random() - 0.5) * 12
						bp.Position = targetPos + Vector3.new(ox, oy, oz)
					end
				end
				-- fallback: mọi BasePart nếu thiếu tên
				if next(used) == nil then
					for _, part in ipairs(chair:GetDescendants()) do
						if part:IsA("BasePart") and not used[part] then
							used[part] = true
							part.Anchored = false
							local bp = part:FindFirstChild("LeafChairForce") or Instance.new("BodyPosition")
							bp.Name = "LeafChairForce"
							bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							bp.P = 1e5
							bp.Parent = part
							table.insert(KillChairForces, bp)
							bp.Position = targetPos + Vector3.new(math.random(-6, 6), math.random(-4, 4), math.random(-6, 6))
							if #KillChairForces >= 8 then break end
						end
					end
				end
			end
		end)
	end,
})

task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.KillPlayerWithChair
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.TextSize = math.max(10, (lbl.TextSize or 14) - 1)
			lbl.Text = '<font color="rgb(255,40,40)">Kill the player With a Chair</font>'
		end
	end)
end)

task.spawn(function()
	while task.wait(1) do
		local t = Toggles.KillPlayerWithChair
		if not t or not t.SetDisabled then continue end
		local floorVal = Floor and Floor.Value
		local ok = (floorVal == "Achiever" or floorVal == "The Achiever" or floorVal == "Achiver")
		t:SetDisabled(not ok)
		if not ok and t.Value then t:SetValue(false) end
	end
end)
local BringItemNames = {
	Key = true, KeyObtain = true,
	Vitamin = true, Vitamins = true,
	Lockpick = true, LockPick = true,
	Crucifix = true, SkeletonKey = true,
	Candle = true, Lighter = true, Flashlight = true, Shakelight = true,
	Battery = true, Bandage = true, AlarmClock = true,
}
local LeafBrought = {} -- [Instance] = {canCollide=..., massless=..., anchored=...}

BringBox:AddToggle("BringItem", {
	Text = "Bring Item",
	Default = false,
	Tooltip = "Bring Các Item trong phạm vi game cho phép",
	Callback = function(Value)
		if not Value then
			for obj, old in pairs(LeafBrought) do
				pcall(function()
					if obj and obj.Parent and obj:IsA("BasePart") then
						obj.CanCollide = old.canCollide
						obj.Massless = old.massless
						obj.Anchored = old.anchored
					end
				end)
			end
			table.clear(LeafBrought)
		end
	end,
})
local DestroyBox = Tabs.Other:AddRightGroupbox("Destroy", "bomb")

-- Hạ TV xuống void (Abysall Under Map Y=-120) — CHỮ ĐỎ
local function LeafLowerTV(tv)
	if not tv or not tv.Parent then return end
	pcall(function()
		for _, p in ipairs(tv:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = true
				p.CanCollide = false
			end
		end
		local pivot = tv:GetPivot()
		tv:PivotTo(CFrame.new(pivot.Position.X, -120, pivot.Position.Z))
	end)
end

-- Lật TV (Abysall Rotate & Lift Orientation 0,180,180)
local function LeafOverthrowTV(tv)
	if not tv or not tv.Parent then return end
	pcall(function()
		for _, p in ipairs(tv:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = true
				p.Orientation = Vector3.new(0, 180, 180)
			end
		end
		local pivot = tv:GetPivot()
		tv:PivotTo(pivot * CFrame.Angles(0, math.rad(180), math.rad(180)) * CFrame.new(0, 2, 0))
	end)
end

local function LeafFindNoiseTVs()
	local list = {}
	local function add(m)
		if m and m:IsA("Model") then
			local n = m.Name
			if n == "TV_Stand" or n == "Noise_TV" or n == "NoiseTV" then
				table.insert(list, m)
			end
		end
	end
	local misc = workspace:FindFirstChild("Misc")
	if misc then for _, c in ipairs(misc:GetChildren()) do add(c) end end
	for _, c in ipairs(workspace:GetChildren()) do add(c) end
	local char = LocalPlayer.Character
	if char then
		for _, t in ipairs(char:GetChildren()) do
			if t:IsA("Tool") then add(t) end
		end
	end
	return list
end

DestroyBox:AddToggle("LowerPositionTV", {
	Text = "Lower Position TV",
	Default = false,
	Risky = true,
	Tooltip = "Hạ TV Noise xuống Y=-120 Under Map",
	Callback = function(Value)
		if not Value then return end
		for _, tv in ipairs(LeafFindNoiseTVs()) do
			LeafLowerTV(tv)
		end
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.LowerPositionTV
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Lower Position TV</font>'
		end
	end)
end)

DestroyBox:AddToggle("BypassOverthrowTV", {
	Text = "Bypass Overthrow TV",
	Default = false,
	Tooltip = "Lật TV Noise Orientation",
	Callback = function(Value)
		if not Value then return end
		for _, tv in ipairs(LeafFindNoiseTVs()) do
			LeafOverthrowTV(tv)
		end
	end,
})
-- Teleport Entity: trước mặt entity 7.85 studs (double confirm)
local LeafTpEntityArmed = false
DestroyBox:AddButton({
	Text = "Teleport Entity",
	Func = function()
		if not LeafTpEntityArmed then
			LeafTpEntityArmed = true
			if Notify then Notify("Bạn chắc chắn?", 3) end
			task.delay(3, function() LeafTpEntityArmed = false end)
			return
		end
		LeafTpEntityArmed = false
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local names = {
			"RushMoving","AmbushMoving","BackdoorRush","A60","A120",
			"GlitchRush","GlitchAmbush","BashMoving","FrozenAmbush",
		}
		local best, bestD = nil, math.huge
		for _, n in ipairs(names) do
			local m = workspace:FindFirstChild(n)
			if m then
				local p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
				if p then
					local d = (p.Position - root.Position).Magnitude
					if d < bestD then bestD, best = d, p end
				end
			end
		end
		if not best then
			if Notify then Notify("Không thấy entity", 2) end
			return
		end
		-- dự đoán phía trước (LookVector * tốc độ ước lượng)
		local look = best.CFrame.LookVector
		local vel = best.AssemblyLinearVelocity
		if vel.Magnitude > 1 then look = vel.Unit end
		local target = best.Position + look * 7.85
		char:PivotTo(CFrame.new(target, target + look))
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		-- Obsidian button label đỏ (nếu có TextLabel trong group)
		for _, d in ipairs((DestroyBox.Container or DestroyBox.Object or Instance.new("Folder")):GetDescendants()) do
			if d:IsA("TextLabel") and d.Text == "Teleport Entity" then
				d.RichText = true
				d.Text = '<font color="rgb(255,40,40)">Teleport Entity</font>'
			end
		end
	end)
end)

-- Avoid Collisions Entities
local AvoidColConn = nil
DestroyBox:AddToggle("AvoidCollisionsEntities", {
	Text = "Avoid Collisions Entities",
	Default = false,
	Risky = true,
	Tooltip = "Pivot ra sau entity,có thể thất bại,Yêu Cầu Ping & FPS trên 30",
	Callback = function(Value)
		if AvoidColConn then
			task.cancel(AvoidColConn)
			AvoidColConn = nil
		end
		if not Value then return end
		AvoidColConn = task.spawn(function()
			local AvoidProfiles = {
				RushMoving   = { range = 200, back = 125 },
				AmbushMoving = { range = 275, back = 150 },
				A60          = { range = 256, back = 135 },
				A120         = { range = 140,  back = 95  },
				BashMoving   = { range = 300, back = 175 },
				GlitchRush   = { range = 300, back = 175 },
				GlitchAmbush = { range = 320, back = 175 },
				BackdoorRush = { range = 278, back = 175 },
				FrozenAmbush = { range = 285, back = 175 },
			}
			while Toggles.AvoidCollisionsEntities and Toggles.AvoidCollisionsEntities.Value do
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root and char then
					for name, conf in pairs(AvoidProfiles) do
						local m = workspace:FindFirstChild(name)
						local part = m and (m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart"))
						if part then
							local d = (part.Position - root.Position).Magnitude
							if d <= conf.range then
								local vel = part.AssemblyLinearVelocity
								local look = (vel.Magnitude > 5) and vel.Unit or part.CFrame.LookVector
								local future = part.Position + vel * 0.28
								local behind = future - look * conf.back
								local side = look:Cross(Vector3.yAxis)
								if side.Magnitude > 0.1 then
									behind = behind + side.Unit * 4
								end
								local ok = false
								for attempt = 1, 25 do
									if not (Toggles.AvoidCollisionsEntities and Toggles.AvoidCollisionsEntities.Value) then break end
									do
	
													-- behind đã tính sẵn (future - look * back)
local hx, hz = behind.X, behind.Z
local baseY = root.Position.Y

-- 1) TP ra sau entity
char:PivotTo(CFrame.new(hx, baseY, hz))

-- 2) Anchor rất ngắn rồi thả
root.Anchored = true
task.wait(0.001)
root.Anchored = false

-- 3) Reset lực — đứng im
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
	hum.PlatformStand = false
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
end

-- 4) Khôi phục sau 2s (nếu còn bật avoid + còn character)
task.delay(2, function()
	local c = LocalPlayer.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if not r then return end
	r.Anchored = false
	r.AssemblyLinearVelocity = Vector3.zero
	r.AssemblyAngularVelocity = Vector3.zero
end)

task.wait(0.01)
end
									local nr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
									if nr and (nr.Position - behind).Magnitude <= 12 then
										ok = true
										break
									end
									part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart") or part
									vel = part.AssemblyLinearVelocity
									look = (vel.Magnitude > 5) and vel.Unit or part.CFrame.LookVector
									future = part.Position + vel * 0.28
									behind = future - look * conf.back
								end
								if not ok and Notify then
									Notify("Né Va chạm.....Thất bại! (" .. name .. ")", 4)
								end
								task.wait(0.35)
							end
						end
					end
				end
				task.wait(0.05)
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.45)
	pcall(function()
		local t = Toggles.AvoidCollisionsEntities
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Avoid Collisions Entities</font>'
		end
	end)
end)
local OtherMainBox = Tabs.Other:AddRightGroupbox("Other-Main", "bomb")

OtherMainBox:AddToggle("DisableTimothyDamage", {
	Text = "Disable Hit Damage Of Timothy",
	Default = false,
	Risky = true,
	Tooltip = "Chặn jumpscare/sound + hook damage Timothy",
	Callback = function(Value)
		local folders = {
			ReplicatedStorage:FindFirstChild("ClientModules"),
			ReplicatedStorage:FindFirstChild("ModulesClient"),
		}
		for _, folder in ipairs(folders) do
			if folder then
				local sp = folder:FindFirstChild("SpiderJumpscare", true)
					or folder:FindFirstChild("_SpiderJumpscare", true)
				if sp then
					sp.Name = Value and "_SpiderJumpscare" or "SpiderJumpscare"
				end
			end
		end
	end,
})

do
	local hooked = false
	task.defer(function()
		if hooked or not hookmetamethod then return end
		hooked = true
		local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local method = getnamecallmethod()
			if Toggles.DisableTimothyDamage and Toggles.DisableTimothyDamage.Value then
				if method == "FireServer" or method == "InvokeServer" then
					local ln = string.lower(tostring(self.Name or ""))
					if ln:find("timothy") or ln:find("spider") then
						return
					end
				end
			end
			return oldNamecall(self, ...)
		end))
	end)
end

task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.DisableTimothyDamage
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.TextSize = math.max(10, (lbl.TextSize or 14) - 1)
			lbl.Text = '<font color="rgb(255,40,40)">Disable Hit Damage Of Timothy</font>'
		end
	end)
end)

local PlayerBox = Tabs.Main:AddLeftGroupbox('Body','person-standing')
local GameBox = Tabs.Main:AddLeftGroupbox('Game Management','gamepad-2')
local SubFloors = Tabs.Floor:AddSubTab("Floors", "building")
local SubExploit = Tabs.Floor:AddSubTab("Exploit", "biohazard")

local HotelFloor = SubFloors:AddLeftGroupbox("Hotel", "hotel")
local MinesFloor = SubFloors:AddRightGroupbox("Mines", "pickaxe")
local FoolsFloor = SubFloors:AddRightGroupbox("Fools", "ghost")
local RoomsFloor = SubFloors:AddLeftGroupbox("Rooms", "door-open")
local RetroFloor = SubFloors:AddLeftGroupbox("Retro", "clock")

local TargetBox = SubExploit:AddLeftGroupbox("Target", "crosshair")
-- Label vàng
TargetBox:AddLabel(
	'<font color="rgb(255,215,0)">Các hỗ trợ chỉ hoạt động Floor Rush Mode / Floor có Gun Gold</font>',
	true
)
TargetBox:AddToggle("AimBot", {
	Text = "Aim Bot",
	Default = false,
	Tooltip = "Aim Vào Entity",
})
TargetBox:AddToggle("AimWallCheck", {
	Text = "Wall Check",
	Default = true,
	Tooltip = "giúp kiểm tra tường Trước Khi Aim",
})
TargetBox:AddSlider("AimRange", {
	Text = "Aim Range",
	Default = 300,
	Min = 50,
	Max = 1200,
	Rounding = 0,
	Suffix = " studs",
})

local AimConn = nil
local function LeafAimEntities()
	local names = {
		"RushMoving", "AmbushMoving", "A60", "A120",
		"GlitchRush", "GlitchAmbush", "BackdoorRush",
		"BashMoving", "FrozenAmbush", "Lookman", "Eyes",
	}
	local list = {}
	for _, n in ipairs(names) do
		local m = workspace:FindFirstChild(n)
		if m then table.insert(list, m) end
	end
	return list
end
local function LeafStartAimBot(on)
	if AimConn then AimConn:Disconnect() AimConn = nil end
	if not on then return end
	AimConn = RunService.RenderStepped:Connect(function()
		if not (Toggles.AimBot and Toggles.AimBot.Value) then return end
		local cam = workspace.CurrentCamera
		local char = LocalPlayer.Character
		if not cam or not char then return end
		local range = (Options.AimRange and Options.AimRange.Value) or 300
		local wallOn = Toggles.AimWallCheck and Toggles.AimWallCheck.Value
		local origin = cam.CFrame.Position
		local best, bestDot = nil, -1
		for _, ent in ipairs(LeafAimEntities()) do
			local part = ent.PrimaryPart or ent:FindFirstChild("Head") or ent:FindFirstChildWhichIsA("BasePart")
			if not part then continue end
			local dist = (part.Position - origin).Magnitude
			if dist > range then continue end
			local dir = part.Position - origin
			if wallOn then
				local rp = RaycastParams.new()
				rp.FilterType = Enum.RaycastFilterType.Exclude
				rp.FilterDescendantsInstances = { char, ent }
				local hit = workspace:Raycast(origin, dir, rp)
				if hit and not hit.Instance:IsDescendantOf(ent) then continue end
			end
			local dot = cam.CFrame.LookVector:Dot(dir.Unit)
			if dot > bestDot then bestDot, best = dot, part end
		end
		if best then
			cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(origin, best.Position), 0.18)
		end
	end)
end
task.spawn(function()
	local last = false
	while true do
		local v = Toggles.AimBot and Toggles.AimBot.Value
		if v ~= last then last = v LeafStartAimBot(v) end
		task.wait(0.2)
	end
end)
-- ===== Auto Bring Item Drop =====
local AutoBringNotif = { t = 0, n = 0, told = {} }
local AutoBringConn = nil

TargetBox:AddToggle("AutoBringItemDrop", {
	Text = "Auto Bring Item Drop",
	Default = false,
	Tooltip = "Bring liên tục item drop",
	Callback = function(Value)
		if AutoBringConn then task.cancel(AutoBringConn) AutoBringConn = nil end
		if not Value then return end
		AutoBringConn = task.spawn(function()
			while Toggles.AutoBringItemDrop and Toggles.AutoBringItemDrop.Value do
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local drops = workspace:FindFirstChild("Drops")
				if root and drops then
					for _, drop in ipairs(drops:GetChildren()) do
						local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
						if not part then continue end
						-- bring gần đầu
						local target = root.CFrame * CFrame.new(0, 2.2, 0)
						pcall(function()
							if drop.PivotTo then drop:PivotTo(target)
							else part.CFrame = target end
						end)
						-- notify 1 lần / item, max 3 / 5s
						local now = tick()
						if now - AutoBringNotif.t > 5 then
							AutoBringNotif.t, AutoBringNotif.n = now, 0
							table.clear(AutoBringNotif.told)
						end
						local key = drop.Name .. "_" .. tostring(drop)
						if not AutoBringNotif.told[key] and AutoBringNotif.n < 3 then
							AutoBringNotif.told[key] = true
							AutoBringNotif.n += 1
							if Notify then Notify("Bring: " .. drop.Name, 2) end
						end
					end
				end
				task.wait(0.05)
			end
		end)
	end,
})
local ExploitOthersBox = SubExploit:AddLeftGroupbox("Others", "bomb")
ExploitOthersBox:AddToggle("GodModeFigure", {
	Text = "God Mode Figure",
	Default = false,
	Risky = true,
})
ExploitOthersBox:AddLabel(
	'<font color="rgb(255,80,80)">Cơ chế có thể thất bại nếu thực hiện khi Lag, Ping không ổn định</font>',
	true
)
ExploitOthersBox:AddDropdown("GodModeFigureMode", {
	Text = "Mode",
	Values = { "Flying Body", "Step Block" },
	Default = "Flying Body",
})
local ExploitOtherBox = SubExploit:AddLeftGroupbox("Main Exploitation", "boxes")
-- Enable Sprinting
ExploitOtherBox:AddToggle("EnableSprinting", {
	Text = "Enable Sprinting",
	Default = false,
	Tooltip = "Cho phép nhân vật chạy nước rút",
	Callback = function(Value)
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			end
			-- remote sprint nếu có
			if RemotesFolder and RemotesFolder:FindFirstChild("Sprint") then
				RemotesFolder.Sprint:FireServer(Value)
			end
			if char then
				char:SetAttribute("CanSprint", Value)
			end
		end)
	end,
})

-- Remove Closet Delay
ExploitOtherBox:AddToggle("RemoveClosetDelay", {
	Text = "Remove Closet Delay",
	Default = false,
	Tooltip = "Loại bỏ độ trễ khi nhân vật trốn tủ",
	Callback = function(Value)
		-- Abysall: bỏ cửa sổ không thoát tủ sau anim
		pcall(function()
			local char = LocalPlayer.Character
			if char then
				char:SetAttribute("ClosetExitDelay", Value and 0 or nil)
			end
		end)
	end,
})
-- loop nhẹ khi bật: clear hide cooldown attribute
task.spawn(function()
	while true do
		task.wait(0.2)
		if Toggles.RemoveClosetDelay and Toggles.RemoveClosetDelay.Value then
			local c = LocalPlayer.Character
			if c and c:GetAttribute("Hiding") then
				pcall(function()
					c:SetAttribute("HideTime", 0)
					c:SetAttribute("ClosetCooldown", 0)
				end)
			end
		end
	end
end)

-- Disable Idle Kick AFK (Abysall: getconnections Idled + VirtualUser)
ExploitOtherBox:AddToggle("DisableIdleKick", {
	Text = "Disable Idle Kick AFK",
	Default = false,
	Tooltip = "Chống Game kick khi AFK lâu",
	Callback = function(Value)
		pcall(function()
			if getconnections then
				for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
					if Value then conn:Disable() else conn:Enable() end
				end
			end
		end)
	end,
})
LocalPlayer.Idled:Connect(function()
	if Toggles.DisableIdleKick and Toggles.DisableIdleKick.Value then
		pcall(function()
			local VU = game:GetService("VirtualUser")
			VU:CaptureController()
			VU:ClickButton2(Vector2.new())
		end)
	end
end)

-- Auto Hide in Closet
local AutoHideConn = nil
ExploitOtherBox:AddToggle("AutoHideInCloset", {
	Text = "Auto Hide in Closet",
	Default = false,
	Tooltip = "Giúp tự động vào tủ khi có entity spam",
	Callback = function(Value)
		if AutoHideConn then task.cancel(AutoHideConn) AutoHideConn = nil end
		if not Value then return end
		local names = {
			RushMoving = true, AmbushMoving = true, A60 = true, A120 = true,
			GlitchRush = true, GlitchAmbush = true, BackdoorRush = true,
		}
		AutoHideConn = task.spawn(function()
			while Toggles.AutoHideInCloset and Toggles.AutoHideInCloset.Value do
				local threat = false
				for n in pairs(names) do
					if workspace:FindFirstChild(n) then threat = true break end
				end
				if threat and LocalPlayer.Character and not LocalPlayer.Character:GetAttribute("Hiding") then
					if LeafGetNearestCloset then
						local closet = LeafGetNearestCloset(100)
						if closet and LeafHideInCloset then
							pcall(LeafHideInCloset, closet)
						end
					else
						-- fallback: tìm Wardrobe gần + Firepp
						local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						local rooms = workspace:FindFirstChild("CurrentRooms")
						if root and rooms then
							local best, bd = nil, 80
							for _, inst in ipairs(rooms:GetDescendants()) do
								if inst.Name == "Wardrobe" or inst.Name == "Toolshed" or inst.Name == "Bed" then
									local p = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
									if p then
										local d = (p.Position - root.Position).Magnitude
										if d < bd then best, bd = inst, d end
									end
								end
							end
							if best then
								local hide = best:FindFirstChild("HidePrompt", true)
								local fire = Firepp or fireproximityprompt
								LocalPlayer.Character:PivotTo((best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")).CFrame * CFrame.new(0, 1.2, 0))
								if hide and fire then pcall(fire, hide) end
							end
						end
					end
				end
				task.wait(0.2)
			end
		end)
	end,
})

-- Spectate Entity
ExploitOtherBox:AddToggle("SpectateEntityToggle", {
	Text = "Spectate Entity",
	Default = false,
	Tooltip = "Giúp nhân vật & Entity quan sát khi trốn trong tủ",
})
ExploitOtherBox:AddDropdown("SpectateEntityMode", {
	Text = "Spectate Mode",
	Values = { "Entity To Player", "Player To Entity" },
	Default = "Entity To Player",
})
task.spawn(function()
	while true do
		task.wait(0.1)
		if not (Toggles.SpectateEntityToggle and Toggles.SpectateEntityToggle.Value) then continue end
		if not (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Hiding")) then continue end
		local mode = Options.SpectateEntityMode and Options.SpectateEntityMode.Value
		local cam = workspace.CurrentCamera
		local ent = workspace:FindFirstChild("RushMoving")
			or workspace:FindFirstChild("AmbushMoving")
			or workspace:FindFirstChild("A60")
		local ep = ent and (ent.PrimaryPart or ent:FindFirstChildWhichIsA("BasePart"))
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if cam and ep and root then
			if mode == "Player To Entity" then
				cam.CameraType = Enum.CameraType.Scriptable
				cam.CFrame = CFrame.lookAt(root.Position + Vector3.new(0, 2, 0), ep.Position)
			else
				cam.CameraType = Enum.CameraType.Scriptable
				cam.CFrame = CFrame.lookAt(ep.Position + Vector3.new(0, 3, 0), root.Position)
			end
		end
	end
end)

-- Skip Gate Room [Hotel] (Abysall)
local SkipGateConn = nil
ExploitOtherBox:AddToggle("SkipGateRooms", {
	Text = "Skip Gate Room [Hotel]",
	Default = false,
	Tooltip = "Giúp Skip nhân vật qua Room Gate",
	Callback = function(Value)
		if SkipGateConn then task.cancel(SkipGateConn) SkipGateConn = nil end
		if not Value then return end
		SkipGateConn = task.spawn(function()
			local skipped = {}
			while Toggles.SkipGateRooms and Toggles.SkipGateRooms.Value do
				local floorVal = Floor and Floor.Value
				if floorVal == "Hotel" or floorVal == "OldHotel" then
					local rooms = workspace:FindFirstChild("CurrentRooms")
					local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
					local room = rooms and roomNum and rooms:FindFirstChild(tostring(roomNum))
					if room and not skipped[roomNum] and roomNum ~= 100 then
						local isGate = room:FindFirstChild("LeverForGate", true)
							or room:FindFirstChild("Gate", true)
							or room:FindFirstChild("ThingToOpen", true)
						if isGate then
							local door = room:FindFirstChild("Door")
							local char = LocalPlayer.Character
							if door and char then
								char:PivotTo(door:GetPivot() * CFrame.new(0, 1, -3))
								local fire = Firepp or fireproximityprompt
								for _, pr in ipairs(door:GetDescendants()) do
									if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
								end
								if door:FindFirstChild("ClientOpen") then
									pcall(function() door.ClientOpen:FireServer() end)
								end
								skipped[roomNum] = true
							end
						end
					end
				end
				task.wait(0.25)
			end
		end)
	end,
})

-- Anti-Self Cart Fling
ExploitOtherBox:AddToggle("AntiSelfCartFling", {
	Text = "Anti-Self Cart Fling",
	Default = true,
	Tooltip = "Phòng chống xe đẩy ngã nhân vật",
	Callback = function(Value)
		-- no-collide cart vs character khi bật
	end,
})
task.spawn(function()
	while true do
		task.wait(0.3)
		if not (Toggles.AntiSelfCartFling and Toggles.AntiSelfCartFling.Value) then continue end
		local char = LocalPlayer.Character
		if not char then continue end
		for _, cart in ipairs(workspace:GetDescendants()) do
			if cart:IsA("Model") and (cart.Name:find("Cart") or cart.Name == "ShoppingCart") then
				for _, p in ipairs(cart:GetDescendants()) do
					if p:IsA("BasePart") then
						pcall(function()
							p.CanCollide = false
							p.CanTouch = false
						end)
					end
				end
			end
		end
	end
end)

-- Disable Entity JumpScares (Abysall: rename module)
ExploitOtherBox:AddToggle("DisableEntityJumpscares", {
	Text = "Disable Entity JumpScares",
	Default = false,
	Tooltip = "Vô hiệu hoá jumpscare entity",
	Callback = function(Value)
		pcall(function()
			local folders = {
				ReplicatedStorage:FindFirstChild("ClientModules"),
				ReplicatedStorage:FindFirstChild("ModulesClient"),
				ReplicatedStorage:FindFirstChild("Modules"),
			}
			for _, folder in ipairs(folders) do
				if not folder then continue end
				for _, name in ipairs({ "Jumpscare", "EntityJumpscare", "RushJumpscare", "AmbushJumpscare" }) do
					local m = folder:FindFirstChild(name, true)
					if m then
						m.Name = Value and (name .. "_Disabled") or name:gsub("_Disabled", "")
					end
					local md = folder:FindFirstChild(name .. "_Disabled", true)
					if md and not Value then md.Name = name end
				end
			end
		end)
	end,
})

-- Disable Firedamp Effect
ExploitOtherBox:AddToggle("DisableFiredampEffect", {
	Text = "Disable Firedamp Effect",
	Default = false,
	Tooltip = "Tắt hiệu ứng màn hình Firedamp",
	Callback = function(Value)
		pcall(function()
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if pg then
				for _, g in ipairs(pg:GetDescendants()) do
					local n = string.lower(g.Name)
					if n:find("firedamp") or n:find("fire_damp") then
						if g:IsA("ScreenGui") or g:IsA("Frame") or g:IsA("ImageLabel") then
							g.Enabled = not Value
							if g:IsA("ImageLabel") or g:IsA("Frame") then
								g.Visible = not Value
							end
						end
					end
				end
			end
			local cam = workspace.CurrentCamera
			if cam then
				for _, fx in ipairs(cam:GetChildren()) do
					if string.lower(fx.Name):find("firedamp") then
						fx.Enabled = not Value
					end
				end
			end
		end)
	end,
})
local KillPlayerBox = SubExploit:AddRightGroupbox("Kill Player", "ban")
KillPlayerBox:AddDropdown("KillPlayerTarget", {
	Text = "Target Player",
	Values = { "Nearest" },
	Default = 1,
})

task.spawn(function()
	while true do
		task.wait(2)
		local names = { "Nearest" }
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then table.insert(names, plr.Name) end
		end
		pcall(function()
			if Options.KillPlayerTarget then Options.KillPlayerTarget:SetValues(names) end
		end)
	end
end)

local function LeafPickKillTarget()
	local pick = Options.KillPlayerTarget and Options.KillPlayerTarget.Value or "Nearest"
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if pick ~= "Nearest" then
		local p = Players:FindFirstChild(pick)
		if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then return p end
	end
	local best, bd = nil, 500
	if not myRoot then return nil end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == LocalPlayer then continue end
		local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if r then
			local d = (r.Position - myRoot.Position).Magnitude
			if d < bd then best, bd = plr, d end
		end
	end
	return best
end

local function LeafFindKillEntity()
	-- ưu tiên 300 studs: Figure / Noise
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil, nil end
	local best, bd, kind = nil, 300, nil
	local function consider(model, k)
		local p = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
		if not p then return end
		local d = (p.Position - root.Position).Magnitude
		if d <= 300 and d < bd then best, bd, kind = model, d, k end
	end
	for _, n in ipairs({ "FigureRig", "FigureRagdoll", "Figure", "Noise", "Noise_TV", "NoiseModel", "TV_Stand" }) do
		local m = workspace:FindFirstChild(n, true)
		if m then consider(m, n) end
	end
	-- scan workspace children
	for _, m in ipairs(workspace:GetChildren()) do
		local ln = string.lower(m.Name)
		if ln:find("figure") or ln:find("noise") then consider(m, m.Name) end
	end
	return best, kind
end

KillPlayerBox:AddButton({
	Text = "Kill Player",
	DoubleClick = true,
	Func = function()
		local target = LeafPickKillTarget()
		if not target or not target.Character then
			if Notify then Notify("Thiếu player xung quanh!", 3) end
			return
		end
		local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
		local tHum = target.Character:FindFirstChildOfClass("Humanoid")
		if not tRoot then
			if Notify then Notify("Thiếu player / HRP!", 3) end
			return
		end

		local ent, entName = LeafFindKillEntity()
		if not ent then
			-- Kill brick fallback?
			local brick = workspace:FindFirstChild("KillBrick", true) or workspace:FindFirstChild("Kill", true)
			if brick and brick:IsA("BasePart") then
				pcall(function() brick.Size = Vector3.new(30, 30, 30) end)
				local conn
				local t0 = tick()
				conn = RunService.Heartbeat:Connect(function()
					if tick() - t0 > 5 then conn:Disconnect() return end
					pcall(function() brick:PivotTo(tRoot.CFrame) end)
					if tHum and tHum.Health <= 0 then
						conn:Disconnect()
						if Notify then Notify("Đã Kill thành công player " .. target.Name .. "!", 4) end
					end
				end)
				return
			end
			if Notify then Notify("Thiếu Figure / Noise / KillBrick trong 300 studs!", 3) end
			return
		end

		local part = ent.PrimaryPart or ent:FindFirstChildWhichIsA("BasePart")
		if not part then return end

		local hasNet = false
		pcall(function()
			if isnetworkowner and isnetworkowner(part) then hasNet = true end
		end)

		if hasNet then
			-- Bring entity part vào player khác 1 lần
			pcall(function()
				if ent.PivotTo then ent:PivotTo(tRoot.CFrame) else part.CFrame = tRoot.CFrame end
			end)
			local t0 = tick()
			task.spawn(function()
				while tick() - t0 < 5 do
					task.wait(0.2)
					local stillNear = false
					local myR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if myR and tRoot and tRoot.Parent and (tRoot.Position - myR.Position).Magnitude <= 500 then
						stillNear = true
					end
					local dead = tHum and tHum.Health <= 0
					if dead then
						if Notify then Notify("Đã Kill thành công player " .. target.Name .. "!", 4) end
						return
					end
					if not stillNear then break end
				end
			end)
		else
			-- Visual client: phóng hitbox + pivot 1 lần
			pcall(function()
				for _, p in ipairs(ent:GetDescendants()) do
					if p:IsA("BasePart") then
						p.Size = Vector3.new(15, 15, 15)
						p.CanCollide = true
						p.CanTouch = true
					end
				end
				if ent.PivotTo then ent:PivotTo(tRoot.CFrame) else part.CFrame = tRoot.CFrame end
			end)
			if Notify then
				Notify("Hiện tại Kill Player KHÔNG CÓ NETWORK OWNERSHIP — chỉ cố gắng kill Visual Client!", 5)
			end
		end
	end,
})

task.defer(function()
	task.wait(0.5)
	pcall(function()
	end)
end)
KillPlayerBox:AddToggle("DeleteOtherTools", {
	Text = "Delete Other People's Tools",
	Default = false,
	Tooltip = "Risk! Ép Tool/item Người Chơi khác Rơi+Phá Hủy thông Qua Pivot Set-Y, có Không khả Thi!",
	Callback = function(Value)
		if not Value then return end
		task.spawn(function()
			while Toggles.DeleteOtherTools and Toggles.DeleteOtherTools.Value do
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr == LocalPlayer then continue end
					local ch = plr.Character
					if not ch then continue end
					for _, tool in ipairs(ch:GetChildren()) do
						if tool:IsA("Tool") then
							local n = tool.Name
							-- vitamin, lockpick, sally...
							local interesting = n:lower():find("vitamin") or n:lower():find("lock")
								or n:lower():find("sally") or n:lower():find("crucifix")
								or n:lower():find("key") or n:lower():find("shears")
							if not interesting then continue end
							pcall(function()
								if RemotesFolder and RemotesFolder:FindFirstChild("DropItem") then
									-- không luôn fire được tool người khác; cố gắng local
								end
							end)
						end
					end
				end
				-- item ngoài (Drops): hub -4999
				local drops = workspace:FindFirstChild("Drops")
				if drops then
					for _, drop in ipairs(drops:GetChildren()) do
						local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
						if part and part.Position.Y > -99 then
							pcall(function()
								if drop.PivotTo then
									drop:PivotTo(CFrame.new(part.Position.X, -4999, part.Position.Z))
								else
									part.CFrame = CFrame.new(part.Position.X, -4999, part.Position.Z)
								end
							end)
							task.delay(1.5, function()
								local p2 = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
								if p2 and p2.Position.Y < -99 then
									if Notify then Notify("Delete Item/Tool Other People's Success!", 3) end
								else
									if Notify then Notify("Delete Item/Tool thất bại!", 3) end
								end
							end)
						end
					end
				end
				task.wait(0.4)
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.DeleteOtherTools
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then lbl.TextSize = math.max(10, (lbl.TextSize or 14) - 2) end
	end)
end)
local RemoveSnareConn, RemoveEyesConn = nil, nil

TargetBox:AddToggle("RemoveSnare", {
	Text = "Remove Snare",
	Default = false,
	Tooltip = "Xoá sổ Cạm bẫy Trap",
	Callback = function(Value)
		if RemoveSnareConn then task.cancel(RemoveSnareConn) RemoveSnareConn = nil end
		if not Value then return end
		local done = {}
		RemoveSnareConn = task.spawn(function()
			while Toggles.RemoveSnare and Toggles.RemoveSnare.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local function handleSnare(model)
						if not model or done[model] then return end
						local part = model.PrimaryPart or model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart")
						if not part then return end
						if (part.Position - root.Position).Magnitude > 175 then return end
						done[model] = true
						pcall(function()
							for _, p in ipairs(model:GetDescendants()) do
								if p:IsA("BasePart") then
									p.Size = Vector3.new(0.1, 0.1, 0.1)
									p.CanTouch = false
									p.CanCollide = false
								end
							end
							local pos = part.Position
							local cf = CFrame.new(pos.X, -499, pos.Z)
							if model.PivotTo then model:PivotTo(cf) else part.CFrame = cf end
						end)
					end
					-- workspace + CurrentRooms
					for _, obj in ipairs(workspace:GetChildren()) do
						if obj.Name == "Snare" then handleSnare(obj) end
					end
					local rooms = workspace:FindFirstChild("CurrentRooms")
					if rooms then
						for _, obj in ipairs(rooms:GetDescendants()) do
							if obj.Name == "Snare" then handleSnare(obj) end
						end
					end
				end
				task.wait(0.15)
			end
		end)
	end,
})

TargetBox:AddToggle("RemoveEyes", {
	Text = "Remove Eyes Lookman",
	Default = false,
	Tooltip = "Xoá Sổ Eye và Look man trog phòng",
	Callback = function(Value)
		if RemoveEyesConn then task.cancel(RemoveEyesConn) RemoveEyesConn = nil end
		if not Value then return end
		local done = {}
		RemoveEyesConn = task.spawn(function()
			while Toggles.RemoveEyes and Toggles.RemoveEyes.Value do
				local roomNum = LocalPlayer:GetAttribute("CurrentRoom")
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local room = rooms and roomNum and rooms:FindFirstChild(tostring(roomNum))
				local function handleEyes(model)
					if not model or done[model] then return end
					done[model] = true
					pcall(function()
						local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
						if not part then return end
						local pos = part.Position
						local cf = CFrame.new(pos.X, -499, pos.Z)
						if model.PivotTo then model:PivotTo(cf) else part.CFrame = cf end
						for _, p in ipairs(model:GetDescendants()) do
							if p:IsA("BasePart") then
								p.Anchored = true
							end
						end
					end)
				end
				local names = { "Eyes", "Lookman", "BackdoorLookman", "EyesRushMode" }
				if room then
					for _, n in ipairs(names) do
						local e = room:FindFirstChild(n, true)
						if e then handleEyes(e) end
					end
				end
				for _, n in ipairs(names) do
					local e = workspace:FindFirstChild(n)
					if e then handleEyes(e) end
				end
				task.wait(0.2)
			end
		end)
	end,
})
local DeleteJeffConn = nil
TargetBox:AddToggle("DeleteJeffFE", {
	Text = "Delete Jeff [FE]",
	Default = false,
	Risky = true,
	Tooltip = "Xoá Sổ Jeff The Killers Bypass FE Sever",
	Callback = function(Value)
		if DeleteJeffConn then task.cancel(DeleteJeffConn) DeleteJeffConn = nil end
		if not Value then return end
		-- tạm tắt Anti Jeff
		if Toggles.AntiJeff and Toggles.AntiJeff.Value then
			Toggles.AntiJeff:SetValue(false)
		end
		DeleteJeffConn = task.spawn(function()
			while Toggles.DeleteJeffFE and Toggles.DeleteJeffFE.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not root then task.wait(0.3) continue end
				local jeff = workspace:FindFirstChild("JeffTheKiller")
				if not jeff then
					for _, c in ipairs(workspace:GetChildren()) do
						if string.lower(c.Name):find("jeff") then jeff = c break end
					end
				end
				if not jeff then task.wait(0.3) continue end
				local jPart = jeff.PrimaryPart or jeff:FindFirstChild("HumanoidRootPart") or jeff:FindFirstChildWhichIsA("BasePart")
				if not jPart or (jPart.Position - root.Position).Magnitude > 95 then
					task.wait(0.25) continue
				end

				local hasNet = false
				pcall(function()
					if isnetworkowner and isnetworkowner(jPart) then hasNet = true end
				end)

				if hasNet then
					-- duyệt part → 0.05s → mất va chạm
					pcall(function()
						for _, p in ipairs(jeff:GetDescendants()) do
							if p:IsA("BasePart") then p.CanCollide = false p.CanTouch = false end
						end
					end)
					task.wait(0.05)
					pcall(function()
						for _, p in ipairs(jeff:GetDescendants()) do
							if p:IsA("BasePart") then p.CanCollide = false end
						end
						local hum = jeff:FindFirstChildOfClass("Humanoid")
						if hum then hum.Health = 0 end
						local cf = CFrame.new(jPart.Position.X, -49999, jPart.Position.Z)
						if jeff.PivotTo then jeff:PivotTo(cf) else jPart.CFrame = cf end
					end)
					if Notify then Notify("Delete Jeff FE Success!", 4) end
					break
				else
					-- set SimulationRadius sớm
					pcall(function()
						if sethiddenproperty then
							sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 1000)
							sethiddenproperty(LocalPlayer, "SimulationRadius", 1000)
						end
						if setsimulationradius then setsimulationradius(1000) end
					end)
					pcall(function()
						jeff:SetAttribute("LeafKillTag", true)
						for _, p in ipairs(jeff:GetDescendants()) do
							if p:IsA("BasePart") then
								p.Size = Vector3.new(60, 60, 60)
								p.CanCollide = true
								p.CanTouch = true
							end
						end
						local hum = jeff:FindFirstChildOfClass("Humanoid")
						if hum then
							pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
							hum.Health = 0
							hum.WalkSpeed = 1000
						end
					end)
					task.wait(0.5)
					local still = false
					local p = jeff.PrimaryPart or jeff:FindFirstChildWhichIsA("BasePart")
					if p and (p.Position - root.Position).Magnitude <= 120 then still = true end
					if not still then
						if Notify then Notify("Delete Jeff FE Success!", 4) end
						break
					else
						pcall(function()
							for _, bp in ipairs(jeff:GetDescendants()) do
								if bp:IsA("BasePart") then
									bp.CanCollide = false
									bp.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
								end
							end
							local hum = jeff:FindFirstChildOfClass("Humanoid")
							if hum then hum.WalkSpeed = 1000 end
						end)
						if Notify then Notify("Delete Jeff thất bại — đã gắn slide + WS 1000", 3) end
					end
				end
				task.wait(0.4)
			end
		end)
	end,
})
task.defer(function()
	local DeleteJeffClientConn = nil
TargetBox:AddToggle("DeleteJeffClient", {
	Text = "Delete Jeff [Client]",
	Default = false,
	Tooltip = "Cố gắng xoá jeff bên Client,Có tỉ lệ cao không hoạt động có thể gây Jeff kill",
	Callback = function(Value)
		if DeleteJeffClientConn then
			task.cancel(DeleteJeffClientConn)
			DeleteJeffClientConn = nil
		end
		if not Value then return end
		DeleteJeffClientConn = task.spawn(function()
			while Toggles.DeleteJeffClient and Toggles.DeleteJeffClient.Value do
				local jeff = workspace:FindFirstChild("JeffTheKiller")
				if not jeff then
					for _, c in ipairs(workspace:GetChildren()) do
						if typeof(c.Name) == "string" and string.lower(c.Name):find("jeff") then
							jeff = c
							break
						end
					end
				end
				if not jeff then
					task.wait(0.35)
					continue
				end

				pcall(function()
					for _, p in ipairs(jeff:GetDescendants()) do
						if p:IsA("BasePart") then
							p.CanCollide = false
							p.CanTouch = false
							p.AssemblyLinearVelocity = Vector3.zero
							p.AssemblyAngularVelocity = Vector3.zero
						end
					end
					local hum = jeff:FindFirstChildOfClass("Humanoid")
					if hum then
						pcall(function() hum:BreakJoints() end)
						hum.MaxHealth = 0
						hum.Health = 0
						pcall(function() hum:TakeDamage(999) end)
						hum.PlatformStand = true
					end
					local hrp = jeff:FindFirstChild("HumanoidRootPart") or jeff.PrimaryPart or jeff:FindFirstChildWhichIsA("BasePart")
					if hrp then
						local cf = CFrame.new(hrp.Position.X, -49999, hrp.Position.Z)
						if jeff.PivotTo then
							jeff:PivotTo(cf)
						else
							hrp.CFrame = cf
						end
						hrp.Anchored = true
						hrp.AssemblyLinearVelocity = Vector3.zero
						hrp.AssemblyAngularVelocity = Vector3.zero
					end
				end)

				task.wait(1.5)
				local p = jeff.PrimaryPart or jeff:FindFirstChildWhichIsA("BasePart")
				if p and p.Position.Y < -50 then
					if Notify then Notify("Delete Jeff Client Success!", 4) end
					break
				end
				task.wait(0.25)
			end
		end)
	end,
})
	task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.DeleteJeffFE
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Delete Jeff [FE]</font>'
		end
	end)
end)
local RemoveJackConn = nil
TargetBox:AddToggle("RemoveJack", {
	Text = "Remove Jack",
	Default = false,
	Tooltip = "Chặn Jack Spam,Âm thanh, Hình Ảnh của Jack",
	Callback = function(Value)
		if RemoveJackConn then
			for _, c in ipairs(RemoveJackConn) do pcall(function() c:Disconnect() end) end
			RemoveJackConn = nil
		end
		if not Value then return end
		RemoveJackConn = {}
		local function nuke(obj)
			if not obj or not obj.Parent then return end
			local n = string.lower(obj.Name)
			-- rộng hơn "jack": jumpscare / spider-like client FX
			if n:find("jack") or n:find("jumpscare") or n:find("closetmonster") then
				pcall(function()
					if obj:IsA("Sound") then obj.Volume = 0 obj:Stop() obj:Destroy()
					elseif obj:IsA("ScreenGui") or obj:IsA("Frame") or obj:IsA("ImageLabel") then obj:Destroy()
					elseif obj:IsA("ParticleEmitter") then obj.Enabled = false
					end
				end)
			end
		end
		-- PlayerGui event only
		local pg = LocalPlayer:FindFirstChild("PlayerGui")
		if pg then
			table.insert(RemoveJackConn, pg.DescendantAdded:Connect(nuke))
			for _, d in ipairs(pg:GetDescendants()) do
				if d:IsA("Sound") or d:IsA("ScreenGui") or d:IsA("Frame") then nuke(d) end
			end
		end
		local cam = workspace.CurrentCamera
		if cam then
			table.insert(RemoveJackConn, cam.DescendantAdded:Connect(nuke))
		end
		-- SoundService một lần + ChildAdded
		local ss = game:GetService("SoundService")
		table.insert(RemoveJackConn, ss.DescendantAdded:Connect(nuke))
	end,
})
local AutoBox = Tabs.Main:AddRightGroupbox('Auto','bot')
local ReachBox = Tabs.Main:AddRightGroupbox('Reach','maximize')
local CameraBox = Tabs.Visuals:AddLeftGroupbox('Camera','camera')
local LightingBox = Tabs.Visuals:AddLeftGroupbox('Lighting','sun')
local Aura999Conn = nil
local Aura999Parts = {}
LightingBox:AddToggle("Aura999", {
	Text = "Aura999",
	Default = false,
	Tooltip = "Làm nhân Vật Aura999,Sigma",
	Callback = function(Value)
		if Aura999Conn then
			Aura999Conn:Disconnect()
			Aura999Conn = nil
		end
		-- dọn
		for _, o in ipairs(Aura999Parts) do
			pcall(function() o:Destroy() end)
		end
		table.clear(Aura999Parts)
		local char = LocalPlayer.Character
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") and p:GetAttribute("LeafAura999") then
					pcall(function()
						p.Material = p:GetAttribute("LeafAuraMat") or Enum.Material.Plastic
						p.Color = Color3.new(1, 1, 1)
						p.Transparency = p:GetAttribute("LeafAuraT") or 0
					end)
					p:SetAttribute("LeafAura999", nil)
				end
			end
		end
		if not Value then return end

		local function apply(char)
			if not char then return end
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
					if not p:GetAttribute("LeafAura999") then
						p:SetAttribute("LeafAura999", true)
						p:SetAttribute("LeafAuraMat", p.Material.Name)
						p:SetAttribute("LeafAuraT", p.Transparency)
					end
					p.Material = Enum.Material.Glass
					p.Color = Color3.fromRGB(0, 100, 0) -- xanh lá đậm
					p.Transparency = 0.35
					-- highlight viền
					local hl = p:FindFirstChild("LeafAuraHL")
					if not hl then
						hl = Instance.new("Highlight")
						hl.Name = "LeafAuraHL"
						hl.FillColor = Color3.fromRGB(0, 180, 80)
						hl.OutlineColor = Color3.fromRGB(0, 200, 255) -- xanh lam
						hl.FillTransparency = 0.7
						hl.OutlineTransparency = 0.1
						hl.Adornee = char
						hl.Parent = char
						table.insert(Aura999Parts, hl)
						break -- 1 highlight cho cả model
					end
				end
			end
		end
		apply(LocalPlayer.Character)
		Aura999Conn = LocalPlayer.CharacterAdded:Connect(function(c)
			task.wait(0.3)
			if Toggles.Aura999 and Toggles.Aura999.Value then apply(c) end
		end)
	end,
})
local ESPBox = Tabs.Visuals:AddRightGroupbox('ESP','scan-eye')
local ESPSettings = Tabs.Visuals:AddRightGroupbox('Settings','sliders-horizontal')
local NotifyBox = Tabs.Visuals:AddRightGroupbox('Notifying','bell')
local BypassEntityBox = Tabs.Bypass:AddLeftGroupbox('Bypass Entities','ghost')
local BypassBox = Tabs.Bypass:AddRightGroupbox('Bypass','shield-check')
RetroFloor:AddToggle('AntiLava',{
Text = "Anti Lava",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Lava" then
v.CanTouch = not Value
end
end
end
})
FoolsFloor:AddToggle('AntiBanana',{
Text = "Anti Banana",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace:GetChildren()) do
if v.Name == "BananaPeel" then
v.CanTouch = not Value
end
end
end
})
local RemoveObstaclesC_Store = {} -- [part] = {CanCollide, Parent?}
local RemoveObstaclesC_Conn = nil

TargetBox:AddToggle("RemoveObstaclesC", {
	Text = "Remove Obstacles C",
	Default = false,
	Tooltip = "Tạm Thời Xoá Bỏ Part phải ngồi,Ẩn",
	Callback = function(Value)
		if RemoveObstaclesC_Conn then
			task.cancel(RemoveObstaclesC_Conn)
			RemoveObstaclesC_Conn = nil
		end
		if not Value then
			-- khôi phục
			for part, data in pairs(RemoveObstaclesC_Store) do
				pcall(function()
					if part and part.Parent then
						part.CanCollide = data.CanCollide
					end
				end)
			end
			table.clear(RemoveObstaclesC_Store)
			return
		end
		RemoveObstaclesC_Conn = task.spawn(function()
			while Toggles.RemoveObstaclesC and Toggles.RemoveObstaclesC.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local rooms = workspace:FindFirstChild("CurrentRooms")
					local function checkPart(p)
						if not p:IsA("BasePart") then return end
						if (p.Position - root.Position).Magnitude > 120 then return end
						-- Thuộc tính / tên gợi ý phải Crouch (C)
						local n = string.lower(p.Name)
						local needC = p:GetAttribute("RequiresCrouch")
							or p:GetAttribute("Crouch")
							or n:find("crouch")
							or n:find("crawl")
							or n:find("duct")
							or n:find("vent")
							or n:find("low")
						-- Hitbox thấp (phải cúi)
						local low = p.Size.Y > 0.5 and p.Size.Y < 3 and p.Size.X > 2
						if not needC and not low then return end
						if RemoveObstaclesC_Store[p] then return end
						local vol = p.Size.X * p.Size.Y * p.Size.Z
						RemoveObstaclesC_Store[p] = { CanCollide = p.CanCollide }
						if vol >= 8 then
							-- to: tắt va chạm
							p.CanCollide = false
						else
							-- nhỏ: tắt + destroy
							p.CanCollide = false
							pcall(function() p:Destroy() end)
						end
					end
					if rooms then
						for _, d in ipairs(rooms:GetDescendants()) do
							checkPart(d)
						end
					end
				end
				task.wait(0.25)
			end
		end)
	end,
})
-- Remove Giggle
local RemoveGiggleConn = nil
TargetBox:AddToggle("RemoveGiggle", {
	Text = "Remove Giggle",
	Default = false,
	Callback = function(Value)
		if RemoveGiggleConn then task.cancel(RemoveGiggleConn) RemoveGiggleConn = nil end
		if not Value then return end
		local done = {}
		RemoveGiggleConn = task.spawn(function()
			while Toggles.RemoveGiggle and Toggles.RemoveGiggle.Value do
				local roomNum = LocalPlayer:GetAttribute("CurrentRoom")
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local room = rooms and rooms:FindFirstChild(tostring(roomNum))
				local function hit(m)
					if not m or done[m] then return end
					done[m] = true
					pcall(function()
						for _, p in ipairs(m:GetDescendants()) do
							if p:IsA("BasePart") then p.Size = Vector3.new(0.1, 0.1, 0.1) end
						end
						local part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
						if part then
							local cf = CFrame.new(part.Position.X, -99, part.Position.Z)
							if m.PivotTo then m:PivotTo(cf) else part.CFrame = cf end
						end
					end)
				end
				if room then
					for _, o in ipairs(room:GetDescendants()) do
						if o.Name == "Giggle" or o.Name == "GiggleCeiling" then hit(o) end
					end
				end
				task.wait(0.2)
			end
		end)
	end,
})

-- Delete Grumble
local GrumbleCount = 0
local DeleteGrumbleConn = nil
TargetBox:AddToggle("DeleteGrumble", {
	Text = "Delete Grumble",
	Default = false,
	Callback = function(Value)
		if DeleteGrumbleConn then
			if typeof(DeleteGrumbleConn) == "RBXScriptConnection" then DeleteGrumbleConn:Disconnect()
			else task.cancel(DeleteGrumbleConn) end
			DeleteGrumbleConn = nil
		end
		if not Value then return end
		local elevating = {}
		DeleteGrumbleConn = RunService.Heartbeat:Connect(function()
			if not (Toggles.DeleteGrumble and Toggles.DeleteGrumble.Value) then return end
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not root then return end
			for _, m in ipairs(workspace:GetChildren()) do
				if not (m.Name == "Grumble" or m.Name:find("Grumble")) then continue end
				if m.Name:find("Queen") then continue end
				local part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
				if not part or (part.Position - root.Position).Magnitude > 60 then continue end
				local hasNet = false
				pcall(function() if isnetworkowner and isnetworkowner(part) then hasNet = true end end)
				if not elevating[m] then
					elevating[m] = { t0 = tick(), baseY = part.Position.Y }
					pcall(function()
						for _, p in ipairs(m:GetDescendants()) do
							if p:IsA("BasePart") then
								p.CanCollide = false
								p.Size = Vector3.new(1, 1, 1)
							end
						end
					end)
				end
				local info = elevating[m]
				local y = info.baseY + 6.5
				pcall(function()
					part.CFrame = CFrame.new(part.Position.X, y, part.Position.Z)
				end)
				if hasNet and (tick() - info.t0) >= 1 then
					pcall(function()
						if m.PivotTo then m:PivotTo(CFrame.new(part.Position.X, -1000, part.Position.Z)) end
					end)
					task.delay(6, function()
						local p2 = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
						local r2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						if not p2 or not r2 or (p2.Position - r2.Position).Magnitude > 100 then
							GrumbleCount += 1
							if Notify then Notify(string.format("Delete Grumble Success %02d", GrumbleCount), 3) end
						end
					end)
					elevating[m] = nil
				end
				-- không net: không dừng, cứ elevate
			end
		end)
	end,
})

-- Delete Queen Grumble [FE] button đỏ
TargetBox:AddButton({
	Text = "Delete Queen Grumble [FE]",
	DoubleClick = true,
	Func = function()
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local queen = nil
		for _, m in ipairs(workspace:GetChildren()) do
			if m.Name:find("Queen") and m.Name:find("Grumble") then queen = m break end
			if m.Name == "QueenGrumble" or m.Name == "GrumbleQueen" then queen = m break end
		end
		if not queen then
			if Notify then Notify("Không phát hiện thấy Queen Grumble!", 3) end
			return
		end
		local part = queen.PrimaryPart or queen:FindFirstChildWhichIsA("BasePart")
		if not part or (part.Position - root.Position).Magnitude > 150 then
			if Notify then Notify("Không phát hiện thấy Queen Grumble (≤150)!", 3) end
			return
		end
		pcall(function()
			for _, p in ipairs(queen:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
			if queen.ScaleTo then queen:ScaleTo(0.15) end -- thu nhỏ model
			for _, p in ipairs(queen:GetDescendants()) do
				if p:IsA("BasePart") then p.Size = Vector3.new(5, 5, 5) end
			end
		end)
		local hasNet = false
		pcall(function() if isnetworkowner and isnetworkowner(part) then hasNet = true end end)
		if hasNet then
			pcall(function()
				if queen.PivotTo then queen:PivotTo(CFrame.new(part.Position.X, -29999, part.Position.Z)) end
			end)
		else
			pcall(function()
				if sethiddenproperty then
					sethiddenproperty(LocalPlayer, "SimulationRadius", 1000)
					sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 1000)
				end
				if setsimulationradius then setsimulationradius(1000) end
			end)
			local y = -20000 - math.random(0, 10000)
			pcall(function()
				if queen.PivotTo then queen:PivotTo(CFrame.new(part.Position.X, y, part.Position.Z)) end
			end)
		end
		local t0 = tick()
		local conn
		conn = RunService.Heartbeat:Connect(function()
			if tick() - t0 > 3.5 then conn:Disconnect() return end
			local p2 = queen.PrimaryPart or queen:FindFirstChildWhichIsA("BasePart")
			local r2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if p2 and r2 and (p2.Position - r2.Position).Magnitude <= 100 then
				local yy = -20000 - math.random(0, 10000)
				pcall(function()
					if queen.PivotTo then queen:PivotTo(CFrame.new(p2.Position.X, yy, p2.Position.Z)) end
				end)
			end
			if p2 and p2.Position.Y < -500 then
				conn:Disconnect()
				if Notify then Notify("Delete Queen Grumble Success!!!", 4) end
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.45)
	pcall(function()
		for _, b in pairs(Buttons or {}) do
			if typeof(b) == "table" and b.Text and tostring(b.Text):find("Queen Grumble") then
				local lbl = b.TextLabel or (b.Object and b.Object:FindFirstChildWhichIsA("TextLabel", true))
				if lbl then
					lbl.RichText = true
					lbl.Text = '<font color="rgb(255,40,40)">Delete Queen Grumble [FE]</font>'
				end
			end
		end
	end)
end)
local DeleteFigMineConn = nil
MinesFloor:AddToggle("DeleteFigureMine", {
	Text = "Delete Figure Mine",
	Default = false,
	Risky = true,
	Tooltip = "Xoá Figure khỏi sever The Mine,Có thể thất bại",
	Callback = function(Value)
		if DeleteFigMineConn then task.cancel(DeleteFigMineConn) DeleteFigMineConn = nil end
		if not Value then return end
		DeleteFigMineConn = task.spawn(function()
			local t0 = tick()
			while Toggles.DeleteFigureMine and Toggles.DeleteFigureMine.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local figs = LeafFindFigures(400, root, nil) -- mines: không whitelist hotel
				-- ưu tiên workspace Figure
				for _, n in ipairs({ "FigureRig", "FigureRagdoll", "Figure" }) do
					local m = workspace:FindFirstChild(n)
					if m then table.insert(figs, m) end
				end
				for _, fig in ipairs(figs) do
					local part = fig.PrimaryPart or fig:FindFirstChild("HumanoidRootPart") or fig:FindFirstChildWhichIsA("BasePart")
					if not part then continue end
					if LeafHasNet(part) then
						pcall(function()
							part.Position = Vector3.new(-49999, -49999, -49999)
						end)
					else
						pcall(function()
							for _, p in ipairs(fig:GetDescendants()) do
								if p:IsA("BasePart") then
									p.CanCollide = false
									p.AssemblyLinearVelocity = Vector3.zero
									p.AssemblyAngularVelocity = Vector3.zero
								end
							end
							local coll = fig:FindFirstChild("Collision", true)
								or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CollisionClone"))
							if coll and coll:IsA("BasePart") then
								coll.Size = Vector3.new(1, 1, 1)
							end
							for _, d in ipairs(fig:GetDescendants()) do
								local ln = string.lower(d.Name)
								if ln:find("trigger") then
									if d:IsA("BasePart") then
										d.CanTouch = false
										d.CanCollide = false
									end
								end
							end
						end)
					end
				end
				if tick() - t0 >= 5 then
					local ok = false
					for _, fig in ipairs(figs) do
						local p = fig.PrimaryPart or fig:FindFirstChildWhichIsA("BasePart")
						if p and p.Position.Y < -1000 then ok = true break end
					end
					if ok and Notify then Notify("Delete Figure Success!!", 4) end
					t0 = tick()
				end
				task.wait(0.2)
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.DeleteFigureMine
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Delete Figure Mine</font>'
		end
	end)
end)
-- Remove Kill Brick [FE]
local RemoveKBConn = nil
TargetBox:AddToggle("RemoveKillBrickFE", {
	Text = "Remove Kill Brick [FE]",
	Default = false,
	Tooltip = "Giúp loại bỏ Trigger Kill Bricks — có thể không hoạt động!",
	Callback = function(Value)
		if RemoveKBConn then task.cancel(RemoveKBConn) RemoveKBConn = nil end
		if not Value then return end
		RemoveKBConn = task.spawn(function()
			while Toggles.RemoveKillBrickFE and Toggles.RemoveKillBrickFE.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					for _, inst in ipairs(workspace:GetDescendants()) do
						if inst.Name == "KillBrick" or inst.Name == "Kill" or inst.Name:find("KillBrick") then
							local p = inst:IsA("BasePart") and inst or inst:FindFirstChildWhichIsA("BasePart")
							if p and (p.Position - root.Position).Magnitude <= 350 then
								pcall(function()
									p.CanCollide = false
									p.CanTouch = false
									p.Size = Vector3.new(1, 1, 1)
									p.CFrame = CFrame.new(p.Position.X, -1000, p.Position.Z)
								end)
								task.delay(5, function()
									if p and p.Position.Y < -100 then
										if Notify then Notify("Loại Bỏ Kill Brick Thành Công!", 3) end
									end
								end)
							end
						end
					end
				end
				task.wait(0.4)
			end
		end)
	end,
})
FoolsFloor:AddToggle('AntiJeff',{
Text = "Anti Jeff",
Default = false,
Callback = function(Value)
local v = workspace:FindFirstChild("JeffTheKiller")
if v.Name == "JeffTheKiller" then
repeat task.wait() until v.PrimaryPart and isnetworkowner(v.PrimaryPart)
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = Value and false or true
end
end
v.Humanoid.Health = Value and 0 or 100
end
end
})
GameBox:AddButton({
Text = "Revive",
DoubleClick = true,
Func = function()
RemotesFolder.Revive:FireServer()
end
})
GameBox:AddButton({
Text = "Play Again",
DoubleClick = true,
Func = function()
RemotesFolder.PlayAgain:FireServer()
end
})
local Pressed = false
GameBox:AddButton({
Text = "Reset",
DoubleClick = true,
Func = function()
Pressed = not Pressed
if not Pressed then
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(false)
end
return
end
if ReplicateSignal then
replicatesignal(LocalPlayer.Kill)
else
Notify("Double Click to stop", 5)
task.spawn(function()
while Pressed and LocalPlayer:GetAttribute("Alive") ~= false do
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(true)
end
task.wait()
end
if RemotesFolder:FindFirstChild("Underwater") then
RemotesFolder.Underwater:FireServer(false)
end
Pressed = false
end)
end
end
})
GameBox:AddButton({
Text = "Lobby",
DoubleClick = true,
Func = function()
RemotesFolder.Lobby:FireServer()
end
})
-- Teleport Void (Abysall Debug Void ≈ Y -120)
BypassBox:AddButton({
	Text = "Teleport Void",
	Func = function()
		local char = LocalPlayer.Character
		if not char then return end
		local pivot = char:GetPivot()
		-- Pivot + Vector3 Y âm
		char:PivotTo(pivot + Vector3.new(0, -120, 0))
	end,
})

-- helpers Next Door
local function getNextClosedDoor()
	local char = LocalPlayer.Character
	if not char then return nil end
	local GameData = ReplicatedStorage:FindFirstChild("GameData")
	if not GameData then return nil end
	local LR = GameData:FindFirstChild("LatestRoom")
	if not LR then return nil end
	local startRoom = LR.Value
	local bestDoor, bestNumber = nil, math.huge
	local rooms = workspace:FindFirstChild("CurrentRooms")
	if not rooms then return nil end
	for _, room in ipairs(rooms:GetChildren()) do
		local roomNum = tonumber(room.Name)
		if roomNum and roomNum ~= 100 and roomNum >= startRoom and roomNum < bestNumber then
			local door = room:FindFirstChild("Door")
			if door and door:IsA("Model") then
				local openAttr = door:GetAttribute("Open")
				if openAttr == false or openAttr == nil then
					bestNumber = roomNum
					bestDoor = door
				end
			end
		end
	end
	return bestDoor, bestNumber
end

BypassBox:AddButton({
	Text = "Teleport To Next Door",
	Func = function()
		local door = getNextClosedDoor()
		local char = LocalPlayer.Character
		if door and char then
			char:PivotTo(door:GetPivot() * CFrame.new(0, -1, 0))
		end
	end,
})
BypassBox:AddButton({
	Text = "Teleport Paradise",
	Func = function()
		local char = LocalPlayer.Character
		if not char then return end
		char:PivotTo(CFrame.new(93535509864777744550000000000, 50, 0))
	end,
})

BypassBox:AddDropdown("TeleportPlayerTarget", {
	Text = "Teleport Player Target",
	Values = { "Nearest" },
	Default = "Nearest",
})
task.spawn(function()
	while task.wait(2) do
		if not Options.TeleportPlayerTarget then break end
		local names = { "Nearest" }
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then table.insert(names, plr.Name) end
		end
		pcall(function() Options.TeleportPlayerTarget:SetValues(names) end)
	end
end)

BypassBox:AddButton({
	Text = "Teleport Player",
	Func = function()
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local pick = Options.TeleportPlayerTarget and Options.TeleportPlayerTarget.Value or "Nearest"
		local targetPlr = nil
		if pick ~= "Nearest" then
			targetPlr = Players:FindFirstChild(pick)
		end
		if not targetPlr then
			local best, bestD = nil, math.huge
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
					if d < bestD then bestD, best = d, plr end
				end
			end
			targetPlr = best
		end
		if targetPlr and targetPlr.Character then
			local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
			if tRoot then
				char:PivotTo(tRoot.CFrame * CFrame.new(0, 0, 3))
			end
		end
	end,
})
local TpNextDoorConnection = nil
BypassBox:AddToggle("TpNextDoor", {
	Text = "Auto TP Next Door",
	Default = false,
	Tooltip = "Liên tục TP tới cửa chưa mở kế tiếp (Abysall)",
	Callback = function(Value)
		if TpNextDoorConnection then
			task.cancel(TpNextDoorConnection)
			TpNextDoorConnection = nil
		end
		if not Value then return end
		TpNextDoorConnection = task.spawn(function()
			while Toggles.TpNextDoor and Toggles.TpNextDoor.Value do
				local door = getNextClosedDoor()
				local char = LocalPlayer.Character
				if door and char then
					char:PivotTo(door:GetPivot() * CFrame.new(0, -1, 0))
				end
				task.wait(0.15)
			end
			TpNextDoorConnection = nil
		end)
	end,
})
FoolsFloor:AddToggle('InfRevive',{
Text = "Infinite Revive",
Default = false
})
FoolsFloor:AddToggle('DeleteSeekFE',{
Text = "Delete Seek (FE)",
Default = false,
Callback = function(Value)
if Value then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "TriggerEventCollision" then
Notify("Deleting Seek",3)
for _, i  in pairs(v:GetChildren()) do
if i.Name == "Collision" then
if FireTouch then
firetouchinterest(LocalPlayer.Character.HumanoidRootPart, i, 0)
end
end
end
task.wait(0.5)
if v:FindFirstChild("Collision") then
Notify("Failed to remove Seek", 3)
else
Notify("Deleted Seek Successfully", 3)
end
end
end
end
end
})
local DeleteFigFoolsConn = nil
FoolsFloor:AddToggle("DeleteFigureFools", {
	Text = "Delete Figure Fools",
	Default = false,
	Tooltip = "Cố Gắng Kill Figure Void và Trigger,có thể thất bại",
	Callback = function(Value)
		if DeleteFigFoolsConn then
			if typeof(DeleteFigFoolsConn) == "RBXScriptConnection" then
				DeleteFigFoolsConn:Disconnect()
			else
				task.cancel(DeleteFigFoolsConn)
			end
			DeleteFigFoolsConn = nil
		end
		if not Value then return end
		local allow = { [50] = true, [100] = true }
		local tMark = tick()
		DeleteFigFoolsConn = task.spawn(function()
			while Toggles.DeleteFigureFools and Toggles.DeleteFigureFools.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not root then task.wait(0.3) continue end
				local figs = LeafFindFigures(300, root, allow)
				for _, fig in ipairs(figs) do
					-- không bắt buộc net: luôn tắt collide + thu size
					pcall(function()
						for _, p in ipairs(fig:GetDescendants()) do
							if p:IsA("BasePart") then
								p.CanCollide = false
								p.CanTouch = false
							end
						end
						local coll = fig:FindFirstChild("Collision", true) or fig:FindFirstChild("Hitbox", true)
						if coll and coll:IsA("BasePart") then
							coll.Size = Vector3.new(1, 1, 1)
						end
					end)
					local part = fig.PrimaryPart or fig:FindFirstChildWhichIsA("BasePart")
					-- khi CÓ net: spam random position
					task.spawn(function()
						local guard = 0
						while Toggles.DeleteFigureFools and Toggles.DeleteFigureFools.Value and part and part.Parent and guard < 200 do
							if LeafHasNet(part) then
								pcall(function()
									part.Position = Vector3.new(
										math.random(-29999, 29999),
										math.random(-29999, 29999),
										math.random(-29999, 29999)
									)
								end)
							else
								break
							end
							guard += 1
							task.wait()
						end
					end)
				end

				-- Bước 2 song song: vô hiệu trigger + neo part gần figure
				local rooms = workspace:FindFirstChild("CurrentRooms")
				if rooms then
					for _, rn in ipairs({ "50", "100" }) do
						local room = rooms:FindFirstChild(rn)
						if room then
							for _, d in ipairs(room:GetDescendants()) do
								local n = string.lower(d.Name)
								if n:find("trigger") or n:find("figure") and (n:find("hit") or n:find("kill") or n:find("collision")) then
									pcall(function()
										if d:IsA("BasePart") then
											d.CanTouch = false
											d.CanCollide = false
										elseif d:IsA("ProximityPrompt") then
											d.Enabled = false
										end
									end)
								end
							end
						end
					end
				end
				for _, fig in ipairs(figs) do
					local fp = fig.PrimaryPart or fig:FindFirstChildWhichIsA("BasePart")
					if not fp or not root then continue end
					if (fp.Position - root.Position).Magnitude > 200 then continue end
					local best, bd = nil, 30
					local room = fp:FindFirstAncestorOfClass("Model")
					local scope = room and room.Parent or workspace
					for _, p in ipairs(scope:GetDescendants()) do
						if p:IsA("BasePart") and not p:IsDescendantOf(fig) then
							local d = (p.Position - fp.Position).Magnitude
							if d < bd then best, bd = p, d end
						end
					end
					if best then
						pcall(function()
							best.Anchored = true
							best.CFrame = fp.CFrame
						end)
					end
				end

				if tick() - tMark >= 3 then
					local still = false
					for _, fig in ipairs(figs) do
						local p = fig.PrimaryPart or fig:FindFirstChildWhichIsA("BasePart")
						if p and root and (p.Position - root.Position).Magnitude < 100 then
							still = true
							break
						end
					end
					if still and Notify then Notify("Delete Figure Fools: thất bại!", 3) end
					tMark = tick()
				end
				task.wait(0.25)
			end
		end)
	end,
})
RetroFloor:AddToggle('AntiWall',{
Text = "Anti SeekWall",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "ScaryWall" then
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = not Value
end
end
end
end
end
})
RetroFloor:AddToggle('RealBridge',{
Text = "Show Real Bridge",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Bridge" then
if v.CanCollide == false then
v.Transparency = Value and 1 or 0
end
end
end
end
})
local Figures = {}
MinesFloor:AddToggle('DeleteFigureFE',{
Text = "Delete Figure (FE)",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "FigureRig" or v.Name == "FigureRagdoll" then
table.insert(Figures,v)
end
end
end
})
MinesFloor:AddToggle('ShowPath',{
Text = "Show Seek Path",
Default = false,
Callback = function(Value)
if Value then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "SeekGuidingLight" then
ShowSeekPath(v)
end
end
else
SeekPath:ClearAllChildren()
end
end
})
MinesFloor:AddToggle('FixBrokenBridge',{
Text = "Auto Fix BrokenBridge",
Default = false,
Callback = function(Value)
if Value then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Bridge" then
FixBridge(v)
end
end
else
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "BridgeBarrier" then
v:Destroy()
end
end
end
end
})
local DuckBoards = {}
local Nodes = {}
local Control
if Require then
	local ok, controls = pcall(function()
		return require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
	end)
	if ok and controls and controls.GetMoveVector then
		Control = controls.GetMoveVector
	end
    end
MinesFloor:AddToggle('AutoMinecart',{
Text = "Auto Minecart",
Risky = true,
Default = false,
Callback = function(Value)
if Value then
for _, v in workspace.CurrentRooms:GetDescendants() do
if v.Name == "DuckBoard" then
table.insert(DuckBoards, v)
end
if string.find(v.Name, "MinecartNode") then
table.insert(Nodes, v)
end
end
else
if Control then
	require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = Control
end
table.clear(DuckBoards)
end
end
})
local Anchors = {}
MinesFloor:AddToggle('AutoAnchorSolver',{
Text = "Auto Anchor Solver",
Default = false,
Callback = function(Value)
if Value then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "MinesAnchor" then
table.insert(Anchors,v)
end
end
end
end
})
MinesFloor:AddToggle('AntiSeekFlood',{
Text = "Anti Seek Flood",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "SeekFloodline" then
v.CanCollide = Value
end
end
end
})
MinesFloor:AddButton({
	Text = "Complete Dam Seek",
	Func = function()
		pcall(function()
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if not rooms then return end
			for _, v in ipairs(rooms:GetDescendants()) do
				if v.Name == "TriggerEventCollision" or v.Name:find("Seek") then
					local coll = v:FindFirstChild("Collision")
					local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if coll and root and (FireTouch or firetouchinterest) then
						local ft = FireTouch or firetouchinterest
						ft(root, coll, 0)
						task.wait()
						ft(root, coll, 1)
					end
				end
			end
			if Notify then Notify("Complete Dam Seek fired", 3) end
		end)
	end,
})

MinesFloor:AddToggle("TeleportMinecraft", {
	Text = "Teleport Minecraft",
	Default = false,
	Risky = true,
	Tooltip = "Tự động dịch chuyển đến đích khi ngồi trên xe Minecraft,Có thể gây Chết,Mất xe",
	Callback = function(Value)
		if not Value then return end
		task.spawn(function()
			task.wait(1)
			pcall(function()
				local rooms = workspace:FindFirstChild("CurrentRooms")
				for _, d in ipairs((rooms or workspace):GetDescendants()) do
					if d.Name:find("Minecraft") or d.Name:find("Minecart") and d.Name:find("End") then
						local p = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
						local char = LocalPlayer.Character
						if p and char then
							char:PivotTo(p.CFrame * CFrame.new(0, 3, 0))
							break
						end
					end
				end
			end)
		end)
	end,
})
task.defer(function()
	task.wait(0.35)
	pcall(function()
		local t = Toggles.TeleportMinecraft
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Teleport Minecraft</font>'
		end
	end)
end)

MinesFloor:AddToggle("AntiPipeGap", {
	Text = "Anti Pipe-Gap",
	Default = false,
	Tooltip = "Chống Kill Brick ở khe hở ống",
	Callback = function(Value)
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				local n = string.lower(d.Name)
				if n:find("pipe") or n:find("gap") then
					if d:IsA("BasePart") then
						d.CanTouch = not Value
						if Value then d.CanCollide = true end
					end
				end
			end
		end)
	end,
})
RoomsFloor:AddToggle('AutoRooms',{
Text = "Auto A-1000",
Default = false,
Callback = function(Value)
if not Value then
PathFolder:ClearAllChildren()
if LocalPlayer.Character then
LocalPlayer.Character.Collision.Size = Vector3.new(5.5,3,3)
LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
PathActive = false
end
end
end
})
if (getrawmetatable or debug.getmetatable) and (setreadonly or make_writeable) and newcclosure then
local getmt = getrawmetatable or debug.getmetatable
local setro = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
local mt = getmt(game)
local oldIndex = mt.__index
setro(mt, false)
mt.__index = newcclosure(function(t, k)
if not checkcaller() and k == "MoveDirection" and t:IsA("Humanoid") then
local char = LocalPlayer.Character
if char and Toggles.AutoRooms.Value and not char:GetAttribute("Hiding") then
return Vector3.new(0, 0, 1)
end
end
return oldIndex(t, k)
end)
setro(mt, true)
end
RoomsFloor:AddToggle('IgnoreA60',{
Text = "Ignore A-60",
})
ESPSettings:AddToggle('ShowDistance',{
Text = "Show ESP Distance",
Default = true,
Callback = function(Value)
ESPLibrary:SetShowDistance(Value)
end
})
ESPSettings:AddToggle('ShowTracers',{
Text = "Show ESP Tracers",
Default = false,
Callback = function(Value)
ESPLibrary:SetTracers(Value)
end
})
ESPSettings:AddToggle('ShowRainbow',{
Text = "Show ESP Rainbow",
Default = false,
Callback = function(Value)
ESPLibrary:SetRainbow(Value)
end
})
ESPSettings:AddDropdown("SetESPMode", {
Text = "Set ESP Mode",
Values = {"Highlight/Text", "Text", "Highlight"},
Default = 1,
Multi = false,
Callback = function(Value)
ESPLibrary:SetESPMode(Value)
end
})
ESPSettings:AddDropdown("SetFont", {
Text = "Set Font",
Values = {
"Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold",
"SourceSansLight", "SourceSansItalic", "Bodoni", "Garamond",
"Cartoon", "Code", "Highway", "SciFi", "Arcade", "Fantasy",
"Antique", "Gotham", "GothamMedium", "GothamBold", "GothamBlack",
"AmaticSC", "Bangers", "Creepster", "DenkOne", "FredokaOne",
"IndieFlower", "LuckiestGuy", "Michroma", "Nunito", "Oswald",
"PatrickHand", "PermanentMarker", "Roboto", "RobotoCondensed",
"RobotoMono", "Sarpanch", "SpecialElite", "TitilliumWeb", "Ubuntu"
},
Default = "Cartoon",
Multi = false,
Callback = function(Value)
ESPLibrary:SetFont(Value)
end
})
task.spawn(function()
task.wait(0.1)
ESPLibrary:SetTracers(false)
ESPLibrary:SetFont("Gotham")
pcall(function()
	if ESPLibrary.SetTextSize then ESPLibrary:SetTextSize(14) end
	if ESPLibrary.SetScale then ESPLibrary:SetScale(false) end
end)
end)
PlayerBox:AddSlider("MovementSpeed", {
Text = "Movement Speed",
Default = 15,
Min = 15,
Max = 21,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Walking Speed",
})
PlayerBox:AddToggle('EnableMovementSpeed',{
Text = "Enable Movement Speed",
Default = false,
Callback = function(Value)
if not Value then
LocalPlayer.Character.Humanoid.WalkSpeed = 15
end
end
})
PlayerBox:AddSlider("ClimbingSpeed", {
Text = "Climbing Speed",
Default = 15,
Min = 15,
Max = 100,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Climbing Speed",
})
PlayerBox:AddToggle('EnableClimbingSpeed',{
Text = "Climbing Speed",
Default = false,
Callback = function(Value)
if not Value then
LocalPlayer.Character.Humanoid.WalkSpeed = 15
end
end
})
PlayerBox:AddDivider()
local OldAccel
PlayerBox:AddToggle('NoAcc',{
Text = "No Acceleration ",
Tooltip = "Giúp nhân vật bỏ Qua ma sát Roblox",
Default = false,
Callback = function(Value)
if Value then
OldAccel = LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties
else
if OldAccel then
LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = OldAccel
OldAccel = nil
end
end
end
})
PlayerBox:AddToggle('NoClip',{
Text = "No Clip",
Default = false,
Tooltip = "You Can Move Through Wall",
Callback = function(Value)
if not Value then
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if not v.Name == "CollisionClone" then
if v:IsA("BasePart") then
v.CanCollide  = true
end
end
end
end
end
}):AddKeyPicker("NoclipKeybind", {
Default = "N", 	SyncToggleState = true,
Mode ="Toggle" , 
Text = "No Clip", 	NoUI = false, 
Callback = function(Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})
PlayerBox:AddToggle('Flight',{
Text = "Flight",
Default = false,
Callback = function(Value)
if not Value then
if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity"):Destroy()
end
end
end
}):AddKeyPicker("FlightKeybind", {
Default = "F", 	SyncToggleState = true,
Mode ="Toggle" , 
Text = "Flight", 	NoUI = false, 
Callback = function(Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})
PlayerBox:AddSlider("FlightSpeed", {
Text = "Flight Speed",
Default = 15,
Min = 15,
Max = 21,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Tốc độ bay của nhân vật",
})
PlayerBox:AddToggle('EnableJump',{
Text = "Enable Jumping",
Default = false,
Tooltip = "Cho phép nhân vật nhảy",
Callback = function(Value)
if not Value then
LocalPlayer.Character:SetAttribute("CanJump",false)
end
end
})
PlayerBox:AddToggle('InstaInteract',{
Text = "Instant Interact",
Default = false,
Tooltip = "Giúp tương tác Roblox Ngay lập tức",
Callback = function(Value)
if Value then
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v:SetAttribute("Duration",v.HoldDuration)
v.HoldDuration = 0
end
end
else
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.HoldDuration = v:GetAttribute("Duration") or 0
end
end
end
end
})
local NoAnimConn = nil
PlayerBox:AddToggle("NoAnimationCharacter", {
	Text = "No Animation Character",
	Default = false,
	Tooltip = "Giúp làm nhân vật không hoạt ảnh, vào tủ animation có thể nhanh hơn",
	Callback = function(Value)
		if NoAnimConn then
			NoAnimConn:Disconnect()
			NoAnimConn = nil
		end
		local function stopAll(char)
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			pcall(function()
				for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
					t:Stop(0)
					t:AdjustSpeed(0)
				end
			end)
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				pcall(function()
					for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
						t:Stop(0)
					end
				end)
			end
		end
		if not Value then return end
		stopAll(LocalPlayer.Character)
		NoAnimConn = RunService.Heartbeat:Connect(function()
			if not (Toggles.NoAnimationCharacter and Toggles.NoAnimationCharacter.Value) then return end
			stopAll(LocalPlayer.Character)
		end)
	end,
})
task.defer(function()
	task.wait(0.35)
	pcall(function()
		local t = Toggles.NoAnimationCharacter
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then lbl.TextSize = math.max(10, (lbl.TextSize or 14) - 1) end
	end)
end)
PlayerBox:AddToggle('InfJump',{
Text = "Infinite Jump",
Default = false
})
if UserInputService.KeyboardEnabled then
local d = false
table.insert(Connections, UserInputService.JumpRequest:Connect(function()
if Toggles.InfJump.Value and not d and LocalPlayer.Character then
d = true
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
task.wait(0.1)
d = false
end
end))
elseif UserInputService.TouchEnabled then
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
if LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
table.insert(Connections, LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles.InfJump.Value and LocalPlayer.Character then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
end
end))
end
end))
if LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
table.insert(Connections, LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles.InfJump.Value and LocalPlayer.Character then
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
end
end))
end
end
PlayerBox:AddToggle("EnableJumpPower", {
	Text = "JumpPower",
	Default = false,
	Tooltip = "Cho phép nhân vật nhảy mạnh hơn",
})
PlayerBox:AddSlider("JumpPowerValue", {
	Text = "Jump Power",
	Default = 5,
	Min = 0,
	Max = 50,
	Rounding = 0,
})
PlayerBox:AddToggle('Godmode',{
	Text = "Position Spoof",
	Default = false,
	Tooltip = "Làm Server thấy character dưới đất Né Va Chạm Entity",
	Risky = true,
	Callback = function(Value)
		local char = LocalPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		local floorVal = Floor and Floor.Value
		-- không spoof trên Fools / OldHotel bằng offset này
		if floorVal == "Fools" or floorVal == "OldHotel" then
			return
		end
		if root and hum then
			if Value then
				root.CFrame = root.CFrame * CFrame.new(0, -2.346, 0)
				hum.HipHeight = 0.05
				if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
					RemotesFolder.Crouch:FireServer(true, true)
				end
			else
				root.CFrame = root.CFrame * CFrame.new(0, 2.346, 0)
				hum.HipHeight = 2.396
			end
		end
	end
}):AddKeyPicker("GodmodeKeybind", {
	Default = "G",
	SyncToggleState = true,
	Mode = "Toggle",
	Text = "Position Spoof",
	NoUI = false,
	Callback = function() end,
	ChangedCallback = function() end,
})
getgenv().LeafAutoSpoofed = false
getgenv().LeafLastMonsterAround = false

local SpoofMonstersList = {
	RushMoving = true, AmbushMoving = true, BackdoorRush = true,
	A60 = true, A120 = true, GlitchRush = true, GlitchAmbush = true,
	BashMoving = true, DronesStampede = true, Scribbles = true,
	CustomEntity = true, FrozenAmbush = true,
}

local function IsSpoofMonsterAround()
	for _, child in ipairs(workspace:GetChildren()) do
		if SpoofMonstersList[child.Name] then return true end
	end
	local live = workspace:FindFirstChild("LiveEntities")
	if live then
		for _, child in ipairs(live:GetChildren()) do
			if SpoofMonstersList[child.Name] then return true end
		end
	end
	return false
end
local function LeafApplyImmortal(char, enabled)
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local collision = char:FindFirstChild("Collision")
	local crouch = collision and collision:FindFirstChild("CollisionCrouch")
	local lowerTorso = char:FindFirstChild("LowerTorso")
	local rootJoint = lowerTorso and lowerTorso:FindFirstChild("Root")
	if humanoid then
		humanoid.HipHeight = enabled and 0.09 or 2.0
	end
	if collision and collision:IsA("BasePart") then
		collision.Size = enabled and Vector3.new(1, 1, 1) or Vector3.new(5.5, 3, 3)
	end
	if crouch and crouch:IsA("BasePart") then
		crouch.Size = enabled and Vector3.new(1, 1, 1) or Vector3.new(5.5, 3, 3)
	end
	if rootJoint then
		rootJoint.C1 = enabled and CFrame.new(0, -2.3, 0) or CFrame.new(0, 0, 0)
	end
	if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
		pcall(function()
			RemotesFolder.Crouch:FireServer(enabled and true or false)
		end)
	end
end

PlayerBox:AddToggle("Immortal", {
	Text = "Immortal",
	Default = false,
	Risky = true,
	Tooltip = "God hitbox| Position Spoof v2.",
	Callback = function(Value)
		if Value then
			-- bật Immortal → tắt Position Spoof
			if Toggles.Godmode and Toggles.Godmode.Value then
				Toggles.Godmode:SetValue(false)
			end
			LeafApplyImmortal(LocalPlayer.Character, true)
		else
			LeafApplyImmortal(LocalPlayer.Character, false)
			local char = LocalPlayer.Character
			if char and char:GetAttribute("Hiding") ~= true then
				pcall(function()
					char:PivotTo(char:GetPivot() * CFrame.new(0, 4, 0))
				end)
			end
		end
	end,
}):AddKeyPicker("ImmortalKeybind", {
	Default = "I",
	SyncToggleState = true,
	Mode = "Toggle",
	Text = "Immortal",
	NoUI = false,
})

task.defer(function()
	task.wait(0.45)
	pcall(function()
		local t = Toggles.Immortal
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(0,220,255)">Immortal</font>'
		end
	end)
end)

PlayerBox:AddToggle("AutoPositionSpoof", {
	Text = "Auto Position Spoof",
	Default = false,
	Tooltip = "Tự bật Position Spoof theo chế độ Luôn Luôn|có thực thể nguy hiểm",
})

PlayerBox:AddDropdown("AutoPositionSpoofMode", {
	Text = "Auto Spoof Mode",
	Values = { "Always On", "Entity Spam" },
	Default = "Entity Spam",
})
local PromptIgnore = {
	HidePrompt = true,
	ClimbPrompt = true,
	PropPrompt = true,
	InteractPrompt = true,
	RiftPrompt = true,
	StarRiftPrompt = true,
	NoHidingLilBro = true,
	AnimatePrompt = true,
	RevivePrompt = true,
	EnterPrompt = true,
	DialoguePrompt = true,
	DonatePrompt = true,
	ToolEventPrompt = true,
	SeatPrompt = true,
	SitPrompt = true,
	ChairPrompt = true,
	}
Interactions = {}
local AutoInteractCooldowns = {}
local SpoofRayParams = RaycastParams.new()
SpoofRayParams.FilterType = Enum.RaycastFilterType.Exclude

AutoBox:AddToggle("AutoInteract",{
Text = "Auto Interact",
Default = false,
Tooltip = "Automatically interacts with nearby prompts",
Callback = function(Value)
	table.clear(Interactions)
	table.clear(AutoInteractCooldowns)
	if Value and workspace:FindFirstChild("CurrentRooms") then
		for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				local parent = v.Parent
				if parent and not PromptIgnore[v.Name]
					and parent.Name ~= "Padlock"
					and not parent:GetAttribute("JeffShop") then
					table.insert(Interactions, v)
				end
			end
		end
	end
end
}):AddKeyPicker("AutoInteractKeybind", {
Default = "R",
SyncToggleState = true,
Mode = Library.IsMobile and "Toggle" or "Hold",
Text = "Auto Interact",
NoUI = false,
Callback = function(Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})

AutoBox:AddSlider("AutoInteractDelay", {
Text = "Auto Interact Delay",
Default = 0.06,
Min = 0.03,
Max = 0.25,
Rounding = 2,
Compact = false,
Callback = function(Value)
end,
})
AutoBox:AddSlider("AutoInteractreach", {
Text = "Auto Interact Range",
Default = 12,
Min = 7,
Max = 20,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
})

local GlitchFarmProgress = 0
local GlitchFarmRoom = nil
local GlitchFarmActive = false

AutoBox:AddToggle("FarmGlitchCube", {
	Text = "Farm Glitch Cube",
	Default = false,
	Risky = true,
	Tooltip = "Kéo Nhân Vật Mạnh để Glitch Entity Xuất Hiện Để Farm Glitch Cube",
	Callback = function(Value)
	GlitchFarmActive = Value and true or false
	local char = LocalPlayer.Character
	if not Value then
		GlitchFarmProgress = 0
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then
					p.CanCollide = true
				end
			end
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				local bv = root:FindFirstChild("LeafGlitchBV")
				if bv then bv:Destroy() end
			end
		end
		if Notify then Notify("Farm Glitch: ĐÃ DỪNG", 3) end
		return
	end
	if Notify then Notify("Farm Glitch: Bắt Đầu Farm", 3) end
end,
})
AutoBox:AddDivider()
AutoBox:AddToggle('AutoLibraryCode',{
Text = "Auto Library Code",
Default = false,
})
AutoBox:AddToggle('BruteForceLibCode',{
Text = "Bruteforce Library Code",
Default = false,
})
AutoBox:AddToggle('AutoHeartbeat',{
Text = "Auto Heartbeat Minigame",
Default = false
})
local function Breaker(part)
local label = part:WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("Code")
local function run()
task.wait(0.05)
if not Toggles.AutoBreaker.Value then return end
local target = tonumber(label.Text)
if target then
for _, v in part:GetChildren() do
if v.Name == "BreakerSwitch" and v:GetAttribute("ID") == target then
local trans = part:WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("Code"):WaitForChild("Frame").BackgroundTransparency
local pc = v:FindFirstChild("PrismaticConstraint")
local light = v:FindFirstChild("Light")
local sound = v:FindFirstChild("Sound")
if trans == 0 then
if v:GetAttribute("Enabled") then return end
v:SetAttribute("Enabled", true)
if pc then pc.TargetPosition = -0.2 end
if light then
light.Material = Enum.Material.Neon
local spark = light:FindFirstChild("Spark", true)
if spark then spark:Emit(1) end
end
if sound then sound:Play() end
elseif trans == 1 then
if not v:GetAttribute("Enabled") then return end
v:SetAttribute("Enabled", false)
if pc then pc.TargetPosition = 0.2 end
if light then light.Material = Enum.Material.Glass end
if sound then sound:Play() end
end
break
end
end
end
end
label:GetPropertyChangedSignal("Text"):Connect(run)
run()
end
AutoBox:AddDropdown("BreakerMode", {
	Text = "Breaker Mode",
	Values = { "Legit", "Exploit" },
	Default = "Legit",
})

AutoBox:AddToggle("AutoBreaker", {
	Text = "Auto Breaker Box",
	Default = false,
	Tooltip = "Hoàn thành hộp cầu chì theo Methods:Hợp lệ:Khai thác Hian lận",
	Callback = function(Value)
		if not Value then return end
		task.spawn(function()
			local cachedBreaker, lastSeenCode = nil, nil
			local roundSeen, tracked = {}, {}
			while Toggles.AutoBreaker and Toggles.AutoBreaker.Value do
				local mode = Options.BreakerMode and Options.BreakerMode.Value or "Legit"
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
				if not rooms or (roomNum ~= 50 and roomNum ~= 100) then
					task.wait(0.5)
					continue
				end
				local room = rooms:FindFirstChild(tostring(roomNum))
				if not cachedBreaker or not cachedBreaker.Parent then
					cachedBreaker = room and room:FindFirstChild("ElevatorBreaker", true)
				end
				if mode == "Exploit" and cachedBreaker then
					Breaker(cachedBreaker)
					task.wait(0.15)
					continue
				end
				-- LEGIT: SurfaceGui Code
				if cachedBreaker then
					local gui = cachedBreaker:FindFirstChildWhichIsA("SurfaceGui", true)
					local codeLabel = gui and (gui:FindFirstChild("Code", true) or gui:FindFirstChild("TextLabel", true))
					local currentText = codeLabel and (codeLabel.Text or codeLabel:FindFirstChild("Text") and codeLabel.Text)
					if typeof(currentText) == "string" and currentText ~= lastSeenCode then
						lastSeenCode = currentText
						local num = tonumber(currentText)
						if num and num >= 1 and num <= 10 then
							roundSeen[num] = true
							tracked[num] = true
							-- bật switch ID = num (FireServer + local visual)
							pcall(function()
								for _, sw in ipairs(cachedBreaker:GetDescendants()) do
									if sw.Name == "BreakerSwitch" and sw:GetAttribute("ID") == num then
										local re = sw:FindFirstChildWhichIsA("RemoteEvent", true)
										if re then re:FireServer(num, true) end
										local cd = sw:FindFirstChildWhichIsA("ClickDetector", true)
										if cd and fireclickdetector then fireclickdetector(cd) end
										local pr = sw:FindFirstChildWhichIsA("ProximityPrompt", true)
										if pr and (Firepp or fireproximityprompt) then
											(Firepp or fireproximityprompt)(pr)
										end
									end
								end
							end)
						elseif currentText:find("??") then
							for i = 1, 10 do
								if not roundSeen[i] then
									-- missingNumber = i
									pcall(function()
										for _, sw in ipairs(cachedBreaker:GetDescendants()) do
											if sw.Name == "BreakerSwitch" and sw:GetAttribute("ID") == i then
												local re = sw:FindFirstChildWhichIsA("RemoteEvent", true)
												if re then re:FireServer(i, true) end
											end
										end
									end)
									break
								end
							end
						elseif currentText:find("POWER ON") or currentText == "..." then
							table.clear(roundSeen)
							table.clear(tracked)
						end
					end
				end
				task.wait(0.08)
			end
		end)
	end,
})
local AutoElevConn = nil
AutoBox:AddToggle("AutoElevatorBreaker", {
	Text = "Auto Elevator Breaker",
	Default = false,
	Tooltip = "Tự động lên thang máy khi Làm hộp Cầu chỉ-Hỗ Trợ Đến thang máy nhanh hơn",
	Callback = function(Value)
		if AutoElevConn then task.cancel(AutoElevConn) AutoElevConn = nil end
		if not Value then return end
		AutoElevConn = task.spawn(function()
			if not (Toggles.AutoBreaker and Toggles.AutoBreaker.Value) then
				if Notify then Notify("Bật Auto Breaker Box trước!", 3) end
				Toggles.AutoElevatorBreaker:SetValue(false)
				return
			end
			local savedDmg = Toggles.AutoDamageFigure and Toggles.AutoDamageFigure.Value
			if savedDmg then Toggles.AutoDamageFigure:SetValue(false) end
			local tries = 0
			while Toggles.AutoElevatorBreaker and Toggles.AutoElevatorBreaker.Value and tries < 15 do
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
				local room = rooms and rooms:FindFirstChild(tostring(roomNum or 100))
				local elev = room and (room:FindFirstChild("Elevator", true) or room:FindFirstChild("ElevatorDoor", true))
				local part = elev and (elev:IsA("BasePart") and elev or elev:FindFirstChildWhichIsA("BasePart"))
				local char = LocalPlayer.Character
				if part and char then
					char:PivotTo(part.CFrame * CFrame.new(0, 2, 0))
					local r = char:FindFirstChild("HumanoidRootPart")
					if r and (r.Position - part.Position).Magnitude < 10 then
						if Notify then Notify("Auto Elevator: đã lên!", 3) end
						break
					end
				end
				tries += 1
				task.wait(0.12)
			end
			if tries >= 15 and Notify then
				Notify("Auto Elevator Breaker: thất bại!", 4)
				Toggles.AutoElevatorBreaker:SetValue(false)
			end
			if savedDmg and Toggles.AutoDamageFigure then
				Toggles.AutoDamageFigure:SetValue(true)
			end
		end)
	end,
})
local OldFogEnd
LightingBox:AddToggle('NoFog',{
Text = "No Fog",
Default = false,
Tooltip = "Xoá Sương Mù Game",
Callback = function(Value)
if not Value then
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("Atmosphere") then
v.Density = 0.94
end
end
end
if Value then
OldFogEnd = Lighting.FogEnd
else
if OldFogEnd then
Lighting.FogEnd = OldFogEnd
OldFogEnd = nil
end
end
end
})
LightingBox:AddToggle('FullBright',{
Text = "Fullbright",
Default = false,
Tooltip = "Make you see in darkness",
Callback = function(Value)
if not Value then
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = true
for _, v in pairs(workspace.CurrentRooms:GetChildren()) do
v:SetAttribute("Ambient", v:GetAttribute("OldAmbient"))
end
end
end
})
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
    if HidingPlaces[v.Name] then
        table.insert(Closets, v)
    end
	end
local SuperFpsCache = { effects = {}, parts = {} }

local function LeafApplySuperSmooth(on)
	local lgt = Lighting
	for _, eff in ipairs(lgt:GetChildren()) do
		if eff:IsA("DepthOfFieldEffect") or eff:IsA("SunRaysEffect") or eff:IsA("BloomEffect")
			or eff:IsA("ColorCorrectionEffect") or eff:IsA("BlurEffect") then
			if on then
				if SuperFpsCache.effects[eff] == nil then SuperFpsCache.effects[eff] = eff.Enabled end
				eff.Enabled = false
			else
				if SuperFpsCache.effects[eff] ~= nil then eff.Enabled = SuperFpsCache.effects[eff] end
			end
		end
	end
	local function opt(p)
		if not p:IsA("BasePart") then return end
		if on then
			if not SuperFpsCache.parts[p] then
				SuperFpsCache.parts[p] = { Material = p.Material, CastShadow = p.CastShadow, Reflectance = p.Reflectance }
			end
			p.Material = Enum.Material.Plastic
			p.CastShadow = false
			p.Reflectance = 0
		else
			local o = SuperFpsCache.parts[p]
			if o then
				p.Material = o.Material
				p.CastShadow = o.CastShadow
				p.Reflectance = o.Reflectance
			end
		end
	end
	if on then
		local cr = workspace:FindFirstChild("CurrentRooms")
		if cr then
			for _, room in ipairs(cr:GetChildren()) do
				for _, d in ipairs(room:GetDescendants()) do opt(d) end
			end
		end
	else
		for p, o in pairs(SuperFpsCache.parts) do
			if p and p.Parent then
				p.Material = o.Material
				p.CastShadow = o.CastShadow
				p.Reflectance = o.Reflectance
			end
		end
		table.clear(SuperFpsCache.parts)
	end
end

LightingBox:AddToggle("SuperSmoothGraphics", {
	Text = "Super Smooth Graphics",
	Default = false,
	Tooltip = "Giảm Đồ Hoạ Triệt Để game Super FPS",
	Callback = function(Value)
		if Value and Toggles.AntiLag and Toggles.AntiLag.Value then
			Toggles.AntiLag:SetValue(false)
		end
		LeafApplySuperSmooth(Value)
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.SuperSmoothGraphics
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.TextSize = (lbl.TextSize or 14) - 1
			lbl.Text = '<font color="rgb(50,205,50)">Super Smooth Graphics</font>'
		end
	end)
end)
ESPHooks = {}
task.spawn(function()
local DoorColor         = Color3.fromRGB(120, 255, 120)
local ItemsColor        = Color3.fromRGB(255, 80, 200)
local HidingPlaceColor  = Color3.fromRGB(255, 255, 255)
local LeverColor        = Color3.fromRGB(150, 150, 150)
local BookColor         = Color3.fromRGB(0, 50, 180)
local BreakerColor      = Color3.fromRGB(0, 50, 180)
local GoldColor         = Color3.fromRGB(255, 255, 0)
local LadderColor       = Color3.fromRGB(0, 191, 255)
local FuseColor         = Color3.fromRGB(255, 170, 0)
local EntityColor       = Color3.new(1, 0, 0)
local DoorActiveESP = {}
local DoorRoomCache = {}
local DoorStringCache = {}
local function RemoveDoorESP(part)
if part and DoorActiveESP[part] then
DoorActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddDoorESP(part, txt, color, roomNum)
if not part then return end
local data = DoorActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
DoorActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = DoorRoomCache[roomNum]
if not bucket then bucket = {} DoorRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldDoorRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(DoorRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveDoorESP(parts[i]) end
DoorRoomCache[roomNum] = nil
end
end
end
local function ClearAllDoorESP()
for part in pairs(DoorActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(DoorActiveESP)
table.clear(DoorRoomCache)
table.clear(DoorStringCache)
end
local function ProcessRoomDoors(roomFolder, roomNum)
if not roomFolder then return end
local doorModel = roomFolder:FindFirstChild("Door")
if doorModel then
local doorPart = doorModel:FindFirstChild("Door")
if doorPart then
local roomID = doorModel:GetAttribute("RoomID") or doorPart:GetAttribute("RoomID") or tostring(roomNum)
local cached = DoorStringCache[roomID]
if not cached then
cached = "Door " .. tostring(roomID)
DoorStringCache[roomID] = cached
end
AddDoorESP(doorPart, cached, DoorColor, roomNum)
local boards = doorPart:FindFirstChild("CrossBoards")
if boards then AddDoorESP(boards, "", DoorColor, roomNum) end
end
end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "KeyObtain" then
AddDoorESP(v, "Key", DoorColor, roomNum)
elseif v.Name == "ElectrialKeyObtain" then
AddDoorESP(v, "Electrical Key", DoorColor, roomNum)
end
end
end
local function UpdateDoorESP()
if not (Toggles.Door and Toggles.Door.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldDoorRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomDoors(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomDoors(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local ObjectiveActiveESP = {}
local ObjectiveRoomCache = {}
local ObjectiveStringCache = {}
local function RemoveObjectiveESP(part)
if part and ObjectiveActiveESP[part] then
ObjectiveActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddObjectiveESP(part, txt, color, roomNum)
if not part then return end
local data = ObjectiveActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
ObjectiveActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = ObjectiveRoomCache[roomNum]
if not bucket then bucket = {} ObjectiveRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldObjectiveRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(ObjectiveRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveObjectiveESP(parts[i]) end
ObjectiveRoomCache[roomNum] = nil
end
end
end
local function ClearAllObjectiveESP()
for part in pairs(ObjectiveActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(ObjectiveActiveESP)
table.clear(ObjectiveRoomCache)
table.clear(ObjectiveStringCache)
end
local function ProcessRoomObjectives(roomFolder, roomNum)
if not roomFolder then return end
for _, v in ipairs(roomFolder:GetDescendants()) do
local itemName = Items[v.Name]
if itemName then
local cached = ObjectiveStringCache[itemName]
if not cached then
cached = itemName
ObjectiveStringCache[itemName] = cached
end
AddObjectiveESP(v, cached, ItemsColor, roomNum)
elseif v.Name == "MinesAnchor" then
local sign = v:FindFirstChild("Sign")
local label = sign and sign:FindFirstChild("TextLabel")
local text = label and label.Text or ""
local key = "Anchor " .. text
local cached = ObjectiveStringCache[key]
if not cached then
cached = key
ObjectiveStringCache[key] = cached
end
AddObjectiveESP(v, cached, ItemsColor, roomNum)
end
end
end
local function UpdateObjectiveESP()
if not (Toggles.Objective and Toggles.Objective.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldObjectiveRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomObjectives(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomObjectives(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local HidingPlaceActiveESP = {}
local HidingPlaceRoomCache = {}
local HidingPlaceStringCache = {}
local function RemoveHidingPlaceESP(part)
if part and HidingPlaceActiveESP[part] then
HidingPlaceActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddHidingPlaceESP(part, txt, color, roomNum)
if not part then return end
local data = HidingPlaceActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
HidingPlaceActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = HidingPlaceRoomCache[roomNum]
if not bucket then bucket = {} HidingPlaceRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldHidingPlaceRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(HidingPlaceRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveHidingPlaceESP(parts[i]) end
HidingPlaceRoomCache[roomNum] = nil
end
end
end
local function ClearAllHidingPlaceESP()
for part in pairs(HidingPlaceActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(HidingPlaceActiveESP)
table.clear(HidingPlaceRoomCache)
table.clear(HidingPlaceStringCache)
end
local function ProcessRoomHidingPlaces(roomFolder, roomNum)
if not roomFolder then return end
for _, v in ipairs(roomFolder:GetDescendants()) do
local name = HidingPlaces[v.Name]
if name then
local cached = HidingPlaceStringCache[name]
if not cached then
cached = name
HidingPlaceStringCache[name] = cached
end
AddHidingPlaceESP(v, cached, HidingPlaceColor, roomNum)
end
end
end
local function UpdateHidingPlaceESP()
if not (Toggles.HidingPlace and Toggles.HidingPlace.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldHidingPlaceRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomHidingPlaces(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomHidingPlaces(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local GateLeverActiveESP = {}
local GateLeverRoomCache = {}
local GateLeverStringCache = {}
local function RemoveGateLeverESP(part)
if part and GateLeverActiveESP[part] then
GateLeverActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddGateLeverESP(part, txt, color, roomNum)
if not part then return end
local data = GateLeverActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
GateLeverActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = GateLeverRoomCache[roomNum]
if not bucket then bucket = {} GateLeverRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldGateLeverRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(GateLeverRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveGateLeverESP(parts[i]) end
GateLeverRoomCache[roomNum] = nil
end
end
end
local function ClearAllGateLeverESP()
for part in pairs(GateLeverActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(GateLeverActiveESP)
table.clear(GateLeverRoomCache)
table.clear(GateLeverStringCache)
end
local function ProcessRoomGateLevers(roomFolder, roomNum)
if not roomFolder then return end
local cached = GateLeverStringCache["Lever"]
if not cached then
cached = "Gate Lever"
GateLeverStringCache["Lever"] = cached
end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "LeverForGate" then
AddGateLeverESP(v, cached, LeverColor, roomNum)
end
end
end
local function UpdateGateLeverESP()
if not (Toggles.GateLever and Toggles.GateLever.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldGateLeverRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomGateLevers(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomGateLevers(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local BookActiveESP = {}
local BookRoomCache = {}
local BookStringCache = {}
local function RemoveBookESP(part)
if part and BookActiveESP[part] then
BookActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddBookESP(part, txt, color, roomNum)
if not part then return end
local data = BookActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
BookActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = BookRoomCache[roomNum]
if not bucket then bucket = {} BookRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldBookRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(BookRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveBookESP(parts[i]) end
BookRoomCache[roomNum] = nil
end
end
end
local function ClearAllBookESP()
for part in pairs(BookActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(BookActiveESP)
table.clear(BookRoomCache)
table.clear(BookStringCache)
end
local function ProcessRoomBooks(roomFolder, roomNum)
if not roomFolder then return end
if (tonumber(roomNum) or 0) ~= 50 then return end
local cached = BookStringCache["Book"]
if not cached then
cached = "Library Book"
BookStringCache["Book"] = cached
end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "LiveHintBook" then
AddBookESP(v, cached, BookColor, roomNum)
end
end
end
local function UpdateBookESP()
if not (Toggles.Books and Toggles.Books.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldBookRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomBooks(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomBooks(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local BreakerActiveESP = {}
local BreakerRoomCache = {}
local BreakerStringCache = {}
local function RemoveBreakerESP(part)
if part and BreakerActiveESP[part] then
BreakerActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddBreakerESP(part, txt, color, roomNum)
if not part then return end
local data = BreakerActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
BreakerActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = BreakerRoomCache[roomNum]
if not bucket then bucket = {} BreakerRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldBreakerRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(BreakerRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveBreakerESP(parts[i]) end
BreakerRoomCache[roomNum] = nil
end
end
end
local function ClearAllBreakerESP()
for part in pairs(BreakerActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(BreakerActiveESP)
table.clear(BreakerRoomCache)
table.clear(BreakerStringCache)
end
local function ProcessRoomBreakers(roomFolder, roomNum)
if not roomFolder then return end
if (tonumber(roomNum) or 0) ~= 100 then return end
local cached = BreakerStringCache["Breaker"]
if not cached then
cached = "Breaker"
BreakerStringCache["Breaker"] = cached
end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "LiveBreakerPolePickup" then
AddBreakerESP(v, cached, BreakerColor, roomNum)
end
end
end
local function UpdateBreakerESP()
if not (Toggles.Breakers and Toggles.Breakers.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldBreakerRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomBreakers(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomBreakers(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local GoldActiveESP = {}
local GoldRoomCache = {}
local GoldStringCache = {}
local function RemoveGoldESP(part)
if part and GoldActiveESP[part] then
GoldActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddGoldESP(part, txt, color, roomNum)
if not part then return end
local data = GoldActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
GoldActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = GoldRoomCache[roomNum]
if not bucket then bucket = {} GoldRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldGoldRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(GoldRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveGoldESP(parts[i]) end
GoldRoomCache[roomNum] = nil
end
end
end
local function ClearAllGoldESP()
for part in pairs(GoldActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(GoldActiveESP)
table.clear(GoldRoomCache)
table.clear(GoldStringCache)
end
local function ProcessRoomGold(roomFolder, roomNum)
if not roomFolder then return end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "GoldPile" then
local value = tonumber(v:GetAttribute("GoldValue")) or 0
local cached = GoldStringCache[value]
if not cached then
cached = "Gold " .. tostring(value)
GoldStringCache[value] = cached
end
AddGoldESP(v, cached, GoldColor, roomNum)
end
end
end
local function UpdateGoldESP()
if not (Toggles.Gold and Toggles.Gold.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldGoldRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomGold(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomGold(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local LadderActiveESP = {}
local LadderRoomCache = {}
local LadderStringCache = {}
local function RemoveLadderESP(part)
if part and LadderActiveESP[part] then
LadderActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddLadderESP(part, txt, color, roomNum)
if not part then return end
local data = LadderActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
LadderActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = LadderRoomCache[roomNum]
if not bucket then bucket = {} LadderRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldLadderRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(LadderRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveLadderESP(parts[i]) end
LadderRoomCache[roomNum] = nil
end
end
end
local function ClearAllLadderESP()
for part in pairs(LadderActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(LadderActiveESP)
table.clear(LadderRoomCache)
table.clear(LadderStringCache)
end
local function ProcessRoomLadders(roomFolder, roomNum)
if not roomFolder then return end
local cached = LadderStringCache["Ladder"]
if not cached then
cached = "Ladder"
LadderStringCache["Ladder"] = cached
end
for _, v in ipairs(roomFolder:GetDescendants()) do
if v.Name == "Ladder" then
AddLadderESP(v, cached, LadderColor, roomNum)
end
end
end
local function UpdateLadderESP()
if not (Toggles.Ladder and Toggles.Ladder.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldLadderRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomLadders(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomLadders(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local FuseActiveESP = {}
local FuseRoomCache = {}
local FuseStringCache = {}
local function RemoveFuseESP(part)
if part and FuseActiveESP[part] then
FuseActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddFuseESP(part, txt, color, roomNum)
if not part then return end
local data = FuseActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
FuseActiveESP[part] = { text = txt, room = roomNum }
if roomNum then
local bucket = FuseRoomCache[roomNum]
if not bucket then bucket = {} FuseRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, txt, color)
end
local function CleanOldFuseRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(FuseRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveFuseESP(parts[i]) end
FuseRoomCache[roomNum] = nil
end
end
end
local function ClearAllFuseESP()
for part in pairs(FuseActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(FuseActiveESP)
table.clear(FuseRoomCache)
table.clear(FuseStringCache)
end
local function ProcessRoomFuses(roomFolder, roomNum)
if not roomFolder then return end
for _, v in ipairs(roomFolder:GetDescendants()) do
local n = v.Name
if n == "FuseObtain" then
AddFuseESP(v, "Fuse", FuseColor, roomNum)
elseif n == "MinesGenerator" then
AddFuseESP(v, "Generator", FuseColor, roomNum)
elseif n == "MinesGateButton" then
AddFuseESP(v, "Gate Button", FuseColor, roomNum)
end
end
end
local function UpdateFuseESP()
if not (Toggles.Fuse and Toggles.Fuse.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
CleanOldFuseRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if not rooms then return end
ProcessRoomFuses(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomFuses(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
local EntityNear = {
["Snare"] = "Snare",
["MandrakeLive"] = "Man Drake",
["Mandrake"] = "Man Drake",
["JeffTheKiller"] = "Jeff",
["Eyes"] = "Eyes",
["Lookman"] = "Eyes",
["BackdoorLookman"] = "Lookman",
}
local EntityCurrent = {
["FigureRig"] = "Figure",
["FigureRagdoll"] = "Figure",
["Groundskeeper"] = "Ground Keeper",
["LiveEntityBramble"] = "Bramble",
}
local EntityGlobal = {
["RushMoving"] = "Rush",
["AmbushMoving"] = "Ambush",
["A60"] = "A-60",
["A120"] = "A-120",
["GlitchRush"] = "Glitch Rush",
["GlitchAmbush"] = "Glitch Ambush",
["BackdoorRush"] = "Blitz",
}
local EntityRoom150 = {
["GrumbleRig"] = "Grumble",
}
local EntityAll = {}
for k, v in pairs(EntityNear) do EntityAll[k] = v end
for k, v in pairs(EntityCurrent) do EntityAll[k] = v end
for k, v in pairs(EntityGlobal) do EntityAll[k] = v end
for k, v in pairs(EntityRoom150) do EntityAll[k] = v end
EntityAll["DoorFake"] = "Dupe"
EntityAll["GiggleCeiling"] = "Giggle"
local EntityActiveESP = {}
local EntityRoomCache = {}
local EntityStringCache = {}
local function PrepareEntity(part)
if not part then return false end
if part:IsA("Model") then
if not part.PrimaryPart then
local base = part:FindFirstChildWhichIsA("BasePart")
if not base then return false end
part.PrimaryPart = base
end
pcall(function() part.PrimaryPart.Transparency = 0.99 end)
if not part:FindFirstChildOfClass("Humanoid") then
Instance.new("Humanoid", part)
end
end
if part.Name == "FigureRig" or part.Name == "FigureRagdoll" then
local root = part:FindFirstChild("Root")
if root then root.Size = Vector3.new(0.001, 0.001, 0.001) end
end
return true
end
local function RemoveEntityESP(part)
if part and EntityActiveESP[part] then
EntityActiveESP[part] = nil
ESPLibrary:RemoveESP(part)
end
end
local function AddEntityESP(part, txt, color, roomNum)
if not part then return end
local data = EntityActiveESP[part]
if data and data.text == txt then return end
if data then ESPLibrary:RemoveESP(part) end
if not PrepareEntity(part) then return end
local cached = EntityStringCache[txt]
if not cached then
cached = txt
EntityStringCache[txt] = cached
end
EntityActiveESP[part] = { text = cached, room = roomNum }
if roomNum then
local bucket = EntityRoomCache[roomNum]
if not bucket then bucket = {} EntityRoomCache[roomNum] = bucket end
table.insert(bucket, part)
end
AddESP(part, cached, color)
end
local function CleanOldEntityRooms(currentRoomNum)
currentRoomNum = tonumber(currentRoomNum) or 0
for roomNum, parts in pairs(EntityRoomCache) do
if roomNum < currentRoomNum or roomNum > (currentRoomNum + 1) then
for i = 1, #parts do RemoveEntityESP(parts[i]) end
EntityRoomCache[roomNum] = nil
end
end
end
local function ClearAllEntityESP()
for part in pairs(EntityActiveESP) do
ESPLibrary:RemoveESP(part)
end
table.clear(EntityActiveESP)
table.clear(EntityRoomCache)
table.clear(EntityStringCache)
end
local function ProcessRoomEntities(roomFolder, roomNum)
if not roomFolder then return end
roomNum = tonumber(roomNum) or 0
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
local isCurrent = (roomNum == currentRoomNum)
for _, v in ipairs(roomFolder:GetDescendants()) do
local n = v.Name
local label = EntityNear[n]
if label then
if n ~= "Snare" or v:FindFirstChild("Hitbox") then
AddEntityESP(v, label, EntityColor, roomNum)
end
elseif n == "DoorFake" then
if v.Parent and v.Parent.Name == "SideroomDupe" then
local fake = v:FindFirstChild("Door")
if fake then AddEntityESP(fake, "Dupe", EntityColor, roomNum) end
end
elseif n == "GiggleCeiling" then
if v:FindFirstChild("Hitbox") then
AddEntityESP(v, "Giggle", EntityColor, roomNum)
end
elseif isCurrent then
label = EntityCurrent[n]
if label then
AddEntityESP(v, label, EntityColor, roomNum)
elseif EntityRoom150[n] and currentRoomNum == 150 then
AddEntityESP(v, EntityRoom150[n], EntityColor, roomNum)
end
end
end
end
local function UpdateEntityESP()
if not (Toggles.Entity and Toggles.Entity.Value) then return end
local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
for part in pairs(EntityActiveESP) do
if not part.Parent then RemoveEntityESP(part) end
end
CleanOldEntityRooms(currentRoomNum)
local rooms = workspace:FindFirstChild("CurrentRooms")
if rooms then
ProcessRoomEntities(rooms:FindFirstChild(tostring(currentRoomNum)), currentRoomNum)
ProcessRoomEntities(rooms:FindFirstChild(tostring(currentRoomNum + 1)), currentRoomNum + 1)
end
for _, v in ipairs(workspace:GetChildren()) do
local n = v.Name
local label = EntityGlobal[n]
if label then
AddEntityESP(v, label, EntityColor, nil)
else
label = EntityNear[n]
if label then
AddEntityESP(v, label, EntityColor, currentRoomNum)
end
end
end
end
local NotifiedEntities = {}
local NotifyNames = {
["RushMoving"] = "Rush",
["AmbushMoving"] = "Ambush",
["A60"] = "A-60",
["A120"] = "A-120",
["GlitchRush"] = "Glitch Rush",
["GlitchAmbush"] = "Glitch Ambush",
["Eyes"] = "Eyes",
["Lookman"] = "Eyes",
["BackdoorRush"] = "Blitz",
["BackdoorLookman"] = "Lookman",
["JeffTheKiller"] = "Jeff",
}
local NotifyOptionKey = {
["RushMoving"] = "Rush",
["AmbushMoving"] = "Ambush",
["A60"] = "A-60",
["A120"] = "A-120",
["GlitchRush"] = "GlitchRush",
["GlitchAmbush"] = "GlitchAmbush",
["Eyes"] = "Eyes",
["Lookman"] = "Eyes",
["BackdoorRush"] = "Blitz",
["BackdoorLookman"] = "Lookman",
["JeffTheKiller"] = "Jeff",
}
local function CheckAndNotifyEntity(entity)
if not entity then return end
if NotifiedEntities[entity] then return end
if not (Toggles.NotifySpawn and Toggles.NotifySpawn.Value) then return end
local key = NotifyOptionKey[entity.Name]
if not key then return end
local selected = Options.Notify and Options.Notify.Value
if type(selected) ~= "table" or not selected[key] then return end
NotifiedEntities[entity] = true
local con
con = entity.AncestryChanged:Connect(function(_, parent)
if not parent then
NotifiedEntities[entity] = nil
if con then con:Disconnect() con = nil end
end
end)
table.insert(Connections, con)
Notify(NotifyNames[entity.Name] .. " has Spawned", 5)
end
local function ScanNotifyEntities()
if not (Toggles.NotifySpawn and Toggles.NotifySpawn.Value) then return end
for _, v in ipairs(workspace:GetChildren()) do
if NotifyOptionKey[v.Name] then
CheckAndNotifyEntity(v)
end
end
end
local function UpdateAllESP()
UpdateDoorESP()
UpdateObjectiveESP()
UpdateHidingPlaceESP()
UpdateGateLeverESP()
UpdateBookESP()
UpdateBreakerESP()
UpdateGoldESP()
UpdateLadderESP()
UpdateFuseESP()
UpdateEntityESP()
end
local function ClearAllESP()
ClearAllDoorESP()
ClearAllObjectiveESP()
ClearAllHidingPlaceESP()
ClearAllGateLeverESP()
ClearAllBookESP()
ClearAllBreakerESP()
ClearAllGoldESP()
ClearAllLadderESP()
ClearAllFuseESP()
ClearAllEntityESP()
table.clear(NotifiedEntities)
end
ESPHooks.UpdateAll = UpdateAllESP
ESPHooks.ClearAll = ClearAllESP
ESPHooks.ScanNotify = ScanNotifyEntities
ESPHooks.CheckNotify = CheckAndNotifyEntity
ESPBox:AddToggle('Door', {
Text = "Door",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateDoorESP) else ClearAllDoorESP() end
end
}):AddColorPicker("ColorPicker2", {
Default = DoorColor,
Title = "Door ESP Color",
Callback = function(Value)
DoorColor = Value
if Toggles.Door and Toggles.Door.Value then
ClearAllDoorESP()
task.defer(UpdateDoorESP)
end
end,
})
ESPBox:AddToggle('Objective', {
Text = "Objective",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateObjectiveESP) else ClearAllObjectiveESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = ItemsColor,
Title = "Objective ESP Color",
Callback = function(Value)
ItemsColor = Value
if Toggles.Objective and Toggles.Objective.Value then
ClearAllObjectiveESP()
task.defer(UpdateObjectiveESP)
end
end,
})
ESPBox:AddToggle('HidingPlace', {
Text = "Hiding Place",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateHidingPlaceESP) else ClearAllHidingPlaceESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = HidingPlaceColor,
Title = "Hiding Place ESP Color",
Callback = function(Value)
HidingPlaceColor = Value
if Toggles.HidingPlace and Toggles.HidingPlace.Value then
ClearAllHidingPlaceESP()
task.defer(UpdateHidingPlaceESP)
end
end,
})
ESPBox:AddToggle('GateLever', {
Text = "Gate Lever",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateGateLeverESP) else ClearAllGateLeverESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = LeverColor,
Title = "Gate Lever ESP Color",
Callback = function(Value)
LeverColor = Value
if Toggles.GateLever and Toggles.GateLever.Value then
ClearAllGateLeverESP()
task.defer(UpdateGateLeverESP)
end
end,
})
ESPBox:AddToggle('Books', {
Text = "Library Book",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateBookESP) else ClearAllBookESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = BookColor,
Title = "Library ESP Color",
Callback = function(Value)
BookColor = Value
if Toggles.Books and Toggles.Books.Value then
ClearAllBookESP()
task.defer(UpdateBookESP)
end
end,
})
ESPBox:AddToggle('Breakers', {
Text = "Breaker",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateBreakerESP) else ClearAllBreakerESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = BreakerColor,
Title = "Breaker ESP Color",
Callback = function(Value)
BreakerColor = Value
if Toggles.Breakers and Toggles.Breakers.Value then
ClearAllBreakerESP()
task.defer(UpdateBreakerESP)
end
end,
})
ESPBox:AddToggle('Gold', {
Text = "Gold",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateGoldESP) else ClearAllGoldESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = GoldColor,
Title = "Gold ESP Color",
Callback = function(Value)
GoldColor = Value
if Toggles.Gold and Toggles.Gold.Value then
ClearAllGoldESP()
task.defer(UpdateGoldESP)
end
end,
})
ESPBox:AddToggle('Entity', {
Text = "Entity",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateEntityESP) else ClearAllEntityESP() end
end
}):AddColorPicker("ColorPicker3", {
Default = EntityColor,
Title = "Entity ESP Color",
Callback = function(Value)
EntityColor = Value
if Toggles.Entity and Toggles.Entity.Value then
ClearAllEntityESP()
task.defer(UpdateEntityESP)
end
end,
})
ESPBox:AddToggle('Ladder', {
Text = "Ladder",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateLadderESP) else ClearAllLadderESP() end
end
}):AddColorPicker("ColorPickerLadder", {
Default = LadderColor,
Title = "Ladder ESP Color",
Callback = function(Value)
LadderColor = Value
if Toggles.Ladder and Toggles.Ladder.Value then
ClearAllLadderESP()
task.defer(UpdateLadderESP)
end
end,
})
ESPBox:AddToggle('Fuse', {
Text = "Fuse",
Default = false,
Callback = function(Value)
if Value then task.defer(UpdateFuseESP) else ClearAllFuseESP() end
end
}):AddColorPicker("ColorPickerFuse", {
Default = FuseColor,
Title = "Fuse ESP Color",
Callback = function(Value)
FuseColor = Value
if Toggles.Fuse and Toggles.Fuse.Value then
ClearAllFuseESP()
task.defer(UpdateFuseESP)
end
end,
})
local ESPWatch = {
["Door"] = UpdateDoorESP,
["KeyObtain"] = UpdateDoorESP,
["ElectrialKeyObtain"] = UpdateDoorESP,
["MinesAnchor"] = UpdateObjectiveESP,
["LeverForGate"] = UpdateGateLeverESP,
["LiveHintBook"] = UpdateBookESP,
["LiveBreakerPolePickup"] = UpdateBreakerESP,
["GoldPile"] = UpdateGoldESP,
["Ladder"] = UpdateLadderESP,
["FuseObtain"] = UpdateFuseESP,
["MinesGenerator"] = UpdateFuseESP,
["MinesGateButton"] = UpdateFuseESP,
}
table.insert(Connections, LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
task.defer(UpdateAllESP)
task.defer(ScanNotifyEntities)
end))
table.insert(Connections, workspace.DescendantAdded:Connect(function(v)
local n = v.Name
local fn = ESPWatch[n]
if fn then task.defer(fn) end
if Items[n] then task.defer(UpdateObjectiveESP) end
if HidingPlaces[n] then task.defer(UpdateHidingPlaceESP) end
if EntityAll[n] then
task.defer(UpdateEntityESP)
if NotifyOptionKey[n] then CheckAndNotifyEntity(v) end
end
end))
table.insert(Connections, workspace.ChildAdded:Connect(function(v)
local n = v.Name
if EntityAll[n] then
task.defer(UpdateEntityESP)
if NotifyOptionKey[n] then CheckAndNotifyEntity(v) end
end
end))
table.insert(Connections, workspace.ChildRemoved:Connect(function(v)
if EntityAll[v.Name] then
RemoveEntityESP(v)
end
end))
end)
CameraBox:AddSlider("FOV", {
Text = "FOV",
Default = 80,
Min = 70,
Max = 140,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Field of View",
})
CameraBox:AddDivider()
CameraBox:AddToggle('ThirdPerson',{
Text = "Third Person",
Default = false
}):AddKeyPicker("ThirdpersonKeybind", {
Default = "T", 	SyncToggleState = true,
Mode = "Toggle", 
Text = "Third Person", 	NoUI = false, 
Callback = function(Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})
CameraBox:AddSlider("X", {
Text = "X",
Default = 0,
Min = -10,
Max = 10,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "X",
})
CameraBox:AddSlider("Y", {
Text = "Y",
Default = 0,
Min = -10,
Max = 10,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Y",
})
CameraBox:AddSlider("Z", {
Text = "Z",
Default = 7,
Min = -10,
Max = 15,
Rounding = 1,
Compact = false,
Callback = function(Value)
end,
Tooltip = "Z",
})
CameraBox:AddToggle('NoCamShake',{
Text = "No Camera Shake",
Tooltip = "giúp nhân vật bỏ qua Rung lắc của Thực thể",
Disabled = not require and true or false,
})
local OldMinZoom = LocalPlayer.CameraMinZoomDistance
local OldMaxZoom  = LocalPlayer.CameraMaxZoomDistance
CameraBox:AddToggle('Freecam',{
Text = "Freecam",
Default = false,
Callback = function(Value)
if not Value then
local fcPart = workspace:FindFirstChild("FreecamPart")
if fcPart then
fcPart:Destroy()
local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if root then root.Anchored = false end
LocalPlayer.CameraMinZoomDistance = LocalPlayer:GetAttribute("fc_om") or 0.5
LocalPlayer.CameraMaxZoomDistance = LocalPlayer:GetAttribute("fc_ox") or 128
end
end
end
}):AddKeyPicker("FreecamKeybind", {
Default = "B", 	SyncToggleState = true,
Mode ="Toggle" , 
Text = "Freecam", 	NoUI = false, 
Callback = function(Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})
CameraBox:AddToggle('NoScenes',{
	Text = "No Cutscenes",
	Default = false,
	Tooltip = "Tắt Cảnh Animation không cần thiết",
	Callback = function(Value)
		pcall(function()
			local rl = RemoteListener
			if not rl and LocalPlayer.PlayerGui:FindFirstChild("MainUI") then
				local mg = LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")
				rl = mg and mg:FindFirstChild("RemoteListener")
			end
			if not rl then return end
			local cut = rl:FindFirstChild("Cutscenes") or rl:FindFirstChild("Cutscenes_")
			if cut then
				cut.Name = Value and "Cutscenes_" or "Cutscenes"
			end
		end)
	end
})
NotifyBox:AddDropdown("Notify", {
Values = { "Rush","Ambush","GlitchRush","GlitchAmbush","A-60","A-120","Eyes","Blitz","Lookman","Jeff"},
Default = 1, 	Multi = true, 
Text = "Choose to Notify",
Callback = function(Value)
end,
})
NotifyBox:AddToggle('NotifySpawn',{
Text = "Notify Entity",
Default = false,
Tooltip = "Notify Entity In Spawn",
Callback = function(Value)
if Value and ESPHooks and ESPHooks.ScanNotify then
task.defer(ESPHooks.ScanNotify)
end
end
})
local FakeScreech = Instance.new("RemoteEvent",RemotesFolder)
FakeScreech.Name = "Screech_"
local FakeA90 = Instance.new("RemoteEvent",RemotesFolder)
FakeA90.Name = "A90_"
local gotToggled = false
local gotToggled2 = false
BypassEntityBox:AddToggle('Screech',{
Text = "Anti Screech Damage",
Default = false,
Callback = function(Value)
if Value then
gotToggled = true
RemotesFolder.Screech.Name = "Screech_"
FakeScreech.Name = "Screech"
else
if gotToggled then
RemotesFolder["Screech_"].Name = "Screech"
FakeScreech.Name = "Screech_"
end
end
end
})
BypassEntityBox:AddToggle('A90',{
Text = "Anti A90 Damage",
Default = false,
Callback = function(Value)
if Value then
gotToggled2 = true
RemotesFolder.A90.Name = "A90_"
FakeA90.Name = "A90"
else
if gotToggled2 then
RemotesFolder["A90_"].Name = "A90"
FakeA90.Name = "A90_"
end
end
end
})
BypassEntityBox:AddToggle('Dread',{
Text = "Anti Dread",
Default = false,
Callback = function(Value)
if Value then
local Dread = LocalPlayer:FindFirstChild("Dread",true) or LocalPlayer:FindFirstChild("_Dread",true)
if Dread then
Dread.Name = "_Dread"
end
else
local Dread = LocalPlayer:FindFirstChild("Dread",true) or LocalPlayer:FindFirstChild("_Dread",true)
if Dread then
Dread.Name = "Dread"
end
end
end
})
BypassEntityBox:AddToggle('Halt',{
Text = "Anti Halt",
Default = false,
Callback = function(Value)
if Value then
local Dread = ClientModules.EntityModules:FindFirstChild("Shade",true) or ClientModules.EntityModules:FindFirstChild("_Shade",true)
if Dread then
Dread.Name = "_Shade"
end
else
local Dread = ClientModules.EntityModules:FindFirstChild("Shade",true) or ClientModules.EntityModules:FindFirstChild("_Shade",true)
if Dread then
Dread.Name = "Shade"
end
end
end
})
BypassEntityBox:AddToggle('Jamming',{
Text = "Anti Jammimg",
Default = false,
Callback = function(Value)
if  ReplicatedStorage:FindFirstChild("LiveModifiers") and ReplicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
local Jam = LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game").Health.Jam
Jam.Playing = not Value
local Jamming = game:GetService("SoundService").Main.Jamming
Jamming.Enabled =  not Value
end
end
})
local Surge = Instance.new("RemoteEvent",ReplicatedStorage)
Surge.Name = "SurgeRemote"
BypassEntityBox:AddToggle('BypassSurgeDamage',{
Text = "Anti Surge Damage",
Default = false,
Callback = function(Value)
if Value then
if RemotesFolder:FindFirstChild("SurgeRemote") then
RemotesFolder.SurgeRemote.Parent = ReplicatedStorage
Surge.Parent = RemotesFolder
end
else
if RemotesFolder:FindFirstChild("SurgeRemote") then
ReplicatedStorage.SurgeRemote.Parent = RemotesFolder
Surge.Parent = ReplicatedStorage
end
end
end
})
BypassEntityBox:AddToggle('Snare',{
Text = "Anti Snare",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if   v.Name == "Snare" then
local wait = 0
repeat task.wait(0.01) wait = wait  + 0.01 until wait > 2 or v:FindFirstChild("Hitbox")
if v:FindFirstChild("Hitbox") then
v.Hitbox.CanTouch = not Value
end
end
end
end
})
BypassEntityBox:AddToggle('Giggle',{
Text = "Anti Giggle",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if   v.Name == "GiggleCeiling" then
local wait = 0
repeat task.wait(0.01) wait = wait  + 0.01 until wait > 2 or v:FindFirstChild("Hitbox")
if v:FindFirstChild("Hitbox") then
v.Hitbox.CanTouch = not Value
end
end
end
end
})
BypassEntityBox:AddToggle('Dupe',{
Text = "Anti Dupe",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "DoorFake"  and v.Parent.Name == "SideroomDupe" then
v:WaitForChild("Hidden",9e9).CanTouch = not Value
end
end
end
})
BypassBox:AddToggle('BypassSpeed',{
Text = "Speed Bypass",
Default = false,
Callback  = function(Value)
Options.MovementSpeed:SetMax(Value and 75 or 21)
Options.FlightSpeed:SetMax(Value and 75 or 21)
end
})
BypassBox:AddDivider()
BypassBox:AddDropdown("AntiCheatManiMethod", {
Values = { "Velocity", "Anticheat" },
Default = 1,
Text = "Manipulation Method",
Callback = function(Value)
end,
})
BypassBox:AddToggle('AntiCheatMani',{
Text = "Manipulation",
Default = false,
Callback = function(Value)
if not Value then
if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani") then
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani"):Destroy()
end
if  Toggles.NoClip.Value then
Toggles.NoClip:SetValue(false)
end
end
end
}):AddKeyPicker("AntiCheatMan", {
Default = "V", 	SyncToggleState = true,
Mode = Library.IsMobile and "Toggle" or "Hold",  
Text = " Manipulation", 	NoUI = false, 
Callback = function(Value)
print("[cb] Keybind clicked!", Value)
end,
ChangedCallback = function(NewKey, NewModifiers)
end,
})
task.spawn(function()
while task.wait() do
if Library.Unloaded then break end
if Toggles.BypassSpeed.Value then
if CollisionClone then
CollisionClone.Massless = true
end
RemotesFolder.Crouch:FireServer(true, true)
end
end
end)
table.insert(Connections,workspace.ChildAdded:Connect(function(v)
if Toggles.AntiBanana.Value then
if v.Name == "BananaPeel" then
v.CanTouch = false
end
end
if Toggles.AntiJeff.Value then
if v.Name == "JeffTheKiller" then
repeat task.wait() until v.PrimaryPart and isnetworkowner(v.PrimaryPart)
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = false
end
end
v.Humanoid.Health = 0
end
end
end))
-- Anti Alma (Abysall: destroy Alma khi spawn)
BypassEntityBox:AddToggle("AntiAlma", {
	Text = "Anti Alma",
	Default = false,
	Tooltip = "Xóa Alma khi spawn",
	Callback = function(Value)
		if AlmaConnection then AlmaConnection:Disconnect() AlmaConnection = nil end
		if not Value then return end
		for _, c in ipairs(workspace:GetChildren()) do
			if c.Name == "Alma" then pcall(function() c:Destroy() end) end
		end
		AlmaConnection = workspace.ChildAdded:Connect(function(child)
			if child.Name == "Alma" and Toggles.AntiAlma.Value then
				pcall(function() child:Destroy() end)
			end
		end)
	end,
})

-- Anti Drone (Abysall: nhấc WalkedInto khỏi Drones)
BypassEntityBox:AddToggle("AntiDrone", {
	Text = "Anti Drone",
	Default = false,
	Tooltip = "Chặn Drones tấn WalkedInto",
	Callback = function(Value)
		local RS = ReplicatedStorage
		local function ProcessDrones(drones)
			local WalkedInto = drones:FindFirstChild("WalkedInto") or drones:WaitForChild("WalkedInto", 2)
			if WalkedInto and not DroneWalkedIntoParents[WalkedInto] then
				DroneWalkedIntoParents[WalkedInto] = drones
				WalkedInto.Parent = RS
			end
		end
		if Value then
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "Drones" then ProcessDrones(child) end
			end
			if DroneConnection then DroneConnection:Disconnect() end
			DroneConnection = workspace.ChildAdded:Connect(function(child)
				if child.Name == "Drones" then ProcessDrones(child) end
			end)
		else
			for WalkedInto, originalParent in pairs(DroneWalkedIntoParents) do
				if WalkedInto and WalkedInto.Parent and originalParent and originalParent.Parent then
					WalkedInto.Parent = originalParent
				end
			end
			table.clear(DroneWalkedIntoParents)
			if DroneConnection then DroneConnection:Disconnect() DroneConnection = nil end
		end
	end,
})

-- Anti Noise (notify + đánh dấu; phá TV nằm ở group Destroy)
BypassEntityBox:AddToggle("AntiNoise", {
	Text = "Anti Noise",
	Default = false,
	Tooltip = "Bật kèm Destroy TV (Lower / Overthrow) khi cầm TV Noise",
})

-- Anti Monument (Outdoor: tắt CanTouch hitbox)
BypassEntityBox:AddToggle("AntiMonument", {
	Text = "Anti Monument",
	Default = false,
	Tooltip = "Tắt CanTouch MonumentEntity",
	Callback = function(Value)
		if AntiMonumentConnection then AntiMonumentConnection:Disconnect() AntiMonumentConnection = nil end
		local function Apply(obj)
			if obj.Name ~= "MonumentEntity" and obj.Name ~= "Monument" then return end
			for _, p in ipairs(obj:GetDescendants()) do
				if p:IsA("BasePart") then p.CanTouch = not Value end
			end
		end
		for _, c in ipairs(workspace:GetChildren()) do Apply(c) end
		if Value then
			AntiMonumentConnection = workspace.ChildAdded:Connect(Apply)
		end
	end,
})

-- Anti Currents / Electric Water (Abysall Water-style đơn giản)
BypassEntityBox:AddToggle("AntiCurrents", {
	Text = "Anti Currents",
	Default = false,
	Tooltip = "Tắt CanTouch nước điện / current",
	Callback = function(Value)
		local rooms = workspace:FindFirstChild("CurrentRooms")
		if not rooms then return end
		for _, room in ipairs(rooms:GetChildren()) do
			local water = room:FindFirstChild("Water")
			if water then
				for _, p in ipairs(water:GetDescendants()) do
					if p:IsA("BasePart") then
						p.CanTouch = not Value
					end
				end
				if water:IsA("BasePart") then water.CanTouch = not Value end
			end
			for _, p in ipairs(room:GetDescendants()) do
				if p.Name == "ElectricWater" or p.Name == "Current" or p.Name == "Currents" then
					if p:IsA("BasePart") then p.CanTouch = not Value end
				end
			end
		end
	end,
})

-- Anti Vacuum (FakeDoor / SideroomSpace)
BypassEntityBox:AddToggle("AntiVacuum", {
	Text = "Anti Vacuum",
	Default = false,
	Tooltip = "Chặn Tương tác Vacuum touch",
	Callback = function(Value)
		local rooms = workspace:FindFirstChild("CurrentRooms")
		if not rooms then return end
		for _, obj in ipairs(rooms:GetDescendants()) do
			if obj.Name == "FakeDoor" or obj.Name == "DoorFake" then
				local hidden = obj:FindFirstChild("Hidden")
				if hidden then hidden.CanTouch = not Value end
				local lock = obj:FindFirstChild("Lock")
				if lock and lock:FindFirstChild("UnlockPrompt") then
					lock.UnlockPrompt.Enabled = not Value
				end
			elseif obj.Name == "SideroomSpace" then
				local coll = obj:FindFirstChild("Collision")
				if coll then
					coll.CanTouch = not Value
					coll.CanCollide = false
				end
			end
		end
	end,
})
BypassEntityBox:AddToggle("SemiGod", {
	Text = "Semi God",
	Default = false,
	Tooltip = "chỉ Tránh Ảnh hưởng Từ thực thể nhỏ không Hoàn Toàn Godmode",
	Callback = function(Value)
	local list = {
		"Screech", "A90", "Dread", "Halt", "Jamming",
		"BypassSurgeDamage", "Snare", "Giggle", "Dupe",
		"EyesDamage", "LookmanDamage", "GloomEggDamage",
		"FigureHearing", "AntiLag",
		"AntiBanana", "AntiJeff", "AntiLava", "AntiWall", "AntiSeekFlood",
		-- mới
		"AntiAlma", "AntiDrone", "AntiNoise", "AntiMonument",
		"AntiCurrents", "AntiVacuum",
		"LowerPositionTV", "BypassOverthrowTV",
	}
	for _, name in ipairs(list) do
		if Toggles[name] then
			pcall(function()
				Toggles[name]:SetValue(Value and true or false)
			end)
		end
	end
end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.SemiGod
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,215,0)">Semi God</font>'
		end
	end)
end)
-- Virtual collision Figure (3 cơ chế ghép nguyên bản)
BypassEntityBox:AddToggle("VirtualCollisionFigure", {
	Text = "Virtual collision Figure",
	Default = false,
	Risky = true,
	Tooltip = "Làm Va Chạm Ảo Hitbox Part khi va chạm Figure Lên sever|Tránh Figure Va chạm",
	Callback = function(Value)
		local char = LocalPlayer.Character
		if not char then return end
		local Collision = char:FindFirstChild("Collision")
		local RootPart = char:FindFirstChild("HumanoidRootPart")
		local Humanoid = char:FindFirstChildOfClass("Humanoid")
		if not Collision or not RootPart or not Humanoid then return end

		-- figure gần nhất
		local figure = nil
		for _, name in ipairs({ "FigureRig", "FigureRagdoll", "Figure" }) do
			local f = workspace:FindFirstChild(name)
			if f then figure = f break end
		end
		if not figure then
			for _, obj in ipairs(workspace:GetChildren()) do
				if obj.Name == "FigureRig" or obj.Name == "FigureRagdoll" or obj.Name == "Figure" then
					figure = obj
					break
				end
			end
		end

		-- Script table giả (map LatestRoom + Collision) — chỉ để đoạn gốc chạy đúng tên
		local Script = {
			LatestRoom = LatestRoom,
			Collision = Collision,
		}
		shared.Humanoid = Humanoid

		if Value then
			-- ===== ACTIVATE: 3 đoạn nguyên văn =====

			-- [ĐOẠN 1] — nâng Collision +200 (1 lần lúc bật
			Collision.Position = RootPart.Position + Vector3.new(0, 200, 0)

			-- [ĐOẠN 2] Floor Fools — GIỮ BUG `or` (luôn return sớm)
			if figure then
				if Script.LatestRoom.Value ~= 50 or Script.LatestRoom.Value ~= 100 then
					-- return sớm theo bug gốc — không chạy for
				else
					for _, v in pairs(figure:GetDescendants()) do
						if v:IsA("BasePart") then
							if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end
							v.CanTouch = false
							task.spawn(function()
								repeat task.wait() until (Script.LatestRoom.Value == 50 or Script.LatestRoom.Value == 100)
								task.wait(5)
								v.CanCollide = false
							end)
						end
					end
				end
			end

			-- [ĐOẠN 3] mspaint GodmodeNoclipBypassFools (bật)
			shared.Humanoid.HipHeight = 3.01
			task.wait()
			Script.Collision.Position = Script.Collision.Position - Vector3.new(0, 8, 0)
			task.wait()
			shared.Humanoid.HipHeight = 3
		else
			-- ===== DEACTIVATE: đảo đoạn 3 + khôi phục Clip =====
			shared.Humanoid.HipHeight = 3.01
			task.wait()
			Script.Collision.Position = Script.Collision.Position + Vector3.new(0, 8, 0)
			task.wait()
			shared.Humanoid.HipHeight = 3

			if figure then
				for _, v in pairs(figure:GetDescendants()) do
					if v:IsA("BasePart") then
						if v:GetAttribute("Clip") ~= nil then
							v.CanCollide = v:GetAttribute("Clip")
							v.CanTouch = true
						end
					end
				end
			end
		end
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.VirtualCollisionFigure
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,20,147)">Virtual collision Figure</font>'
		end
	end)
end)
end)
BypassEntityBox:AddToggle('EyesDamage',{
Text = "Anti Eyes Damage",
Default = false
})
BypassEntityBox:AddToggle('LookmanDamage',{
Text = "Anti Lookman Damage",
Default = false
})
BypassEntityBox:AddToggle('GloomEggDamage',{
Text = "Anti Gloom Egg",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GloomEgg" then
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart")  then
i.CanTouch = not Value
end
end
end
end
end
})
HotelFloor:AddToggle('NotifyLibraryCode',{
Text = "Notify Library Code",
Default = false,
})
HotelFloor:AddToggle('SeekObf',{
Text = "Anti Seek Obstacles",
Default = false,
Callback = function(Value)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction" then
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = not Value
end
end
end
end
end
})
HotelFloor:AddButton({
	Text = "Complete Cringle",
	Func = function()
		pcall(function()
			-- Workshop / cringle objectives: fire prompts + doors
			local fire = Firepp or fireproximityprompt
			for _, d in ipairs(workspace:GetDescendants()) do
				if string.lower(d.Name):find("cringle") or d.Name:find("Workshop") then
					for _, pr in ipairs(d:GetDescendants()) do
						if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
					end
				end
			end
			if Notify then Notify("Complete Cringle fired", 3) end
		end)
	end,
})
-- ===== Auto Hotel (Abysall-style) =====
local AutoHotelConnection, AutoHotelSeekConnection = nil, nil
local AutoHotelEntityNames = {
	RushMoving = true, AmbushMoving = true, A60 = true, A120 = true,
	GlitchRush = true, GlitchAmbush = true, BackdoorRush = true,
	BashMoving = true, Scribbles = true,
}
local AutoHotelProcessedRooms = {}

local function AutoHotelIsEntityPresent()
	for _, c in ipairs(workspace:GetChildren()) do
		if AutoHotelEntityNames[c.Name] then return true end
	end
	return false
end

local function AutoHotelWaitForEntities(sec)
	task.wait(sec or 3)
	while AutoHotelIsEntityPresent() and Toggles.AutoHotel and Toggles.AutoHotel.Value do
		task.wait(0.15)
	end
end

local function AutoHotelGetNextDoor()
	local gd = ReplicatedStorage:FindFirstChild("GameData")
	local lr = gd and gd:FindFirstChild("LatestRoom")
	local rooms = workspace:FindFirstChild("CurrentRooms")
	if not lr or not rooms then return nil end
	local startN = tonumber(lr.Value) or 0
	local bestDoor, bestN = nil, math.huge
	for _, room in ipairs(rooms:GetChildren()) do
		local n = tonumber(room.Name)
		if n and n >= startN and n < bestN and n ~= 100 then
			local door = room:FindFirstChild("Door")
			if door and not door:GetAttribute("Opened") then
				bestN, bestDoor = n, door
			end
		end
	end
	return bestDoor, bestN
end

HotelFloor:AddToggle("AutoHotel", {
	Text = "Auto Hotel",
	Default = false,
	Risky = true,
	Tooltip = "Risk!Tự hoàn thành khách sạn,có thể lỗi!!",
	Callback = function(Value)
		if AutoHotelConnection then task.cancel(AutoHotelConnection) AutoHotelConnection = nil end
		if AutoHotelSeekConnection then task.cancel(AutoHotelSeekConnection) AutoHotelSeekConnection = nil end
		table.clear(AutoHotelProcessedRooms)
		if not Value then return end

		AutoHotelConnection = task.spawn(function()
			while Toggles.AutoHotel and Toggles.AutoHotel.Value do
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if not root then task.wait(0.2) continue end
				if AutoHotelIsEntityPresent() then
					AutoHotelWaitForEntities(2)
					continue
				end
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
				local room = rooms and rooms:FindFirstChild(tostring(roomNum))
				if room and char then
					local door = room:FindFirstChild("Door")
					if door and door:FindFirstChild("Lock") then
						local hasKey = LocalPlayer.Backpack:FindFirstChild("Key") or char:FindFirstChild("Key")
						if not hasKey then
							for _, d in ipairs(room:GetDescendants()) do
								if d.Name == "KeyObtain" or (d.Name == "Key" and d:IsA("Model")) then
									char:PivotTo(d:GetPivot() * CFrame.new(0, 1, 0))
									task.wait(0.12)
									local fire = Firepp or fireproximityprompt
									for _, pr in ipairs(d:GetDescendants()) do
										if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
									end
									break
								end
							end
						end
					end
				end
				local door, num = AutoHotelGetNextDoor()
				if door and num and not AutoHotelProcessedRooms[num] then
					local dpart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
					if dpart then
						char:PivotTo(dpart.CFrame * CFrame.new(0, 0, 2))
						task.wait(0.15)
						local fire = Firepp or fireproximityprompt
						for _, pr in ipairs(door:GetDescendants()) do
							if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
						end
						if door:FindFirstChild("ClientOpen") then
							pcall(function() door.ClientOpen:FireServer() end)
						end
						AutoHotelProcessedRooms[num] = true
					end
				end
				task.wait(0.2)
			end
		end)

		AutoHotelSeekConnection = task.spawn(function()
			local lastTrig = nil
			while Toggles.AutoHotel and Toggles.AutoHotel.Value do
				local rooms = workspace:FindFirstChild("CurrentRooms")
				if rooms then
					for _, Room in ipairs(rooms:GetChildren()) do
						local Num = tonumber(Room.Name)
						if Num and Num ~= lastTrig then
							local Trigger = Room:FindFirstChild("TriggerEventCollision")
								or Room:FindFirstChild("TriggerEventCollision", true)
							if Trigger then
								lastTrig = Num
								AutoHotelWaitForEntities(8)
							end
						end
					end
				end
				task.wait(0.2)
			end
		end)
	end,
})
HotelFloor:AddToggle("DeleteSeekHotelFE", {
	Text = "Delete Seek Hotel [FE]",
	Default = false,
	Risky = true,
	Tooltip = "Xoá Trigger của Seek trong Hotel,áp dụng Màn chạy 1,2,Có tỉ lệ không Hoạt Động",
	Callback = function(Value)
		if not Value then return end
		task.spawn(function()
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not root then
				if Notify then Notify("Delete Seek Hotel thất bại", 3) end
				return
			end
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if not rooms then return end
			for _, v in pairs(rooms:GetDescendants()) do
				if v.Name ~= "TriggerEventCollision" then continue end
				if Notify then Notify("Deleting Seek (Hotel)...", 2) end
				local coll = v:FindFirstChild("Collision")
				if not coll then
					pcall(function() coll = v.ChildAdded:Wait() end)
				end
				if not coll or not coll:IsA("BasePart") then continue end

				pcall(function()
					if FireTouch or firetouchinterest then
						local ft = FireTouch or firetouchinterest
						ft(root, coll, 0)
						task.wait()
						ft(root, coll, 1)
					end
				end)
				task.wait(0.1)

				-- Bước 2: phóng to NGANG (X/Z), giữ Y
				local oldSize = coll.Size
				pcall(function()
					coll.Size = Vector3.new(120, oldSize.Y, 120)
				end)

				-- Pivot về player 3 lần
				for i = 1, 15 do
					pcall(function()
						coll.CFrame = root.CFrame
					end)
					task.wait(0.01)
				end

				pcall(function() coll.Size = oldSize end)

				task.spawn(function()
					task.wait(5.3)
					if not v.Parent then
						if Notify then Notify("Delete Trigger Seek Success!", 4) end
						return
					end
					if v:FindFirstChild("Collision") then
						if Notify then Notify("Delete Trigger Seek thất bại!", 4) end
					else
						if Notify then Notify("Delete Trigger Seek Success!", 4) end
					end
				end)
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.5)
	pcall(function()
		local t = Toggles.AutoHotel
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Auto Hotel</font>'
		end
	end)
end)
-- ===== Auto Complete Library (room 50) =====
local AutoLibConn = nil
HotelFloor:AddToggle("AutoCompleteLibrary", {
	Text = "Auto Complete Library",
	Default = false,
	Tooltip = "Giúp tự hoàn thành màn giải Puzzle 50 Hotel",
	Callback = function(Value)
		if AutoLibConn then task.cancel(AutoLibConn) AutoLibConn = nil end
		if not Value then return end
		AutoLibConn = task.spawn(function()
			local ok, err = pcall(function()
				local function toggleOn()
					return Toggles.AutoCompleteLibrary and Toggles.AutoCompleteLibrary.Value
				end

				-- chờ vào room 50
				while toggleOn() and tonumber(LocalPlayer:GetAttribute("CurrentRoom")) ~= 50 do
					task.wait(0.3)
				end
				if not toggleOn() then return end

				local rooms = workspace:FindFirstChild("CurrentRooms")
				if not rooms then
					if Notify then Notify("Library: không có CurrentRooms", 3) end
					return
				end
				local room50 = rooms:WaitForChild("50", 15)
				if not room50 then
					if Notify then Notify("Library: room 50 chưa load", 3) end
					return
				end

				local books = {}
				local function collect()
					for _, d in ipairs(room50:GetDescendants()) do
						if d.Name == "LiveHintBook" and not table.find(books, d) then
							table.insert(books, d)
						end
					end
				end

				local function hasPaper()
					local c = LocalPlayer.Character
					return (c and c:FindFirstChild("LibraryHintPaper", true))
						or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper", true)
				end

				local fire = Firepp or fireproximityprompt
				local t0 = tick()
				while toggleOn() and not hasPaper() and (tick() - t0) < 60 do
					collect()
					for _, book in ipairs(books) do
						if not toggleOn() then return end
						if not book.Parent then continue end
						local part = book.PrimaryPart or book:FindFirstChildWhichIsA("BasePart")
						local char = LocalPlayer.Character
						if part and char then
							char:PivotTo(part.CFrame * CFrame.new(0, 2, 0))
							task.wait(0.15)
							for _, pr in ipairs(book:GetDescendants()) do
								if pr:IsA("ProximityPrompt") and fire then
									pcall(fire, pr)
								end
							end
						end
						task.wait(0.15)
					end
					-- paper / pad trong room
					for _, d in ipairs(room50:GetDescendants()) do
						if d.Name == "LibraryHintPaper" or d.Name == "HintPaper" then
							local pr = d:FindFirstChildWhichIsA("ProximityPrompt", true)
							if pr and fire then pcall(fire, pr) end
						end
					end
					task.wait(0.3)
				end

				if hasPaper() then
					if Notify then Notify("Auto Complete Library: hoàn thành!", 4) end
				else
					if Notify then Notify("Auto Complete Library: hết thời gian / chưa có paper", 4) end
				end
			end)
			if not ok then
				warn("[AutoLibrary]", err)
				if Notify then Notify("Library lỗi: " .. tostring(err), 5) end
			end
		end)
	end,
})

-- ===== Auto Complete Electrical (room 100) =====
local AutoElecConn = nil
HotelFloor:AddToggle("AutoCompleteElectrical", {
	Text = "Auto Complete Electrical Box",
	Default = false,
	Risky = true,
	Tooltip = "Risk! Tự hoàn thành puzzle cửa 100 Hotel — có thể lỗi!",
	Callback = function(Value)
		if AutoElecConn then task.cancel(AutoElecConn) AutoElecConn = nil end
		if not Value then return end
		AutoElecConn = task.spawn(function()
			local ok, err = pcall(function()
				local function toggleOn()
					return Toggles.AutoCompleteElectrical and Toggles.AutoCompleteElectrical.Value
				end
				local function getRoot()
					local c = LocalPlayer.Character
					local h = c and c:FindFirstChildOfClass("Humanoid")
					if c and h and h.Health > 0 then
						return c:FindFirstChild("HumanoidRootPart"), c
					end
					return nil, nil
				end

				local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
				if roomNum ~= 100 then
					if Notify then Notify("Không hỗ trợ — không phải cửa 100!", 3) end
					return
				end

				local rooms = workspace:FindFirstChild("CurrentRooms")
				if not rooms then return end
				local room = rooms:WaitForChild("100", 10)
				if not room then
					if Notify then Notify("Room 100 chưa load", 3) end
					return
				end

				local fire = Firepp or fireproximityprompt
				local fuseErr = {}

				local function nearestPrompt(filterFn)
					local root = getRoot()
					if not root then return nil, 1e9 end
					local best, bd = nil, 1e9
					for _, pr in ipairs(room:GetDescendants()) do
						if pr:IsA("ProximityPrompt") and not fuseErr[pr] and (not filterFn or filterFn(pr)) then
							local parent = pr.Parent
							if not parent then continue end
							local ad = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart")
							if ad then
								local d = (ad.Position - root.Position).Magnitude
								if d < bd then best, bd = pr, d end
							end
						end
					end
					return best, bd
				end

				-- Fuse / box
				for _ = 1, 12 do
					if not toggleOn() then return end
					local root, char = getRoot()
					if not root then return end

					local pr, dist = nearestPrompt(function(p)
						local n = string.lower(p.Name .. (p.Parent and p.Parent.Name or ""))
						return n:find("fuse") or n:find("electrical") or n:find("box") or n:find("switch")
					end)
					if not pr then break end

					local parent = pr.Parent
					if not parent then
						fuseErr[pr] = true
						continue
					end
					local ad = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart")
					if not ad then
						fuseErr[pr] = true
						continue
					end

					if dist > 50 then
						fuseErr[pr] = true
					else
						local tries = 0
						while pr.Parent and tries < 25 do
							root, char = getRoot()
							if not root or not char then return end
							char:PivotTo(ad.CFrame * CFrame.new(0, 2, 0))
							if fire then pcall(fire, pr) end
							task.wait(0.12)
							tries += 1
							if not pr.Parent or not pr:IsDescendantOf(workspace) then break end
						end
						if pr.Parent and tries >= 25 then
							pcall(function() pr:SetAttribute("FuseErrorInteract", true) end)
							fuseErr[pr] = true
						end
					end
					task.wait(0.15)
				end

				-- Lever + lùi sau character
				do
					local lever = nearestPrompt(function(p)
						local n = string.lower(p.Name .. (p.Parent and p.Parent.Name or ""))
						return n:find("lever") or n:find("pull") or n:find("switch")
					end)
					if lever and lever.Parent then
						local adOk, ad = pcall(function()
							local p = lever.Parent
							return p:IsA("BasePart") and p or p:FindFirstChildWhichIsA("BasePart")
						end)
						if adOk and ad then
							local root, char = getRoot()
							if root and char then
								local look = root.CFrame.LookVector
								char:PivotTo(CFrame.new(root.Position - look * 8, root.Position))
								task.wait(0.1)
								char:PivotTo(ad.CFrame * CFrame.new(0, 2, 0))
								if fire then pcall(fire, lever) end
								for _ = 1, 20 do
									local r, c = getRoot()
									if not r or not c then break end
									local lv = r.CFrame.LookVector
									c:PivotTo(CFrame.new(r.Position - lv * 6, r.Position - lv * 8))
									task.wait(0.1)
								end
							end
						end
					end
				end

				-- Figure ≤25 → bay gần trần (không phụ thuộc Toggles.Flight bắt buộc)
				local figureNames = { FigureRig = true, FigureRagdoll = true, Figure = true }
				local function getFigurePart()
					for _, child in ipairs(workspace:GetChildren()) do
						if figureNames[child.Name] then
							return child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
						end
					end
					return nil
				end
				local function figureNear(dist)
					local r = getRoot()
					local p = getFigurePart()
					return r and p and (p.Position - r.Position).Magnitude <= dist
				end

				if figureNear(25) then
					if Toggles.Flight then
						pcall(function() Toggles.Flight:SetValue(true) end)
					end
					for _ = 1, 40 do
						local r, c = getRoot()
						if not r or not c then break end
						local rp = RaycastParams.new()
						rp.FilterType = Enum.RaycastFilterType.Exclude
						local filter = { c }
						local fp = getFigurePart()
						if fp and fp.Parent then table.insert(filter, fp.Parent) end
						rp.FilterDescendantsInstances = filter
						local hit = workspace:Raycast(r.Position, Vector3.new(0, 80, 0), rp)
						local y
						if hit then
							local inst = hit.Instance
							local half = (inst and inst.Size and inst.Size.Y or 2) / 2
							y = hit.Position.Y - half - 3
						else
							y = r.Position.Y + 20
						end
						c:PivotTo(CFrame.new(r.Position.X, y, r.Position.Z))
						r.AssemblyLinearVelocity = Vector3.zero
						if not figureNear(25) then break end
						task.wait(0.05)
					end
					if Toggles.Flight then
						pcall(function() Toggles.Flight:SetValue(false) end)
					end
				end

				-- Key + cửa + breaker
				local root, char = getRoot()
				if root and char then
					for _, d in ipairs(room:GetDescendants()) do
						if d.Name == "Key" or d.Name == "ElectricalKey" or (typeof(d.Name) == "string" and d.Name:find("Key")) then
							local pr = d:FindFirstChildWhichIsA("ProximityPrompt", true)
							local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
							if part then
								char:PivotTo(part.CFrame * CFrame.new(0, 2, 0))
								if pr and fire then pcall(fire, pr) end
							end
						end
					end
					local door = room:FindFirstChild("Door")
					if door then
						char:PivotTo(door:GetPivot() * CFrame.new(0, 1, 2))
						for _, pr in ipairs(door:GetDescendants()) do
							if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
						end
					end
					for _, pr in ipairs(room:GetDescendants()) do
						if pr:IsA("ProximityPrompt") and pr.Parent then
							local n = string.lower(pr.Name .. pr.Parent.Name)
							if n:find("break") or n:find("electric") or n:find("fuse") then
								local ad = pr.Parent:IsA("BasePart") and pr.Parent or pr.Parent:FindFirstChildWhichIsA("BasePart")
								if ad then
									char:PivotTo(ad.CFrame * CFrame.new(0, 2, 0))
									if fire then pcall(fire, pr) end
								end
							end
						end
					end
				end

				-- Elevator
				local elev = room:FindFirstChild("Elevator", true) or room:FindFirstChild("ElevatorDoor", true)
				local okElev = false
				if elev then
					local part = elev:IsA("BasePart") and elev or elev:FindFirstChildWhichIsA("BasePart")
					for _ = 1, 25 do
						local r, c = getRoot()
						if part and r and c then
							c:PivotTo(part.CFrame * CFrame.new(0, 2, 0))
							local elevPr = elev:FindFirstChildWhichIsA("ProximityPrompt", true)
							if elevPr and fire then pcall(fire, elevPr) end
							if (r.Position - part.Position).Magnitude < 8 then
								okElev = true
								break
							end
						end
						task.wait(0.08)
					end
				end
				if not okElev then
					if Notify then Notify("Cooldown!! Auto Hoàn Thành Thất bại!", 5) end
				else
					if Notify then Notify("Đã lên thang máy — chờ win!", 4) end
				end
			end)
			if not ok then
				warn("[AutoElectrical]", err)
				if Notify then Notify("Electrical lỗi: " .. tostring(err), 5) end
			end
		end)
	end,
})
local DeleteFigHotelConn = nil
HotelFloor:AddToggle("DeleteFigureHotels", {
	Text = "Delete Figure Hotels",
	Default = false,
	Tooltip = "Cố gắng kill Figure Void và Vô hiệu hoá Hitbox,Có thể thất bại Cao",
	Callback = function(Value)
		if DeleteFigHotelConn then task.cancel(DeleteFigHotelConn) DeleteFigHotelConn = nil end
		if not Value then return end
		local allow = { [49] = true, [50] = true, [51] = true, [99] = true, [100] = true }
		DeleteFigHotelConn = task.spawn(function()
			while Toggles.DeleteFigureHotels and Toggles.DeleteFigureHotels.Value do
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					for _, fig in ipairs(LeafFindFigures(250, root, allow)) do
						local part = fig.PrimaryPart or fig:FindFirstChild("HumanoidRootPart") or fig:FindFirstChildWhichIsA("BasePart")
						if not part then continue end
						if LeafHasNet(part) then
							pcall(function()
								part.Position = Vector3.new(-49999, -49999, -49999)
							end)
						else
							pcall(function()
								for _, p in ipairs(fig:GetDescendants()) do
									if p:IsA("BasePart") then
										p.CanCollide = false
										p.CanTouch = false
									end
								end
								local coll = fig:FindFirstChild("Collision", true) or fig:FindFirstChild("Hitbox", true)
								if coll and coll:IsA("BasePart") then
									coll.Size = Vector3.new(1, 1, 1)
								end
							end)
						end
					end
				end
				task.wait(0.35) -- quét nhẹ
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.35)
	pcall(function()
		local t = Toggles.DeleteFigureHotels
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then lbl.TextSize = math.max(10, (lbl.TextSize or 14) - 1) end
	end)
end)
local AutoDmgFigConn = nil
HotelFloor:AddToggle("AutoDamageFigure", {
	Text = "Auto Damage Figure",
	Default = false,
	Risky = true,
	Tooltip = "Chủ động Đập Figure nếu có cơ Hội, Yêu cầu Networks OwnerShip Luôn có!",
	Callback = function(Value)
		if AutoDmgFigConn then task.cancel(AutoDmgFigConn) AutoDmgFigConn = nil end
		if not Value then return end

		-- tạm tắt GodModeFigure / Delete Figure*
		local saved = {}
		local function pauseRelated(on)
			for _, name in ipairs({
				"GodModeFigure", "DeleteFigureHotels", "DeleteFigureFools",
				"DeleteFigureMine", "DeleteFigureFE",
			}) do
				local t = Toggles[name]
				if t then
					if on then
						saved[name] = t.Value
						if t.Value then t:SetValue(false) end
					else
						if saved[name] then t:SetValue(true) end
					end
				end
			end
		end
		pauseRelated(true)

		AutoDmgFigConn = task.spawn(function()
			local function getRoot()
				local c = LocalPlayer.Character
				local h = c and c:FindFirstChildOfClass("Humanoid")
				if c and h and h.Health > 0 then
					return c:FindFirstChild("HumanoidRootPart"), c
				end
				return nil, nil
			end
			local function findFigure()
				local root = getRoot()
				if not root then return nil end
				local allow = { [49] = true, [50] = true, [51] = true, [99] = true, [100] = true }
				local list = LeafFindFigures and LeafFindFigures(400, root, nil) or {}
				for _, n in ipairs({ "FigureRig", "FigureRagdoll", "Figure" }) do
					local m = workspace:FindFirstChild(n)
					if m then table.insert(list, m) end
				end
				return list[1]
			end
			local function getFigPart(fig)
				return fig and (fig.PrimaryPart or fig:FindFirstChild("HumanoidRootPart") or fig:FindFirstChildWhichIsA("BasePart"))
			end

			local fig = findFigure()
			if not fig then
				if Notify then Notify("Auto Damage Figure: không có Figure — dừng", 3) end
				pauseRelated(false)
				if Toggles.AutoDamageFigure then Toggles.AutoDamageFigure:SetValue(false) end
				return
			end

			local fire = Firepp or fireproximityprompt
			local roomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0

			-- Phòng 49–50: tìm Clock
			if roomNum == 49 or roomNum == 50 then
				local rooms = workspace:FindFirstChild("CurrentRooms")
				local room = rooms and rooms:FindFirstChild(tostring(roomNum))
				local hasClock = LocalPlayer.Backpack:FindFirstChild("AlarmClock")
					or LocalPlayer.Backpack:FindFirstChild("Clock")
					or (LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("AlarmClock") or LocalPlayer.Character:FindFirstChild("Clock")))
				if not hasClock and room then
					for _, d in ipairs(room:GetDescendants()) do
						local n = string.lower(d.Name)
						if n:find("clock") or n:find("alarm") then
							local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
							local pr = d:FindFirstChildWhichIsA("ProximityPrompt", true)
							local _, char = getRoot()
							if part and char then
								char:PivotTo(part.CFrame * CFrame.new(0, 2, 0))
								task.wait(0.15)
								if pr and fire then pcall(fire, pr) end
							end
						end
					end
					task.wait(0.4)
				end
				-- có clock + đang 49 → TP room 50
				hasClock = LocalPlayer.Backpack:FindFirstChild("AlarmClock")
					or LocalPlayer.Backpack:FindFirstChild("Clock")
					or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("AlarmClock"))
				if hasClock and roomNum == 49 then
					local rooms = workspace:FindFirstChild("CurrentRooms")
					local r50 = rooms and rooms:FindFirstChild("50")
					local door = r50 and r50:FindFirstChild("Door")
					local _, char = getRoot()
					if door and char then
						char:PivotTo(door:GetPivot() * CFrame.new(0, 1, 2))
						for _, pr in ipairs(door:GetDescendants()) do
							if pr:IsA("ProximityPrompt") and fire then pcall(fire, pr) end
						end
					end
					task.wait(0.5)
				end
			end

			-- Bay trên đầu Figure 3–5 studs + dùng / drop clock
			local flyConn
			local done = false
			flyConn = RunService.Heartbeat:Connect(function()
				if done or not (Toggles.AutoDamageFigure and Toggles.AutoDamageFigure.Value) then
					if flyConn then flyConn:Disconnect() end
					return
				end
				local root, char = getRoot()
				fig = findFigure()
				local fp = getFigPart(fig)
				if not root or not char or not fp then return end
				local off = 3 + (tick() % 2) -- 3–5
				char:PivotTo(CFrame.new(fp.Position + Vector3.new(0, off, 0)))
				root.AssemblyLinearVelocity = Vector3.zero

				local clock = LocalPlayer.Backpack:FindFirstChild("AlarmClock")
					or LocalPlayer.Backpack:FindFirstChild("Clock")
					or char:FindFirstChild("AlarmClock")
					or char:FindFirstChild("Clock")
				if clock and clock:IsA("Tool") then
					pcall(function()
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum then hum:EquipTool(clock) end
						clock:Activate()
					end)
					task.defer(function()
						-- nếu còn trong kho → drop; bring dưới chân (trên figure 2 studs từ offset)
						task.wait(0.2)
						local drop = workspace:FindFirstChild("AlarmClock") or workspace:FindFirstChild("Clock")
						if not drop then
							pcall(function()
								if RemotesFolder and RemotesFolder:FindFirstChild("DropItem") then
									RemotesFolder.DropItem:FireServer()
								end
							end)
						end
					end)
				end
				-- bring clock dropped dưới chân player (cao hơn figure \~2)
				for _, d in ipairs(workspace:GetChildren()) do
					if d.Name == "AlarmClock" or d.Name == "Clock" then
						local p = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
						if p then
							pcall(function()
								p.CFrame = CFrame.new(fp.Position + Vector3.new(0, 2, 0))
							end)
						end
					end
				end
			end)

			task.wait(2)
			local part = getFigPart(findFigure())
			local hasNet = part and LeafHasNet and LeafHasNet(part)

			if hasNet and part then
				-- raycast đất, bay 20 studs từ đất, void figure
				local root, char = getRoot()
				if root and char then
					local rp = RaycastParams.new()
					rp.FilterType = Enum.RaycastFilterType.Exclude
					rp.FilterDescendantsInstances = { char, findFigure() }
					local hit = workspace:Raycast(root.Position, Vector3.new(0, -50, 0), rp)
					local groundY = hit and hit.Position.Y or (root.Position.Y - 5)
					char:PivotTo(CFrame.new(root.Position.X, groundY + 20, root.Position.Z))
				end
				pcall(function()
					part.Position = Vector3.new(-49999, -49999, -49999)
				end)
				task.wait(5)
				local p2 = getFigPart(findFigure())
				if p2 and p2.Position.Y < -1000 then
					if Notify then Notify("Damage Figure Success!", 4) end
				else
					if Notify then Notify("Damage Figure: void chưa đủ", 3) end
				end
			else
				-- chờ net 15s
				local t0 = tick()
				while tick() - t0 < 15 and Toggles.AutoDamageFigure and Toggles.AutoDamageFigure.Value do
					part = getFigPart(findFigure())
					if part and LeafHasNet and LeafHasNet(part) then
						pcall(function()
							part.Position = Vector3.new(-49999, -49999, -49999)
						end)
						task.wait(5)
						if Notify then Notify("Damage Figure Success!", 4) end
						done = true
						break
					end
					task.wait(0.3)
				end
				if not done then
					-- pivot ra xa 120 studs + đất
					local root, char = getRoot()
					local fp = getFigPart(findFigure())
					if root and char and fp then
						local dir = (root.Position - fp.Position)
						if dir.Magnitude < 1 then dir = Vector3.new(1, 0, 0) end
						dir = dir.Unit * 120
						local target = fp.Position + dir
						local rp = RaycastParams.new()
						rp.FilterDescendantsInstances = { char }
						local hit = workspace:Raycast(target + Vector3.new(0, 30, 0), Vector3.new(0, -80, 0), rp)
						local y = hit and hit.Position.Y + 3 or target.Y
						char:PivotTo(CFrame.new(target.X, y, target.Z))
					end
					if Notify then Notify("Auto Damage Figure: thất bại (no network 15s)", 4) end
					if Toggles.AutoDamageFigure then Toggles.AutoDamageFigure:SetValue(false) end
				end
			end

			done = true
			if flyConn then flyConn:Disconnect() end
			pauseRelated(false) -- khôi phục GodMode / Delete Figure
		end)
	end,
})
task.defer(function()
	task.wait(0.4)
	pcall(function()
		local t = Toggles.AutoDamageFigure
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Auto Damage Figure</font>'
		end
	end)
end)
BypassEntityBox:AddToggle('FigureHearing',{
Text = "Anti Figure Hearing",
Default = false,
Callback = function(Value)
if not Value then
RemotesFolder.Crouch:FireServer(false)
else
RemotesFolder.Crouch:FireServer(true)
end
end
})
BypassEntityBox:AddToggle('AntiLag',{
Text = "Anti Lag ",
Default = false,
Tooltip = "Giảm đồ hoạ thành Plastic tránh Tụt FPS",
Callback = function(Value)
if Value then
for _, v in workspace.CurrentRooms:GetDescendants() do
if v:IsA("BasePart") then
v:SetAttribute("Mat", v.Material)
v.Material = "Plastic"
end
end
else
for _, v in workspace.CurrentRooms:GetDescendants() do
if v:IsA("BasePart") then
if v:GetAttribute("Mat") then
v.Material = v:GetAttribute("Mat") or "Plastic"
end
end
end
end
end
})
local HasteHookConn = nil
BypassEntityBox:AddToggle("AntiHaste", {
	Text = "Anti Haste",
	Default = false,
	Risky = true,
	Tooltip = "Xoá Visual Haste + Điều chỉnh Coliison Part Né va Chạm",
	Callback = function(Value)
		if HasteHookConn then
			task.cancel(HasteHookConn)
			HasteHookConn = nil
		end
		if not Value then return end
		HasteHookConn = task.spawn(function()
			while Toggles.AntiHaste and Toggles.AntiHaste.Value do
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local coll = char and (char:FindFirstChild("Collision") or char:FindFirstChild("CollisionPart") or char:FindFirstChild("CollisionClone"))
				if root then
					-- tìm Haste
					local haste = workspace:FindFirstChild("Haste") or workspace:FindFirstChild("HasteEntity")
					if not haste then
						for _, c in ipairs(workspace:GetChildren()) do
							if typeof(c.Name) == "string" and string.lower(c.Name):find("haste") then
								haste = c
								break
							end
						end
					end
					if haste then
						local hp = haste.PrimaryPart or haste:FindFirstChildWhichIsA("BasePart")
						if hp then
							local dist = (hp.Position - root.Position).Magnitude

							-- ===== Lớp 1: ≤125 studs =====
							if dist <= 125 then
								pcall(function()
									-- đứng yên entity
									hp.AssemblyLinearVelocity = Vector3.zero
									hp.AssemblyAngularVelocity = Vector3.zero
									local hHum = haste:FindFirstChildOfClass("Humanoid")
									if hHum then
										hHum.WalkSpeed = 0
										hHum.JumpPower = 0
										pcall(function() hHum.JumpHeight = 0 end)
										pcall(function()
											hHum:Move(Vector3.zero, false)
										end)
									end
									-- path / body movers
									for _, d in ipairs(haste:GetDescendants()) do
										if d:IsA("BodyVelocity") or d:IsA("BodyPosition") or d:IsA("BodyGyro")
											or d:IsA("LinearVelocity") or d:IsA("AlignPosition")
											or d:IsA("VectorForce") or d:IsA("PathfindingModifier") then
											pcall(function() d:Destroy() end)
										end
										if d:IsA("BasePart") then
											d.AssemblyLinearVelocity = Vector3.zero
										end
										-- tắt FX
										if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
											d.Enabled = false
										end
									end
									-- xóa hiệu ứng camera
									local cam = workspace.CurrentCamera
									if cam then
										for _, fx in ipairs(cam:GetChildren()) do
											local n = string.lower(fx.Name)
											if n:find("haste") or n:find("chase") or n:find("distort") then
												pcall(function() fx:Destroy() end)
											end
										end
									end
								end)
							end

							-- ===== Lớp 2: ≤50 studs — Collision xuống -49999 =====
							if dist <= 50 and coll and coll:IsA("BasePart") then
								pcall(function()
									local pos = coll.Position
									coll.Position = Vector3.new(pos.X, -49999, pos.Z)
									-- nếu có CollisionCrouch
									local crouch = coll:FindFirstChild("CollisionCrouch")
									if crouch and crouch:IsA("BasePart") then
										local cp = crouch.Position
										crouch.Position = Vector3.new(cp.X, -49999, cp.Z)
									end
								end)
							end
						end
					end
				end
				task.wait() -- mỗi frame-ish
			end
		end)
	end,
})
task.defer(function()
	task.wait(0.45)
	pcall(function()
		local t = Toggles.AntiHaste
		if not t then return end
		local lbl = t.TextLabel or (t.Object and t.Object:FindFirstChildWhichIsA("TextLabel", true))
		if lbl then
			lbl.RichText = true
			lbl.Text = '<font color="rgb(255,40,40)">Anti Haste</font>'
		end
	end)
end)
ReachBox:AddSlider("PromptReachMult", {
	Text = "Prompt Reach Multiplier",
	Min = 1,
	Max = 3,
	Default = 1.5,
	Rounding = 1,
	Compact = true,
	Callback = function(Value)
		if Toggles.PromptReach and Toggles.PromptReach.Value then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ProximityPrompt") then
					local base = v:GetAttribute("Range_Old") or v:GetAttribute("Range") or v.MaxActivationDistance
					if not v:GetAttribute("Range_Old") then
						v:SetAttribute("Range_Old", base)
					end
					v.MaxActivationDistance = base * Value
				end
			end
		end
	end,
})
ReachBox:AddToggle('PromptReach',{
	Text = "Prompt Reach",
	Default = false,
	Callback = function(Value)
		local mult = (Options.PromptReachMult and Options.PromptReachMult.Value) or 1.5
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				if not v:GetAttribute("Range_Old") then
					v:SetAttribute("Range_Old", v.MaxActivationDistance)
				end
				local base = v:GetAttribute("Range_Old")
				v.MaxActivationDistance = Value and (base * mult) or base
			end
		end
	end
})
ReachBox:AddToggle('InstantPrompts',{
	Text = "Instant Prompts",
	Default = false,
	Tooltip = "Ép Tương Tác Prompt về 0,Áp dụng cho tất cả Prompt",
	Callback = function(Value)
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				if not v:GetAttribute("Hold_Old") then
					v:SetAttribute("Hold_Old", v.HoldDuration)
				end
				v.HoldDuration = Value and 0 or (v:GetAttribute("Hold_Old") or 0)
			end
		end
	end,
})
local AntiSallyConn = nil
BypassEntityBox:AddToggle("AntiSally", {
	Text = "Anti Sally",
	Default = false,
	Risky = true,
	Tooltip = "Chống Sally Entity|Bảo vệ|Cố gắng Làm Sally dưới Void",
	Callback = function(Value)
		if AntiSallyConn then
			if typeof(AntiSallyConn) == "RBXScriptConnection" then
				AntiSallyConn:Disconnect()
			else
				task.cancel(AntiSallyConn)
			end
			AntiSallyConn = nil
		end
		if not Value then return end
		local t0 = nil
		AntiSallyConn = RunService.Heartbeat:Connect(function()
			if not (Toggles.AntiSally and Toggles.AntiSally.Value) then return end
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local clone = char and (char:FindFirstChild("CollisionClone") or char:FindFirstChild("Collision") or char:FindFirstChild("CollisionPart"))

			local sally = workspace:FindFirstChild("Sally") or workspace:FindFirstChild("SallyRig")
			if not sally then
				for _, c in ipairs(workspace:GetChildren()) do
					if typeof(c.Name) == "string" and string.lower(c.Name):find("sally") then
						sally = c
						break
					end
				end
			end
			if not sally then
				t0 = nil
				return
			end
			if not t0 then t0 = tick() end

			if clone and clone:IsA("BasePart") then
				pcall(function()
					clone.CFrame = CFrame.new(clone.Position.X, -199, clone.Position.Z)
				end)
			end

			local hum = sally:FindFirstChildOfClass("Humanoid")
			local hrp = sally:FindFirstChild("HumanoidRootPart") or sally.PrimaryPart or sally:FindFirstChildWhichIsA("BasePart")

			if hum then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Dead)
					hum.Health = 0
				end)
			else
				pcall(function()
					for _, p in ipairs(sally:GetDescendants()) do
						if p:IsA("BasePart") then
							p.CanCollide = false
							p.CanTouch = false
						end
					end
				end)
				local hasNet = false
				pcall(function()
					if hrp and isnetworkowner and isnetworkowner(hrp) then hasNet = true end
				end)
				if hasNet and hrp then
					pcall(function()
						if sally.PivotTo then
							sally:PivotTo(CFrame.new(hrp.Position.X, -12999, hrp.Position.Z))
						else
							hrp.CFrame = CFrame.new(hrp.Position.X, -12999, hrp.Position.Z)
						end
					end)
				elseif hrp then
					pcall(function()
						if sethiddenproperty then
							sethiddenproperty(LocalPlayer, "SimulationRadius", 500)
							sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 500)
						end
						if setsimulationradius then setsimulationradius(500) end
						if sally.PivotTo then
							sally:PivotTo(CFrame.new(hrp.Position.X, -800, hrp.Position.Z))
						else
							hrp.CFrame = CFrame.new(hrp.Position.X, -800, hrp.Position.Z)
						end
					end)
				end
			end

			if t0 and tick() - t0 >= 3 then
				local still = false
				local p = sally.PrimaryPart or sally:FindFirstChildWhichIsA("BasePart")
				if p and root and (p.Position - root.Position).Magnitude < 80 then
					still = true
				end
				if p and p.Position.Y < -50 then
					if Notify then Notify("Anti Sally: thành công!", 3) end
					t0 = nil
				elseif still then
					if Notify then Notify("Anti Sally: thất bại!", 3) end
					t0 = tick()
				else
					t0 = nil
				end
			end
		end)
	end,
})
ReachBox:AddToggle('PromptClip',{
	Text = "Prompt Clip",
	Default = false,
	Callback = function(Value)
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				if not v:GetAttribute("Clip") then
					v:SetAttribute("Clip", v.RequiresLineOfSight)
				end
				v.RequiresLineOfSight = Value and false or (v:GetAttribute("Clip") ~= false)
			end
		end
	end
})
ReachBox:AddToggle('DoorReach',{
	Text = "Door Reach",
	Default = false,
	Tooltip = "Mở cửa từ phạm vi cửa",
})
PlayerColor = Color3.fromRGB(150, 150, 150)
ESPBox:AddToggle('Player', {
Text = "Player",
Default = false,
Callback = function(Value)
for _, v in pairs(Players:GetPlayers()) do
if v ~= LocalPlayer and v.Character then
ESPLibrary:RemoveESP(v.Character)
if Value then
local hum = v.Character:FindFirstChildOfClass("Humanoid")
if hum and hum.Health > 0 then
AddESP(v.Character, v.Name .. " [" .. math.floor((hum.Health / hum.MaxHealth) * 100) .. "%]", PlayerColor)
end
end
end
end
end
}):AddColorPicker("ColorPicker99", {
Default = PlayerColor,
Title = "Player ESP Color",
Callback = function(Value)
PlayerColor = Value
Toggles.Player:SetValue(false)
Toggles.Player:SetValue(true)
end,
})
BypassBox:AddDivider()
BypassBox:AddToggle("InfCrucifix", {
	Text = "Infinite Crucifix",
	Default = false,
	Tooltip = "Risky! Bạn Có thể chết Hoặc mất Crucifix.Yêu cầu FPS trên 35 Ping ổn định.",
	Risky = true,
})

do
	local InfCrucifixDropTable = {
		RushMoving   = 54,
		AmbushMoving = 67,
		A60          = 70,
		GlitchRush   = 120,
		GlitchAmbush = 155,
		A120         = 75,
	}

	local InfCrucifixConnection = nil

	local function LeafInfCrucifixOnChanged(Value)
		if InfCrucifixConnection then
			InfCrucifixConnection:Disconnect()
			InfCrucifixConnection = nil
		end

		if not Value then
			return
		end

		local InfCrucifixRaycastParams = RaycastParams.new()
		InfCrucifixRaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

		InfCrucifixConnection = RunService.RenderStepped:Connect(function()
			if not Toggles.InfCrucifix.Value then
				if InfCrucifixConnection then
					InfCrucifixConnection:Disconnect()
					InfCrucifixConnection = nil
				end
				return
			end

			local InfCrucifixCharacter = LocalPlayer.Character
			if not InfCrucifixCharacter then
				return
			end

			local InfCrucifixCollision = InfCrucifixCharacter:FindFirstChild("CollisionPart")
				or InfCrucifixCharacter:FindFirstChild("Collision")
				or InfCrucifixCharacter:FindFirstChild("HumanoidRootPart")
			if not InfCrucifixCollision then
				return
			end

			InfCrucifixRaycastParams.FilterDescendantsInstances = { InfCrucifixCharacter }

			for _, InfCrucifixEntity in ipairs(workspace:GetChildren()) do
				local InfCrucifixMaxDistance = InfCrucifixDropTable[InfCrucifixEntity.Name]
				if not InfCrucifixMaxDistance or not InfCrucifixEntity.PrimaryPart then
					continue
				end

				InfCrucifixEntity.PrimaryPart.CanCollide = true
				InfCrucifixEntity.PrimaryPart.CanQuery = true

				local InfCrucifixOrigin = InfCrucifixCollision.Position
				local InfCrucifixDirection = InfCrucifixEntity.PrimaryPart.Position - InfCrucifixOrigin
				local InfCrucifixRayResult = workspace:Raycast(InfCrucifixOrigin, InfCrucifixDirection, InfCrucifixRaycastParams)

				if not InfCrucifixRayResult or not InfCrucifixRayResult.Instance:IsDescendantOf(InfCrucifixEntity) then
					continue
				end

				local InfCrucifixDistance = (InfCrucifixCollision.Position - InfCrucifixEntity.PrimaryPart.Position).Magnitude
				if InfCrucifixDistance >= InfCrucifixMaxDistance then
					continue
				end

				local InfCrucifixTool = InfCrucifixCharacter:FindFirstChildOfClass("Tool")
				if not InfCrucifixTool or InfCrucifixTool.Name ~= "Crucifix" then
					continue
				end

				task.spawn(function()
					local remotes = RemotesFolder
					if remotes and remotes:FindFirstChild("DropItem") then
						remotes.DropItem:FireServer(InfCrucifixTool)
					end
					task.wait(0.54)
					local InfCrucifixDrops = workspace:FindFirstChild("Drops")
					if not InfCrucifixDrops then
						return
					end

					local InfCrucifixDropped = InfCrucifixDrops:FindFirstChild("Crucifix")
					if not InfCrucifixDropped then
						return
					end

					local InfCrucifixPrompt = InfCrucifixDropped:FindFirstChildOfClass("ProximityPrompt")
					local fire = Firepp or fireproximityprompt
					if InfCrucifixPrompt and fire then
						fire(InfCrucifixPrompt)
					end
				end)
				task.wait(0.6)
			end
		end)
	end

	pcall(function()
		if Toggles.InfCrucifix.OnChanged then
			Toggles.InfCrucifix:OnChanged(LeafInfCrucifixOnChanged)
		end
	end)
	task.defer(function()
		task.wait(0.2)
		if Toggles.InfCrucifix and Toggles.InfCrucifix.Value then
			LeafInfCrucifixOnChanged(true)
		end
	end)
	end
BypassBox:AddDivider()
local Stored = {}
local Names = {
Lock = true,
ChestBoxLocked = true,
Cellar = true,
Chest_Vine = true,
CuttableVines = true,
SkullLock = true,
Toolbox_Locked = true,
Lock1 = true,
Lock2 = true,
}
local function IsInfItemTarget(prompt)
if not prompt or not prompt:IsA("ProximityPrompt") then return false end
if prompt.Name == "FusesPrompt" then return true end
local parent = prompt.Parent
if not parent then return false end
local parentName = parent.Name
local grandParentName = parent.Parent and parent.Parent.Name
if Names[parentName] or (grandParentName and Names[grandParentName]) then return true end
if grandParentName == "Locker_Small_Locked" then return true end
return false
end
local function RestorePrompt(Prompt)
if not Prompt then return end
if Prompt.Parent then
local ExistingPrompt = Prompt.Parent:FindFirstChild("InfPrompt")
if ExistingPrompt then
ExistingPrompt:Destroy()
end
end
Prompt:SetAttribute("InfItems", nil)
Prompt:SetAttribute("Tool", nil)
Prompt:SetAttribute("InfTime", nil)
Prompt.Enabled = true
Prompt.ClickablePrompt = true
end
local function InfPrompt(Prompt)
local Char = LocalPlayer.Character
if not Char then return end
local RootPart = Char:FindFirstChild("HumanoidRootPart")
if not RootPart then return end
local Tool = Char:FindFirstChild("Lockpick") or Char:FindFirstChild("SkeletonKey") or Char:FindFirstChild("Shears")
local Name = Tool and Tool.Name
local TargetPart = Prompt.Parent and (Prompt.Parent:IsA("BasePart") and Prompt.Parent or Prompt.Parent:FindFirstChildWhichIsA("BasePart"))
local Dist = TargetPart and GetDistanceToPlayer(TargetPart.Position) or 999
if Tool and Dist <= (Prompt.MaxActivationDistance + 5) then
if Prompt:GetAttribute("InfItems") and Prompt:GetAttribute("Tool") ~= Name then
RestorePrompt(Prompt)
end
if Prompt:GetAttribute("InfItems") then
local startTime = Prompt:GetAttribute("InfTime") or 0
if (tick() - startTime > 8) or (Dist > Prompt.MaxActivationDistance + 7) then
RestorePrompt(Prompt)
end
return
end
if not Prompt:GetAttribute("InfItems") then
Prompt.Enabled = false
Prompt:SetAttribute("InfItems", true)
Prompt:SetAttribute("Tool", Name)
Prompt:SetAttribute("InfTime", tick())
Prompt.ClickablePrompt = false
local Clone = Prompt:Clone()
Clone.Name = "InfPrompt"
Clone.MaxActivationDistance = Prompt.MaxActivationDistance
Clone.Parent = Prompt.Parent
Clone.Enabled = true
Clone.ClickablePrompt = true
local Con, ConEnded
local function Cleanup()
if Con then Con:Disconnect() end
if ConEnded then ConEnded:Disconnect() end
RestorePrompt(Prompt)
end
ConEnded = Clone.PromptButtonHoldEnded:Connect(function()
task.delay(0.15, function()
if Clone and Clone.Parent then
Cleanup()
end
end)
end)
Con = Clone.Triggered:Connect(function()
if ConEnded then ConEnded:Disconnect() end
if Con then Con:Disconnect() end
if Clone and Clone.Parent then Clone:Destroy() end
if Char:FindFirstChild(Name) then
task.spawn(function()
local Drop = nil
local StartTime = tick()
repeat
RemotesFolder.DropItem:FireServer(Tool)
task.wait(0.01)
local ClosestDist = 15
if workspace:FindFirstChild("Drops") then
for _, v in ipairs(workspace.Drops:GetChildren()) do
if v.Name == Name then
local d = GetDistanceToPlayer(v:GetPivot().Position)
if d < ClosestDist then
ClosestDist = d
Drop = v
end
end
end
end
until Drop or not Char:FindFirstChild(Name) or (tick() - StartTime) > 2.5
local firePromptFunc = Firepp or fireproximityprompt
if Name == "Shears" then
if firePromptFunc then firePromptFunc(Prompt) end
if Drop then
local DropPrompt = Drop:FindFirstChildWhichIsA("ProximityPrompt", true)
if DropPrompt and firePromptFunc then firePromptFunc(DropPrompt) end
end
else
if Drop then
local DropPrompt = Drop:FindFirstChildWhichIsA("ProximityPrompt", true)
if DropPrompt and firePromptFunc then firePromptFunc(DropPrompt) end
end
if firePromptFunc then firePromptFunc(Prompt) end
end
RestorePrompt(Prompt)
end)
else
RestorePrompt(Prompt)
end
end)
end
else
if Prompt:GetAttribute("InfItems") then
RestorePrompt(Prompt)
end
end
end
BypassBox:AddLabel("If Infinite Items doesn't work with Auto-Interact (R), it will work with the default game bind (E). Just keep tapping it",true)
BypassBox:AddToggle('InfItems',{
Text = "Infinite Items",
Callback = function(Value)
if Value then
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if IsInfItemTarget(v) then
table.insert(Stored, v)
end
end
else
for _, Prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
if Prompt:IsA("ProximityPrompt") and Prompt:GetAttribute("InfItems") then
RestorePrompt(Prompt)
end
end
table.clear(Stored)
end
end
})
local InfParams = RaycastParams.new()
InfParams.FilterType = Enum.RaycastFilterType.Exclude
local AutoInteract = 0
local AutoLibrary = 0
local AutoAnchorSolver  = 0
local NotifyCode = 0
local InfItemsDelay = 0
local PlayerESP = 0
local DoorReach = 0
table.insert(Connections,RunService.RenderStepped:Connect(function(dt)
AutoInteract += dt
NotifyCode += dt
AutoAnchorSolver += dt
InfItemsDelay += dt
PlayerESP += dt
AutoLibrary += dt
DoorReach += dt
local isAlive = LocalPlayer:GetAttribute("Alive")
if not isAlive then
	if Toggles.InfRevive and Toggles.InfRevive.Value and RemotesFolder then
		pcall(function() RemotesFolder.Revive:FireServer() end)
	end
	if CollisionClone then CollisionClone = nil end
	-- KHÔNG return — vẫn chạy phần dưới nếu còn Character
end

if Camera ~= workspace.CurrentCamera then
	Camera = workspace.CurrentCamera
end

local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")

if isAlive ~= false and char and hum then
	if not char:GetAttribute("Climbing") and Toggles.EnableMovementSpeed and Toggles.EnableMovementSpeed.Value then
		hum.WalkSpeed = Options.MovementSpeed.Value
	elseif char:GetAttribute("Climbing") and Toggles.EnableClimbingSpeed and Toggles.EnableClimbingSpeed.Value then
		hum.WalkSpeed = Options.ClimbingSpeed.Value
	end
end

if Toggles.ThirdPerson and Toggles.ThirdPerson.Value and Camera then
	local x = (Options.X and Options.X.Value) or 2
	local y = (Options.Y and Options.Y.Value) or 0
	local z = (Options.Z and Options.Z.Value) or 6
	Camera.CFrame = Camera.CFrame * CFrame.new(x, y, z)
end

if char then
for _, v in pairs(char:GetChildren()) do
if v:IsA("Accessory") then
local handle = v:FindFirstChild("Handle")
if handle then
handle.Transparency = Toggles.ThirdPerson.Value and 0 or 1
handle.LocalTransparencyModifier = Toggles.ThirdPerson.Value and 0 or 1
end
end
end
Camera.FieldOfView = Options.FOV.Value
if Toggles.Freecam.Value then
local char = LocalPlayer.Character
local hum = char and char:FindFirstChild("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if root and not root.Anchored then root.Anchored = true end
if not workspace:FindFirstChild("FreecamPart") then
local part = Instance.new("Part")
part.Name = "FreecamPart"
part.Size = Vector3.new(0.01, 0.01, 0.01)
part.Transparency = 1
part.CanCollide = false
part.Anchored = true
part.CFrame = Camera.CFrame
part.Parent = workspace
LocalPlayer:SetAttribute("fc_om", LocalPlayer.CameraMinZoomDistance)
LocalPlayer:SetAttribute("fc_ox", LocalPlayer.CameraMaxZoomDistance)
LocalPlayer.CameraMinZoomDistance = 0
LocalPlayer.CameraMaxZoomDistance = 0
local rx, ry, rz = Camera.CFrame:ToOrientation()
LocalPlayer:SetAttribute("fc_p", math.deg(rx))
LocalPlayer:SetAttribute("fc_y", math.deg(ry))
end
local fcPart = workspace:FindFirstChild("FreecamPart")
local curCam = Camera
if fcPart and curCam then
local delta = UserInputService:GetMouseDelta()
local sensitivity = UserInputService.KeyboardEnabled and 0.3 or 0.6
local pitch = (LocalPlayer:GetAttribute("fc_p") or 0) - (delta.Y * sensitivity)
local yaw = (LocalPlayer:GetAttribute("fc_y") or 0) - (delta.X * sensitivity)
pitch = math.clamp(pitch, -80, 80)
LocalPlayer:SetAttribute("fc_p", pitch)
LocalPlayer:SetAttribute("fc_y", yaw)
fcPart.CFrame = CFrame.new(fcPart.Position) * CFrame.fromOrientation(math.rad(pitch), math.rad(yaw), 0)
curCam.CFrame = fcPart.CFrame
curCam.Focus = curCam.CFrame * CFrame.new(0, 0, -10)
if hum and hum.MoveDirection.Magnitude > 0 then
local speed = 75
local moveVec = hum.MoveDirection
local localMove = curCam.CFrame:VectorToObjectSpace(moveVec)
local finalMove = (curCam.CFrame.RightVector * localMove.X) + (curCam.CFrame.LookVector * -localMove.Z)
fcPart.Position = fcPart.Position + (finalMove * speed * dt)
end
end
end
if Toggles.DeleteFigureFE.Value and Figures then
for _, v in pairs(Figures) do
local Root = v:FindFirstChild("Root")
if not IsNetworkOwner then
Notify("Xin lỗi Bạn! executor không hỗ trợ Delete Figure Vì isnetworkowner", 5)
Toggles.DeleteFigureFE:SetValue(false)
end
if Root and isnetworkowner(Root) then
if Root:FindFirstChild("BodyForce") then
Root.BodyForce.Force = Vector3.new(0, -50000, 0)
else
Root:PivotTo(CFrame.new(0, -50000, 0))
end
for _, part in pairs(v:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
part.Anchored = false
end
end
if Root.Position.Y < -1000 and not v:GetAttribute("Deleted") then
Notify("Deleted Figure Successfully", 4)
v:SetAttribute("Deleted", true)
end
end
end
end
if Toggles.AutoAnchorSolver.Value and LatestRoom.Value == 50 and AutoAnchorSolver > 0.5  then
AutoAnchorSolver = 0
local Hint = LocalPlayer.PlayerGui.MainUI:FindFirstChild("AnchorHintFrame")
if Anchors and Hint and Hint.Visible then
local ID = Hint.AnchorCode.Text
for _, v in pairs(Anchors) do
if v:FindFirstChild("Sign") and v.Sign.TextLabel.Text == ID then
local Code = Hint.Code.Text
local Note = v:FindFirstChild("Note")
local NoteText = Note and Note.SurfaceGui.TextLabel.Text or ""
local Mod = tonumber(string.match(NoteText, "%d+")) or 0
local Final = ""
for i = 1, #Code do
local Digit = tonumber(string.sub(Code, i, i)) or 0
local Res = string.find(NoteText, "+") and (Digit + Mod) % 10 or (Digit - Mod) % 10
Final = Final .. tostring(Res < 0 and Res + 10 or Res)
end
local Dis = (LocalPlayer.Character.HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
if Dis < 20 then
local AnchorRemote = v:FindFirstChildOfClass("RemoteFunction")
if AnchorRemote then
AnchorRemote:InvokeServer(tostring(Code))
end
Notify("Anchor " .. Final, 1)
end
end
end
end
end
if Toggles.AutoMinecart.Value and Camera:FindFirstChild("MinecartRig") then
if LatestRoom.Value < 49 then
if not LocalPlayer:GetAttribute("NotifyMinecart") then
Notify("[Auto Minecart] DONT MOVE", 5)
LocalPlayer:SetAttribute("NotifyMinecart", true)
end
local Root = LocalPlayer.Character.HumanoidRootPart
local ClosestDuckDist = math.huge
for _, v in pairs(DuckBoards) do
local Dist = GetDistanceToPlayer(v:GetPivot().Position)
if Dist < ClosestDuckDist then
ClosestDuckDist = Dist
end
end
if RequiredMainGame.crouching ~= (ClosestDuckDist < 30) then
RequiredMainGame.crouching = (ClosestDuckDist < 30)
end
local CurrentNode = nil
local MinDist = math.huge
for _, Node in pairs(Nodes) do
if Node:GetAttribute("ForceConnect") then
local Dist = (Root.Position - Node.Position).Magnitude
if Dist < MinDist then
MinDist = Dist
CurrentNode = Node
end
end
end
if CurrentNode then
local CurrentNum = tonumber(string.match(CurrentNode.Name, "%d+"))
if CurrentNum then
local Node1
for _, Node in pairs(Nodes) do
if Node.Name == "MinecartNode" .. tostring(CurrentNum + 3) then
Node1 = Node
break
end
end
if Node1 then
local DistToNode = GetDistanceToPlayer(CurrentNode.Position)
if DistToNode > 30 then
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = function()
return Vector3.new(0, 0, -1)
end
else
local DirectionToNode = (CurrentNode.Position - Node1.Position).Unit
local Dot = DirectionToNode:Dot(CurrentNode.CFrame.RightVector)
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = function()
if Dot > 0.15 then
return Vector3.new(1, 0, 0)
elseif Dot < -0.15 then
return Vector3.new(1, 0, 0)
end
return Vector3.new(0, 0, -1)
end
end
end
end
end
elseif LatestRoom.Value >= 50 then
if LocalPlayer:GetAttribute("NotifyMinecart") then
Notify("[Auto Minecart] YOU CAN MOVE", 5)
LocalPlayer:SetAttribute("NotifyMinecart", false)
end
Toggles.AutoMinecart:SetValue(false)
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector = Control
end
end
if Toggles.InfItems.Value and InfItemsDelay > 0.15 then
InfItemsDelay = 0
for _, Prompt in pairs(Stored) do
InfPrompt(Prompt)
end
end
if Toggles.NotifyLibraryCode.Value and NotifyCode >  5 then
NotifyCode = 0
local Code = GetLibraryCode()
if Code and LatestRoom.Value == 50 then
Notify("Code " .. Code)
end
end
if Toggles.Flight.Value then
if not LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
local Velocity = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
Velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
Velocity.Velocity = Vector3.zero
Velocity.Name = "FlightVelocity"
Velocity.P = math.huge
end
if OldAccel then
LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = OldAccel
end
local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
local flatLook = Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
if flatLook.Magnitude < 0.001 then
flatLook = Camera.CFrame.UpVector * Vector3.new(1, 0, 1) * math.sign(-Camera.CFrame.LookVector.Y)
end
local flatCam = CFrame.lookAt(Vector3.zero, flatLook)
local localInput = flatCam:VectorToObjectSpace(moveDir)
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity").Velocity = Camera.CFrame:VectorToWorldSpace(localInput) * Options.FlightSpeed.Value
end
	-- ===== Auto Position Spoof (Always On / Entity Spam) =====
if Toggles.AutoPositionSpoof and Toggles.AutoPositionSpoof.Value then
	local mode = "Entity Spam"
	if Options.AutoPositionSpoofMode and Options.AutoPositionSpoofMode.Value then
		mode = Options.AutoPositionSpoofMode.Value
	end
	if mode == "Always On" then
		if Toggles.Godmode and not Toggles.Godmode.Value then
			Toggles.Godmode:SetValue(true)
		end
		getgenv().LeafAutoSpoofed = true
	else
		local monsterAround = IsSpoofMonsterAround()
		if monsterAround and not getgenv().LeafLastMonsterAround then
			getgenv().LeafLastMonsterAround = true
			getgenv().LeafAutoSpoofed = true
			if Toggles.Godmode and not Toggles.Godmode.Value then
				Toggles.Godmode:SetValue(true)
			end
		elseif (not monsterAround) and getgenv().LeafLastMonsterAround then
			getgenv().LeafLastMonsterAround = false
			if getgenv().LeafAutoSpoofed and Toggles.Godmode and Toggles.Godmode.Value then
				Toggles.Godmode:SetValue(false)
			end
			getgenv().LeafAutoSpoofed = false
		end
	end
end
if Toggles.Immortal and Toggles.Immortal.Value then
	if LeafApplyImmortal then
		LeafApplyImmortal(LocalPlayer.Character, true)
	end
end
if (Toggles.AntiNoise and Toggles.AntiNoise.Value)
	or (Toggles.LowerPositionTV and Toggles.LowerPositionTV.Value)
	or (Toggles.BypassOverthrowTV and Toggles.BypassOverthrowTV.Value) then
	local char = LocalPlayer.Character
	if char then
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Tool") or child:IsA("Model") then
				local n = child.Name
				if n == "TV_Stand" or n == "Noise_TV" or n == "NoiseTV" or n == "TV" then
					if Toggles.LowerPositionTV and Toggles.LowerPositionTV.Value then
						LeafLowerTV(child)
					elseif Toggles.BypassOverthrowTV and Toggles.BypassOverthrowTV.Value then
						LeafOverthrowTV(child)
					elseif Toggles.AntiNoise and Toggles.AntiNoise.Value then
						LeafLowerTV(child) -- mặc định hạ void khi Anti Noise
					end
				end
			end
		end
	end
end
if Toggles.Godmode.Value then
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local coll = char and char:FindFirstChild("Collision")
	local collPart = char and char:FindFirstChild("CollisionPart")
	local floorVal = Floor and Floor.Value
	local isFool = (floorVal == "Fools" or floorVal == "OldHotel")
	-- CollisionClone
	if char and not char:FindFirstChild("CollisionClone") then
		local src = char:FindFirstChild("CollisionPart") or coll
		if src then
			local clone = src:Clone()
			clone.Name = "CollisionClone"
			clone.CanCollide = false
			clone.Anchored = false
			clone.Parent = char
			if clone:FindFirstChild("CollisionCrouch") then
				clone.CollisionCrouch:Destroy()
			end
		end
	end
	local clone = char and char:FindFirstChild("CollisionClone")

	if not isFool and root and hum then
		-- giữ hip thấp
		if hum.HipHeight ~= 0.05 then
			hum.HipHeight = 0.05
		end
		-- C1 offset
		if char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("Root") then
			local orig = getgenv().LeafOriginalC1 or CFrame.new()
			char.LowerTorso.Root.C1 = orig * CFrame.new(0, -2.346, 0)
		end
		-- Collision Y spoof
		local SpoofY = 2.328
		if coll then
			coll.Position = root.Position + Vector3.new(0, SpoofY, 0)
			coll.CanCollide = false
			if coll:FindFirstChild("CollisionCrouch") then
				coll.CollisionCrouch.Position = root.Position + Vector3.new(0, 1.328, 0)
				coll.CollisionCrouch.CanCollide = false
			end
		end
		if collPart then
			collPart.Position = root.Position + Vector3.new(0, SpoofY, 0)
		end
		if clone then
			clone.Position = root.Position + Vector3.new(0, SpoofY, 0)
			clone.CanCollide = false
		end
	elseif isFool and root and coll then
		-- Fools: SpoofOffset kiểu entity  — chỉ đẩy Collision cao nếu cần
		coll.CanCollide = false
	end
-- Virtual collision Figure — [ĐOẠN 1] mỗi frame khi bật (Abysall)
if Toggles.VirtualCollisionFigure and Toggles.VirtualCollisionFigure.Value then
	local char = LocalPlayer.Character
	local RootPart = char and char:FindFirstChild("HumanoidRootPart")
	local Collision = char and char:FindFirstChild("Collision")
	if RootPart and Collision then
		Collision.Position = RootPart.Position + Vector3.new(0, 200, 0)
	end
end
end
if not LocalPlayer.Character:FindFirstChild("CollisionClone") then
if LocalPlayer.Character:FindFirstChild("CollisionPart") then
CollisionClone = LocalPlayer.Character.CollisionPart:Clone()
CollisionClone.Parent = LocalPlayer.Character
CollisionClone.Name = "CollisionClone"
CollisionClone.RootPriority = 127
CollisionClone.Anchored = false
CollisionClone.CanCollide = false
if CollisionClone:FindFirstChild("CollisionCrouch") then
CollisionClone:FindFirstChild("CollisionCrouch"):Destroy()
end
end
end
-- God Mode Figure
if Toggles.GodModeFigure and Toggles.GodModeFigure.Value then
	local mode = (Options.GodModeFigureMode and Options.GodModeFigureMode.Value) or "Flying Body"
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local figNear, figDist = false, 999
	if root then
		for _, n in ipairs({ "FigureRig", "FigureRagdoll", "Figure" }) do
			local m = workspace:FindFirstChild(n, true)
			local p = m and (m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart"))
			if p then
				local d = (p.Position - root.Position).Magnitude
				if d < figDist then figDist = d end
				if d <= (mode == "Step Block" and 31 or 25) then figNear = true end
			end
		end
	end
	if mode == "Flying Body" then
		if figNear and root then
			local targetY = root.Position.Y -- giữ offset +11 từ lúc phát hiện
			if not getgenv().LeafGodFigY then
				getgenv().LeafGodFigY = root.Position.Y + 11
			end
			char:PivotTo(CFrame.new(root.Position.X, getgenv().LeafGodFigY, root.Position.Z))
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			if Toggles.Flight and not Toggles.Flight.Value then
				-- optional: không bắt buộc bật toggle Flight
			end
		else
			getgenv().LeafGodFigY = nil
		end
	else
		-- Step Block
		local part = workspace:FindFirstChild("LeafGodFigBlock")
		if not part then
			part = Instance.new("Part")
			part.Name = "LeafGodFigBlock"
			part.Anchored = true
			part.CanCollide = true
			part.Material = Enum.Material.Glass
			part.Color = Color3.fromRGB(50, 205, 50)
			part.Transparency = 0.35
			part.Size = Vector3.new(6, 1, 6)
			part.Parent = workspace
		end
		if figNear and root then
			if not getgenv().LeafGodFigBlockY then
				getgenv().LeafGodFigBlockY = root.Position.Y
			end
			local base = getgenv().LeafGodFigBlockY
			local elev = math.min(13, (getgenv().LeafGodFigElev or 0) + 6.5 * (dt or 0.016))
			getgenv().LeafGodFigElev = elev
			part.Transparency = 0.35
			part.CanCollide = true
			part.Position = Vector3.new(root.Position.X, base + elev - 0.5, root.Position.Z)
		else
			getgenv().LeafGodFigElev = 0
			getgenv().LeafGodFigBlockY = nil
			if part then
				part.Transparency = 1
				part.CanCollide = false
				part.Position = Vector3.new(0, -500, 0)
			end
		end
	end
end
if not HookMeta then
if Toggles.FigureHearing.Value then
if RemotesFolder:FindFirstChild("Crouch") then
RemotesFolder.Crouch:FireServer(true)
end
end
end
if Toggles.AutoLibraryCode.Value then
if LatestRoom.Value == 50 then
local Code = GetLibraryCode()
if Code then
if Toggles.BruteForceLibCode.Value and string.find(Code, "_") then
local Bruted = ""
for i = 1, #Code do
local char = string.sub(Code, i, i)
Bruted ..= (char == "_" and math.random(0, 9) or char)
end
Code = Bruted
end
PL:FireServer(Code)
end
end
end
if Toggles.DoorReach.Value and DoorReach > 0.15 then
	DoorReach = 0
	local Rooms = workspace:FindFirstChild("CurrentRooms")
	local Room = Rooms and Rooms:FindFirstChild(tostring(tonumber(LatestRoom.Value) or 0))
	local Door = Room and Room:FindFirstChild("Door")
	if Door then
		for _, p in ipairs(Door:GetDescendants()) do
			if p:IsA("ProximityPrompt") then
				if not p:GetAttribute("DoorRange_Old") then
					p:SetAttribute("DoorRange_Old", p.MaxActivationDistance)
				end
				p.MaxActivationDistance = math.max(p:GetAttribute("DoorRange_Old") * 2.5, 30)
			end
		end
		local doorPart = Door:FindFirstChild("Door")
		if doorPart and Door.Parent and Door.Parent.Name ~= "101" and GetDistanceToPlayer(doorPart.Position) < 30 then
			if Door:FindFirstChild("ClientOpen") then
				Door.ClientOpen:FireServer()
			end
		end
	end
end
if Toggles.NoAcc.Value then
	if not Toggles.Flight.Value then
		if LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties ~= PhysicalProperties.new(100, 0.1, 0.1, 0.1, 0.1) then
			LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.1, 0.1, 0.1, 0.1)
		end
	end
end
if Toggles.EnableJump.Value then
	if not LocalPlayer.Character:GetAttribute("CanJump") then
		LocalPlayer.Character:SetAttribute("CanJump", true)
	end
end
if (Toggles.AutoInteract and Toggles.AutoInteract.Value)
	or (Options.AutoInteractKeybind and Options.AutoInteractKeybind:GetState()) then
	AutoInteract = AutoInteract + (dt or 0.016)
	local interactDelay = (Options.AutoInteractDelay and Options.AutoInteractDelay.Value) or 0.06
	if AutoInteract >= interactDelay then
		AutoInteract = 0
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local fireppFunc = Firepp or fireproximityprompt
		if root and fireppFunc then
			local hrpPos = root.Position
			local reachDist = (Options.AutoInteractreach and Options.AutoInteractreach.Value) or 12
			local function tryPrompt(prompt)
				if not prompt or not prompt:IsA("ProximityPrompt") then return end
				if PromptIgnore[prompt.Name] then return end
				local parent = prompt.Parent
				if not parent then return end
				if parent.Name == "SeatPart" or parent.Name == "Seat" or parent.Name == "Chair"
					or parent:IsA("Seat") or parent:IsA("VehicleSeat") then return end
				if parent.Name == "Padlock" or parent:GetAttribute("JeffShop") then return end
				if parent.Name == "KeyObtainFake" or parent.Name == "Mandrake" then return end
				if parent.Name == "GoldPile" and Floor and Floor.Value == "Fools" then return end
				if prompt:GetAttribute("InfItems") and prompt.Name ~= "InfPrompt" then return end
				local last = AutoInteractCooldowns[prompt]
				if last and (tick() - last) < 0.12 then return end
				local targetPart = parent:IsA("BasePart") and parent
					or (parent:IsA("Model") and (parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")))
				if not targetPart then return end
				if (hrpPos - targetPart.Position).Magnitude > reachDist then return end
				-- boost range tạm
				if not prompt:GetAttribute("LeafMaxOld") then
					prompt:SetAttribute("LeafMaxOld", prompt.MaxActivationDistance)
				end
				prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, reachDist + 2)
				prompt.RequiresLineOfSight = false
				pcall(function()
					-- hold để prompt HoldDuration
					fireppFunc(prompt)
					if typeof(fireppFunc) == "function" then
						pcall(fireppFunc, prompt, true) -- một số executor: (prompt, hold)
					end
				end)
				AutoInteractCooldowns[prompt] = tick()
			end
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if rooms then
				for _, prompt in ipairs(rooms:GetDescendants()) do
					tryPrompt(prompt)
				end
			end
			-- prompt gần nhân vật (item trên người / drops)
			if char then
				for _, prompt in ipairs(char:GetDescendants()) do
					tryPrompt(prompt)
				end
			end
			local drops = workspace:FindFirstChild("Drops")
			if drops then
				for _, prompt in ipairs(drops:GetDescendants()) do
					tryPrompt(prompt)
				end
			end
		end
	end
end
-- Bring Item (bám đầu, không delay)
if Toggles.BringItem and Toggles.BringItem.Value then
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		local headCF = root.CFrame * CFrame.new(0, 2.75, 0)
		local function isPickupModel(obj)
			if not obj or not obj:IsA("Model") then return false end
			if not BringItemNames[obj.Name] then return false end
			-- phải có prompt nhặt (tránh model map trùng tên)
			if not obj:FindFirstChildWhichIsA("ProximityPrompt", true) then return false end
			return true
		end
		local function bringOne(obj)
			if not isPickupModel(obj) then return end
			local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
			if not part then return end
			if (part.Position - root.Position).Magnitude > 14.5 then return end
			pcall(function()
				for _, p in ipairs(obj:GetDescendants()) do
					if p:IsA("BasePart") then
						if not LeafBrought[p] then
							LeafBrought[p] = {
								canCollide = p.CanCollide,
								massless = p.Massless,
								anchored = p.Anchored,
							}
						end
						p.CanCollide = false
						p.Massless = true
						p.AssemblyLinearVelocity = Vector3.zero
						p.AssemblyAngularVelocity = Vector3.zero
					end
				end
				obj:PivotTo(headCF)
			end)
		end
		local drops = workspace:FindFirstChild("Drops")
		if drops then
			for _, it in ipairs(drops:GetChildren()) do bringOne(it) end
		end
		local rooms = workspace:FindFirstChild("CurrentRooms")
		local room = rooms and rooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom") or ""))
		if room then
			for _, it in ipairs(room:GetChildren()) do -- GetChildren: không duyệt mọi part
				bringOne(it)
				-- item thường nằm trong Assets/Props 1 tầng
				if it:IsA("Folder") or it:IsA("Model") then
					for _, ch in ipairs(it:GetChildren()) do
						bringOne(ch)
					end
				end
			end
		end
	end
end
if Toggles.FarmGlitchCube and Toggles.FarmGlitchCube.Value and GlitchFarmActive then
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root then
		-- không return khỏi RenderStepped — chỉ bỏ farm frame này
	else
		local spam = false
		for _, n in ipairs({"RushMoving","AmbushMoving","A60","A120","GlitchRush","GlitchAmbush","BackdoorRush"}) do
			local ent = workspace:FindFirstChild(n)
			if ent then
				local pp = ent.PrimaryPart or ent:FindFirstChildWhichIsA("BasePart")
				if pp and (pp.Position - root.Position).Magnitude < 90 then
					spam = true
					break
				end
			end
		end
		if spam then
			if Notify then Notify("Farm Glitch: ENTITY GẦN — TẮT", 4) end
			Toggles.FarmGlitchCube:SetValue(false)
		else
			for _, name in ipairs({"Collision", "CollisionPart", "CollisionClone"}) do
				local p = char:FindFirstChild(name)
				if p and p:IsA("BasePart") then p.CanCollide = false end
			end
			-- BodyVelocity (không BodyGyro)
			local bv = root:FindFirstChild("LeafGlitchBV")
			if not bv or not bv:IsA("BodyVelocity") then
				if bv then bv:Destroy() end
				bv = Instance.new("BodyVelocity")
				bv.Name = "LeafGlitchBV"
				bv.MaxForce = Vector3.new(1e5, 1e4, 1e5)
				bv.P = 5000
				bv.Parent = root
			end
			local right = root.CFrame.RightVector
			bv.Velocity = Vector3.new(right.X * 90, 12, right.Z * 90)
			-- backup CFrame nếu BV bị nuốt
			root.CFrame = root.CFrame + Vector3.new(right.X * 1.2, 0.05, right.Z * 1.2)
			if hum then hum.PlatformStand = false end
		end
	end
end

-- Wasteful Tool Others (Leaf Spam Other Tools)
do
	local wasteOn = Toggles.WastefulToolOthers and Toggles.WastefulToolOthers.Value
	local keyOn = Options.WastefulToolOthersKey and Options.WastefulToolOthersKey:GetState()
	if wasteOn or keyOn then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				pcall(function()
					if plr:FindFirstChild("Backpack") then
						for _, tool in pairs(plr.Backpack:GetChildren()) do
							if tool:IsA("Tool") then
								local re = tool:FindFirstChildOfClass("RemoteEvent")
								if re then
									re:FireServer()
								end
							end
						end
					end
					if plr.Character then
						local toolRemote = plr.Character:FindFirstChild("Remote", true)
						if toolRemote and toolRemote:IsA("RemoteEvent") then
							toolRemote:FireServer()
						end
					end
				end)
			end
		end
	end
end
-- Giữ Upside Down mỗi frame (game có thể reset Rotation)
-- Upside Down (ép mỗi frame)
if Toggles.UpsideDown and Toggles.UpsideDown.Value then
	local char = LocalPlayer.Character
	local coll = char and char:FindFirstChild("Collision")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if coll then
		local rot = coll.Rotation
		coll.Rotation = Vector3.new(rot.X, rot.Y, -90)
	end
	if root then
		local pos = root.Position
		local look = root.CFrame.LookVector * Vector3.new(1, 0, 1)
		if look.Magnitude < 0.05 then look = Vector3.new(0, 0, -1) else look = look.Unit end
		root.CFrame = CFrame.lookAt(pos, pos + look) * CFrame.Angles(math.rad(180), 0, 0)
	end
end
do
	local eyesOn = Toggles.EyesDamage and Toggles.EyesDamage.Value
	local lookOn = Toggles.LookmanDamage and Toggles.LookmanDamage.Value
	if (eyesOn or lookOn) and MotorReplication then
		local hasEyes = workspace:FindFirstChild("Eyes")
			or workspace:FindFirstChild("Lookman")
			or workspace:FindFirstChild("EyesRushMode")
		local hasLook = workspace:FindFirstChild("BackdoorLookman")
			or workspace:FindFirstChild("Lookman")
		local need = (eyesOn and hasEyes) or (lookOn and hasLook)
		if need then
			local hiding = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Hiding")
			if not hiding then
				pcall(function()
					local floorVal = Floor and Floor.Value
					if floorVal == "Fools" or floorVal == "OldHotel" then
						MotorReplication:FireServer(0, -65, 0, false)
					elseif RemotesFolder and RemotesFolder.Name ~= "RemotesFolder" then
						MotorReplication:FireServer(0, -650, 0, false)
					else
						MotorReplication:FireServer(-650)
					end
				end)
			end
		end
	end
end
if Toggles.Screech and Toggles.Screech.Value then
	local cam = workspace.CurrentCamera
	if cam then
		local sc = cam:FindFirstChild("Screech")
		if sc then pcall(function() sc:Destroy() end) end
	end
end
if Toggles.FullBright.Value then
if Lighting.Ambient ~= Color3.new(1, 1, 1) then
Lighting.Ambient = Color3.new(1, 1, 1)
end
local FBRooms = workspace:FindFirstChild("CurrentRooms")
local FBNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
local FBRoom = FBRooms and FBRooms:FindFirstChild(tostring(FBNum))
if FBRoom then
if not FBRoom:GetAttribute("OldAmbient") then
FBRoom:SetAttribute("OldAmbient", FBRoom:GetAttribute("Ambient"))
end
if FBRoom:GetAttribute("Ambient") ~= Color3.new(1, 1, 1) then
FBRoom:SetAttribute("Ambient", Color3.new(1, 1, 1))
end
end
if (tonumber(LatestRoom.Value) or 0) < 100 then
local FBNext = FBRooms and FBRooms:FindFirstChild(tostring(FBNum + 1))
if FBNext then
if not FBNext:GetAttribute("OldAmbient") then
FBNext:SetAttribute("OldAmbient", FBNext:GetAttribute("Ambient"))
end
if FBNext:GetAttribute("Ambient") ~= Color3.new(1, 1, 1) then
FBNext:SetAttribute("Ambient", Color3.new(1, 1, 1))
end
end
end
end
if Toggles.AntiCheatMani.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if Options.AntiCheatManiMethod.Value == "Velocity" then
if not Toggles.NoClip.Value then
Toggles.NoClip:SetValue(true)
end
local BodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani") or Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
local LookingVector = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 2
BodyVelocity.Velocity = Vector3.new(LookingVector.X, LookingVector.Y, LookingVector.Z)
BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
BodyVelocity.Name = "VelocityMani"
else
local currentPivot = LocalPlayer.Character:GetPivot()
LocalPlayer.Character:PivotTo(currentPivot  * CFrame.new(0, 0, 10000))
end
end
if Options.AutoInteractKeybind:GetState() and not Toggles.AutoInteract.Value then
Toggles.AutoInteract:SetValue(true)
end
if not Options.AutoInteractKeybind:GetState() and  Toggles.AutoInteract.Value then
Toggles.AutoInteract:SetValue(false)
end
if Options.NoclipKeybind:GetState() and not Toggles.NoClip.Value then
Toggles.NoClip:SetValue(true)
end
if not Options.NoclipKeybind:GetState() and  Toggles.NoClip.Value then
Toggles.NoClip:SetValue(false)
end
if Options.ThirdpersonKeybind:GetState() and not Toggles.ThirdPerson.Value then
Toggles.ThirdPerson:SetValue(true)
end
if not Options.ThirdpersonKeybind:GetState() and  Toggles.ThirdPerson.Value then
Toggles.ThirdPerson:SetValue(false)
end
if Options.AntiCheatMan:GetState() and not Toggles.AntiCheatMani.Value then
Toggles.AntiCheatMani:SetValue(true)
end
if not Options.AntiCheatMan:GetState() and  Toggles.AntiCheatMani.Value then
Toggles.AntiCheatMani:SetValue(false)
end
if Toggles.NoClip.Value then
for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
if v:IsA("BasePart") and v.Name ~= "CollisionClone" and v.CanCollide then
v.CanCollide = false
end
end
if LocalPlayer.Character:FindFirstChild("Collision") then
LocalPlayer.Character.Collision.CanCollide = false
if LocalPlayer.Character.Collision:FindFirstChild("CollisionCrouch") then
LocalPlayer.Character.Collision.CollisionCrouch.CanCollide = false
end
end
end
if not Toggles.NoClip.Value then
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if v.Name ~= "CollisionClone" and v.Name ~= "Collision" then
if v:IsA("BasePart") and not v.CanCollide then
v.CanCollide = true
end
end
end
if LocalPlayer.Character:FindFirstChild("Collision") then
LocalPlayer.Character.Collision.CanCollide = (LocalPlayer.Character.Collision.CollisionGroup == "PlayerCrouching" and false or LocalPlayer.Character.Collision.CollisionGroup ~= "PlayerCrouching" and true)
if LocalPlayer.Character.Collision:FindFirstChild("CollisionCrouch") then
LocalPlayer.Character.Collision.CollisionCrouch.CanCollide = LocalPlayer.Character.Collision.CanCollide
end
end
end
end
end))
table.insert(Connections, RunService.RenderStepped:Connect(function()
if Toggles.AutoRooms.Value then
if IsMoving then return end
if Toggles.IgnoreA60.Value and not Toggles.Godmode.Value then
Toggles.Godmode:SetValue(true)
Notify("Godmode Enabled Automatically For Ignore A-60", 5)
end
LocalPlayer.Character.Collision.Size = Vector3.new(1, 1, 3)
local DangerousEntity = workspace:FindFirstChild("A120") or workspace:FindFirstChild("GlitchRush") or workspace:FindFirstChild("GlitchAmbush")
local A60 = workspace:FindFirstChild("A60")
local ShouldHide = false
if DangerousEntity and DangerousEntity.PrimaryPart and DangerousEntity.PrimaryPart.Position.Y > -4 then
ShouldHide = true
elseif A60 and A60.PrimaryPart and A60.PrimaryPart.Position.Y > -4 then
if not Toggles.IgnoreA60.Value then
ShouldHide = true
end
end
if ShouldHide then
local Closet = GetNearestHidingSpot()
if Closet then
Closet.Base.CanCollide = false
PathTo(Closet.Base.Position)
if not LocalPlayer.Character.CollisionPart.Anchored then
fireproximityprompt(Closet.HidePrompt)
end
end
else
LocalPlayer.Character:SetAttribute("Hiding", false)
local CurrentRoom = workspace.CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))
if CurrentRoom then
local TargetDoor = CurrentRoom:FindFirstChild("Door")
if TargetDoor and TargetDoor:FindFirstChild("Door") then
PathTo(TargetDoor.Door.Position)
end
end
end
end
end))
if HookMeta then
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
if Library.Unloaded then
if HookMeta then
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
	if Library.Unloaded then
		return Old(Self, ...)
	end
	local Method = getnamecallmethod()
	local Args = {...}

	if Method == "FireServer" or Method == "InvokeServer" then
		if Toggles.AutoHeartbeat.Value and Self.Name == "ClutchHeartbeat" then
			return Old(Self, true)
		end
		if Method == "FireServer" and Toggles.FigureHearing.Value and Self.Name == "Crouch" then
			return Old(Self, true, true)
		end

		if Method == "FireServer" and Self.Name == "MotorReplication" then
			local eyesOn = Toggles.EyesDamage and Toggles.EyesDamage.Value
			local lookOn = Toggles.LookmanDamage and Toggles.LookmanDamage.Value
			local hasEyes = workspace:FindFirstChild("Eyes")
				or workspace:FindFirstChild("Lookman")
				or workspace:FindFirstChild("EyesRushMode")
			local hasLook = workspace:FindFirstChild("BackdoorLookman")
				or workspace:FindFirstChild("Lookman")
			if (eyesOn and hasEyes) or (lookOn and hasLook) then
				local floorVal = Floor and Floor.Value
				if floorVal == "Fools" or floorVal == "OldHotel" then
					return Old(Self, 0, -65, 0, false)
				else
					return Old(Self, -650)
				end
			end
		end
	end
	return Old(Self, ...)
end)
end
return Old(Self, ...)
end
local Method = getnamecallmethod()
if Method == "FireServer" or Method == "InvokeServer" then
if Toggles.AutoHeartbeat.Value and Self.Name == "ClutchHeartbeat" then
return Old(Self, true)
end
if Method == "FireServer" and Toggles.FigureHearing.Value and Self.Name == "Crouch" then
return Old(Self, true,true)
end
end
return Old(Self, ...)
end)
end
table.insert(Connections,workspace.DescendantAdded:Connect(function(v)
local timeout = 0
repeat task.wait(0.03) timeout += 0.03 until v.Parent or timeout > 0.5
if v.Parent then
if v.Parent:FindFirstChildOfClass("Humanoid") then return end
if (v.Name == "Candle" and v.Parent.Name == "Candle" or v.Parent.Parent and v.Parent.Parent.Name == "Candle") then return end
if  HidingPlaces[v.Name] then
table.insert(Closets, v)
end
if Toggles.AntiLag.Value then
if v:IsA("BasePart") then
v:SetAttribute("Mat", v.Material)
v.Material = "Plastic"
end
end
if Toggles.InfItems.Value then
if IsInfItemTarget(v) then
table.insert(Stored, v)
end
end
if Toggles.DeleteSeekFE.Value then
if v.Name == "TriggerEventCollision" then
Notify("Deleting Seek", 3)
local Part = v:FindFirstChild("Collision") or v.ChildAdded:Wait()
if Part then
Notify("DONT OPEN NEXT DOOR", 1)
task.wait(0.1)
for _, Item in pairs(v:GetChildren()) do
if Item.Name == "Collision" then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if FireTouch then
firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Item, 0)
task.wait()
firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Item, 1)
end
end
end
end
task.wait(0.5)
local Success = true
for _, Item in pairs(v:GetChildren()) do
if Item.Name == "Collision" then
Success = false
break
end
end
if Success then
Notify("Deleted Seek Successfully Open Next Door", 3)
else
Notify("Failed To Delete Seek Open Next Door", 3)
end
end
end
end
if Toggles.SeekObf.Value then
if v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction" then
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = false
end
end
end
end
if Toggles.AutoMinecart.Value then
if v.Name == "DuckBoard" then
table.insert(DuckBoards, v)
end
if string.find(v.Name, "MinecartNode") then
table.insert(Nodes, v)
end
end
if Toggles.AntiSeekFlood.Value then
if v.Name == "SeekFloodline" then
v.CanCollide = true
end
end
if Toggles.ShowPath.Value then
if v.Name == "SeekGuidingLight" then
ShowSeekPath(v)
end
end
if Toggles.DeleteFigureFE.Value then
if v.Name == "FigureRig" or v.Name == "FigureRagdoll" then
table.insert(Figures,v)
end
end
if Toggles.PromptClip.Value then
if v:IsA("ProximityPrompt") then
v:SetAttribute("Clip", v.RequiresLineOfSight)
v.RequiresLineOfSight = false
end
end
if Toggles.AutoBreaker.Value then
if v.Name == "ElevatorBreaker" then
Breaker(v)
end
end
if Toggles.PromptReach.Value then
if v:IsA("ProximityPrompt") then
v:SetAttribute("Range", v.MaxActivationDistance)
v.MaxActivationDistance = v.MaxActivationDistance * 2
end
end
if Toggles.Snare.Value then
if  v.Name == "Snare" then
local wait = 0
repeat task.wait(0.01) wait = wait  + 0.01 until wait > 1 or v:FindFirstChild("Hitbox")
if v:FindFirstChild("Hitbox") then
v.Hitbox.CanTouch = false
end
end
end
if Toggles.AntiLava.Value then
if v.Name == "Lava" then
v.CanTouch = false
end
end
if Toggles.AntiWall.Value then
if v.Name == "ScaryWall" then
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart") then
i.CanTouch = false
end
end
end
end
if Toggles.RealBridge.Value then
if v.Name == "Bridge" then
if v.CanCollide == false then
v.Transparency = 1
end
end
end
if Toggles.Dupe.Value then
if v.Name == "DoorFake"  and v.Parent.Name == "SideroomDupe" then
v:WaitForChild("Hidden",9e9).CanTouch = false
end
end
if Toggles.FixBrokenBridge.Value then
if v.Name == "Bridge" then
FixBridge(v)
end
end
if Toggles.AutoAnchorSolver.Value then
if v.Name == "MinesAnchor" then
table.insert(Anchors,v)
end
end
if Toggles.GloomEggDamage.Value then
if v.Name == "GloomEgg" then
repeat task.wait() until v:FindFirstChildWhichIsA("BasePart")
for _, i in pairs(v:GetChildren()) do
if i:IsA("BasePart")  then
i.CanTouch = false
end
end
end
end
if v:IsA("ProximityPrompt") then
if not (PromptIgnore[v.Name] or  v.Parent.Name == "Padlock" or  v.Parent:GetAttribute("JeffShop"))  or v.Parent.Parent.Name == "RetroWardrobe" then
table.insert(Interactions, v)
end
end
if Toggles.Giggle.Value then
if   v.Name == "GiggleCeiling" then
repeat task.wait() until v:FindFirstChild("Hitbox")
v.Hitbox.CanTouch = false
end
end
if v:IsA("ProximityPrompt") then
if Toggles.InstaInteract.Value then
v:SetAttribute("Duration",v.HoldDuration)
v.HoldDuration = 0
end
end
end
end))
table.insert(Connections,workspace.DescendantRemoving:Connect(function(v)
if Toggles.AutoInteract.Value then
for i, g in pairs(Interactions) do
if g ==  v then
table.remove(Interactions, i)
break
end
end
end
for i, g in pairs(Closets) do
if v == g then
table.remove(Closets, i)
end
end
for i, k in pairs(Stored) do
if v == k then
table.remove(Stored, i)
end
end
end))
task.spawn(function()
local MenuGroup = Tabs.Settings:AddLeftGroupbox('UI Settings')
local UtilityBox = Tabs.Settings:AddRightGroupbox('Hub Utilities')
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind
MenuGroup:AddToggle("ShowKeybinds", { Text = "Show Keybinds Overlay", Default = false }):OnChanged(function()
Library.KeybindFrame.Visible = Toggles.ShowKeybinds.Value
end)
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = true,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDivider()
MenuGroup:AddToggle('PlayNotifySound',{
Text = "Play Notification Sound",
Default = true,
Callback = function(Value)
PlaySound = Value
end
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddButton('Test Notification',function()
Notify("Hello World",2)
end)
MenuGroup:AddDropdown("Library", {
Values = { "Obsidian", "Linoria" },
Default = 1,
Text = "Library",
Callback = function(Value)
getgenv().ScriptLibrary = tostring(Value)
Notify('Please Unload Script and Execute Again to Take Effect',4)
end,
})
MenuGroup:AddDropdown("RenderESPSpeed", {
Values = { "10", "30", "60", "90", "120","144", "240"},
Default = Library.IsMobile and 2 or 6,
Text = "ESP Rendering Speed",
Callback = function(Value)
ESPLibrary:SetRenderingSpeed(Value)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "95%", "100%", "125%", "150%", "175%", "200%" },
Default = "95%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
-- ===== Show Watermark [Beta] =====
local LeafWmLabel = nil
local LeafWmConn = nil
local LeafWmFrameCount, LeafWmFrameTime, LeafWmFPS = 0, 0, 60
local LeafWmCachedPingStat = nil

local FLOOR_META = {
	Hotel = { color = "rgb(80,180,255)", icon = "hotel" },
	Hotels = { color = "rgb(80,180,255)", icon = "hotel" },
	Mines = { color = "rgb(180,140,80)", icon = "pickaxe" },
	Mine = { color = "rgb(180,140,80)", icon = "pickaxe" },
	Outdoors = { color = "rgb(80,220,120)", icon = "trees" },
	Backdoor = { color = "rgb(160,120,255)", icon = "clock" },
	OldHotel = { color = "rgb(120,160,200)", icon = "building-2" },
	Achiever = { color = "rgb(255,180,80)", icon = "graduation-cap" },
	Achiver = { color = "rgb(255,180,80)", icon = "graduation-cap" },
	Stairwell = { color = "rgb(200,200,120)", icon = "stairs" },
	Fools = { color = "rgb(255,100,100)", icon = "brick-wall" },
}

local function LeafGetFPSColor(fps)
	if fps >= 45 then return "rgb(50,220,90)" end
	if fps >= 30 then return "rgb(255,200,40)" end
	return "rgb(255,60,60)"
end

local function LeafGetPingColor(ms)
	if ms <= 80 then return "rgb(50,220,90)" end
	if ms <= 150 then return "rgb(255,200,40)" end
	return "rgb(255,60,60)"
end

local function LeafGetRealPing()
	local ping = 0
	pcall(function()
		local stats = game:GetService("Stats")
		local net = stats:FindFirstChild("Network")
		local ssi = net and net:FindFirstChild("ServerStatsItem")
		if not LeafWmCachedPingStat and ssi then
			LeafWmCachedPingStat = ssi:FindFirstChild("Data Ping")
		end
		if LeafWmCachedPingStat and LeafWmCachedPingStat.GetValue then
			ping = LeafWmCachedPingStat:GetValue()
		end
	end)
	if not ping or ping <= 0 then
		pcall(function()
			ping = (LocalPlayer:GetNetworkPing() or 0) * 1000
		end)
	end
	return math.max(1, math.floor(ping))
end

local function LeafFloorLabel()
	local fv = "?"
	pcall(function()
		fv = tostring(Floor and Floor.Value or ReplicatedStorage.GameData.Floor.Value)
	end)
	local meta = FLOOR_META[fv] or { color = "rgb(160,200,255)", icon = "layers" }
	return fv, meta.color, meta.icon
end

MenuGroup:AddToggle("ShowWatermarkBeta", {
	Text = "Show Watermark [Beta]",
	Default = false,
	Tooltip = "Player | Floor | FPS | Ping Đo chỉ số",
	Callback = function(Value)
		if LeafWmConn then
			LeafWmConn:Disconnect()
			LeafWmConn = nil
		end
		if LeafWmLabel then
			pcall(function()
				if LeafWmLabel.Destroy then LeafWmLabel:Destroy() end
			end)
			LeafWmLabel = nil
		end
		if not Value then return end

		local logoIcon = LeafLogoAsset or ""
		LeafWmLabel = Library:AddDraggableLabel({
			Text = "Leaf Hub",
			Icon = logoIcon,
			IconPosition = "left",
		})

		LeafWmFrameCount, LeafWmFrameTime, LeafWmFPS = 0, 0, 60
		local lastUi = 0

		LeafWmConn = RunService.RenderStepped:Connect(function(dt)
			LeafWmFrameCount += 1
			LeafWmFrameTime += dt
			if LeafWmFrameTime >= 1 then
				LeafWmFPS = math.clamp(math.floor(LeafWmFrameCount / LeafWmFrameTime), 1, 999)
				LeafWmFrameCount = 0
				LeafWmFrameTime = 0
			end
			if tick() - lastUi < 1 then return end
			lastUi = tick()

			local ping = LeafGetRealPing()
			local floorName, floorColor = LeafFloorLabel()
			local fpsC = LeafGetFPSColor(LeafWmFPS)
			local pingC = LeafGetPingColor(ping)
			local name = LocalPlayer.DisplayName or LocalPlayer.Name

			-- RichText: tên | Floor màu | FPS màu | Ping màu
			local text = string.format(
				'<font color="rgb(230,255,245)">%s</font> | <font color="%s">Floor: %s</font> | <font color="%s">FPS: %d</font> | <font color="%s">Ping: %dms</font>',
				name,
				floorColor,
				floorName,
				fpsC,
				LeafWmFPS,
				pingC,
				ping
			)
			pcall(function()
				if LeafWmLabel.SetText then
					LeafWmLabel:SetText(text)
				end
				if LeafWmLabel.SetIcon and logoIcon ~= "" then
					LeafWmLabel:SetIcon(logoIcon)
				end
			end)
		end)
	end,
})
UtilityBox:AddButton({
Text = "Unload Hub",
Func = function()
LocalPlayer:SetAttribute("LeafLoaded", nil)
for _, con in pairs(Connections) do con:Disconnect() end
if ESPHooks and ESPHooks.ClearAll then
ESPHooks.ClearAll()
end
local Dread = LocalPlayer:FindFirstChild("Dread",true) or LocalPlayer:FindFirstChild("_Dread",true)
if Dread then
Dread.Name = "Dread"
end
local Dread = ClientModules.EntityModules:FindFirstChild("Shade",true) or ClientModules.EntityModules:FindFirstChild("_Shade",true)
if Dread then
Dread.Name = "Shade"
end
FakeA90:Destroy()
FakeScreech:Destroy()
if ReplicatedStorage:FindFirstChild("Screech") then
ReplicatedStorage:FindFirstChild("Screech").Parent = RemotesFolder
end
local getcons = getconnections or get_signal_cons or get_relative_connections
if getcons then
for _, con in pairs(getcons(LocalPlayer.Idled)) do
if con.Enable then
con:Enable()
end
end
end
local fcPart = workspace:FindFirstChild("FreecamPart")
if fcPart then
fcPart:Destroy()
local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if root then root.Anchored = false end
LocalPlayer.CameraMinZoomDistance = LocalPlayer:GetAttribute("fc_om") or 0.5
LocalPlayer.CameraMaxZoomDistance = LocalPlayer:GetAttribute("fc_ox") or 128
end
if ReplicatedStorage:FindFirstChild("A90") then
ReplicatedStorage:FindFirstChild("A90").Parent = RemotesFolder
end
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
v.CanTouch = true
end
if v.Name == "BridgeBarrier" then
v:Destroy()
end
end
if LocalPlayer.Character then
LocalPlayer.Character.Humanoid.WalkSpeed = 16
LocalPlayer.Character:SetAttribute("CanJump",false)
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if not (v.Name == "CollisionClone") and v:IsA("BasePart") then
v.CanCollide  = true
end
end
if OldAccel then
LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = OldAccel
OldAccel = nil
end
end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.HoldDuration = v:GetAttribute("Duration") or
v.HoldDuration
end
end
if OldFogEnd then
Lighting.FogEnd = OldFogEnd
OldFogEnd = nil
end
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("Atmosphere") then
v.Density = 0.94
end
end
if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani") then
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani"):Destroy()
end
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = true
for _, v in pairs(workspace.CurrentRooms:GetChildren()) do
v:SetAttribute("Ambient", v:GetAttribute("OldAmbient") and v:GetAttribute("OldAmbient") or Color3.new(0, 0, 0))
end
FakeScreech:Destroy()
FakeA90:Destroy()
task.wait()
if RemotesFolder:FindFirstChild("A90_") then
RemotesFolder:FindFirstChild("A90_").Name = "A90"
end
if RemotesFolder:FindFirstChild("Screech_") then
local Cutscene = RemoteListener:FindFirstChild("Cutscenes") or RemoteListener:FindFirstChild("Cutscenes_")
Cutscene.Name = "Cutscenes"
RemotesFolder:FindFirstChild("Screech_").Name = "Screech"
end
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.MaxActivationDistance = v:GetAttribute("Range") or v.MaxActivationDistance
end
if v.Name == "SeekFloodline" then
v.CanCollide = false
end
end
for _, Prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
if Prompt:IsA("ProximityPrompt") and Prompt:GetAttribute("InfItems") then
RestorePrompt(Prompt)
end
end
for _, v in workspace.CurrentRooms:GetDescendants() do
if v:IsA("BasePart") then
if v:GetAttribute("Mat") then
v.Material = v:GetAttribute("Mat") or "Plastic"
end
end
end
if CollisionClone then
CollisionClone:Destroy()
CollisionClone = nil
end
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.RequiresLineOfSight = v:GetAttribute("Clip") or true
end
end
if PathFolder then
PathFolder:Destroy()
end
if LocalPlayer.Character then
LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
LocalPlayer.Character.LowerTorso.Root.C1 = CFrame.new(Vector3.new(0, 0, 0))
end
if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity"):Destroy()
end
if RemotesFolder:FindFirstChild("Crouch") then
RemotesFolder.Crouch:FireServer(false)
end
if LocalPlayer.Character then
LocalPlayer.Character.Collision.Position = LocalPlayer.Character.HumanoidRootPart.Position
LocalPlayer.Character.Humanoid.HipHeight =2.4
if RemotesFolder.Name ~= "RemotesFolder" then
LocalPlayer.Character.Collision.Position = LocalPlayer.Character.HumanoidRootPart.Position
end
end
if GodmodeFolder then Folder:Destroy()
end
if LocalPlayer.Character then
for _, v in pairs(LocalPlayer.Character:GetChildren()) do
if v.Name ~= "CollisionClone"  and v.Name ~= "Collision" and v.Name ~= "HumanoidRootPart" and v.Name ~= "CollisionPart" then
if v:IsA("BasePart") then
v.Transparency = 0
end
end
end
end
if  ReplicatedStorage:FindFirstChild("LiveModifiers") and ReplicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
local Jam = LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game").Health.Jam
Jam.Playing = true
local Jamming = game:GetService("SoundService").Main.Jamming
Jamming.Enabled =  true
end
if Library.KeybindFrame then
local pos = Library.KeybindFrame.Position
getgenv().LeafHub_KeybindPos = { pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset }
end
Library:Unload()
ESPLibrary:Unload()
ShouldStop = true
end
})
end)
if ThemeManager then
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("LeafHub")
end
if SaveManager then
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
SaveManager:SetFolder("LeafHub/DOORSLOBBY")
SaveManager:BuildConfigSection(Tabs['Settings'])
end
if ThemeManager then
ThemeManager:ApplyToTab(Tabs['Settings'])
end
Notify("Successfully Loaded for Game |  DOORS ",4)
end
