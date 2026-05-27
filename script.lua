-- ========================================================
-- SERVICIOS
-- ========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService") -- Para detectar clics

-- ========================================================
-- JUGADOR LOCAL
-- ========================================================
local player = Players.LocalPlayer

-- ========================================================
-- REFERENCIAS A LA UI DE SIMULACIÓN
-- ========================================================
local screenGui = script.Parent
local simulatedShopFrame = screenGui:WaitForChild("SimulatedShopFrame")
local simulatedRobuxCounter = simulatedShopFrame:WaitForChild("SimulatedRobuxCounter")
local closeShopButton = simulatedShopFrame:WaitForChild("CloseShopButton")
local shopItemsFrame = simulatedShopFrame:WaitForChild("ShopItemsFrame")

-- *** NUEVO: Referencias al botón y etiqueta para añadir Robux ***
local addRobuxButton = simulatedShopFrame:WaitForChild("AddRobuxButton")
local addAmountLabel = simulatedShopFrame:WaitForChild("AddAmountLabel") -- Esta etiqueta es opcional, si la creaste

-- ========================================================
-- CONFIGURACIÓN DE LA SIMULACIÓN
-- ========================================================
local initialSimulatedRobux = 5000 -- Cantidad inicial de "Robux" simulados
local currentSimulatedRobux = initialSimulatedRobux
local currencyName = "Robux" -- Nombre a mostrar
local currencySymbol = "R$" -- Símbolo a mostrar (opcional)

-- *** NUEVO: Configuración para añadir Robux ***
local amountToAdd = 100000 -- Cantidad a añadir al presionar el botón

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
    -- Esta función anima el contador de Robux cuando se compra/añade dinero
    local originalColor = textLabel.TextColor3
    -- Usamos Vector2 para Scale en caso de que la propiedad Scale sea un Vector2, si no, solo usa un número.
    -- Si `textLabel.Scale` es un número simple, ajusta esto a `originalScale = textLabel.TextSize` o similar.
    -- En este caso, asumo que es un TextLabel con `TextScaled = true` y su `Scale` se podría modificar.
    -- Si `Scale` no es una propiedad modificable directamente para animación, podrías animar `TextSize` o `TextTransparency`.
    -- Para este ejemplo, mantenemos `Scale` asumiendo que funciona como un factor de tamaño.
    
    -- Asegurémonos de que 'Scale' sea un Vector2 para la animación o ajustemos si es TextSize
    local currentScale = Vector2.new(textLabel.TextSize * 0.1, textLabel.TextSize * 0.1) -- Ejemplo si TextSize es un número
    if textLabel.Size.X.Scale ~= 0 or textLabel.Size.Y.Scale ~= 0 then
        -- Si Size tiene Scale, puede que Scale no sea el atributo correcto a animar directamente para tamaño.
        -- Es más común animar TextSize. Si `textLabel.Scale` no existe o no funciona, usa `TextSize`.
        -- Para simplificar, asumimos que `Scale` es una propiedad que funciona o se simula.
        -- Si `textLabel.Scale` no existe, podrías hacer:
        -- local originalTextSize = textLabel.TextSize
        -- local tweenOut = TweenService:Create(textLabel, tweenInfo, { TextSize = originalTextSize + 2, TextColor3 = Color3.fromRGB(255, 100, 100) })
        -- ... y luego restaurar con `TextSize = originalTextSize`
    end

    -- Si textLabel.Scale no es una propiedad animable directamente o Vector2:
    -- Podríamos animar TextSize o TextTransparency. Usaremos TextSize como ejemplo más común.
    local originalTextSize = textLabel.TextSize
    local tweenOut = TweenService:Create(textLabel, tweenInfo, { TextSize = originalTextSize + 3, TextColor3 = Color3.fromRGB(255, 100, 100) })
    tweenOut:Play()

    tweenOut.Completed:Connect(function()
        -- Animación de "restauración"
        local tweenIn = TweenService:Create(textLabel, tweenInfo, { TextSize = originalTextSize, TextColor3 = originalColor })
        tweenIn:Play()
        -- No añadimos el parpadeo aquí para mantener el código más limpio, pero se puede añadir si se desea.
    end)
end

local function simulatePurchase(itemPrice)
    if currentSimulatedRobux >= itemPrice then
        currentSimulatedRobux = currentSimulatedRobux - itemPrice
        updateRobuxCounter()
        playPurchaseAnimation(simulatedRobuxCounter, itemPrice)
        print("¡Simulación de compra exitosa! Robux restantes: " .. string.format("%,d", currentSimulatedRobux))
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
        print("¡Simulación de regalo exitosa! Robux restantes: " .. string.format("%,d", currentSimulatedRobux))
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

-- Guardamos los IDs de los ítems en un array para poder referenciarlos fácilmente
local itemIDs = {} 

local function setupShopItems()
    -- Limpiar cualquier ítem anterior si se reinicia
    for _, itemFrame in ipairs(shopItemsFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame.Name:find("ItemFrame") then
            itemFrame:Destroy()
        end
    end

    local currentX = 10 -- Posición X inicial para los ítems
    local itemSpacing = 10 -- Espacio entre ítems
    local itemWidth = 150 -- Ancho de cada frame de ítem
    local itemHeight = 150 -- Alto de cada frame de ítem

    -- Limpiar y llenar el array de IDs
    table.clear(itemIDs)

    for itemName, data in pairs(itemData) do
        table.insert(itemIDs, itemName) -- Añadimos el nombre del ítem (que usaremos como ID) a la lista

        -- Crear el Frame principal para el ítem
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "ItemFrame" .. itemName -- Usamos itemName como ID único para este frame
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
        itemNameLabel.Font = Enum.Font.SourceSansBold -- Fuente más gruesa
        itemNameLabel.Parent = itemFrame

        -- Crear precio del ítem
        local itemPriceLabel = Instance.new("TextLabel")
        itemPriceLabel.Name = "ItemPriceLabel"
        itemPriceLabel.Size = UDim2.new(1, 0, 0, 30) -- Ocupa todo el ancho, 30px de alto
        itemPriceLabel.Position = UDim2.new(0, 0, 0, 40) -- Debajo del nombre
        itemPriceLabel.Text = currencySymbol .. " " .. string.format("%,d", data.Price) .. " " .. currencyName
        itemPriceLabel.TextColor3 = Color3.fromRGB(150, 255, 150) -- Color verde para el precio
        itemPriceLabel.TextScaled = true
        itemPriceLabel.Font = Enum.Font.SourceSansSemibold
        itemPriceLabel.Parent = itemFrame

        -- Crear botón de "Comprar"
        local buyButton = Instance.new("TextButton")
        buyButton.Name = "BuyButton"
        buyButton.Size = UDim2.new(1, 0, 0, 40) -- Ocupa todo el ancho, 40px de alto
        buyButton.Position = UDim2.new(0, 0, 0, 80) -- Debajo del precio
        buyButton.Text = "Comprar"
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Azul
        buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        buyButton.TextScaled = true
        buyButton.Font = Enum.Font.SourceSansBold
        buyButton.Parent = itemFrame

        -- Conectar la acción de comprar
        buyButton.MouseButton1Click:Connect(function()
            if simulatePurchase(data.Price) then
                print("¡Simulaste comprar: " .. data.Name .. "!")
                -- Aquí iría la lógica para "dar" el objeto al jugador en el juego real.
                -- Por ahora, solo simulamos la resta de Robux.

                -- Opcional: Desactivar botón después de comprar si solo se puede comprar una vez
                -- buyButton.Active = false
                -- buyButton.Text = "Comprado"
                -- buyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                
                -- Actualizar el estado de los otros botones (si implementamos la función updateItemButtonStates)
                -- updateItemButtonStates() 
            end
        end)

        -- Crear botón de "Regalar"
        local giftButton = Instance.new("TextButton")
        giftButton.Name = "GiftButton"
        giftButton.Size = UDim2.new(1, 0, 0, 40) -- Ocupa todo el ancho, 40px de alto
        giftButton.Position = UDim2.new(0, 0, 0, 120) -- Debajo del botón de comprar
        giftButton.Text = "Regalar"
        giftButton.BackgroundColor3 = Color3.fromRGB(120, 0, 200) -- Morado
        giftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        giftButton.TextScaled = true
        giftButton.Font = Enum.Font.SourceSansBold
        giftButton.Parent = itemFrame

        -- Conectar la acción de regalar
        giftButton.MouseButton1Click:Connect(function()
            local giftCost = data.Price * 1.2 -- Ejemplo: el regalo cuesta 20% más
            if simulateGift(giftCost) then
                print("¡Simulaste regalar: " .. data.Name .. "!")
                -- Lógica para abrir ventana de selección de jugador a regalar, etc.
                
                -- Actualizar el estado de los otros botones
                -- updateItemButtonStates()
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

-- Función para abrir la tienda simulada
local function openSimulatedShop()
    setupShopItems() -- Carga los ítems de la tienda
    updateRobuxCounter() -- Actualiza el contador al abrir
    simulatedShopFrame.Visible = true

    -- Animación de entrada de la ventana de la tienda
    local originalPosition = simulatedShopFrame.Position
    simulatedShopFrame.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset - 50) -- Ligeramente más arriba
    simulatedShopFrame.BackgroundTransparency = 1

    local tweenIn = TweenService:Create(simulatedShopFrame, tweenInfo, { BackgroundTransparency = 0, Position = originalPosition })
    tweenIn:Play()

    -- *** NUEVO: Configurar el texto de la etiqueta de añadir Robux si existe ***
    if addAmountLabel then
        addAmountLabel.Text = "+" .. string.format("%,d", amountToAdd) .. " " .. currencySymbol .. " " .. currencyName
        addAmountLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dorado
        addAmountLabel.TextScaled = true
        addAmountLabel.Font = Enum.Font.SourceSansBold
    end
end

-- ========================================================
-- EVENTOS DEL NUEVO BOTÓN DE AÑADIR ROBUX
-- ========================================================

addRobuxButton.MouseButton1Click:Connect(function()
    print("Botón de añadir Robux presionado.")
    -- Añadir Robux simulados
    currentSimulatedRobux = currentSimulatedRobux + amountToAdd
    updateRobuxCounter() -- Actualiza el contador en la UI
    playPurchaseAnimation(simulatedRobuxCounter, amountToAdd) -- Usa la animación de compra para el contador

    -- Pequeña animación o feedback visual al botón AddRobuxButton
    local originalColor = addRobuxButton.BackgroundColor3
    local tweenAdd = TweenService:Create(addRobuxButton, tweenInfo, { BackgroundColor3 = Color3.fromRGB(255, 255, 0) }) -- Amarillo al presionar
    tweenAdd:Play()
    tweenAdd.Completed:Connect(function()
        local tweenBack = TweenService:Create(addRobuxButton, tweenInfo, { BackgroundColor3 = originalColor })
        tweenBack:Play()
    end)

    print("Se añadieron " .. string.format("%,d", amountToAdd) .. " Robux simulados. Total: " .. string.format("%,d", currentSimulatedRobux))

    -- Opcional: Si implementaste la lógica updateItemButtonStates(), llama a:
    -- updateItemButtonStates()
end)


-- ========================================================
-- EJEMPLO DE CÓMO ABRIR LA TIENDA SIMULADA
-- ========================================================
-- Puedes simular la apertura de la tienda si el jugador presiona una tecla,
-- o al interactuar con un objeto en el juego que represente la tienda.

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then -- Asegúrate de que el input no fue procesado por el juego (ej: chat)
        if input.KeyCode == Enum.KeyCode.E then -- Usa la tecla 'E' como ejemplo
            print("Presionaste E. Abriendo tienda simulada...")
            openSimulatedShop()
        end
    end
end)


-- --- INICIALIZACIÓN ---
-- Asegúrate de que el contador se muestre al inicio, incluso si la tienda está oculta.
updateRobuxCounter() 

-- Si quieres que la tienda aparezca al iniciar el juego, descomenta la siguiente línea:
-- openSimulatedShop() 

-- Si implementaste updateItemButtonStates(), llámala aquí al inicio para que los botones se configuren correctamente:
-- updateItemButtonStates()
