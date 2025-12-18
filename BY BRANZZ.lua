-- Script Finder Brainrots
-- Por: @branzz_br

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Desativar notificações do CoreScript
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Configurações
local PLAYER = Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "BrainrotsFinder_" .. HttpService:GenerateGUID(false):sub(1, 8)
SCREEN_GUI.ResetOnSpawn = false
SCREEN_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SCREEN_GUI.Parent = PLAYER:WaitForChild("PlayerGui")

-- Tela de carregamento
local function createLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ZIndex = 1000
    loadingFrame.Parent = SCREEN_GUI
    
    -- Gradiente animado
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = loadingFrame
    
    -- Efeito de partículas
    local particles = Instance.new("Frame")
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.ZIndex = 1001
    particles.Parent = loadingFrame
    
    -- Logo com efeito
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 400, 0, 150)
    logoContainer.Position = UDim2.new(0.5, -200, 0.4, -75)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = loadingFrame
    
    local logoShadow = Instance.new("TextLabel")
    logoShadow.Text = "FINDER BRAINROTS"
    logoShadow.Font = Enum.Font.GothamBlack
    logoShadow.TextSize = 42
    logoShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    logoShadow.TextTransparency = 0.7
    logoShadow.BackgroundTransparency = 1
    logoShadow.Position = UDim2.new(0.5, -198, 0.5, -73)
    logoShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoShadow.Size = UDim2.new(1, 0, 1, 0)
    logoShadow.ZIndex = 1001
    logoShadow.Parent = logoContainer
    
    local logo = Instance.new("TextLabel")
    logo.Text = "FINDER BRAINROTS"
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 40
    logo.TextColor3 = Color3.fromRGB(0, 170, 255)
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.new(0.5, -200, 0.5, -75)
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
    
    -- Barra de progresso moderna
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
    
    -- Efeito de brilho na barra
    local progressGlow = Instance.new("UIGradient")
    progressGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
    })
    progressGlow.Rotation = 90
    progressGlow.Parent = progressFill
    
    local progressText = Instance.new("TextLabel")
    progressText.Text = "INICIALIZANDO..."
    progressText.Font = Enum.Font.GothamMedium
    progressText.TextSize = 14
    progressText.TextColor3 = Color3.fromRGB(200, 200, 255)
    progressText.BackgroundTransparency = 1
    progressText.Position = UDim2.new(0.5, 0, 0.72, 0)
    progressText.AnchorPoint = Vector2.new(0.5, 0.5)
    progressText.Size = UDim2.new(0, 300, 0, 30)
    progressText.ZIndex = 1002
    progressText.Parent = loadingFrame
    
    -- Animação da barra de progresso
    local duration = 3
    local startTime = tick()
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        -- Animação suave da barra
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(progress, 0, 1, 0)})
        tween:Play()
        
        -- Texto dinâmico
        local percent = math.floor(progress * 100)
        if percent < 30 then
            progressText.Text = "SCANNING FOR BRAINROTS..."
        elseif percent < 60 then
            progressText.Text = "LOADING INTERFACE..."
        elseif percent < 90 then
            progressText.Text = "FINALIZING..."
        else
            progressText.Text = "READY!"
        end
        
        progressText.Text = progressText.Text .. string.format(" %d%%", percent)
        
        -- Efeito de pulso no logo
        local pulse = math.sin(tick() * 6) * 0.1 + 0.9
        logo.TextColor3 = Color3.fromRGB(
            math.floor(0 * pulse),
            math.floor(170 * pulse),
            math.floor(255 * pulse)
        )
        
        -- Rotação do gradiente
        gradient.Rotation = gradient.Rotation + 0.5
        
        if progress >= 1 then
            connection:Disconnect()
            
            -- Animação de saída
            local fadeOut = TweenService:Create(loadingFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            
            for _, child in ipairs(loadingFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1,
                        TextTransparency = 1
                    }):Play()
                end
            end
            
            fadeOut:Play()
            fadeOut.Completed:Wait()
            loadingFrame:Destroy()
        end
    end)
    
    return loadingFrame
end

-- Sistema avançado de detecção de Brainrots
local function findBrainrots()
    local foundBrainrots = {}
    
    -- Função de busca recursiva
    local function deepSearch(parent, path)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name:lower():find("brainrot") then
                table.insert(foundBrainrots, {
                    Object = child,
                    Path = path .. "." .. child.Name,
                    Type = child.ClassName
                })
            end
            
            -- Buscar em sub-objetos
            if #child:GetChildren() > 0 then
                deepSearch(child, path .. "." .. child.Name)
            end
        end
    end
    
    -- Lugares para buscar
    local searchLocations = {
        game.Workspace,
        game.ReplicatedStorage,
        game.ServerStorage,
        game.Lighting,
        game:GetService("Players")
    }
    
    for _, location in ipairs(searchLocations) do
        -- Primeiro, buscar por pasta/modelo exato "Brainrots"
        local exactMatch = location:FindFirstChild("Brainrots")
        if exactMatch then
            table.insert(foundBrainrots, {
                Object = exactMatch,
                Path = location.Name .. ".Brainrots",
                Type = exactMatch.ClassName
            })
            deepSearch(exactMatch, location.Name .. ".Brainrots")
        end
        
        -- Busca profunda
        deepSearch(location, location.Name)
    end
    
    -- Filtrar duplicados e organizar
    local uniqueBrainrots = {}
    local seen = {}
    
    for _, brainrot in ipairs(foundBrainrots) do
        local id = brainrot.Object:GetFullName()
        if not seen[id] then
            seen[id] = true
            table.insert(uniqueBrainrots, brainrot)
        end
    end
    
    -- Ordenar por nome
    table.sort(uniqueBrainrots, function(a, b)
        return a.Object.Name:lower() < b.Object.Name:lower()
    end)
    
    return uniqueBrainrots
end

-- Sistema de teleport avançado
local function advancedTeleport(target, teleportMode)
    local char = PLAYER.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    -- Determinar posição do alvo
    local targetPosition
    local targetCFrame
    
    if target:IsA("Model") then
        local primaryPart = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
        if primaryPart then
            targetPosition = primaryPart.Position
            targetCFrame = primaryPart.CFrame
        else
            return false
        end
    elseif target:IsA("BasePart") then
        targetPosition = target.Position
        targetCFrame = target.CFrame
    else
        return false
    end
    
    -- Modos de teleport
    if teleportMode == "TO_TARGET" then
        -- Teleportar jogador para o alvo
        local safeOffset = Vector3.new(0, 5, 0)
        local lookVector = (targetPosition - hrp.Position).Unit
        
        -- Verificar se a posição é segura
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {char}
        
        local raycastResult = workspace:Raycast(targetPosition + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), raycastParams)
        
        if raycastResult then
            safeOffset = Vector3.new(0, 5, 0)
        end
        
        -- Aplicar teleport com efeito visual
        hrp.CFrame = CFrame.new(targetPosition + safeOffset) * CFrame.Angles(0, math.atan2(lookVector.X, lookVector.Z), 0)
        return true
        
    elseif teleportMode == "TO_PLAYER" then
        -- Trazer alvo para o jogador
        local playerPosition = hrp.Position
        local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
        
        if target:IsA("BasePart") then
            target.CFrame = CFrame.new(playerPosition + offset)
        elseif target:IsA("Model") then
            target:PivotTo(CFrame.new(playerPosition + offset))
        end
        return true
        
    elseif teleportMode == "SWAP" then
        -- Trocar posições
        local tempPosition = hrp.Position
        hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        
        if target:IsA("BasePart") then
            target.Position = tempPosition
        elseif target:IsA("Model") then
            local primaryPart = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                primaryPart.Position = tempPosition
            end
        end
        return true
    end
    
    return false
end

-- Sistema de drag para toda a GUI
local function makeDraggable(gui, dragPart)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Criar a GUI principal
local function createMainGUI()
    local brainrots = findBrainrots()
    
    if #brainrots == 0 then
        -- Tela de erro estilizada
        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 350, 0, 200)
        errorFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
        errorFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
        errorFrame.BorderSizePixel = 0
        errorFrame.ClipsDescendants = true
        errorFrame.Parent = SCREEN_GUI
        
        -- Tornar arrastável
        makeDraggable(errorFrame, errorFrame)
        
        -- Sombreamento
        local shadow = Instance.new("UIStroke")
        shadow.Color = Color3.fromRGB(0, 0, 0)
        shadow.Thickness = 2
        shadow.Transparency = 0.5
        shadow.Parent = errorFrame
        
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = errorFrame
        
        local titleText = Instance.new("TextLabel")
        titleText.Text = "⚠ NO BRAINROTS FOUND"
        titleText.Font = Enum.Font.GothamBlack
        titleText.TextSize = 18
        titleText.TextColor3 = Color3.fromRGB(255, 100, 100)
        titleText.BackgroundTransparency = 1
        titleText.Size = UDim2.new(1, -10, 1, 0)
        titleText.Position = UDim2.new(0, 10, 0, 0)
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.Parent = titleBar
        
        local message = Instance.new("TextLabel")
        message.Text = "No Brainrots objects found in the game.\n\nMake sure there are objects with 'brainrot' in their name."
        message.Font = Enum.Font.Gotham
        message.TextSize = 14
        message.TextColor3 = Color3.fromRGB(200, 200, 200)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 20, 0.3, 0)
        message.Size = UDim2.new(1, -40, 0.5, 0)
        message.TextWrapped = true
        message.Parent = errorFrame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Text = "CLOSE"
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        closeBtn.BorderSizePixel = 0
        closeBtn.Position = UDim2.new(0.3, 0, 0.8, 0)
        closeBtn.Size = UDim2.new(0.4, 0, 0, 35)
        closeBtn.Parent = errorFrame
        
        closeBtn.MouseButton1Click:Connect(function()
            errorFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true, function()
                errorFrame:Destroy()
            end)
        end)
        
        errorFrame.Size = UDim2.new(0, 0, 0, 0)
        errorFrame:TweenSize(UDim2.new(0, 350, 0, 200), "Out", "Quad", 0.5, true)
        
        return
    end
    
    -- GUI principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = SCREEN_GUI
    
    -- Sombreamento
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Transparency = 0.7
    shadow.Parent = mainFrame
    
    local innerShadow = Instance.new("Frame")
    innerShadow.Size = UDim2.new(1, 0, 1, 0)
    innerShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    innerShadow.BackgroundTransparency = 0.9
    innerShadow.BorderSizePixel = 0
    innerShadow.Parent = mainFrame
    
    -- Barra de título (para arrastar)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 10
    titleBar.Parent = mainFrame
    
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar
    
    -- Título
    local titleText = Instance.new("TextLabel")
    titleText.Text = "🔍 FINDER BRAINROTS v2.0"
    titleText.Font = Enum.Font.GothamBlack
    titleText.TextSize = 20
    titleText.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 11
    titleText.Parent = titleBar
    
    local subtitleText = Instance.new("TextLabel")
    subtitleText.Text = "by @branzz_br"
    subtitleText.Font = Enum.Font.Gotham
    subtitleText.TextSize = 12
    subtitleText.TextColor3 = Color3.fromRGB(150, 150, 200)
    subtitleText.BackgroundTransparency = 1
    subtitleText.Size = UDim2.new(0.3, 0, 1, 0)
    subtitleText.Position = UDim2.new(0.7, 0, 0, 0)
    subtitleText.TextXAlignment = Enum.TextXAlignment.Right
    subtitleText.Padding = {Right = UDim.new(0, 100)}
    subtitleText.ZIndex = 11
    subtitleText.Parent = titleBar
    
    -- Contador
    local countText = Instance.new("TextLabel")
    countText.Text = string.format("Found: %d", #brainrots)
    countText.Font = Enum.Font.GothamBold
    countText.TextSize = 12
    countText.TextColor3 = Color3.fromRGB(0, 255, 150)
    countText.BackgroundTransparency = 1
    countText.Size = UDim2.new(0, 100, 1, 0)
    countText.Position = UDim2.new(1, -115, 0, 0)
    countText.TextXAlignment = Enum.TextXAlignment.Right
    countText.ZIndex = 11
    countText.Parent = titleBar
    
    -- Botões de controle
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 50, 1, 0)
    closeBtn.Position = UDim2.new(1, -50, 0, 0)
    closeBtn.ZIndex = 11
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true, function()
            mainFrame:Destroy()
        end)
    end)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "–"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 20
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Size = UDim2.new(0, 50, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -100, 0, 0)
    minimizeBtn.ZIndex = 11
    minimizeBtn.Parent = titleBar
    
    -- Tornar toda a GUI arrastável
    makeDraggable(mainFrame, titleBar)
    
    -- Painel principal
    local mainContainer = Instance.new("Frame")
    mainContainer.Size = UDim2.new(1, -20, 1, -70)
    mainContainer.Position = UDim2.new(0, 10, 0, 60)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = mainFrame
    
    -- Lista de Brainrots com scroll
    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(1, 0, 0.7, 0)
    listContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    listContainer.BorderSizePixel = 0
    listContainer.ClipsDescendants = true
    listContainer.Parent = mainContainer
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 70)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = listContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    -- Painel de controle
    local controlPanel = Instance.new("Frame")
    controlPanel.Size = UDim2.new(1, 0, 0.28, 0)
    controlPanel.Position = UDim2.new(0, 0, 0.72, 0)
    controlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    controlPanel.BorderSizePixel = 0
    controlPanel.Parent = mainContainer
    
    -- Sistema de seleção
    local selectedBrainrot = nil
    
    local function createBrainrotItem(brainrot, index)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -10, 0, 50)
        item.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        item.BorderSizePixel = 0
        item.Parent = scrollFrame
        
        local highlight = Instance.new("Frame")
        highlight.Size = UDim2.new(0, 4, 1, 0)
        highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        highlight.BorderSizePixel = 0
        highlight.Visible = false
        highlight.Parent = item
        
        local selectBtn = Instance.new("TextButton")
        selectBtn.Text = ""
        selectBtn.BackgroundTransparency = 1
        selectBtn.Size = UDim2.new(1, 0, 1, 0)
        selectBtn.ZIndex = 2
        selectBtn.Parent = item
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = string.format("%d. %s", index, brainrot.Object.Name)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = item
        
        local pathLabel = Instance.new("TextLabel")
        pathLabel.Text = brainrot.Path
        pathLabel.Font = Enum.Font.Gotham
        pathLabel.TextSize = 11
        pathLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
        pathLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
        pathLabel.TextXAlignment = Enum.TextXAlignment.Left
        pathLabel.Parent = item
        
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Text = brainrot.Type
        typeLabel.Font = Enum.Font.Gotham
        typeLabel.TextSize = 11
        typeLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
        typeLabel.BackgroundTransparency = 1
        typeLabel.Size = UDim2.new(0.2, 0, 0.6, 0)
        typeLabel.Position = UDim2.new(0.75, 0, 0.1, 0)
        typeLabel.TextXAlignment = Enum.TextXAlignment.Right
        typeLabel.Parent = item
        
        selectBtn.MouseButton1Click:Connect(function()
            -- Desselecionar todos
            for _, child in ipairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") and child ~= item then
                    child.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                    child:FindFirstChild("Highlight").Visible = false
                end
            end
            
            -- Selecionar este
            selectedBrainrot = brainrot.Object
            item.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            highlight.Visible = true
            
            -- Efeito de clique
            selectBtn.BackgroundTransparency = 0.9
            selectBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            wait(0.1)
            selectBtn.BackgroundTransparency = 1
        end)
        
        return item
    end
    
    -- Preencher lista
    for i, brainrot in ipairs(brainrots) do
        createBrainrotItem(brainrot, i)
    end
    
    -- Atualizar tamanho do canvas
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
    
    -- Modos de teleport
    local teleportMode = "TO_TARGET"
    
    local modeSelector = Instance.new("Frame")
    modeSelector.Size = UDim2.new(1, -20, 0, 40)
    modeSelector.Position = UDim2.new(0, 10, 0.1, 0)
    modeSelector.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    modeSelector.BorderSizePixel = 0
    modeSelector.Parent = controlPanel
    
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Text = "TELEPORT MODE:"
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextSize = 12
    modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Size = UDim2.new(0.3, 0, 1, 0)
    modeLabel.Position = UDim2.new(0, 10, 0, 0)
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = modeSelector
    
    local modeText = Instance.new("TextLabel")
    modeText.Text = "TO TARGET"
    modeText.Font = Enum.Font.GothamBold
    modeText.TextSize = 12
    modeText.TextColor3 = Color3.fromRGB(0, 170, 255)
    modeText.BackgroundTransparency = 1
    modeText.Size = UDim2.new(0.7, 0, 1, 0)
    modeText.Position = UDim2.new(0.3, 0, 0, 0)
    modeText.TextXAlignment = Enum.TextXAlignment.Right
    modeText.Padding = {Right = UDim.new(0, 10)}
    modeText.Parent = modeSelector
    
    modeSelector.MouseButton1Click:Connect(function()
        if teleportMode == "TO_TARGET" then
            teleportMode = "TO_PLAYER"
            modeText.Text = "TO PLAYER"
            modeText.TextColor3 = Color3.fromRGB(255, 150, 0)
        elseif teleportMode == "TO_PLAYER" then
            teleportMode = "SWAP"
            modeText.Text = "SWAP"
            modeText.TextColor3 = Color3.fromRGB(150, 255, 0)
        else
            teleportMode = "TO_TARGET"
            modeText.Text = "TO TARGET"
            modeText.TextColor3 = Color3.fromRGB(0, 170, 255)
        end
    end)
    
    -- Botões de ação
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 0, 100)
    buttonContainer.Position = UDim2.new(0, 10, 0.5, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = controlPanel
    
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Text = "🔍 FIND BRAINROT"
    teleportBtn.Font = Enum.Font.GothamBlack
    teleportBtn.TextSize = 16
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    teleportBtn.BorderSizePixel = 0
    teleportBtn.Size = UDim2.new(0.48, 0, 0, 45)
    teleportBtn.Position = UDim2.new(0, 0, 0, 0)
    teleportBtn.Parent = buttonContainer
    
    local grabAllBtn = Instance.new("TextButton")
    grabAllBtn.Text = "🌀 GRAB ALL"
    grabAllBtn.Font = Enum.Font.GothamBlack
    grabAllBtn.TextSize = 16
    grabAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    grabAllBtn.BorderSizePixel = 0
    grabAllBtn.Size = UDim2.new(0.48, 0, 0, 45)
    grabAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
    grabAllBtn.Parent = buttonContainer
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 14
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Size = UDim2.new(1, 0, 0, 30)
    refreshBtn.Position = UDim2.new(0, 0, 0.55, 0)
    refreshBtn.Parent = buttonContainer
    
    -- Função do botão de teleport
    teleportBtn.MouseButton1Click:Connect(function()
        if selectedBrainrot then
            local success = advancedTeleport(selectedBrainrot, teleportMode)
            
            if success then
                -- Efeito visual
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                teleportBtn.Text = "✓ SUCCESS!"
                wait(0.5)
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                teleportBtn.Text = "🔍 FIND BRAINROT"
            else
                teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                teleportBtn.Text = "✗ FAILED!"
                wait(0.5)
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                teleportBtn.Text = "🔍 FIND BRAINROT"
            end
        else
            teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            teleportBtn.Text = "SELECT FIRST!"
            wait(0.5)
            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            teleportBtn.Text = "🔍 FIND BRAINROT"
        end
    end)
    
    -- Função do botão Grab All
    grabAllBtn.MouseButton1Click:Connect(function()
        local char = PLAYER.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        grabAllBtn.Text = "WORKING..."
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        local successful = 0
        local failed = 0
        
        for _, brainrot in ipairs(brainrots) do
            local success = advancedTeleport(brainrot.Object, "TO_PLAYER")
            
            if success then
                successful = successful + 1
            else
                failed = failed + 1
            end
            
            wait(0.05) -- Pequeno delay para evitar crash
        end
        
        grabAllBtn.Text = string.format("DONE! (%d✓ %d✗)", successful, failed)
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        wait(1)
        grabAllBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        grabAllBtn.Text = "🌀 GRAB ALL"
    end)
    
    -- Função do botão Refresh
    refreshBtn.MouseButton1Click:Connect(function()
        refreshBtn.Text = "SCANNING..."
        refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        
        -- Limpar lista atual
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Buscar novamente
        brainrots = findBrainrots()
        
        -- Atualizar contador
        countText.Text = string.format("Found: %d", #brainrots)
        
        -- Recriar itens
        for i, brainrot in ipairs(brainrots) do
            createBrainrotItem(brainrot, i)
        end
        
        selectedBrainrot = nil
        
        refreshBtn.Text = "✓ REFRESHED!"
        wait(0.5)
        refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        refreshBtn.Text = "🔄 REFRESH"
    end)
    
    -- Minimizar/Maximizar
    local isMinimized = false
    local originalSize = mainFrame.Size
    local originalPosition = mainFrame.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            -- Minimizar
            mainFrame:TweenSize(UDim2.new(0, 500, 0, 50), "Out", "Quad", 0.3, true)
            mainContainer.Visible = false
            isMinimized = true
            minimizeBtn.Text = "+"
        else
            -- Maximizar
            mainFrame:TweenSize(originalSize, "Out", "Quad", 0.3, true)
            mainContainer.Visible = true
            isMinimized = false
            minimizeBtn.Text = "–"
        end
    end)
    
    -- Animação de entrada
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame:TweenSize(UDim2.new(0, 500, 0, 550), "Out", "Back", 0.8, true)
    
    -- Efeito de hover nos botões
    local function setupButtonHover(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = hoverColor
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = normalColor
        end)
    end
    
    setupButtonHover(teleportBtn, Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 150, 255))
    setupButtonHover(grabAllBtn, Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 130, 0))
    setupButtonHover(refreshBtn, Color3.fromRGB(50, 50, 70), Color3.fromRGB(60, 60, 90))
    setupButtonHover(closeBtn, Color3.fromRGB(0, 0, 0, 0), Color3.fromRGB(255, 100, 100, 0.3))
    setupButtonHover(minimizeBtn, Color3.fromRGB(0, 0, 0, 0), Color3.fromRGB(200, 200, 200, 0.3))
end

-- Executar
createLoadingScreen()
wait(3.2) -- Esperar tempo da animação
createMainGUI()