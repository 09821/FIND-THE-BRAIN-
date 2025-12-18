-- Script Finder Brainrots
-- Por: @branzz_br

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

-- Configurações
local PLAYER = Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()

-- Esperar PlayerGui estar pronto
local playerGui = PLAYER:WaitForChild("PlayerGui")

-- Criar ScreenGui
local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "BrainrotsFinder_" .. HttpService:GenerateGUID(false):sub(1, 8)
SCREEN_GUI.ResetOnSpawn = false
SCREEN_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SCREEN_GUI.DisplayOrder = 999
SCREEN_GUI.Parent = playerGui

-- Variável global para controlar o loading
local isLoadingComplete = false

-- Tela de carregamento COM CORREÇÃO
local function createLoadingScreen()
    print("Iniciando tela de carregamento...")
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ZIndex = 1000
    loadingFrame.Parent = SCREEN_GUI
    
    -- Gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = loadingFrame

    -- Logo
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 400, 0, 150)
    logoContainer.Position = UDim2.new(0.5, -200, 0.4, -75)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = loadingFrame
    
    local logo = Instance.new("TextLabel")
    logo.Text = "FINDER BRAINROTS"
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 40
    logo.TextColor3 = Color3.fromRGB(0, 170, 255)
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.ZIndex = 1002
    logo.Parent = logoContainer
    
    local creator = Instance.new("TextLabel")
    creator.Text = "By @branzz_br"
    creator.Font = Enum.Font.GothamBold
    creator.TextSize = 18
    creator.TextColor3 = Color3.fromRGB(150, 150, 255)
    creator.BackgroundTransparency = 1
    creator.Position = UDim2.new(0.5, 0, 0.55, 0)
    creator.AnchorPoint = Vector2.new(0.5, 0.5)
    creator.Size = UDim2.new(0, 200, 0, 30)
    creator.ZIndex = 1002
    creator.Parent = loadingFrame
    
    -- Barra de progresso SIMPLIFICADA
    local progressContainer = Instance.new("Frame")
    progressContainer.Size = UDim2.new(0.4, 0, 0, 20)
    progressContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
    progressContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    progressContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progressContainer.BorderSizePixel = 0
    progressContainer.ClipsDescendants = true
    progressContainer.ZIndex = 1001
    progressContainer.Parent = loadingFrame
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 1002
    progressFill.Parent = progressContainer
    
    local progressText = Instance.new("TextLabel")
    progressText.Text = "CARREGANDO..."
    progressText.Font = Enum.Font.GothamMedium
    progressText.TextSize = 14
    progressText.TextColor3 = Color3.fromRGB(200, 200, 255)
    progressText.BackgroundTransparency = 1
    progressText.Position = UDim2.new(0.5, 0, 0.72, 0)
    progressText.AnchorPoint = Vector2.new(0.5, 0.5)
    progressText.Size = UDim2.new(0, 300, 0, 30)
    progressText.ZIndex = 1002
    progressText.Parent = loadingFrame
    
    -- Função para remover a tela de loading
    local function removeLoadingScreen()
        print("Removendo tela de carregamento...")
        
        -- Primeiro fazer fade out
        local fadeTween = TweenService:Create(loadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        
        -- Fazer fade out de todos os elementos filhos
        for _, child in ipairs(loadingFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 1
                }):Play()
            elseif child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end
        
        fadeTween:Play()
        
        -- Esperar animação terminar e remover
        wait(0.6)
        if loadingFrame and loadingFrame.Parent then
            loadingFrame:Destroy()
            print("Tela de carregamento removida!")
        end
        
        isLoadingComplete = true
    end
    
    -- Animar progresso por 3 segundos
    local duration = 3
    local startTime = tick()
    local lastUpdate = startTime
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        local elapsed = currentTime - startTime
        
        if elapsed >= duration then
            connection:Disconnect()
            removeLoadingScreen()
            return
        end
        
        -- Atualizar apenas a cada 0.1 segundos para melhor performance
        if currentTime - lastUpdate >= 0.1 then
            local progress = math.min(elapsed / duration, 1)
            
            -- Atualizar barra de progresso
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
            
            -- Atualizar texto
            local percent = math.floor(progress * 100)
            if percent < 30 then
                progressText.Text = "PROCURANDO BRAINROTS..."
            elseif percent < 60 then
                progressText.Text = "CARREGANDO INTERFACE..."
            elseif percent < 90 then
                progressText.Text = "FINALIZANDO..."
            else
                progressText.Text = "PRONTO!"
            end
            progressText.Text = string.format("%s %d%%", progressText.Text, percent)
            
            lastUpdate = currentTime
        end
    end)
    
    return loadingFrame
end

-- Sistema de detecção de Brainrots (SIMPLIFICADO)
local function findBrainrots()
    print("Procurando Brainrots...")
    local foundBrainrots = {}
    
    -- Buscar no Workspace primeiro
    local function searchInWorkspace()
        local workspaceBrainrots = game.Workspace:FindFirstChild("Brainrots")
        if workspaceBrainrots then
            print("Encontrado Brainrots no Workspace")
            table.insert(foundBrainrots, {
                Object = workspaceBrainrots,
                Path = "Workspace.Brainrots",
                Type = workspaceBrainrots.ClassName
            })
            
            -- Coletar filhos
            for _, child in ipairs(workspaceBrainrots:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    table.insert(foundBrainrots, {
                        Object = child,
                        Path = "Workspace.Brainrots." .. child.Name,
                        Type = child.ClassName
                    })
                end
            end
        end
    end
    
    -- Buscar objetos com "brainrot" no nome
    local function searchByName()
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if obj.Name:lower():find("brainrot") then
                table.insert(foundBrainrots, {
                    Object = obj,
                    Path = obj:GetFullName(),
                    Type = obj.ClassName
                })
            end
        end
    end
    
    -- Executar buscas
    searchInWorkspace()
    searchByName()
    
    print(string.format("Encontrados %d Brainrots", #foundBrainrots))
    return foundBrainrots
end

-- Teleport simples
local function simpleTeleport(target, mode)
    local char = PLAYER.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local targetPos
    if target:IsA("Model") then
        local primary = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
        if primary then
            targetPos = primary.Position
        else
            return false
        end
    elseif target:IsA("BasePart") then
        targetPos = target.Position
    else
        return false
    end
    
    if mode == "TO_TARGET" then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        return true
    elseif mode == "TO_PLAYER" then
        if target:IsA("BasePart") then
            target.Position = hrp.Position + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
        end
        return true
    end
    
    return false
end

-- Sistema drag simplificado
local function makeDraggable(gui, dragPart)
    local dragging = false
    local dragStart, startPos
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- GUI principal SIMPLIFICADA E FUNCIONAL
local function createMainGUI()
    print("Criando GUI principal...")
    
    -- Encontrar Brainrots
    local brainrots = findBrainrots()
    
    -- Criar frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = SCREEN_GUI
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = "FINDER BRAINROTS"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame:Destroy()
    end)
    
    -- Tornar arrastável
    makeDraggable(mainFrame, titleBar)
    
    -- Contador
    local countText = Instance.new("TextLabel")
    countText.Text = string.format("Encontrados: %d", #brainrots)
    countText.Font = Enum.Font.Gotham
    countText.TextSize = 14
    countText.TextColor3 = Color3.fromRGB(0, 255, 150)
    countText.BackgroundTransparency = 1
    countText.Size = UDim2.new(1, -20, 0, 30)
    countText.Position = UDim2.new(0, 10, 0, 50)
    countText.TextXAlignment = Enum.TextXAlignment.Left
    countText.Parent = mainFrame
    
    -- Lista de Brainrots
    local listContainer = Instance.new("ScrollingFrame")
    listContainer.Size = UDim2.new(1, -20, 0, 300)
    listContainer.Position = UDim2.new(0, 10, 0, 90)
    listContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    listContainer.BorderSizePixel = 0
    listContainer.ScrollBarThickness = 6
    listContainer.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 70)
    listContainer.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = listContainer
    
    -- Seleção
    local selectedBrainrot = nil
    
    -- Adicionar Brainrots à lista
    for i, brainrot in ipairs(brainrots) do
        local item = Instance.new("TextButton")
        item.Text = string.format("%d. %s", i, brainrot.Object.Name)
        item.Font = Enum.Font.Gotham
        item.TextSize = 14
        item.TextColor3 = Color3.fromRGB(220, 220, 220)
        item.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        item.BorderSizePixel = 0
        item.Size = UDim2.new(1, -10, 0, 40)
        item.Position = UDim2.new(0, 5, 0, (i-1)*45)
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Padding = {Left = UDim.new(0, 10)}
        item.Parent = listContainer
        
        item.MouseButton1Click:Connect(function()
            selectedBrainrot = brainrot.Object
            
            -- Resetar cores
            for _, child in ipairs(listContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                end
            end
            
            -- Destacar selecionado
            item.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end)
    end
    
    -- Ajustar tamanho do canvas
    listContainer.CanvasSize = UDim2.new(0, 0, 0, #brainrots * 45)
    
    -- Painel de controle
    local controlPanel = Instance.new("Frame")
    controlPanel.Size = UDim2.new(1, -20, 0, 120)
    controlPanel.Position = UDim2.new(0, 10, 1, -130)
    controlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    controlPanel.BorderSizePixel = 0
    controlPanel.Parent = mainFrame
    
    -- Botão Teleport
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Text = "🔍 TELEPORT TO BRAINROT"
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.TextSize = 14
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    teleportBtn.BorderSizePixel = 0
    teleportBtn.Size = UDim2.new(1, 0, 0, 35)
    teleportBtn.Position = UDim2.new(0, 0, 0, 10)
    teleportBtn.Parent = controlPanel
    
    -- Botão Grab All
    local grabAllBtn = Instance.new("TextButton")
    grabAllBtn.Text = "🌀 GRAB ALL BRAINROTS"
    grabAllBtn.Font = Enum.Font.GothamBold
    grabAllBtn.TextSize = 14
    grabAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    grabAllBtn.BorderSizePixel = 0
    grabAllBtn.Size = UDim2.new(1, 0, 0, 35)
    grabAllBtn.Position = UDim2.new(0, 0, 0, 55)
    grabAllBtn.Parent = controlPanel
    
    -- Função do botão Teleport
    teleportBtn.MouseButton1Click:Connect(function()
        if selectedBrainrot then
            local success = simpleTeleport(selectedBrainrot, "TO_TARGET")
            if success then
                teleportBtn.Text = "✓ TELEPORTADO!"
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                wait(1)
                teleportBtn.Text = "🔍 TELEPORT TO BRAINROT"
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            else
                teleportBtn.Text = "✗ FALHOU!"
                teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                wait(1)
                teleportBtn.Text = "🔍 TELEPORT TO BRAINROT"
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            end
        else
            teleportBtn.Text = "SELECIONE UM BRAINROT!"
            teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            wait(1)
            teleportBtn.Text = "🔍 TELEPORT TO BRAINROT"
            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    -- Função do botão Grab All
    grabAllBtn.MouseButton1Click:Connect(function()
        local char = PLAYER.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        grabAllBtn.Text = "TRANSFORMANDO..."
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        local successful = 0
        for _, brainrot in ipairs(brainrots) do
            if simpleTeleport(brainrot.Object, "TO_PLAYER") then
                successful = successful + 1
            end
            wait(0.05)
        end
        
        grabAllBtn.Text = string.format("✓ %d TRANSFORMADOS!", successful)
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        wait(1.5)
        grabAllBtn.Text = "🌀 GRAB ALL BRAINROTS"
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    end)
    
    -- Efeitos de hover
    teleportBtn.MouseEnter:Connect(function()
        teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    teleportBtn.MouseLeave:Connect(function()
        if teleportBtn.Text:find("TELEPORT TO") then
            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    grabAllBtn.MouseEnter:Connect(function()
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 30)
    end)
    
    grabAllBtn.MouseLeave:Connect(function()
        if grabAllBtn.Text:find("GRAB ALL") then
            grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        end
    end)
    
    -- Animar entrada
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame:TweenSize(UDim2.new(0, 400, 0, 500), "Out", "Quad", 0.5, true)
    
    print("GUI principal criada com sucesso!")
end

-- Função principal
local function main()
    print("=== INICIANDO FINDER BRAINROTS ===")
    
    -- Criar tela de loading
    createLoadingScreen()
    
    -- Esperar 3 segundos para o loading
    local startTime = tick()
    while tick() - startTime < 3 do
        wait(0.1)
    end
    
    print("Loading completo, criando GUI principal...")
    
    -- Pequeno delay para garantir que o loading terminou
    wait(0.5)
    
    -- Criar GUI principal
    createMainGUI()
    
    print("=== SCRIPT EXECUTADO COM SUCESSO ===")
end

-- Executar com proteção contra erros
local success, errorMsg = pcall(main)

if not success then
    print("ERRO AO EXECUTAR SCRIPT:", errorMsg)
    
    -- Tentar criar pelo menos uma interface simples
    local errorFrame = Instance.new("Frame")
    errorFrame.Size = UDim2.new(0, 300, 0, 150)
    errorFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    errorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    errorFrame.BorderSizePixel = 0
    errorFrame.Parent = SCREEN_GUI
    
    local errorText = Instance.new("TextLabel")
    errorText.Text = "ERRO:\n" .. tostring(errorMsg):sub(1, 100)
    errorText.Font = Enum.Font.Gotham
    errorText.TextSize = 14
    errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorText.BackgroundTransparency = 1
    errorText.Size = UDim2.new(1, -20, 1, -20)
    errorText.Position = UDim2.new(0, 10, 0, 10)
    errorText.TextWrapped = true
    errorText.Parent = errorFrame
end