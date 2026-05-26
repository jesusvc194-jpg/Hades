-- Servicios
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService") -- Para detectar clics

-- Jugador local
local player = Players.LocalPlayer

-- Referencias a la UI de simulación
local screenGui = script.Parent
local simulatedShopFrame = screenGui:WaitForChild("SimulatedShopFrame")
local simulatedRobuxCounter = simulatedShopFrame:WaitForChild("SimulatedRobuxCounter")
local closeShopButton = simulatedShopFrame:WaitForChild("CloseShopButton")
local shopItemsFrame = simulatedShopFrame:WaitForChild("ShopItemsFrame")

-- Configuración de la simulación
local initialSimulatedRobux = 5000 -- Cantidad inicial de "Robux" simulados
local currentSimulatedRobux = initialSimulatedRobux
local currencyName = "Robux" -- Nombre a mostrar
local currencySymbol = "R$" -- Símbolo a mostrar (opcional)

local itemData = {
    -- Define los objetos de tu tienda simulada aquí
    -- Cada objeto debe tener: nombre, precio, y opcionalmente, una descripción o ID
    AdminCommands = { Name = "[REGALO] Comandos de administrador", Price = 7499, Description = "Obtén comandos de administrador" },
    VIP = { Name = "[REGALO] VIP", Price = 399, Description = "Beneficios VIP, vidas múltiples!" },
    FlyingCarpet = { Name = "[REGALO] Alfombra Voladora", Price = 215, Description = "¡Te permite volar!" },
    BlackHolePunch = { Name = "[REGALO] Golpe de agujero negro", Price = 199, Description = "Tira, sujeta y empuja a los jugadores!" },
    LaserPistol = { Name = "Pistola láser", Price = 115, Description = "¡Lanza lásers a los jugadores!" },
    BanHammer = { Name = "Martillo de Ban", Price = 115, Description = "¡Elimina a los jugadores y a las trampas con poderes administrativos!" },
    -- Añade más objetos según tus imágenes
}

-- Ajustes visuales para la UI
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ========================================================
-- FUNCIONES DE UTILERÍA
-- ========================================================

local function updateRobuxCounter()
    -- Formatea el número con comas y añade el nombre/símbolo de la moneda
    simulatedRobuxCounter.Text = string.format("%,d", currentSimulatedRobux) .. " " .. currencySymbol .. " " .. currencyName
    -- Si no quieres el símbolo, usa:
    -- simulatedRobuxCounter.Text = string.format("%,d", currentSimulatedRobux) .. " " .. currencyName
end

local function playPurchaseAnimation(textLabel, amount)
    local originalColor = textLabel.TextColor3
    local originalScale = textLabel.Scale

    -- Animación de "disminución" visual
    local tweenOut = TweenService:Create(textLabel, tweenInfo, { Scale = originalScale + Vector2.new(0.1, 0.1), TextColor3 = Color3.fromRGB(255, 100, 100) })
    tweenOut:Play()

    tweenOut.Completed:Connect(function()
        -- Animación de "restauración"
        local tweenIn = TweenService:Create(textLabel, tweenInfo, { Scale = originalScale, TextColor3 = originalColor })
        tweenIn:Play()
        tweenIn.Completed:Connect(function()
            -- Opcional: Si quieres que el número parpadee después de volver a la normalidad
            -- wait(0.5)
            -- local tweenFlash = TweenService:Create(textLabel, tweenInfo, { TextTransparency = 0.5 })
            -- tweenFlash:Play()
            -- tweenFlash.Completed:Connect(function()
            --     local tweenFlashBack = TweenService:Create(textLabel, tweenInfo, { TextTransparency = 0 })
            --     tweenFlashBack:Play()
            -- end)
        end)
    end)
end

local function simulatePurchase(itemPrice)
    if currentSimulatedRobux >= itemPrice then
        currentSimulatedRobux = currentSimulatedRobux - itemPrice
        updateRobuxCounter()
        playPurchaseAnimation(simulatedRobuxCounter, itemPrice)
        print("¡Simulación de compra exitosa! Robux restantes: " .. currentSimulatedRobux)
        return true
    else
        print("¡Simulación de compra fallida! Robux insuficientes.")
        -- Opcional: Mostrar un mensaje visual de error al jugador
        return false
    end
end

local function simulateGift(giftAmount)
    if currentSimulatedRobux >= giftAmount then
        currentSimulatedRobux = currentSimulatedRobux - giftAmount
        updateRobuxCounter()
        playPurchaseAnimation(simulatedRobuxCounter, giftAmount)
        print("¡Simulación de regalo exitosa! Robux restantes: " .. currentSimulatedRobux)
        return true
    else
        print("¡Simulación de regalo fallida! Robux insuficientes.")
        -- Opcional: Mostrar un mensaje visual de error al jugador
        return false
    end
end

-- ========================================================
-- CONFIGURACIÓN DE LA TIENDA SIMULADA
-- ========================================================

local function setupShopItems()
    -- Limpiar cualquier ítem anterior si se reinicia (opcional)
    for _, itemFrame in ipairs(shopItemsFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame.Name:find("ItemFrame") then
            itemFrame:Destroy()
        end
    end

    local currentX = 10 -- Posición X inicial para los ítems
    local itemSpacing = 10 -- Espacio entre ítems
    local itemWidth = 150 -- Ancho de cada frame de ítem
    local itemHeight = 150 -- Alto de cada frame de ítem

    for itemName, data in pairs(itemData) do
        -- Crear el Frame principal para el ítem
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "ItemFrame" .. itemName
        itemFrame.Size = UDim2.new(0, itemWidth, 0, itemHeight)
        itemFrame.Position = UDim2.new(0, currentX, 0, 10) -- Posición Y fija
        itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Color de fondo del ítem
        itemFrame.BorderSizePixel = 1
        itemFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
        itemFrame.Parent = shopItemsFrame

        -- Crear nombre del ítem
        local itemNameLabel = Instance.new("TextLabel")
        itemNameLabel.Name = "ItemNameLabel"
        itemNameLabel.Size = UDim2.new(1, 0, 0, 30) -- Ocupa todo el ancho, 30px de alto
        itemNameLabel.Position = UDim2.new(0, 0, 0, 0) -- Arriba
        itemNameLabel.Text = data.Name
        itemNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        itemNameLabel.TextScaled = true -- Ajusta el tamaño de la fuente automáticamente
        itemNameLabel.Parent = itemFrame

        -- Crear precio del ítem
        local itemPriceLabel = Instance.new("TextLabel")
        itemPriceLabel.Name = "ItemPriceLabel"
        itemPriceLabel.Size = UDim2.new(1, 0, 0, 30) -- Ocupa todo el ancho, 30px de alto
        itemPriceLabel.Position = UDim2.new(0, 0, 0, 40) -- Debajo del nombre
        itemPriceLabel.Text = currencySymbol .. " " .. string.format("%,d", data.Price) .. " " .. currencyName
        itemPriceLabel.TextColor3 = Color3.fromRGB(150, 255, 150) -- Color verde para el precio
        itemPriceLabel.TextScaled = true
        itemPriceLabel.Parent = itemFrame

        -- Crear botón de "Comprar"
        local buyButton = Instance.new("TextButton")
        buyButton.Name = "BuyButton"
        buyauyButton.Size = UDim2.new(1, 0, 0, 40) -- Ocupa todo el ancho, 40px de alto
        buyButton.Position = UDim2.new(0, 0, 0, 80) -- Debajo del precio
        buyButton.Text = "Comprar"
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Azul
        buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        buyButton.TextScaled = true
        buyButton.Parent = itemFrame

        -- Conectar la acción de comprar
        buyButton.MouseButton1Click:Connect(function()
            if simulatePurchase(data.Price) then
                -- Opcional: Aquí podrías hacer que el objeto aparezca en el inventario del jugador,
                -- o mostrar un mensaje de "Objeto comprado"
                print("¡Simulaste comprar: " .. data.Name .. "!")
                -- Opcional: Si quieres que el botón se desactive después de comprar una vez
                -- buyButton.Visible = false 
                -- buyButton.Disabled = true
            end
        end)

        -- Crear botón de "Regalar" (si quieres simularlo también)
        local giftButton = Instance.new("TextButton")
        giftButton.Name = "GiftButton"
        giftButton.Size = UDim2.new(1, 0, 0, 40) -- Ocupa todo el ancho, 40px de alto
        giftButton.Position = UDim2.new(0, 0, 0, 120) -- Debajo del botón de comprar
        giftButton.Text = "Regalar"
        giftButton.BackgroundColor3 = Color3.fromRGB(120, 0, 200) -- Morado
        giftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        giftButton.TextScaled = true
        giftButton.Parent = itemFrame

        -- Conectar la acción de regalar (simulamos un costo de regalo diferente o igual)
        giftButton.MouseButton1Click:Connect(function()
            local giftCost = data.Price * 1.2 -- Ejemplo: el regalo cuesta 20% más
            if simulateGift(giftCost) then
                print("¡Simulaste regalar: " .. data.Name .. "!")
                -- Opcional: Aquí podrías abrir una ventana para elegir a qué jugador regalar
                -- o simplemente mostrar un mensaje de éxito
            end
        end)

        -- Incrementar posición X para el siguiente ítem
        currentX = currentX + itemWidth + itemSpacing
    end
end

-- ========================================================
-- CONFIGURACIÓN INICIAL Y EVENTOS
-- ========================================================

-- Hacer que la tienda simulada sea inicialmente visible o invisible según prefieras
simulatedShopFrame.Visible = false -- Empieza oculta

-- Conectar el botón de cerrar la tienda simulada
closeShopButton.MouseButton1Click:Connect(function()
    simulatedShopFrame.Visible = false
end)

-- Función para abrir la tienda simulada (ejemplo)
-- Puedes llamar a esta función cuando el jugador interactúe con algo en el juego
-- Por ejemplo, si encuentras un botón de "Tienda de Robux" en el juego,
-- puedes hacer que su clic llame a esta función.

local function openSimulatedShop()
    setupShopItems() -- Asegúrate de que los ítems se carguen/reinicien
    updateRobuxCounter() -- Actualiza el contador al abrir
    simulatedShopFrame.Visible = true

    -- Si quieres que la ventana aparezca con una animación suave:
    local originalPosition = simulatedShopFrame.Position
    simulatedShopFrame.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset - 50) -- Ligeramente más arriba
    simulatedShopFrame.BackgroundTransparency = 1

    local tweenIn = TweenService:Create(simulatedShopFrame, tweenInfo, { BackgroundTransparency = 0, Position = originalPosition })
    tweenIn:Play()
end

-- ========================================================
-- EJEMPLO DE CÓMO ABRIR LA TIENDA SIMULADA
-- ========================================================
-- Para probar, puedes simular que un botón en el juego real llama a esta función.
-- Si en tu juego hay un botón de "Tienda de Robux" que al hacer clic te lleva a una UI,
-- podrías intentar reemplazar esa acción (o añadir un nuevo botón oculto)
-- para que llame a `openSimulatedShop()`.

-- EJEMPLO: Simular la apertura de la tienda si el jugador presiona 'E'
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then -- Asegúrate de que el input no fue procesado por el juego (ej: chat)
        if input.KeyCode == Enum.KeyCode.E then -- Usa la tecla 'E' como ejemplo
            -- Aquí podrías buscar un objeto específico en el mundo que represente la tienda
            -- y si el jugador está cerca, abrirías la simulación.
            -- Por ahora, solo la abrimos al presionar 'E'.
            print("Presionaste E. Abriendo tienda simulada...")
            openSimulatedShop()
        end
    end
end)


-- --- INICIALIZACIÓN ---
-- Puedes llamar a openSimulatedShop() aquí si quieres que la tienda aparezca al iniciar el juego
-- openSimulatedShop() 
updateRobuxCounter() -- Asegúrate de que el contador se muestre al inicio, incluso si la tienda está oculta.
