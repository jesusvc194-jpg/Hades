function HopServer()

	if not AutoHop then
		return
	end

	status.Text = "🔄 Searching new server..."

	local success,servers = pcall(function()

		local url =
			"https://games.roblox.com/v1/games/"..
			PlaceId..
			"/servers/Public?sortOrder=Asc&limit=100"

		if ServerCursor then
			url = url.."&cursor="..ServerCursor
		end

		return HttpService:JSONDecode(
			game:HttpGet(url)
		)
	end)

	-- FAILED REQUEST
	if not success or not servers or not servers.data then

		status.Text = "❌ Retry request..."

		ServerCursor = nil

		task.wait(2)

		return HopServer()
	end

	-- SAVE CURSOR
	ServerCursor = servers.nextPageCursor

	local foundServer = false

	for _,server in ipairs(servers.data) do

		local freeSlots =
			server.maxPlayers - server.playing

		-- VALID SERVER
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

			local tp = pcall(function()

				TeleportService:
				TeleportToPlaceInstance(
					PlaceId,
					server.id,
					LocalPlayer
				)

			end)

			-- TELEPORT FAILED
			if not tp then

				status.Text =
					"❌ TP failed retry..."

				task.wait(1)

				return HopServer()
			end

			break
		end
	end

	-- NO SERVERS FOUND
	if not foundServer then

		status.Text =
			"♻ Refreshing servers..."

		ServerCursor = nil

		task.wait(1)

		return HopServer()
	end
end
