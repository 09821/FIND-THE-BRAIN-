-- Script Completo TP Instantâneo by Branzz
-- Compatível com PC e Mobile

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Player
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis globais
local mainGUI, titleBar, contentFrame
local markedPosition = nil
local flightSpeed = 27
local flying = false
local flightEnabled = false
local flyingToPosition = false
local aerialTPActive = false
local cFlyActive = false
local cloneCharacter = nil
local originalTransparency = {}
local platformFolder = nil
local cFlyConfigGUI = nil
local currentCFlySpeed = 15
local minimizado = false

-- Anti-Kick System
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldNewIndex = mt.__newindex

if setreadonly then setreadonly(mt, false) end

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "Kick" or method == "kick") and self == player then
        return nil
    end
    
    if method == "FireServer" or method == "InvokeServer" then
        local arg1 = tostring(args[1])
        if arg1:lower():find("kick") or arg1:lower():find("ban") then
            return nil
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Anti-Ragdoll
mt.__newindex = newcclosure(function(t, k, v)
    if k == "Ragdoll" or k == "BreakJointsOnDeath" then
        return nil
    end
    if k == "CanCollide" and v == false and cFlyActive then
        return
    end
    return oldNewIndex(t, k, v)
end)

if setreadonly then setreadonly(mt, true) end

-- Funções auxiliares
function criarBordaRGB(frame)
    local border = Instance.new("Frame")
    border.Name = "RGBBorder"
    border.Size = UDim2.new(1, 6, 1, 6)
    border.Position = UDim2.new(0, -3, 0, -3)
    border.BackgroundTransparency = 1
    border.ZIndex = frame.ZIndex - 1
    border.Parent = frame.Parent
    
    local uIGradient = Instance.new("UIGradient")
    uIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    uIGradient.Rotation = 45
    uIGradient.Parent = border
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = border
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if border and border.Parent then
            uIGradient.Rotation = (uIGradient.Rotation + 1) % 360
        else
            connection:Disconnect()
        end
    end)
    
    return border
end

function criarBotao(nome, texto, posicao, tamanho, cor)
    local btn = Instance.new("TextButton")
    btn.Name = nome
    btn.Text = texto
    btn.Position = posicao
    btn.Size = tamanho
    btn.BackgroundColor3 = cor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

function criarLabel(nome, texto, posicao, tamanho)
    local lbl = Instance.new("TextLabel")
    lbl.Name = nome
    lbl.Text = texto
    lbl.Position = posicao
    lbl.Size = tamanho
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    return lbl
end

function atualizarContador()
    local contador = contentFrame:FindFirstChild("Contador")
    if contador then
        if markedPosition then
            contador.Text = string.format("Posição: X=%.1f, Y=%.1f, Z=%.1f", 
                markedPosition.X, markedPosition.Y, markedPosition.Z)
            contador.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            contador.Text = "Nenhuma posição marcada"
            contador.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end

-- Sistema de Voo
local flightConnection
flightConnection = RunService.RenderStepped:Connect(function()
    if flightEnabled and flying and humanoidRootPart then
        local camera = Workspace.CurrentCamera
        if camera then
            local lookVector = camera.CFrame.LookVector
            humanoidRootPart.Velocity = Vector3.new(
                lookVector.X * flightSpeed,
                humanoidRootPart.Velocity.Y,
                lookVector.Z * flightSpeed
            )
        end
    end
    
    if cFlyActive and cloneCharacter and cloneCharacter:FindFirstChild("HumanoidRootPart") then
        local camera = Workspace.CurrentCamera
        if camera and UserInputService:IsKeyDown(Enum.KeyCode.W) then
            local lookVector = camera.CFrame.LookVector
            humanoidRootPart.Velocity = Vector3.new(
                lookVector.X * currentCFlySpeed,
                lookVector.Velocity.Y,
                lookVector.Z * currentCFlySpeed
            )
        end
    end
end)

-- Criar GUI Principal
function criarGUI()
    -- ScreenGui Principal
    mainGUI = Instance.new("ScreenGui")
    mainGUI.Name = "TPInstantaneoGUI"
    mainGUI.ResetOnSpawn = false
    mainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGUI.Parent = CoreGui

    -- Frame Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Borda RGB Animada
    local rgbBorder = criarBordaRGB(mainFrame)
    
    -- Barra de Título
    titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TP INSTANTÂNEO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Subtítulo com borda RGB
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(0, 120, 0, 25)
    subtitle.Position = UDim2.new(1, -130, 0, 7)
    subtitle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    subtitle.Text = "BY BRANZZ"
    subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.GothamBold
    
    local subtitleCorner = Instance.new("UICorner")
    subtitleCorner.CornerRadius = UDim.new(0, 6)
    subtitleCorner.Parent = subtitle
    
    subtitle.Parent = titleBar
    
    -- Animação RGB no subtítulo
    local subtitleRGB = Instance.new("UIGradient")
    subtitleRGB.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    subtitleRGB.Rotation = 45
    subtitleRGB.Parent = subtitle
    
    RunService.RenderStepped:Connect(function()
        if subtitleRGB then
            subtitleRGB.Rotation = (subtitleRGB.Rotation + 2) % 360
        end
    end)

    -- Botão Minimizar
    local minButton = Instance.new("TextButton")
    minButton.Name = "MinButton"
    minButton.Size = UDim2.new(0, 30, 0, 30)
    minButton.Position = UDim2.new(1, -70, 0, 5)
    minButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    minButton.Text = "-"
    minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minButton.TextSize = 20
    minButton.Font = Enum.Font.GothamBold
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minButton
    
    minButton.Parent = titleBar

    -- Botão Fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.Parent = titleBar
    titleBar.Parent = mainFrame

    -- Frame de Conteúdo
    contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- ScrollingFrame para conteúdo
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = contentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scrollFrame

    -- Sistema de Posições
    local posSection = Instance.new("Frame")
    posSection.Size = UDim2.new(1, 0, 0, 100)
    posSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    posSection.BorderSizePixel = 0
    
    local posCorner = Instance.new("UICorner")
    posCorner.CornerRadius = UDim.new(0, 8)
    posCorner.Parent = posSection
    
    local posTitle = criarLabel("PosTitle", "📌 SISTEMA DE POSIÇÕES", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 20))
    posTitle.TextSize = 16
    posTitle.Font = Enum.Font.GothamBold
    posTitle.TextXAlignment = Enum.TextXAlignment.Center
    posTitle.Parent = posSection

    -- Botão Marcar Posição
    local markBtn = criarBotao("MarkBtn", "📍 Mark Position", UDim2.new(0, 10, 0, 40), UDim2.new(0.45, -5, 0, 30), Color3.fromRGB(0, 150, 255))
    markBtn.Parent = posSection

    -- Botão Limpar
    local clearBtn = criarBotao("ClearBtn", "🗑️ Clear", UDim2.new(0.55, 5, 0, 40), UDim2.new(0.45, -5, 0, 30), Color3.fromRGB(255, 100, 100))
    clearBtn.Parent = posSection

    -- Contador
    local contador = criarLabel("Contador", "Nenhuma posição marcada", UDim2.new(0, 10, 0, 80), UDim2.new(1, -20, 0, 15))
    contador.TextXAlignment = Enum.TextXAlignment.Center
    contador.Parent = posSection
    
    posSection.Parent = scrollFrame

    -- Funções de Teleporte (Toggles)
    local functionsSection = Instance.new("Frame")
    functionsSection.Size = UDim2.new(1, 0, 0, 250)
    functionsSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    functionsSection.BorderSizePixel = 0
    
    local funcCorner = Instance.new("UICorner")
    funcCorner.CornerRadius = UDim.new(0, 8)
    funcCorner.Parent = functionsSection
    
    local funcTitle = criarLabel("FuncTitle", "🚀 FUNÇÕES DE TELEPORTE", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 20))
    funcTitle.TextSize = 16
    funcTitle.Font = Enum.Font.GothamBold
    funcTitle.TextXAlignment = Enum.TextXAlignment.Center
    funcTitle.Parent = functionsSection

    -- Voo Livre
    local flightToggleBtn = criarBotao("FlightToggle", "✈️ Voo Livre", UDim2.new(0, 10, 0, 40), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 80))
    flightToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local flightStatus = criarLabel("FlightStatus", "OFF", UDim2.new(1, -60, 0.5, -10), UDim2.new(0, 50, 0, 20))
    flightStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    flightStatus.TextXAlignment = Enum.TextXAlignment.Center
    flightStatus.Parent = flightToggleBtn
    
    flightToggleBtn.Parent = functionsSection

    -- TP Voando (Plataformas)
    local flyingTPBtn = criarBotao("FlyingTP", "🎯 TP Voando (Plataformas)", UDim2.new(0, 10, 0, 90), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 80))
    flyingTPBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local flyingTPStatus = criarLabel("FlyingTPStatus", "OFF", UDim2.new(1, -60, 0.5, -10), UDim2.new(0, 50, 0, 20))
    flyingTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    flyingTPStatus.TextXAlignment = Enum.TextXAlignment.Center
    flyingTPStatus.Parent = flyingTPBtn
    
    flyingTPBtn.Parent = functionsSection

    -- TP Aéreo + Queda
    local aerialTPBtn = criarBotao("AerialTP", "🌤️ TP Aéreo + Queda", UDim2.new(0, 10, 0, 140), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 80))
    aerialTPBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local aerialTPStatus = criarLabel("AerialTPStatus", "OFF", UDim2.new(1, -60, 0.5, -10), UDim2.new(0, 50, 0, 20))
    aerialTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    aerialTPStatus.TextXAlignment = Enum.TextXAlignment.Center
    aerialTPStatus.Parent = aerialTPBtn
    
    aerialTPBtn.Parent = functionsSection

    -- C-Fly (Clone)
    local cFlyBtn = criarBotao("CFly", "👻 C-Fly (Clone)", UDim2.new(0, 10, 0, 190), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 80))
    cFlyBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local cFlyStatus = criarLabel("CFlyStatus", "OFF", UDim2.new(1, -60, 0.5, -10), UDim2.new(0, 50, 0, 20))
    cFlyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    cFlyStatus.TextXAlignment = Enum.TextXAlignment.Center
    cFlyStatus.Parent = cFlyBtn
    
    cFlyBtn.Parent = functionsSection
    
    functionsSection.Parent = scrollFrame

    mainFrame.Parent = mainGUI
    
    -- Eventos dos botões
    markBtn.MouseButton1Click:Connect(function()
        if markedPosition then
            local notif = Instance.new("TextLabel")
            notif.Size = UDim2.new(1, -20, 0, 30)
            notif.Position = UDim2.new(0, 10, 0, -40)
            notif.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            notif.Text = "Use CLEAR para marcar nova posição!"
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            notif.TextSize = 12
            notif.Font = Enum.Font.GothamBold
            notif.Parent = posSection
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = notif
            
            task.wait(2)
            notif:Destroy()
            return
        end
        
        if humanoidRootPart then
            markedPosition = humanoidRootPart.Position
            atualizarContador()
        end
    end)
    
    clearBtn.MouseButton1Click:Connect(function()
        markedPosition = nil
        atualizarContador()
    end)
    
    -- Sistema de Voo Livre
    flightToggleBtn.MouseButton1Click:Connect(function()
        if flightEnabled then
            flightEnabled = false
            flying = false
            flightStatus.Text = "OFF"
            flightStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            flightToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            flightEnabled = true
            flying = true
            flightStatus.Text = "ON"
            flightStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            flightToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
    end)
    
    -- Sistema TP Voando (Plataformas)
    local platformConnection
    flyingTPBtn.MouseButton1Click:Connect(function()
        if flyingToPosition then
            flyingToPosition = false
            flyingTPStatus.Text = "OFF"
            flyingTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            flyingTPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            
            if platformConnection then
                platformConnection:Disconnect()
                platformConnection = nil
            end
            
            -- Remover todas as plataformas
            if platformFolder then
                platformFolder:Destroy()
                platformFolder = nil
            end
        else
            if not markedPosition then
                local notif = Instance.new("TextLabel")
                notif.Size = UDim2.new(1, -20, 0, 30)
                notif.Position = UDim2.new(0, 10, 0, -40)
                notif.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                notif.Text = "Marque uma posição primeiro!"
                notif.TextColor3 = Color3.fromRGB(255, 255, 255)
                notif.TextSize = 12
                notif.Font = Enum.Font.GothamBold
                notif.Parent = posSection
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = notif
                
                task.wait(2)
                notif:Destroy()
                return
            end
            
            flyingToPosition = true
            flyingTPStatus.Text = "ON"
            flyingTPStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            flyingTPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            
            -- Criar pasta para plataformas
            platformFolder = Instance.new("Folder")
            platformFolder.Name = "TPPlatforms"
            platformFolder.Parent = Workspace
            
            -- Ativar voo
            flightEnabled = true
            flying = true
            
            -- Calcular direção
            local direction = (markedPosition - humanoidRootPart.Position).Unit
            
            -- Sistema de plataformas
            platformConnection = RunService.Heartbeat:Connect(function()
                if not flyingToPosition then return end
                
                -- Verificar se chegou
                local distance = (humanoidRootPart.Position - markedPosition).Magnitude
                if distance < 5 then
                    flying = false
                    flightEnabled = false
                    flyingToPosition = false
                    flyingTPStatus.Text = "OFF"
                    flyingTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    flyingTPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    platformConnection:Disconnect()
                    return
                end
                
                -- Criar plataforma a cada 1 segundo
                local platform = Instance.new("Part")
                platform.Name = "TPPlatform"
                platform.Size = Vector3.new(6, 1, 6)
                platform.Position = humanoidRootPart.Position - Vector3.new(0, 4, 0)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Material = EnumMaterial.Neon
                platform.Color = Color3.fromRGB(100, 255, 200)
                platform.Parent = platformFolder
                
                -- Remover após 5 segundos
                task.delay(5, function()
                    if platform then
                        platform:Destroy()
                    end
                end)
                
                -- Mover jogador
                humanoidRootPart.Velocity = direction * flightSpeed
                
                task.wait(1)
            end)
        end
    end)
    
    -- Sistema TP Aéreo + Queda
    local aerialConnection
    aerialTPBtn.MouseButton1Click:Connect(function()
        if aerialTPActive then
            aerialTPActive = false
            aerialTPStatus.Text = "OFF"
            aerialTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            aerialTPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            
            if aerialConnection then
                aerialConnection:Disconnect()
                aerialConnection = nil
            end
            
            if humanoidRootPart then
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        else
            if not markedPosition then
                local notif = Instance.new("TextLabel")
                notif.Size = UDim2.new(1, -20, 0, 30)
                notif.Position = UDim2.new(0, 10, 0, -40)
                notif.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                notif.Text = "Marque uma posição primeiro!"
                notif.TextColor3 = Color3.fromRGB(255, 255, 255)
                notif.TextSize = 12
                notif.Font = Enum.Font.GothamBold
                notif.Parent = posSection
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = notif
                
                task.wait(2)
                notif:Destroy()
                return
            end
            
            aerialTPActive = true
            aerialTPStatus.Text = "ON"
            aerialTPStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            aerialTPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            
            -- Altura de 8 jogadores (8 * 5 = 40 studs)
            local startHeight = humanoidRootPart.Position.Y + 40
            
            local zigzagPhase = 0
            local timeCounter = 0
            
            aerialConnection = RunService.Heartbeat:Connect(function()
                if not aerialTPActive then return end
                
                timeCounter = timeCounter + 0.1
                
                -- Ciclo: 2 segundos no ar, 2 segundos no chão
                local cycleTime = timeCounter % 4
                
                if cycleTime < 2 then
                    -- Fase aérea: zigzag para cima
                    zigzagPhase = zigzagPhase + 0.1
                    local zigzagOffset = math.sin(zigzagPhase) * 10
                    
                    humanoidRootPart.Velocity = Vector3.new(
                        zigzagOffset,
                        15 + math.sin(zigzagPhase * 2) * 5,
                        zigzagOffset
                    )
                else
                    -- Fase no chão: descer
                    if humanoidRootPart.Position.Y > markedPosition.Y + 2 then
                        humanoidRootPart.Velocity = Vector3.new(0, -20, 0)
                    else
                        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        humanoidRootPart.Position = Vector3.new(
                            markedPosition.X,
                            markedPosition.Y + 2,
                            markedPosition.Z
                        )
                    end
                end
                
                -- Teleportar para a posição marcada quando perto
                local distance = (humanoidRootPart.Position - markedPosition).Magnitude
                if distance < 10 and humanoidRootPart.Position.Y < markedPosition.Y + 5 then
                    humanoidRootPart.Position = markedPosition
                    aerialTPActive = false
                    aerialTPStatus.Text = "OFF"
                    aerialTPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                    aerialTPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    aerialConnection:Disconnect()
                end
            end)
        end
    end)
    
    -- Sistema C-Fly
    local function criarConfigCFly()
        if cFlyConfigGUI then
            cFlyConfigGUI:Destroy()
            cFlyConfigGUI = nil
            return
        end
        
        -- GUI de Configuração C-Fly
        cFlyConfigGUI = Instance.new("ScreenGui")
        cFlyConfigGUI.Name = "CFlyConfigGUI"
        cFlyConfigGUI.ResetOnSpawn = false
        cFlyConfigGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        cFlyConfigGUI.Parent = CoreGui
        
        local configFrame = Instance.new("Frame")
        configFrame.Name = "ConfigFrame"
        configFrame.Size = UDim2.new(0, 250, 0, 120)
        configFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
        configFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        configFrame.BorderSizePixel = 0
        
        local configCorner = Instance.new("UICorner")
        configCorner.CornerRadius = UDim.new(0, 10)
        configCorner.Parent = configFrame
        
        -- Borda RGB
        criarBordaRGB(configFrame)
        
        -- Barra de título
        local configTitleBar = Instance.new("Frame")
        configTitleBar.Size = UDim2.new(1, 0, 0, 30)
        configTitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        configTitleBar.BorderSizePixel = 0
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = configTitleBar
        
        local configTitle = criarLabel("ConfigTitle", "C-FLY CONFIG", UDim2.new(0, 10, 0, 0), UDim2.new(1, -50, 1, 0))
        configTitle.TextSize = 14
        configTitle.Font = Enum.Font.GothamBold
        configTitle.Parent = configTitleBar
        
        local closeConfigBtn = Instance.new("TextButton")
        closeConfigBtn.Size = UDim2.new(0, 30, 0, 30)
        closeConfigBtn.Position = UDim2.new(1, -35, 0, 0)
        closeConfigBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        closeConfigBtn.Text = "X"
        closeConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeConfigBtn.TextSize = 14
        closeConfigBtn.Font = Enum.Font.GothamBold
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 6)
        closeCorner.Parent = closeConfigBtn
        
        closeConfigBtn.MouseButton1Click:Connect(function()
            cFlyConfigGUI:Destroy()
            cFlyConfigGUI = nil
        end)
        
        closeConfigBtn.Parent = configTitleBar
        configTitleBar.Parent = configFrame
        
        -- Conteúdo
        local speedLabel = criarLabel("SpeedLabel", "Velocidade (1-25):", UDim2.new(0, 20, 0, 40), UDim2.new(1, -40, 0, 20))
        speedLabel.Parent = configFrame
        
        local speedBox = Instance.new("TextBox")
        speedBox.Name = "SpeedBox"
        speedBox.Size = UDim2.new(1, -40, 0, 30)
        speedBox.Position = UDim2.new(0, 20, 0, 60)
        speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedBox.Text = tostring(currentCFlySpeed)
        speedBox.TextSize = 14
        speedBox.Font = Enum.Font.Gotham
        speedBox.ClearTextOnFocus = false
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = speedBox
        
        speedBox.FocusLost:Connect(function(enterPressed)
            local num = tonumber(speedBox.Text)
            if num and num >= 1 and num <= 25 then
                currentCFlySpeed = num
                speedBox.Text = tostring(num)
            else
                speedBox.Text = tostring(currentCFlySpeed)
            end
        end)
        
        speedBox.Parent = configFrame
        configFrame.Parent = cFlyConfigGUI
        
        -- Sistema de arrastar
        local dragging = false
        local dragStart, frameStart
        
        configTitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                frameStart = configFrame.Position
            end
        end)
        
        configTitleBar.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                configFrame.Position = UDim2.new(
                    frameStart.X.Scale,
                    frameStart.X.Offset + delta.X,
                    frameStart.Y.Scale,
                    frameStart.Y.Offset + delta.Y
                )
            end
        end)
        
        configTitleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    
    cFlyBtn.MouseButton1Click:Connect(function()
        if cFlyActive then
            -- Desativar C-Fly
            cFlyActive = false
            cFlyStatus.Text = "OFF"
            cFlyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
            cFlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            
            -- Destruir clone
            if cloneCharacter then
                cloneCharacter:Destroy()
                cloneCharacter = nil
            end
            
            -- Restaurar visibilidade
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and originalTransparency[part] then
                        part.Transparency = originalTransparency[part]
                    end
                end
                originalTransparency = {}
            end
            
            -- Fechar GUI de configuração
            if cFlyConfigGUI then
                cFlyConfigGUI:Destroy()
                cFlyConfigGUI = nil
            end
            
            -- Restaurar colisão
            if humanoidRootPart then
                humanoidRootPart.CanCollide = true
            end
            
        else
            -- Ativar C-Fly
            cFlyActive = true
            cFlyStatus.Text = "ON"
            cFlyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
            cFlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            
            -- Salvar transparência original e tornar invisível
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        originalTransparency[part] = part.Transparency
                        part.Transparency = 1
                    end
                end
            end
            
            -- Criar clone
            cloneCharacter = character:Clone()
            
            -- Remover scripts do clone
            for _, child in pairs(cloneCharacter:GetDescendants()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    child:Destroy()
                end
            end
            
            -- Posicionar clone
            cloneCharacter:MoveTo(humanoidRootPart.Position)
            
            -- Ancorar clone
            local cloneRoot = cloneCharacter:FindFirstChild("HumanoidRootPart")
            if cloneRoot then
                cloneRoot.Anchored = true
            end
            
            cloneCharacter.Parent = Workspace
            
            -- Ativar sistema de atravessar paredes
            if humanoidRootPart then
                humanoidRootPart.CanCollide = false
            end
            
            -- Abrir GUI de configuração
            criarConfigCFly()
        end
    end)
    
    -- Sistema de arrastar a janela principal
    local draggingMain = false
    local dragStartMain, frameStartMain
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            dragStartMain = input.Position
            frameStartMain = mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartMain
            mainFrame.Position = UDim2.new(
                frameStartMain.X.Scale,
                frameStartMain.X.Offset + delta.X,
                frameStartMain.Y.Scale,
                frameStartMain.Y.Offset + delta.Y
            )
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = false
        end
    end)
    
    -- Botão Minimizar/Expandir
    minButton.MouseButton1Click:Connect(function()
        if minimizado then
            -- Expandir
            mainFrame.Size = UDim2.new(0, 340, 0, 420)
            contentFrame.Visible = true
            minButton.Text = "-"
            minimizado = false
        else
            -- Minimizar
            mainFrame.Size = UDim2.new(0, 340, 0, 40)
            contentFrame.Visible = false
            minButton.Text = "+"
            minimizado = true
        end
    end)
    
    -- Botão Fechar
    closeButton.MouseButton1Click:Connect(function()
        -- Desativar tudo
        flightEnabled = false
        flying = false
        flyingToPosition = false
        aerialTPActive = false
        cFlyActive = false
        
        -- Limpar plataformas
        if platformFolder then
            platformFolder:Destroy()
            platformFolder = nil
        end
        
        -- Destruir clone
        if cloneCharacter then
            cloneCharacter:Destroy()
            cloneCharacter = nil
        end
        
        -- Restaurar visibilidade
        if character and originalTransparency then
            for part, transparency in pairs(originalTransparency) do
                if part and part.Parent then
                    part.Transparency = transparency
                end
            end
        end
        
        -- Fechar GUIs
        if cFlyConfigGUI then
            cFlyConfigGUI:Destroy()
        end
        
        mainGUI:Destroy()
    end)
    
    -- Atalhos de teclado
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F then
            flightToggleBtn:Fire("MouseButton1Click")
        elseif input.KeyCode == Enum.KeyCode.T then
            if flyingTPBtn then
                flyingTPBtn:Fire("MouseButton1Click")
            end
        elseif input.KeyCode == Enum.KeyCode.A then
            if aerialTPBtn then
                aerialTPBtn:Fire("MouseButton1Click")
            end
        elseif input.KeyCode == Enum.KeyCode.C then
            if cFlyBtn then
                cFlyBtn:Fire("MouseButton1Click")
            end
        elseif input.KeyCode == Enum.KeyCode.M then
            if markBtn then
                markBtn:Fire("MouseButton1Click")
            end
        elseif input.KeyCode == Enum.KeyCode.X then
            if clearBtn then
                clearBtn:Fire("MouseButton1Click")
            end
        end
    end)
    
    -- Atualizar personagem quando morrer
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    end)
end

-- Iniciar
criarGUI()
