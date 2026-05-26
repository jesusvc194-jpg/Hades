-- ============================================
-- MODIFICAR ROBUX DEL JUEGO (Visual)
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Tu Robux falso
local FAKE_ROBUX = 9764432
local CurrentRobux = FAKE_ROBUX

-- Función para formatear números
local function FormatNumber(num)
    return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- Esperar a que cargue la UI del juego
local playerGui = player:WaitForChild("PlayerGui")

-- Buscar el display de Robux existente
local function FindRobuxDisplay()
    -- Buscar en todas las ScreenGuis
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            -- Buscar texto que contenga "0" o el icono de Robux
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    -- Si el texto es "0" y está cerca de un icono de Robux
                    if obj.Text == "0" or obj.Text == "1" or obj.Text == "" then
                        -- Verificar si tiene un icono de Robux cerca (ImageLabel)
                        local parent = obj.Parent
                        for _, sibling in ipairs(parent:GetChildren()) do
                            if sibling:IsA("ImageLabel") and (
                                sibling.Image:find("rbxassetid") or 
                                sibling.Name:lower():find("robux") or
                                sibling.Name:lower():find("premium")
                            ) then
                                return obj
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Esperar y modificar
task.wait(2) -- Esperar a que cargue todo

local RobuxDisplay = FindRobuxDisplay()

if RobuxDisplay then
    -- Modificar el texto a tu Robux falso
    RobuxDisplay.Text = FormatNumber(CurrentRobux)
    
    -- Hacer que no se pueda cambiar (bloquear actualizaciones)
    local connection
    connection = RobuxDisplay:GetPropertyChangedSignal("Text"):Connect(function()
        if RobuxDisplay.Text ~= FormatNumber(CurrentRobux) then
            RobuxDisplay.Text = FormatNumber(CurrentRobux)
        end
    end)
    
    print("✅ Robux modificado a: " .. FormatNumber(CurrentRobux))
else
    print("❌ No se encontró el display de Robux. Intentando método alternativo...")
    
    -- Método alternativo: buscar por posición (generalmente arriba a la derecha)
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Position.X.Scale > 0.7 and obj.Position.Y.Scale < 0.2 then
                    if obj.Text:match("^%d+$") or obj.Text == "0" then -- Solo números
                        RobuxDisplay = obj
                        RobuxDisplay.Text = FormatNumber(CurrentRobux)
                        print("✅ Robux encontrado por posición y modificado")
                        break
                    end
                end
            end
        end
    end
end

-- ============================================
-- FUNCIÓN PARA RESTAR ROBUX (Al "comprar")
-- ============================================

function SpendRobux(amount)
    if CurrentRobux >= amount then
        CurrentRobux = CurrentRobux - amount
        
        -- Actualizar el display
        if RobuxDisplay then
            RobuxDisplay.Text = FormatNumber(CurrentRobux)
            
            -- Animación de cambio
            TweenService:Create(RobuxDisplay, TweenInfo.new(0.2), {TextSize = RobuxDisplay.TextSize + 4}):Play()
            task.wait(0.2)
            TweenService:Create(RobuxDisplay, TweenInfo.new(0.2), {TextSize = RobuxDisplay.TextSize - 4}):Play()
        end
        
        return true
    else
        return false -- No hay suficiente
    end
end

-- ============================================
-- EJEMPLO: Conectar a tu tienda
-- ============================================

-- Cuando compres algo, llama: SpendRobux(precio)
-- Ejemplo:
-- SpendRobux(600000) -- Resta 600,000 y muestra: 9,164,432

print("💰 Sistema cargado. Usa SpendRobux(cantidad) para restar")
