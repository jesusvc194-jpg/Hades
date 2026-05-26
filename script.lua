--// DENYS ULTIMATE SECRET FINDER
--// PREMIUM FULL VERSION
--// AUTO HOP + ANTI FREEZE + ANTI REPEAT
--// BETTER DETECTOR + PREMIUM UI

if getgenv().BrainrotLoaded then
	return
end

getgenv().BrainrotLoaded = true

repeat task.wait()
until game:IsLoaded()

-- SERVICES

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

repeat task.wait()
until LocalPlayer.Character
and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

task.wait(8)

-- AUTO EXECUTE

if queue_on_teleport then
	queue_on_teleport([[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jesusvc194-jpg/Hades/main/script.lua"))()
	]])
end

-- SETTINGS

local AutoHop = true
local ServerCursor = nil

getgenv().VisitedServers =
	getgenv().VisitedServers or {}

local VisitedServers =
	getgenv().VisitedServers

-- SECRET LIST

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

-- GUI

local gui = Instance.new("ScreenGui")
gui.Name = "DenysFinder"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,340,0,300)
main.Position = UDim2.new(0.02,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius =
	UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(255,140,0)
stroke.Thickness = 2

local gradient = Instance.new("UIGradient")
gradient.Parent = main
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(
		0,
		Color3.fromRGB(20,20,20)
	),

	ColorSequenceKeypoint.new(
		1,
		Color3.fromRGB(40,15,0)
	)
}

-- TITLE

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🔥 DENYS PREMIUM"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,170,0)

-- STATUS

local status = Instance.new("TextLabel")
status.Parent = main
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,0,35)
status.BackgroundTransparency = 1
status.Text = "🔍 Searching..."
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.new(1,1,1)

-- BUTTONS

local stopBtn = Instance.new("TextButton")
stopBtn.Parent = main
stopBtn.Size = UDim2.new(0,55,0,25)
stopBtn.Position = UDim2.new(0.34,0,0.03,0)
stopBtn.Text = "STOP"
stopBtn.TextScaled = true
stopBtn.BackgroundColor3 =
	Color3.fromRGB(255,170,0)

Instance.new("UICorner",stopBtn)

local hopBtn = Instance.new("TextButton")
hopBtn.Parent = main
hopBtn.Size = UDim2.new(0,55,0,25)
hopBtn.Position = UDim2.new(0.53,0,0.03,0)
hopBtn.Text = "HOP"
hopBtn.TextScaled = true
hopBtn.BackgroundColor3 =
	Color3.fromRGB(0,170,255)

Instance.new("UICorner",hopBtn)

local minimizeBtn =
	Instance.new("TextButton")

minimizeBtn.Parent = main
minimizeBtn.Size = UDim2.new(0,30,0,25)
minimizeBtn.Position =
	UDim2.new(0.72,0,0.03,0)

minimizeBtn.Text = "-"
minimizeBtn.TextScaled = true

Instance.new("UICorner",minimizeBtn)

local exitBtn = Instance.new("TextButton")
exitBtn.Parent = main
exitBtn.Size = UDim2.new(0,55,0,25)
exitBtn.Position = UDim2.new(0.82,0,0.03,0)
exitBtn.Text = "EXIT"
exitBtn.TextScaled = true
exitBtn.BackgroundColor3 =
	Color3.fromRGB(255,70,70)

Instance.new("UICorner",exitBtn)

-- SCROLLING

local scrolling = Instance.new("ScrollingFrame")
scrolling.Parent = main
scrolling.Position = UDim2.new(0,8,0,65)
scrolling.Size = UDim2.new(1,-16,1,-73)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout")
layout.Parent = scrolling
layout.Padding = UDim.new(0,5)

layout:GetPropertyChangedSignal(
	"AbsoluteContentSize"
):Connect(function()

	scrolling.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 10
		)
end)

-- BUTTONS

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
	gui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()

	scrolling.Visible =
		not scrolling.Visible

	status.Visible =
		not status.Visible
end)

-- SOUND

local function PlaySound()

	local sound = Instance.new("Sound")

	sound.SoundId =
		"rbxassetid://9118828562"

	sound.Volume = 3
	sound.Parent = workspace

	sound:Play()

	game.Debris:AddItem(sound,5)
end

-- CARD SYSTEM

local DetectedCards = {}

local function AddCard(player,item)

	local id = player.."_"..item

	if DetectedCards[id] then
		return
	end

	DetectedCards[id] = true

	local holder = Instance.new("Frame")
	holder.Parent = scrolling
	holder.Size = UDim2.new(1,-5,0,55)
	holder.BackgroundColor3 =
		Color3.fromRGB(30,30,30)

	Instance.new("UICorner",holder)

	local stroke =
		Instance.new("UIStroke")

	stroke.Parent = holder
	stroke.Color =
		Color3.fromRGB(255,140,0)

	local txt = Instance.new("TextLabel")
	txt.Parent = holder
	txt.Size = UDim2.new(1,-10,1,0)
	txt.Position = UDim2.new(0,10,0,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBold
	txt.TextXAlignment =
		Enum.TextXAlignment.Left

	txt.Text =
	"👤 "..player..
	"\n💎 "..item
end

-- DETECTOR

local foundRare = false
local Detected = {}

local function Normalize(text)

	return string.lower(
		string.gsub(text,"[^%w]","")
	)
end

local function IsRare(name)

	local normalizedName =
		Normalize(name)

	for _,keyword in pairs(
		SecretKeywords
	) do

		local normalizedKeyword =
			Normalize(keyword)

		if string.find(
			normalizedName,
			normalizedKeyword,
			1,
			true
		) then
			return true
		end
	end

	return false
end

local function Detect(obj, owner)

	if not obj or not obj.Name then
		return
	end

	if IsRare(obj.Name) then

		local id =
			owner.."_"..obj.Name

		if Detected[id] then
			return
		end

		Detected[id] = true

		foundRare = true

		AddCard(owner,obj.Name)

		PlaySound()

		status.Text =
			"🔥 FOUND: "..obj.Name
	end
end

local function ScanContainer(container, owner)

	pcall(function()

		for _,obj in pairs(
			container:GetDescendants()
		) do

			Detect(obj, owner)
		end
	end)
end

local function ScanServer()

	foundRare = false

	-- PLAYERS

	for _,plr in pairs(
		Players:GetPlayers()
	) do

		if plr ~= LocalPlayer then

			if plr.Character then
				ScanContainer(
					plr.Character,
					plr.Name
				)
			end

			if plr:FindFirstChild(
				"Backpack"
			) then

				ScanContainer(
					plr.Backpack,
					plr.Name
				)
			end
		end
	end

	-- WORKSPACE

	for _,obj in pairs(
		workspace:GetDescendants()
	) do

		Detect(obj,"Workspace")
	end
end

-- SERVER HOP

function HopServer()

	if not AutoHop then
		return
	end

	status.Text =
		"🔄 Searching server..."

	local success,servers =
		pcall(function()

		local url =
		"https://games.roblox.com/v1/games/"..
		PlaceId..
		"/servers/Public?sortOrder=Asc&limit=100"

		if ServerCursor then
			url = url..
			"&cursor="..
			ServerCursor
		end

		return HttpService:JSONDecode(
			game:HttpGet(url)
		)
	end)

	if not success
	or not servers
	or not servers.data then

		status.Text =
			"❌ Retry request..."

		ServerCursor = nil

		task.wait(2)

		return HopServer()
	end

	ServerCursor =
		servers.nextPageCursor

	local foundServer = false

	for _,server in ipairs(
		servers.data
	) do

		local freeSlots =
			server.maxPlayers -
			server.playing

		if server.id ~= game.JobId
		and freeSlots > 0
		and server.playing >= 2
		and not table.find(
			VisitedServers,
			server.id
		) then

			foundServer = true

			table.insert(
				VisitedServers,
				server.id
			)

			status.Text =
			"🚀 Joining "..server.playing..
			"/"..server.maxPlayers

			local CurrentJobId =
				game.JobId

			task.spawn(function()

				task.wait(15)

				if game.JobId ==
					CurrentJobId
				then

					status.Text =
					"❌ Freeze retry..."

					HopServer()
				end
			end)

			local tp = pcall(function()

				TeleportService:
				TeleportToPlaceInstance(
					PlaceId,
					server.id,
					LocalPlayer
				)
			end)

			if not tp then

				status.Text =
				"❌ TP failed..."

				task.wait(1)

				return HopServer()
			end

			break
		end
	end

	if not foundServer then

		status.Text =
			"♻ Refreshing..."

		ServerCursor = nil

		task.wait(1)

		return HopServer()
	end
end

-- RETRY TP

GuiService.ErrorMessageChanged:Connect(function()

	task.wait(1)

	HopServer()

end)

-- AUTO REJOIN

LocalPlayer.OnTeleport:Connect(function(State)

	if State ==
		Enum.TeleportState.Failed
	then

		task.wait(2)

		HopServer()
	end
end)

-- PREMIUM GLOW

task.spawn(function()

	while task.wait() do

		TweenService:Create(
			stroke,
			TweenInfo.new(1),
			{
				Transparency = 0.6
			}
		):Play()

		task.wait(1)

		TweenService:Create(
			stroke,
			TweenInfo.new(1),
			{
				Transparency = 0
			}
		):Play()
	end
end)

-- MULTI SCAN

for i = 1,5 do

	status.Text =
		"🔍 Scanning "..i.."/5"

	ScanServer()

	if foundRare then
		break
	end

	task.wait(4)
end

-- AUTO HOP

if not foundRare then

	status.Text =
		"❌ No secrets found"

	task.wait(5)

	HopServer()

else

	status.Text =
		"✅ SECRET SERVER"
end
