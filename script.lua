--// SECRET FINDER FINAL
--// UNIVERSAL SECRET DETECTOR
--// AUTO SERVER HOP
--// NO REPEATED SERVERS
--// AUTO EXECUTE AFTER TELEPORT
--// AUTOJOIN + NEXT SERVER
--// DRAG + STOP + MINIMIZE + EXIT

if getgenv().SecretFinderLoaded then
	return
end
getgenv().SecretFinderLoaded = true

--// AUTO EXECUTE AFTER TELEPORT

if queue_on_teleport then

	queue_on_teleport([[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jesusvc194-jpg/Hades/refs/heads/main/script.lua"))()
	]])

elseif syn and syn.queue_on_teleport then

	syn.queue_on_teleport([[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jesusvc194-jpg/Hades/refs/heads/main/script.lua"))()
	]])
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId
local JobID = game.JobId

--// VISITED SERVERS

local visitedServers = {}

--// GUI

local gui = Instance.new("ScreenGui")
gui.Name = "SecretFinder"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,380,0,270)
main.Position = UDim2.new(0.65,0,0.02,0)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,18)

--// TOP BAR

local top = Instance.new("Frame")
top.Parent = main
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(0,140,1,0)
title.BackgroundTransparency = 1
title.Text = "🔥 SECRET FINDER"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

--// NEXT BUTTON

local nextBtn = Instance.new("TextButton")
nextBtn.Parent = top
nextBtn.Size = UDim2.new(0,55,0,28)
nextBtn.Position = UDim2.new(0,145,0.1,0)
nextBtn.Text = "NEXT"
nextBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
nextBtn.TextColor3 = Color3.new(1,1,1)
nextBtn.Font = Enum.Font.GothamBold
nextBtn.TextScaled = true

Instance.new("UICorner",nextBtn).CornerRadius = UDim.new(0,8)

--// AUTOJOIN BUTTON

local autoJoin = true

local autoBtn = Instance.new("TextButton")
autoBtn.Parent = top
autoBtn.Size = UDim2.new(0,80,0,28)
autoBtn.Position = UDim2.new(0,205,0.1,0)
autoBtn.Text = "AUTOJOIN"
autoBtn.BackgroundColor3 = Color3.fromRGB(0,255,120)
autoBtn.TextColor3 = Color3.new(0,0,0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true

Instance.new("UICorner",autoBtn).CornerRadius = UDim.new(0,8)

--// STOP BUTTON

local stopBtn = Instance.new("TextButton")
stopBtn.Parent = top
stopBtn.Size = UDim2.new(0,50,0,28)
stopBtn.Position = UDim2.new(0,290,0.1,0)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
stopBtn.TextColor3 = Color3.new(0,0,0)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextScaled = true

Instance.new("UICorner",stopBtn).CornerRadius = UDim.new(0,8)

--// MIN BUTTON

local minBtn = Instance.new("TextButton")
minBtn.Parent = top
minBtn.Size = UDim2.new(0,25,0,28)
minBtn.Position = UDim2.new(1,-55,0.1,0)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(180,180,180)
minBtn.TextColor3 = Color3.new(0,0,0)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextScaled = true

Instance.new("UICorner",minBtn).CornerRadius = UDim.new(0,8)

--// EXIT BUTTON

local exitBtn = Instance.new("TextButton")
exitBtn.Parent = top
exitBtn.Size = UDim2.new(0,25,0,28)
exitBtn.Position = UDim2.new(1,-28,0.1,0)
exitBtn.Text = "X"
exitBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
exitBtn.TextColor3 = Color3.new(1,1,1)
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextScaled = true

Instance.new("UICorner",exitBtn).CornerRadius = UDim.new(0,8)

--// CONTENT

local content = Instance.new("Frame")
content.Parent = main
content.Size = UDim2.new(1,-10,1,-50)
content.Position = UDim2.new(0,5,0,45)
content.BackgroundTransparency = 1

local status = Instance.new("TextLabel")
status.Parent = content
status.Size = UDim2.new(1,0,0,35)
status.BackgroundTransparency = 1
status.Text = "🔍 Searching Secret..."
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Font = Enum.Font.GothamBold
status.TextScaled = true

local log = Instance.new("TextLabel")
log.Parent = content
log.Size = UDim2.new(1,-10,1,-45)
log.Position = UDim2.new(0,5,0,40)
log.BackgroundTransparency = 1
log.Text = "Waiting..."
log.TextColor3 = Color3.fromRGB(255,170,0)
log.Font = Enum.Font.Code
log.TextSize = 18
log.TextWrapped = true
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top

--// MINIMIZE

local minimized = false
local originalSize = main.Size

minBtn.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		content.Visible = false
		main.Size = UDim2.new(0,380,0,40)
		minBtn.Text = "+"

	else

		content.Visible = true
		main.Size = originalSize
		minBtn.Text = "-"

	end
end)

--// EXIT

exitBtn.MouseButton1Click:Connect(function()

	gui:Destroy()
	getgenv().SecretFinderLoaded = false

end)

--// STOP

local stopped = false

stopBtn.MouseButton1Click:Connect(function()

	stopped = not stopped

	if stopped then

		stopBtn.Text = "START"
		status.Text = "⏹️ Stopped"

	else

		stopBtn.Text = "STOP"
		status.Text = "🔍 Searching Secret..."

	end
end)

--// AUTOJOIN TOGGLE

autoBtn.MouseButton1Click:Connect(function()

	autoJoin = not autoJoin

	if autoJoin then

		autoBtn.Text = "AUTOJOIN"
		autoBtn.BackgroundColor3 = Color3.fromRGB(0,255,120)

	else

		autoBtn.Text = "MANUAL"
		autoBtn.BackgroundColor3 = Color3.fromRGB(255,120,120)

	end
end)

--// SERVER HOP

local hopping = false

local function ServerHop()

	if hopping then
		return
	end

	hopping = true

	local success,err = pcall(function()

		local req = game:HttpGet(
			"https://games.roblox.com/v1/games/" ..
			PlaceID ..
			"/servers/Public?sortOrder=Asc&limit=100"
		)

		local data = HttpService:JSONDecode(req)

		if not data or not data.data then
			error("Failed to get servers")
		end

		local foundServer = false

		for _,server in ipairs(data.data) do

			if server.id ~= JobID
			and server.playing < server.maxPlayers
			and not visitedServers[server.id] then

				foundServer = true
				visitedServers[server.id] = true

				log.Text =
					"🚀 Joining New Server...\n\nPlayers: " ..
					server.playing ..
					"/" ..
					server.maxPlayers

				status.Text = "🔄 Server Hop"

				task.spawn(function()

					task.wait(1)

					TeleportService:TeleportToPlaceInstance(
						PlaceID,
						server.id,
						LocalPlayer
					)
				end)

				return
			end
		end

		if not foundServer then

			log.Text = "⚠️ Resetting Server List..."
			status.Text = "🔄 Retry..."

			table.clear(visitedServers)

			task.wait(2)
		end
	end)

	if not success then

		log.Text = tostring(err)
		status.Text = "❌ Hop Failed"

	end

	hopping = false
end

--// NEXT SERVER BUTTON

nextBtn.MouseButton1Click:Connect(function()

	status.Text = "🔄 Manual Hop"

	ServerHop()

end)

--// SECRET DETECTOR LOOP

task.spawn(function()

	while true do

		task.wait(3)

		if stopped then
			continue
		end

		local found = {}

		pcall(function()

			for _,v in pairs(workspace:GetDescendants()) do

				if v:IsA("TextLabel") then

					local text = string.lower(v.Text)

					if text == "secret" then

						local model = v:FindFirstAncestorOfClass("Model")

						if model then

							local brainrotName = model.Name

							if not table.find(found, brainrotName) then
								table.insert(found, brainrotName)
							end
						end
					end
				end
			end
		end)

		if #found > 0 then

			log.Text =
				"🔥 SECRET FOUND:\n\n" ..
				table.concat(found,"\n")

			status.Text =
				"✅ FOUND " .. #found .. " SECRET"

			if autoJoin then
				stopped = true
			else
				ServerHop()
			end

		else

			log.Text =
				"❌ No Secret Found\n\nSearching New Server..."

			status.Text = "🔍 Searching"

			ServerHop()
		end
	end
end)

print("SECRET FINDER FINAL LOADED")
