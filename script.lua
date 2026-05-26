-- ============================================
-- TIENDA VISUAL CON RESTA DE ROBUX
-- Steal a Brainrot - Móvil
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIGURACIÓN
local SHOP_RANGE = 20
local FAKE_ROBUX = 9764432 -- Tu Robux inicial falso

-- CREAR GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ShopVisual"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- DATOS DE ITEMS
local ShopItems = {
	{Name = "Alfombra Voladora", Desc = "¡Te permite volar!", Price = 215, Icon = "rbxassetid://1517156714", Color = Color3.fromRGB(138, 43, 226)},
	{Name = "Golpe de Agujero Negro", Desc = "¡Tira y empuja!", Price = 115, Icon = "rbxassetid://1517156842", Color = Color3.fromRGB(43, 43, 43)},
	{Name = "Pistola Láser", Desc = "¡Lanza láseres!", Price = 399, Icon = "rbxassetid://1517156987", Color = Color3.fromRGB(255, 50, 50)},
	{Name = "Martillo de Ban", Desc = "¡Elimina jugadores!", Price = 799, Icon = "rbxassetid://1517157123", Color = Color3.fromRGB(255, 215, 0)},
	{Name = "Llama Brainrot", Desc = "Pet exclusiva", Price = 1500, Icon = "rbxassetid://1517157256", Color = Color3.fromRGB(255, 100, 200)},
	{Name = "Skibidi Toilet", Desc = "Legendario", Price = 600000, Icon = "rbxassetid://1517157389", Color = Color3.fromRGB(255, 0, 100)},
}

-- INVENTARIO Y ROBUX ACTUAL
local CurrentRobux = FAKE_ROBUX
local FakeInventory = {}

-- ============================================
-- UI - DISPLAY DE ROBUX (Arriba izquierda)
-- ============================================

local RobuxFrame = Instance.new("Frame")
RobuxFrame.Size = UDim2.new(0, 180, 0, 45)
RobuxFrame.Position = UDim2.new(0, 10, 0, 10)
RobuxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
RobuxFrame.BorderSizePixel = 0
RobuxFrame.Visible = false
RobuxFrame.Parent = gui

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 10)
corner1.Parent = RobuxFrame

local RobuxIcon = Instance.new("ImageLabel")
RobuxIcon.Size = UDim2.new(0, 30, 0, 30)
RobuxIcon.Position = UDim2.new(0, 10, 0.5, -15)
RobuxIcon.BackgroundTransparency = 1
RobuxIcon.Image = "rbxassetid://1517157512" -- Icono Robux
RobuxIcon.Parent = RobuxFrame

local RobuxText = Instance.new("TextLabel")
RobuxText.Name = "RobuxAmount"
RobuxText.Size = UDim2.new(0, 130, 1, 0)
RobuxText.Position = UDim2.new(0, 45, 0, 0)
RobuxText.BackgroundTransparency = 1
RobuxText.Text = tostring(CurrentRobux)
RobuxText.TextColor3 = Color3.fromRGB(255, 255, 255)
RobuxText.TextSize = 22
RobuxText.Font = Enum.Font.GothamBold
RobuxText.TextXAlignment = Enum.TextXAlignment.Left
RobuxText.Parent = RobuxFrame

-- Función para formatear números grandes (9,764,432)
local function FormatNumber(num)
	return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- Actualizar display de Robux
local function UpdateRobuxDisplay()
	RobuxText.Text = FormatNumber(CurrentRobux)
	
	-- Animación de cambio
	TweenService:Create(RobuxText, TweenInfo.new(0.2), {TextSize = 26}):Play()
	wait(0.2)
	TweenService:Create(RobuxText, TweenInfo.new(0.2), {TextSize = 22}):Play()
end

-- ============================================
-- UI - PANEL DE TIENDA
-- ============================================

local ShopFrame = Instance.new("Frame")
ShopFrame.Name = "ShopPanel"
ShopFrame.Size = UDim2.new(0.95, 0, 0.8, 0)
ShopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShopFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ShopFrame.BorderSizePixel = 0
ShopFrame.Visible = false
ShopFrame.Parent = gui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 20)
corner2.Parent = ShopFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 110)
stroke.Thickness = 2
stroke.Parent = ShopFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Header.BorderSizePixel = 0
Header.Parent = ShopFrame

local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 20)
corner3.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 30)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🛒 TIENDA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Robux en el header también
local HeaderRobux = Instance.new("TextLabel")
HeaderRobux.Name = "HeaderRobux"
HeaderRobux.Size = UDim2.new(0, 150, 0, 40)
HeaderRobux.Position = UDim2.new(1, -170, 0.5, -20)
HeaderRobux.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
HeaderRobux.Text = "💰 " .. FormatNumber(CurrentRobux)
HeaderRobux.TextColor3 = Color3.fromRGB(255, 215, 0)
HeaderRobux.TextSize = 18
HeaderRobux.Font = Enum.Font.GothamBold
HeaderRobux.Parent = Header

local cornerRobux = Instance.new("UICorner")
cornerRobux.CornerRadius = UDim.new(0, 10)
cornerRobux.Parent = HeaderRobux

-- Botón cerrar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -55, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local corner4 = Instance.new("UICorner")
corner4.CornerRadius = UDim.new(0, 12)
corner4.Parent = CloseBtn

-- Scroll de items
local ItemsScroll = Instance.new("ScrollingFrame")
ItemsScroll.Size = UDim2.new(1, -20, 1, -80)
ItemsScroll.Position = UDim2.new(0, 10, 0, 70)
ItemsScroll.BackgroundTransparency = 1
ItemsScroll.BorderSizePixel = 0
ItemsScroll.ScrollBarThickness = 6
ItemsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ItemsScroll.Parent = ShopFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 200, 0, 140)
Grid.CellPadding = UDim2.new(0, 15, 0, 15)
Grid.Parent = ItemsScroll

-- ============================================
-- UI - PANEL DE COMPRA
-- ============================================

local BuyPanel = Instance.new("Frame")
BuyPanel.Name = "BuyPanel"
BuyPanel.Size = UDim2.new(0, 320, 0, 220)
BuyPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
BuyPanel.AnchorPoint = Vector2.new(0.5, 0.5)
BuyPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
BuyPanel.BorderSizePixel = 0
BuyPanel.Visible = false
BuyPanel.ZIndex = 10
BuyPanel.Parent = gui

local corner5 = Instance.new("UICorner")
corner5.CornerRadius = UDim.new(0, 20)
corner5.Parent = BuyPanel

local stroke2 = Instance.new("UIStroke")
stroke2.Color = Color3.fromRGB(120, 120, 130)
stroke2.Thickness = 3
stroke2.Parent = BuyPanel

local BuyTitle = Instance.new("TextLabel")
BuyTitle.Size = UDim2.new(1, 0, 0, 40)
BuyTitle.Position = UDim2.new(0, 0, 0, 10)
BuyTitle.BackgroundTransparency = 1
BuyTitle.Text = "¿Comprar este objeto?"
BuyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyTitle.TextSize = 22
BuyTitle.Font = Enum.Font.GothamBold
BuyTitle.Parent = BuyPanel

local BuyIcon = Instance.new("ImageLabel")
BuyIcon.Size = UDim2.new(0, 70, 0, 70)
BuyIcon.Position = UDim2.new(0.5, -35, 0, 55)
BuyIcon.BackgroundTransparency = 1
BuyIcon.Parent = BuyPanel

local BuyName = Instance.new("TextLabel")
BuyName.Size = UDim2.new(1, 0, 0, 25)
BuyName.Position = UDim2.new(0, 0, 0, 130)
BuyName.BackgroundTransparency = 1
BuyName.Text = "Nombre"
BuyName.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyName.TextSize = 20
BuyName.Font = Enum.Font.GothamBold
BuyName.Parent = BuyPanel

local BuyPrice = Instance.new("TextLabel")
BuyPrice.Size = UDim2.new(0, 120, 0, 30)
BuyPrice.Position = UDim2.new(0.5, -60, 0, 160)
BuyPrice.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
BuyPrice.Text = "💰 0"
BuyPrice.TextColor3 = Color3.fromRGB(255, 215, 0)
BuyPrice.TextSize = 18
BuyPrice.Font = Enum.Font.GothamBold
BuyPrice.Parent = BuyPanel

local corner6 = Instance.new("UICorner")
corner6.CornerRadius = UDim.new(0, 10)
corner6.Parent = BuyPrice

-- Botones
local BuyButton = Instance.new("TextButton")
BuyButton.Size = UDim2.new(0.4, 0, 0, 40)
BuyButton.Position = UDim2.new(0.08, 0, 1, -55)
BuyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
BuyButton.Text = "Comprar"
BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyButton.TextSize = 18
BuyButton.Font = Enum.Font.GothamBold
BuyButton.Parent = BuyPanel

local corner7 = Instance.new("UICorner")
corner7.CornerRadius = UDim.new(0, 10)
corner7.Parent = BuyButton

local GiftButton = Instance.new("TextButton")
GiftButton.Size = UDim2.new(0.4, 0, 0, 40)
GiftButton.Position = UDim2.new(0.52, 0, 1, -55)
GiftButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
GiftButton.Text = "🎁 Regalar"
GiftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GiftButton.TextSize = 18
GiftButton.Font = Enum.Font.GothamBold
GiftButton.Parent = BuyPanel

local corner8 = Instance.new("UICorner")
corner8.CornerRadius = UDim.new(0, 10)
corner8.Parent = GiftButton

local CancelButton = Instance.new("TextButton")
CancelButton.Size = UDim2.new(0, 35, 0, 35)
CancelButton.Position = UDim2.new(1, -40, 0, 8)
CancelButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CancelButton.Text = "✕"
CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelButton.TextSize = 20
CancelButton.Font = Enum.Font.GothamBold
CancelButton.Parent = BuyPanel

-- Mensaje de fondos insuficientes
local InsufficientFunds = Instance.new("TextLabel")
InsufficientFunds.Size = UDim2.new(1, 0, 0, 30)
InsufficientFunds.Position = UDim2.new(0, 0, 0.85, 0)
InsufficientFunds.BackgroundTransparency = 1
InsufficientFunds.Text = "❌ Fondos insuficientes"
InsufficientFunds.TextColor3 = Color3.fromRGB(255, 50, 50)
InsufficientFunds.TextSize = 16
InsufficientFunds.Font = Enum.Font.GothamBold
InsufficientFunds.Visible = false
InsufficientFunds.Parent = BuyPanel

-- ============================================
-- FUNCIONES
-- ============================================

-- Crear tarjeta de item
local function CreateItemCard(itemData)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 1, 0)
	card.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
	card.BorderSizePixel = 0
	
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 15)
	cardCorner.Parent = card
	
	-- Borde de rareza
	local rarityStroke = Instance.new("UIStroke")
	rarityStroke.Color = itemData.Color
	rarityStroke.Thickness = 3
	rarityStroke.Parent = card
	
	-- Icono
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 60, 0, 60)
	icon.Position = UDim2.new(0.5, -30, 0, 10)
	icon.BackgroundTransparency = 1
	icon.Image = itemData.Icon
	icon.Parent = card
	
	-- Nombre
	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(0.9, 0, 0, 25)
	name.Position = UDim2.new(0.05, 0, 0, 75)
	name.BackgroundTransparency = 1
	name.Text = itemData.Name
	name.TextColor3 = itemData.Color
	name.TextSize = 16
	name.Font = Enum.Font.GothamBold
	name.Parent = card
	
	-- Descripción
	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(0.9, 0, 0, 20)
	desc.Position = UDim2.new(0.05, 0, 0, 100)
	desc.BackgroundTransparency = 1
	desc.Text = itemData.Desc
	desc.TextColor3 = Color3.fromRGB(180, 180, 180)
	desc.TextSize = 12
	desc.Font = Enum.Font.Gotham
	desc.Parent = card
	
	-- Precio
	local priceBtn = Instance.new("TextButton")
	priceBtn.Size = UDim2.new(0, 100, 0, 35)
	priceBtn.Position = UDim2.new(0.5, -50, 1, -45)
	priceBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	priceBtn.Text = "💰 " .. FormatNumber(itemData.Price)
	priceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	priceBtn.TextSize = 16
	priceBtn.Font = Enum.Font.GothamBold
	priceBtn.Parent = card
	
	local priceCorner = Instance.new("UICorner")
	priceCorner.CornerRadius = UDim.new(0, 10)
	priceCorner.Parent = priceBtn
	
	-- Click
	priceBtn.MouseButton1Click:Connect(function()
		-- Animación
		TweenService:Create(priceBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 95, 0, 32)}):Play()
		wait(0.1)
		TweenService:Create(priceBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 100, 0, 35)}):Play()
		
		-- Guardar item seleccionado
		BuyPanel:SetAttribute("ItemName", itemData.Name)
		BuyPanel:SetAttribute("ItemPrice", itemData.Price)
		BuyPanel:SetAttribute("ItemIcon", itemData.Icon)
		BuyPanel:SetAttribute("ItemColor", itemData.Color)
		
		-- Mostrar panel
		BuyIcon.Image = itemData.Icon
		BuyName.Text = itemData.Name
		BuyName.TextColor3 = itemData.Color
		BuyPrice.Text = "💰 " .. FormatNumber(itemData.Price)
		InsufficientFunds.Visible = false
		
		BuyPanel.Visible = true
		BuyPanel.Size = UDim2.new(0, 280, 0, 200)
		TweenService:Create(BuyPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 320, 0, 220)
		}):Play()
	end)
	
	return card
end

-- Cargar items
for _, item in ipairs(ShopItems) do
	local card = CreateItemCard(item)
	card.Parent = ItemsScroll
end

-- ============================================
-- COMPRAR (CON RESTA DE ROBUX)
-- ============================================

BuyButton.MouseButton1Click:Connect(function()
	local itemPrice = BuyPanel:GetAttribute("ItemPrice")
	local itemName = BuyPanel:GetAttribute("ItemName")
	
	-- Verificar si tiene suficiente
	if CurrentRobux < itemPrice then
		-- Fondos insuficientes
		InsufficientFunds.Visible = true
		
		-- Shake animation
		TweenService:Create(BuyPanel, TweenInfo.new(0.05), {Position = UDim2.new(0.49, 0, 0.5, 0)}):Play()
		wait(0.05)
		TweenService:Create(BuyPanel, TweenInfo.new(0.05), {Position = UDim2.new(0.51, 0, 0.5, 0)}):Play()
		wait(0.05)
		TweenService:Create(BuyPanel, TweenInfo.new(0.05), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		
		wait(1.5)
		InsufficientFunds.Visible = false
		return
	end
	
	-- RESTAR ROBUX (Visual)
	CurrentRobux = CurrentRobux - itemPrice
	
	-- Actualizar displays
	UpdateRobuxDisplay()
	HeaderRobux.Text = "💰 " .. FormatNumber(CurrentRobux)
	
	-- Agregar a inventario
	table.insert(FakeInventory, itemName)
	
	-- Animación de éxito
	BuyButton.Text = "✓ ¡Comprado!"
	BuyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	
	-- Partículas de celebración
	for i = 1, 15 do
		local particle = Instance.new("TextLabel")
		particle.Size = UDim2.new(0, 25, 0, 25)
		particle.Position = UDim2.new(0.5, 0, 0.5, 0)
		particle.AnchorPoint = Vector2.new(0.5, 0.5)
		particle.BackgroundTransparency = 1
		particle.Text = math.random() > 0.5 and "✨" or "💰"
		particle.TextSize = 30
		particle.Parent = BuyPanel
		
		local angle = math.random() * math.pi * 2
		local distance = math.random(100, 200)
		
		TweenService:Create(particle, TweenInfo.new(1), {
			Position = UDim2.new(0.5, math.cos(angle) * distance, 0.5, math.sin(angle) * distance),
			TextTransparency = 1,
			Rotation = math.random(-180, 180)
		}):Play()
		
		game:GetService("Debris"):AddItem(particle, 1)
	end
	
	wait(1.5)
	
	-- Resetear botón
	BuyButton.Text = "Comprar"
	BuyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	BuyPanel.Visible = false
end)

-- ============================================
-- CERRAR
-- ============================================

CancelButton.MouseButton1Click:Connect(function()
	BuyPanel.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
	TweenService:Create(ShopFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 1, 0)}):Play()
	wait(0.3)
	ShopFrame.Visible = false
	RobuxFrame.Visible = false
end)

-- ============================================
-- PROXIMIDAD (Caminar a la tienda)
-- ============================================

local shopLocation = workspace:FindFirstChild("ShopLocation") or workspace:FindFirstChild("Tienda")

if not shopLocation then
	shopLocation = Instance.new("Part")
	shopLocation.Name = "ShopLocation"
	shopLocation.Size = Vector3.new(15, 1, 15)
	shopLocation.Position = Vector3.new(0, 0, 0)
	shopLocation.Anchored = true
	shopLocation.Transparency = 1
	shopLocation.CanCollide = false
	shopLocation.Parent = workspace
end

local ProximityLabel = Instance.new("TextButton")
ProximityLabel.Size = UDim2.new(0, 220, 0, 50)
ProximityLabel.Position = UDim2.new(0.5, 0, 0.7, 0)
ProximityLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ProximityLabel.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
ProximityLabel.Text = "🏪 TIENDA CERCANA\nToca para abrir"
ProximityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ProximityLabel.TextSize = 14
ProximityLabel.Font = Enum.Font.GothamBold
ProximityLabel.Visible = false
ProximityLabel.Parent = gui

local proxCorner = Instance.new("UICorner")
proxCorner.CornerRadius = UDim.new(0, 12)
proxCorner.Parent = ProximityLabel

-- Verificar distancia
RunService.Heartbeat:Connect(function()
	if not character or not humanoidRootPart then return end
	
	local distance = (humanoidRootPart.Position - shopLocation.Position).Magnitude
	
	if distance <= SHOP_RANGE then
		if not ProximityLabel.Visible then
			ProximityLabel.Visible = true
			TweenService:Create(ProximityLabel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 230, 0, 55)
			}):Play()
		end
	elseif distance > SHOP_RANGE * 1.5 then
		if ProximityLabel.Visible then
			ProximityLabel.Visible = false
			ShopFrame.Visible = false
			RobuxFrame.Visible = false
			BuyPanel.Visible = false
		end
	end
end)

-- Abrir tienda
ProximityLabel.MouseButton1Click:Connect(function()
	ShopFrame.Visible = true
	RobuxFrame.Visible = true
	
	ShopFrame.Position = UDim2.new(0.5, 0, 1, 0)
	TweenService:Create(ShopFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()
end)

-- Tecla E (PC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.E and ProximityLabel.Visible and not ShopFrame.Visible then
		ProximityLabel:Activate()
	end
end)

print("✅ Tienda cargada - Robux iniciales: " .. FormatNumber(CurrentRobux))
