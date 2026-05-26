--// DENYS ULTIMATE SECRET FINDER
--// AUTO HOP + BETTER DETECTION + ANTI REPEAT
--// DRAG GUI + STOP + MINIMIZE + EXIT

if getgenv().BrainrotLoaded then
	return
end
getgenv().BrainrotLoaded = true

repeat task.wait()
until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

repeat task.wait()
until LocalPlayer.Character
and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

task.wait(8)

--========================
-- AUTO EXECUTE
--========================

if queue_on_teleport then
	queue_on_teleport([[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jesusvc194-jpg/script.lua/main/Denys"))()
	]])
end

--========================
-- SETTINGS
--========================

local AutoHop = true
local ServerCursor = nil

getgenv().VisitedServers =
	getgenv().VisitedServers or {}

local VisitedServers =
	getgenv().VisitedServers

--========================
-- SECRET LIST
--========================

local SecretKeywords = {

"La Supreme Combinasion",
"La Grande Combinasion",
"Dragon Cannelloni",
"Garama and Madundung",
"Ketchuru and Musturu",
"Developini Braziliaspidini",
"Money Money Puggy",
"Kings Coleslaw",
"Tralaledon",
"Nuclearo Dinossauro",
"Ketupat Kepat",
"Tictac Sahur",
"Spaghetti Tualetti",
"Strawberry Elephant",
"Burguro and Fryuro",
"Chillin Chili",
"Spyderinis",
"Extinct Tralalero",
"Los Spyderrinis",
"Fragola La La La",
"La Cucaracha",
"Los Tralaleritos",
"Los Tortus",
"Guerriro Digitale",
"Yess my examine",
"Extinct Matteo",
"Las Tralaleritas",
"La Karkerkar Combinasion",
"Job Job Job Sahur",
"Karker Sahur",
"Las Vaquitas Saturnitas",
"Graipuss Medussi",
"Perrito Burrito",
"Nooo My Hotspot",
"Los Jobcitos",
"Noo my examine",
"La Sahur Combinasion",
"To to to Sahur",
"Karkerkar Kurkur",
"Pot Hotspot",
"Quesadilla Crocodila",
"Chicleteira Bicicleteira",
"Los Noo My Hotspotsitos",
"Los Nooo My Hotspotsitos",
"Los Chicleteiras",
"61",
"Mariachi Corazoni",
"Tacorita Bicicleta",
"Las Sis",
"Los Hotspotsitos",
"Celularcini Viciosini",
"Los 61",
"La Extinct Grande",
"Los Bros",
"Esok Sekolah",
"Los Primos",
"Los Tacoritas",
"Tang Tang Kelentang",
"Los Combinasionas",
"La Combinasion"

}

--========================
-- GUI
--========================

local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer.PlayerGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,320,0,270)
main.Position = UDim2.new(0.02,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)

Instance.new("UICorner",main)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🔥 DENYS FINDER"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,170,0)

local stopBtn = Instance.new("TextButton")
stopBtn.Parent = main
stopBtn.Size = UDim2.new(0,50,0,25)
stopBtn.Position = UDim2.new(0.34,0,0.03,0)
stopBtn.Text = "STOP"
stopBtn.TextScaled = true
stopBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)

Instance.new("UICorner",stopBtn)

local hopBtn = Instance.new("TextButton")
hopBtn.Parent = main
hopBtn.Size = UDim2.new(0,50,0,25)
hopBtn.Position = UDim2.new(0.52,0,0.03,0)
hopBtn.Text = "HOP"
hopBtn.TextScaled = true
hopBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)

Instance.new("UICorner",hopBtn)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = main
minimizeBtn.Size = UDim2.new(0,30,0,25)
minimizeBtn.Position = UDim2.new(0.71,0,0.03,0)
minimizeBtn.Text = "-"
minimizeBtn.TextScaled = true

Instance.new("UICorner",minimizeBtn)

local exitBtn = Instance.new("TextButton")
exitBtn.Parent = main
exitBtn.Size = UDim2.new(0,55,0,25)
exitBtn.Position = UDim2.new(0.82,0,0.03,0)
exitBtn.Text = "EXIT"
exitBtn.TextScaled = true
exitBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)

Instance.new("UICorner",exitBtn)

local status = Instance.new("TextLabel")
status.Parent = main
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,0,35)
status.BackgroundTransparency = 1
status.Text = "🔍 Searching..."
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.new(1,1,1)

local scrolling = Instance.new("ScrollingFrame")
scrolling.Parent = main
scrolling.Position = UDim2.new(0,8,0,65)
scrolling.Size = UDim2.new(1,-16,1,-73)
scrolling.BackgroundTransparency = 1
scrolling.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout")
layout.Parent = scrolling
layout.Padding = UDim.new(0,5)

--========================
-- BUTTONS
--========================

stopBtn.MouseButton1Click:Connect(function()

	AutoHop = not AutoHop

	if AutoHop then
		stopBtn.Text = "STOP"
	else
		stopBtn.Text = "PLAY"
	end
end)

hopBtn.MouseButton1Click:Connect(function()
	HopServer()
end)

exitBtn.MouseButton1Click:Connect(function()
	game:Shutdown()
end)

minimizeBtn.MouseButton1Click:Connect(function()

	scrolling.Visible =
		not scrolling.Visible

	status.Visible =
		not status.Visible
end)

--========================
-- DRAG GUI
--========================

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

	local delta =
		input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

main.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
	then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End
			then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
	then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		update(input)
	end
end)

--========================
-- SOUND
--========================

local function PlaySound()

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9118828562"
	sound.Volume = 3
	sound.Parent = workspace

	sound:Play()

	game.Debris:AddItem(sound,5)
end

--========================
-- ADD CARD
--========================

local function AddCard(player,item)

	local holder = Instance.new("Frame")
	holder.Parent = scrolling
	holder.Size = UDim2.new(1,-5,0,55)
	holder.BackgroundColor3 = Color3.fromRGB(30,30,30)

	Instance.new("UICorner",holder)

	local txt = Instance.new("TextLabel")
	txt.Parent = holder
	txt.Size = UDim2.new(1,-10,1,0)
	txt.Position = UDim2.new(0,10,0,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBold
	txt.TextXAlignment = Enum.TextXAlignment.Left

	txt.Text =
	"👤 "..player..
	"\n💎 "..item
end

--========================
-- DETECTOR
--========================

local foundRare = false

local function IsRare(name)

	for _,keyword in pairs(SecretKeywords) do

		if string.find(
			string.lower(name),
			string.lower(keyword)
		) then
			return true
		end
	end

	return false
end

local function ScanServer()

	foundRare = false

	scrolling:ClearAllChildren()

	layout.Parent = scrolling

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= LocalPlayer then

			local function check(container)

				for _,obj in pairs(container:GetDescendants()) do

					if IsRare(obj.Name) then

						foundRare = true

						AddCard(plr.Name,obj.Name)

						PlaySound()

						status.Text =
							"🔥 SECRET FOUND"

					end
				end
			end

			pcall(function()

				if plr.Character then
					check(plr.Character)
				end

				if plr:FindFirstChild("Backpack") then
					check(plr.Backpack)
				end

			end)
		end
	end
end

--========================
-- SERVER HOP
--========================

function HopServer()

	if not AutoHop then
		return
	end

	status.Text = "🔁 Searching new server..."

	local success,servers = pcall(function()

		local url =
			"https://games.roblox.com/v1/games/"..
			PlaceId..
			"/servers/Public?sortOrder=Desc&limit=100"

		if ServerCursor then
			url = url .. "&cursor=" .. ServerCursor
		end

		return HttpService:JSONDecode(
			game:HttpGet(url)
		)

	end)

	if not success or not servers then

		task.wait(2)

		return HopServer()
	end

	ServerCursor = servers.nextPageCursor

	local bestServer = nil

	for _,server in pairs(servers.data) do

		local freeSlots =
			server.maxPlayers - server.playing

		if server.id ~= game.JobId
		and freeSlots >= 2
		and server.playing >= 3
		and not table.find(VisitedServers,server.id) then

			table.insert(VisitedServers,server.id)

			bestServer = server

			break
		end
	end

	if not bestServer then

		ServerCursor = nil

		task.wait(1)

		return HopServer()
	end

	TeleportService:TeleportToPlaceInstance(
		PlaceId,
		bestServer.id,
		LocalPlayer
	)
end

--========================
-- RETRY TP
--========================

GuiService.ErrorMessageChanged:Connect(function()

	task.wait(1)

	HopServer()

end)

--========================
-- MULTI SCAN
--========================

for i = 1,5 do

	status.Text =
		"🔍 Scanning "..i.."/5"

	ScanServer()

	if foundRare then
		break
	end

	task.wait(4)
end

--========================
-- AUTO HOP
--========================

if not foundRare then

	status.Text = "❌ No secrets found"

	task.wait(5)

	HopServer()

else

	status.Text = "✅ SECRET SERVER"

end
