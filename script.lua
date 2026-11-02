--==================================================
-- SLCHEATS BLACK EDITION
-- LocalScript | StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- CONFIGURATION
--==================================================

local C = {
    Aim = false,
    SilentAim = false,

    ESP = false,
    Names = true,
    Distance = true,
    Boxes = false,
    Tracers = false,
    HealthBar = false,
    WeaponIcon = false,

    TeamCheck = false,
    IgnoreDead = true,

    FOVEnabled = true,
    FOV = 150,
    Part = "Head",

    ESPColor = Color3.fromRGB(210,210,210),
    BoxColor = Color3.fromRGB(210,210,210),
    TracerColor = Color3.fromRGB(210,210,210),
    FOVColor = Color3.fromRGB(210,210,210),

    ReopenKey = Enum.KeyCode.RightShift,
    Closed = false
}

local CategoryIcons = {
    Home = "rbxassetid://117309635334531",
    Combat = "rbxassetid://139187624829619",
    Visuals = "rbxassetid://116902996831996",
    Settings = "rbxassetid://118208900986904"
}

local DISCORD_INVITE = "https://discord.gg/q73MDjNx9F"
local DISCORD_LOGO = "rbxassetid://108243268178034"

--==================================================
-- GUI HELPERS
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "SLcheats"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function new(class, props, parent)
    local obj = Instance.new(class)

    for k,v in pairs(props) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function animate(obj, props, duration)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.3,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )

    tween:Play()
    return tween
end

--==================================================
-- MAIN PANEL
--==================================================

local main = new("Frame", {
    Size = UDim2.fromOffset(1000,620),
    Position = UDim2.new(0.5,-500,0.5,-310),
    BackgroundColor3 = Color3.fromRGB(8,8,8),
    BorderSizePixel = 0,
    Visible = false
}, gui)

corner(main,14)

new("UIStroke", {
    Color = Color3.fromRGB(75,75,75),
    Thickness = 2.5
}, main)

local function openPanel()
    main.Visible = true
    main.Size = UDim2.fromOffset(760,470)
    main.BackgroundTransparency = 0.12

    animate(main, {
        Size = UDim2.fromOffset(1000,620),
        BackgroundTransparency = 0
    }, 0.48)
end

local function closePanel()
    local tween = animate(main, {
        Size = UDim2.fromOffset(0,0)
    }, 0.2)

    tween.Completed:Connect(function()
        main.Visible = false
    end)
end

--==================================================
-- LOGIN + LOVABLE
--==================================================

local HttpService = game:GetService("HttpService")

local LOVABLE_URL = "https://project--2275e028-7a04-4c84-9a60-d57b41930768.lovable.app/api/public/verify"

local authenticated = false
local checkingLogin = false
local keyPaused = false
local remainingSeconds = 0
local lastSync = os.clock()
local keyLocked = false

-- Forward declarations used by callbacks defined before their UI objects.
local startKeyMonitor
local timerBadge
local icon
local running = true

local function httpRequest(options)
    local req = request or http_request

    if not req and syn then
        req = syn.request
    end

    if not req then
        error("Seu executor não oferece suporte a requisições HTTP.")
    end

    return req(options)
end

local function verifyKey(username, password)
    local response = httpRequest({
        Url = LOVABLE_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            username = username,
            password = password
        })
    })

    if not response or not response.Body then
        error("Resposta inválida do servidor.")
    end

    return HttpService:JSONDecode(response.Body)
end

local loginFrame = new("Frame", {
    Size = UDim2.fromOffset(390,330),
    Position = UDim2.new(0.5,-195,0.5,-165),
    BackgroundColor3 = Color3.fromRGB(10,10,10),
    BorderSizePixel = 0,
    ZIndex = 20
}, gui)

corner(loginFrame,14)

new("UIStroke", {
    Color = Color3.fromRGB(75,75,75),
    Thickness = 2
}, loginFrame)

new("TextLabel", {
    Size = UDim2.new(1,-30,0,42),
    Position = UDim2.fromOffset(15,20),
    BackgroundTransparency = 1,
    Text = "SLcheats | BLACK EDITION",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 20,
    Font = Enum.Font.GothamBlack,
    ZIndex = 21
}, loginFrame)

new("TextLabel", {
    Size = UDim2.new(1,-30,0,24),
    Position = UDim2.fromOffset(15,62),
    BackgroundTransparency = 1,
    Text = "Faça login para acessar o painel",
    TextColor3 = Color3.fromRGB(155,155,155),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ZIndex = 21
}, loginFrame)

local userBox = new("TextBox", {
    Size = UDim2.new(1,-48,0,44),
    Position = UDim2.fromOffset(24,108),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BorderSizePixel = 0,
    PlaceholderText = "USUARIO",
    Text = "",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    ZIndex = 21
}, loginFrame)

corner(userBox,8)

new("UIPadding", {
    PaddingLeft = UDim.new(0,12)
}, userBox)

local passBox = new("TextBox", {
    Size = UDim2.new(1,-48,0,44),
    Position = UDim2.fromOffset(24,164),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BorderSizePixel = 0,
    PlaceholderText = "SENHA",
    Text = "",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 14,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    ZIndex = 21
}, loginFrame)

corner(passBox,8)

new("UIPadding", {
    PaddingLeft = UDim.new(0,12)
}, passBox)

local loginButton = new("TextButton", {
    Size = UDim2.new(1,-48,0,44),
    Position = UDim2.fromOffset(24,222),
    BackgroundColor3 = Color3.fromRGB(55,55,55),
    BorderSizePixel = 0,
    Text = "ENTRAR",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    ZIndex = 21
}, loginFrame)

corner(loginButton,8)

local loginStatus = new("TextLabel", {
    Size = UDim2.new(1,-30,0,25),
    Position = UDim2.fromOffset(15,275),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(255,90,90),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ZIndex = 21
}, loginFrame)

local function tryLogin()
    if authenticated or checkingLogin then return end

    if userBox.Text == "" or passBox.Text == "" then
        loginStatus.Text = "Preencha usuario e senha."
        return
    end

    checkingLogin = true
    loginButton.Text = "VERIFICANDO..."
    loginStatus.Text = ""

    task.spawn(function()
        local success, result = pcall(function()
            return verifyKey(userBox.Text, passBox.Text)
        end)

        checkingLogin = false
        loginButton.Text = "ENTRAR"

        if not success then
            loginStatus.Text = "Erro ao conectar ao servidor."
            warn("Lovable:", result)
            return
        end

        if type(result) ~= "table" then
            loginStatus.Text = "Resposta inválida do servidor."
            return
        end

        if result.valid ~= true then
            local reason = tostring(result.reason or "invalid")

            if reason == "expired" then
                loginStatus.Text = "Key expirada."
            elseif reason == "blocked" or reason == "disabled" then
                loginStatus.Text = "Key bloqueada."
            elseif reason == "deleted" then
                loginStatus.Text = "Key excluida."
            else
                loginStatus.Text = "Usuario ou senha incorretos."
            end

            passBox.Text = ""
            return
        end

        authenticated = true
        keyPaused = result.paused == true

        if tonumber(result.remainingSeconds) then
            remainingSeconds = math.max(0, tonumber(result.remainingSeconds))
        end

        lastSync = os.clock()

        loginStatus.TextColor3 = Color3.fromRGB(120,220,140)
        loginStatus.Text = "Login autorizado!"

        task.wait(0.25)

        loginFrame:Destroy()
        openPanel()

        startKeyMonitor()
    end)
end

loginButton.MouseButton1Click:Connect(tryLogin)

passBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tryLogin()
    end
end)

--==================================================
-- HEADER
--==================================================

local header = new("Frame", {
    Size = UDim2.new(1,0,0,88),
    BackgroundColor3 = Color3.fromRGB(14,14,14),
    BorderSizePixel = 0
}, main)

corner(header,14)

new("ImageLabel", {
    Size = UDim2.fromOffset(330,86),
    Position = UDim2.fromOffset(8,-2),
    BackgroundTransparency = 1,
    Image = "rbxassetid://97076199926291",
    ScaleType = Enum.ScaleType.Fit
}, header)

local minimize = new("TextButton", {
    Size = UDim2.fromOffset(42,38),
    Position = UDim2.new(1,-104,0,15),
    BackgroundColor3 = Color3.fromRGB(35,35,35),
    Text = "-",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 22
}, header)

corner(minimize,8)

local closeButton = new("TextButton", {
    Size = UDim2.fromOffset(42,38),
    Position = UDim2.new(1,-55,0,15),
    BackgroundColor3 = Color3.fromRGB(35,35,35),
    Text = "X",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 16,
    Font = Enum.Font.GothamBold
}, header)

corner(closeButton,8)

--==================================================
-- PROFILE
--==================================================

local avatar = new("ImageLabel", {
    Size = UDim2.fromOffset(112,112),
    Position = UDim2.fromOffset(28,88),
    BackgroundColor3 = Color3.fromRGB(28,28,28),
    BorderSizePixel = 0
}, main)

corner(avatar,50)

new("UIStroke", {
    Color = Color3.fromRGB(75,75,75),
    Thickness = 3
}, avatar)

task.spawn(function()
    local ok,image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    if ok then
        avatar.Image = image
    end
end)

new("TextLabel", {
    Position = UDim2.fromOffset(155,112),
    Size = UDim2.fromOffset(230,30),
    BackgroundTransparency = 1,
    Text = player.DisplayName,
    TextColor3 = Color3.new(1,1,1),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

new("TextLabel", {
    Position = UDim2.fromOffset(155,145),
    Size = UDim2.fromOffset(230,24),
    BackgroundTransparency = 1,
    Text = "@"..player.Name,
    TextColor3 = Color3.fromRGB(145,140,160),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

new("Frame", {
    Size = UDim2.new(0,2,1,-92),
    Position = UDim2.fromOffset(280,78),
    BackgroundColor3 = Color3.fromRGB(48,48,48),
    BorderSizePixel = 0
}, main)

new("TextLabel", {
    Size = UDim2.new(0,250,0,66),
    Position = UDim2.new(0,20,1,-90),
    BackgroundTransparency = 1,
    Text = "SLcheats\nBLACK EDITION",
    TextColor3 = Color3.fromRGB(220,220,220),
    TextSize = 20,
    Font = Enum.Font.GothamBlack
}, main)

--==================================================
-- SIDEBAR / PAGES
--==================================================

local sidebar = new("Frame", {
    Position = UDim2.fromOffset(18,225),
    Size = UDim2.new(0,255,1,-245),
    BackgroundColor3 = Color3.fromRGB(15,15,15),
    BorderSizePixel = 0
}, main)

corner(sidebar,10)

local content = new("Frame", {
    Position = UDim2.fromOffset(295,86),
    Size = UDim2.new(1,-315,1,-106),
    BackgroundTransparency = 1
}, main)

local pages = {}

local function makePage(name)
    local page = new("ScrollingFrame", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0,0,0,0),
        Visible = false
    }, content)

    local layout = new("UIListLayout", {
        Padding = UDim.new(0,9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y+10
        )
    end)

    pages[name] = page
    return page
end

local home = makePage("Home")
local combat = makePage("Combat")
local visuals = makePage("Visuals")
local settings = makePage("Settings")

local function showPage(name)
    for n,p in pairs(pages) do
        p.Visible = n == name
    end

    if timerBadge then
        timerBadge.Visible = name == "Home" and authenticated and not keyLocked
    end
end

--==================================================
-- CATEGORY BUTTONS
--==================================================

local categories = {
    {"Home","Home"},
    {"Combat","Combat"},
    {"Visuals","Visuals"},
    {"Settings","Settings"}
}

local categoryButtons = {}

for i,item in ipairs(categories) do
    local b = new("TextButton", {
        Size = UDim2.new(1,-16,0,48),
        Position = UDim2.fromOffset(8,8+(i-1)*56),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    }, sidebar)

    corner(b,10)

    new("UIStroke", {
        Color = Color3.fromRGB(60,60,60),
        Thickness = 1,
        Transparency = 0.35
    }, b)

    new("ImageLabel", {
        Size = UDim2.fromOffset(27,27),
        Position = UDim2.fromOffset(14,10),
        BackgroundTransparency = 1,
        Image = CategoryIcons[item[1]],
        ScaleType = Enum.ScaleType.Fit
    }, b)

    new("TextLabel", {
        Size = UDim2.new(1,-58,1,0),
        Position = UDim2.fromOffset(53,0),
        BackgroundTransparency = 1,
        Text = item[1],
        TextColor3 = Color3.fromRGB(245,245,245),
        TextSize = 15,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, b)

    categoryButtons[item[1]] = b

    b.MouseEnter:Connect(function()
        if pages[item[2]].Visible then return end

        animate(b, {
            BackgroundColor3 = Color3.fromRGB(38,38,38)
        }, 0.16)
    end)

    b.MouseLeave:Connect(function()
        if pages[item[2]].Visible then return end

        animate(b, {
            BackgroundColor3 = Color3.fromRGB(25,25,25)
        }, 0.16)
    end)

    b.MouseButton1Click:Connect(function()
        showPage(item[2])

        for _,other in pairs(categoryButtons) do
            animate(other, {
                BackgroundColor3 = other == b
                    and Color3.fromRGB(48,48,48)
                    or Color3.fromRGB(25,25,25)
            }, 0.18)
        end
    end)
end

--==================================================
-- CONTROLS
--==================================================

local function label(page, text)
    return new("TextLabel", {
        Size = UDim2.new(1,-8,0,36),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)
end

local function button(page, text, callback)
    local b = new("TextButton", {
        Size = UDim2.new(1,-8,0,43),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 15,
        Font = Enum.Font.GothamMedium
    }, page)

    corner(b,10)

    new("UIStroke", {
        Color = Color3.fromRGB(60,60,60),
        Thickness = 1,
        Transparency = 0.35
    }, b)

    b.MouseButton1Click:Connect(function()
        callback(b)
    end)

    return b
end

local function toggle(page, name, key)
    local b = button(page, name, function() end)

    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "   "..name

    local track = new("Frame", {
        Size = UDim2.fromOffset(48,25),
        Position = UDim2.new(1,-62,0.5,-12),
        BackgroundColor3 = C[key]
            and Color3.fromRGB(180,180,180)
            or Color3.fromRGB(48,48,48),
        BorderSizePixel = 0
    }, b)

    corner(track,20)

    local knob = new("Frame", {
        Size = UDim2.fromOffset(19,19),
        Position = C[key]
            and UDim2.new(1,-22,0.5,-9)
            or UDim2.fromOffset(3,3),
        BackgroundColor3 = Color3.fromRGB(250,245,255),
        BorderSizePixel = 0
    }, track)

    corner(knob,20)

    b.MouseButton1Click:Connect(function()
        C[key] = not C[key]

        animate(track, {
            BackgroundColor3 = C[key]
                and Color3.fromRGB(180,180,180)
                or Color3.fromRGB(48,48,48)
        }, 0.18)

        animate(knob, {
            Position = C[key]
                and UDim2.new(1,-22,0.5,-9)
                or UDim2.fromOffset(3,3)
        }, 0.18)
    end)

    return b
end

--==================================================
-- HOME
--==================================================

label(home,"Welcome to SLcheats")
label(home,"BLACK EDITION")
label(home," "..player.DisplayName)
label(home," Training interface")

--==================================================
-- KEY TIMER
--==================================================

timerBadge = new("Frame", {
    Size = UDim2.fromOffset(165,34),
    Position = UDim2.new(1,-175,0,92),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 5
}, main)

corner(timerBadge,8)

local timerText = new("TextLabel", {
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    Text = "TEMPO: VERIFICANDO",
    TextColor3 = Color3.fromRGB(220,220,220),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    ZIndex = 6
}, timerBadge)

local function formatTime(seconds)
    seconds = math.max(0, math.floor(seconds))

    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    if days > 0 then
        return string.format("%dd %02d:%02d:%02d",days,hours,minutes,secs)
    end

    return string.format("%02d:%02d:%02d",hours,minutes,secs)
end

--===DISCORD BUTTON===================================-

local discordButton = new("TextButton", {
    Size = UDim2.new(1,-8,0,48),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false
}, home)

corner(discordButton,10)

new("ImageLabel", {
    Size = UDim2.fromOffset(27,27),
    Position = UDim2.fromOffset(13,10),
    BackgroundTransparency = 1,
    Image = DISCORD_LOGO,
    ScaleType = Enum.ScaleType.Fit
}, discordButton)

new("TextLabel", {
    Size = UDim2.new(1,-55,1,0),
    Position = UDim2.fromOffset(52,0),
    BackgroundTransparency = 1,
    Text = "Join our Discord Server",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, discordButton)

discordButton.MouseButton1Click:Connect(function()
    pcall(function()
        GuiService:OpenBrowserWindow(DISCORD_INVITE)
    end)
end)

--==================================================
-- COMBAT
--==================================================

label(combat,"COMBAT SETTINGS")

toggle(combat,"Training Aim Assist","Aim")
toggle(combat,"Silent Aim Integration","SilentAim")
toggle(combat,"Team Check","TeamCheck")
toggle(combat,"Ignore Dead Players","IgnoreDead")

local parts = {
    "Head",
    "UpperTorso",
    "Torso",
    "HumanoidRootPart"
}

button(combat,"PART: HEAD",function(b)
    local index = table.find(parts,C.Part) or 1
    index = index % #parts + 1

    C.Part = parts[index]
    b.Text = "PART: "..C.Part
end)

local fovLabel = label(combat,"FOV: 150")

button(combat,"Increase FOV",function()
    C.FOV = math.min(C.FOV+20,500)
    fovLabel.Text = "FOV: "..C.FOV
end)

button(combat,"Decrease FOV",function()
    C.FOV = math.max(C.FOV-20,40)
    fovLabel.Text = "FOV: "..C.FOV
end)

--==================================================
-- DOWNED / DEAD DETECTION
--==================================================

local DOWNED_NAMES = {
    Downed = true,
    IsDowned = true,
    Knocked = true,
    KnockedOut = true,
    IsKnocked = true,
    Ragdoll = true,
    Ragdolled = true,
    IsRagdoll = true,
    Incapacitated = true,
    Unconscious = true,
    IsUnconscious = true,
    Disabled = true,
    Stunned = true,
    IsStunned = true,
    Dead = true,
    IsDead = true
}

local function isDowned(character, humanoid)
    if not character or not humanoid then
        return true
    end

    if humanoid.Health <= 0 then
        return true
    end

    local state = humanoid:GetState()

    local blockedStates = {
        Enum.HumanoidStateType.Dead,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding
    }

    for _,blockedState in ipairs(blockedStates) do
        if state == blockedState then
            return true
        end
    end

    if humanoid.PlatformStand then
        return true
    end

    for name in pairs(DOWNED_NAMES) do
        if character:GetAttribute(name) == true
            or humanoid:GetAttribute(name) == true then
            return true
        end
    end

    for _,object in ipairs(character:GetDescendants()) do
        if DOWNED_NAMES[object.Name] then
            if object:IsA("BoolValue") and object.Value then
                return true
            end

            if object:IsA("NumberValue") and object.Value > 0 then
                return true
            end

            if object:IsA("StringValue") then
                local value = string.lower(object.Value)

                if value == "downed"
                    or value == "knocked"
                    or value == "ragdoll"
                    or value == "dead"
                    or value == "unconscious" then
                    return true
                end
            end
        end
    end

    return false
end

--==================================================
-- TARGET VALIDATION
--==================================================

local function validTarget(target)
    if not target or target == player then
        return false
    end

    local character = target.Character

    if not character or not character.Parent then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return false
    end

    if C.IgnoreDead and isDowned(character,humanoid) then
        return false
    end

    if C.TeamCheck
        and player.Team ~= nil
        and target.Team == player.Team then
        return false
    end

    return true
end

--==================================================
-- VISUALS
--==================================================

label(visuals,"VISUAL SETTINGS")

toggle(visuals,"Player ESP","ESP")
toggle(visuals,"Player Names","Names")
toggle(visuals,"Distance","Distance")
toggle(visuals,"2D Box ESP","Boxes")
toggle(visuals,"Player Tracers","Tracers")
toggle(visuals,"Health Bar","HealthBar")
toggle(visuals,"Weapon Icon","WeaponIcon")
toggle(visuals,"Show FOV","FOVEnabled")

--==================================================
-- COLOR PALETTE
--==================================================

local palette = new("Frame", {
    Name = "ColorPalette",
    Size = UDim2.fromOffset(390,365),
    Position = UDim2.new(0.5,-195,0.5,-182),
    BackgroundColor3 = Color3.fromRGB(12,12,12),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50
}, gui)

corner(palette,14)

new("UIStroke", {
    Color = Color3.fromRGB(85,85,85),
    Thickness = 2
}, palette)

new("TextLabel", {
    Size = UDim2.new(1,-60,0,42),
    Position = UDim2.fromOffset(15,5),
    BackgroundTransparency = 1,
    Text = "SLcheats | COLOR PALETTE",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51
}, palette)

local paletteClose = new("TextButton", {
    Size = UDim2.fromOffset(32,32),
    Position = UDim2.new(1,-43,0,9),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    Text = "X",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 52
}, palette)

corner(paletteClose,7)

local selectedColorType = "ESPColor"

local colorTypes = {
    {"ESP","ESPColor"},
    {"BOX","BoxColor"},
    {"TRACER","TracerColor"},
    {"FOV","FOVColor"}
}

local selectedButtons = {}

local typeContainer = new("Frame", {
    Size = UDim2.new(1,-20,0,42),
    Position = UDim2.fromOffset(10,55),
    BackgroundTransparency = 1,
    ZIndex = 51
}, palette)

for i,item in ipairs(colorTypes) do
    local b = new("TextButton", {
        Size = UDim2.new(0.25,-5,1,0),
        Position = UDim2.new((i-1)*0.25,0,0,0),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        Text = item[1],
        TextColor3 = Color3.new(1,1,1),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 52
    }, typeContainer)

    corner(b,7)
    selectedButtons[item[2]] = b

    b.MouseButton1Click:Connect(function()
        selectedColorType = item[2]

        for _,entry in ipairs(colorTypes) do
            animate(selectedButtons[entry[2]], {
                BackgroundColor3 = entry[2] == selectedColorType
                    and Color3.fromRGB(85,85,85)
                    or Color3.fromRGB(35,35,35)
            }, 0.15)
        end
    end)
end

local colorGrid = new("Frame", {
    Size = UDim2.new(1,-24,0,200),
    Position = UDim2.fromOffset(12,110),
    BackgroundTransparency = 1,
    ZIndex = 51
}, palette)

local paletteColors = {
    Color3.fromRGB(255,255,255),
    Color3.fromRGB(220,220,220),
    Color3.fromRGB(130,130,130),
    Color3.fromRGB(50,50,50),

    Color3.fromRGB(255,0,0),
    Color3.fromRGB(255,70,100),
    Color3.fromRGB(180,0,50),
    Color3.fromRGB(255,130,130),

    Color3.fromRGB(255,150,0),
    Color3.fromRGB(255,220,0),
    Color3.fromRGB(170,120,0),
    Color3.fromRGB(255,240,150),

    Color3.fromRGB(0,255,100),
    Color3.fromRGB(0,200,160),
    Color3.fromRGB(0,255,255),
    Color3.fromRGB(0,130,180),

    Color3.fromRGB(0,100,255),
    Color3.fromRGB(80,80,255),
    Color3.fromRGB(130,0,255),
    Color3.fromRGB(200,0,255),

    Color3.fromRGB(255,0,200),
    Color3.fromRGB(255,100,180),
    Color3.fromRGB(130,70,100),
    Color3.fromRGB(100,255,200)
}

for i,color in ipairs(paletteColors) do
    local column = (i-1)%6
    local row = math.floor((i-1)/6)

    local swatch = new("TextButton", {
        Size = UDim2.fromOffset(49,39),
        Position = UDim2.fromOffset(column*57,row*47),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 52
    }, colorGrid)

    corner(swatch,7)

    new("UIStroke", {
        Color = Color3.fromRGB(100,100,100),
        Thickness = 1,
        Transparency = 0.3
    }, swatch)

    swatch.MouseButton1Click:Connect(function()
        C[selectedColorType] = color
        palette.Visible = false
    end)
end

button(visuals,"OPEN COLOR PALETTE",function()
    palette.Visible = not palette.Visible
end)

paletteClose.MouseButton1Click:Connect(function()
    palette.Visible = false
end)

--==================================================
-- SETTINGS
--==================================================

label(settings,"SETTINGS")

button(settings,"Change Reopen Key",function(b)
    b.Text = "Press a key..."

    local connection

    connection = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            C.ReopenKey = input.KeyCode
            b.Text = " "..input.KeyCode.Name
            connection:Disconnect()
        end
    end)
end)

button(settings,"Reset FOV",function()
    C.FOV = 150
    fovLabel.Text = "FOV: 150"
end)

label(settings,"VISUAL COLORS")

button(settings,"Open Color Palette",function()
    palette.Visible = true
end)

--==================================================
-- FOV CIRCLE
--==================================================

local circle = new("Frame", {
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    Size = UDim2.fromOffset(300,300),
    BackgroundTransparency = 1
}, gui)

corner(circle,500)

local circleStroke = new("UIStroke", {
    Color = C.FOVColor,
    Thickness = 2
}, circle)

--==================================================
-- ESP HIGHLIGHTS / LABELS
--==================================================

local highlights = {}
local labels = {}

local function updateESP()
    for _,target in ipairs(Players:GetPlayers()) do
        if validTarget(target) and C.ESP then
            if not highlights[target] then
                local h = Instance.new("Highlight")

                h.FillColor = C.ESPColor
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.65
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = target.Character

                highlights[target] = h
            end

            highlights[target].FillColor = C.ESPColor
        elseif highlights[target] then
            highlights[target]:Destroy()
            highlights[target] = nil
        end

        if validTarget(target) and (C.Names or C.Distance) then
            local head = target.Character:FindFirstChild("Head")

            if head then
                if not labels[target] then
                    local bb = Instance.new("BillboardGui")

                    bb.Size = UDim2.fromOffset(180,30)
                    bb.StudsOffset = Vector3.new(0,2.7,0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head

                    local text = Instance.new("TextLabel")

                    text.Name = "Info"
                    text.Size = UDim2.fromScale(1,1)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.new(1,1,1)
                    text.TextStrokeTransparency = 0
                    text.Font = Enum.Font.GothamBold
                    text.TextSize = 12
                    text.Parent = bb

                    labels[target] = bb
                end

                local root = target.Character:FindFirstChild("HumanoidRootPart")

                local myRoot = player.Character
                    and player.Character:FindFirstChild("HumanoidRootPart")

                local distance = 0

                if root and myRoot then
                    distance = math.floor(
                        (root.Position-myRoot.Position).Magnitude
                    )
                end

                local name = C.Names and target.DisplayName or ""
                local dist = C.Distance and (" ["..distance.." studs]") or ""

                labels[target].Info.Text = name..dist
            end
        elseif labels[target] then
            labels[target]:Destroy()
            labels[target] = nil
        end
    end
end

--==================================================
-- TARGET SELECTION
--==================================================

local function getTargetPart(character)
    local candidates = {
        Head = {"Head"},
        UpperTorso = {"UpperTorso","Torso"},
        Torso = {"Torso","UpperTorso"},
        HumanoidRootPart = {"HumanoidRootPart"}
    }

    for _,name in ipairs(candidates[C.Part] or {}) do
        local part = character:FindFirstChild(name)

        if part and part:IsA("BasePart") then
            return part
        end
    end
end

local function getClosestTarget()
    local closest
    local shortest = C.FOV
    local center = camera.ViewportSize/2

    for _,target in ipairs(Players:GetPlayers()) do
        if validTarget(target) then
            local part = getTargetPart(target.Character)

            if part then
                local pos,visible =
                    camera:WorldToViewportPoint(part.Position)

                if visible then
                    local distance = (
                        Vector2.new(pos.X,pos.Y)-center
                    ).Magnitude

                    if distance < shortest then
                        shortest = distance
                        closest = part
                    end
                end
            end
        end
    end

    return closest
end

--==================================================
-- VISUAL OVERLAY
--==================================================

local overlay = new("ScreenGui", {
    Name = "SLcheatsVisualOverlay",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 10
}, player.PlayerGui)

local visualObjects = {}

local function createVisual(target)
    local box = new("Frame", {
        Name = "Box",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false
    }, overlay)

    local stroke = new("UIStroke", {
        Color = C.BoxColor,
        Thickness = 1.5
    }, box)

    local tracer = new("Frame", {
        Name = "Tracer",
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = C.TracerColor,
        BorderSizePixel = 0,
        Visible = false
    }, overlay)

    corner(tracer,1)

    local healthBackground = new("Frame", {
        Name = "HealthBackground",
        BackgroundColor3 = Color3.fromRGB(20,20,20),
        BorderSizePixel = 0,
        Visible = false
    }, overlay)

    corner(healthBackground,3)

    local healthFill = new("Frame", {
        Name = "HealthFill",
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,0,1,0),
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.fromRGB(0,255,70),
        BorderSizePixel = 0
    }, healthBackground)

    corner(healthFill,3)

    local weaponImage = new("ImageLabel", {
        Name = "WeaponIcon",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(42,28),
        ScaleType = Enum.ScaleType.Fit,
        Visible = false
    }, overlay)

    visualObjects[target] = {
        Box = box,
        Stroke = stroke,
        Tracer = tracer,
        HealthBackground = healthBackground,
        HealthFill = healthFill,
        WeaponImage = weaponImage
    }
end

local function updateTracer(frame,fromPosition,toPosition)
    local difference = toPosition-fromPosition

    frame.Position = UDim2.fromOffset(
        (fromPosition.X+toPosition.X)/2,
        (fromPosition.Y+toPosition.Y)/2
    )

    frame.Size = UDim2.fromOffset(
        2,
        difference.Magnitude
    )

    frame.Rotation =
        math.deg(math.atan2(difference.Y,difference.X))-90
end

--==================================================
-- STABLE CHARACTER BOX PROJECTION
--==================================================

local function getCharacterBounds(character)
    if not character or not character.Parent then
        return nil
    end

    local success,cf,size = pcall(function()
        return character:GetBoundingBox()
    end)

    if not success or not cf or not size then
        return nil
    end

    local corners = {
        Vector3.new(-1,-1,-1),
        Vector3.new(-1,-1,1),
        Vector3.new(-1,1,-1),
        Vector3.new(-1,1,1),
        Vector3.new(1,-1,-1),
        Vector3.new(1,-1,1),
        Vector3.new(1,1,-1),
        Vector3.new(1,1,1)
    }

    local minX,minY = math.huge,math.huge
    local maxX,maxY = -math.huge,-math.huge

    local viewport = camera.ViewportSize

    for _,point in ipairs(corners) do
        local worldPosition = cf:PointToWorldSpace(
            Vector3.new(
                point.X*size.X/2,
                point.Y*size.Y/2,
                point.Z*size.Z/2
            )
        )

        local screenPosition =
            camera:WorldToViewportPoint(worldPosition)

        if screenPosition.Z <= 0 then
            return nil
        end

        minX = math.min(minX,screenPosition.X)
        minY = math.min(minY,screenPosition.Y)
        maxX = math.max(maxX,screenPosition.X)
        maxY = math.max(maxY,screenPosition.Y)
    end

    if minX == math.huge then
        return nil
    end

    if maxX < 0 or maxY < 0
        or minX > viewport.X or minY > viewport.Y then
        return nil
    end

    return minX,minY,maxX,maxY
end

--==================================================
-- HEALTH BAR
--==================================================

local function updateHealthBar(objects,character,minX,minY,maxY)
    if not C.HealthBar then
        objects.HealthBackground.Visible = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.MaxHealth <= 0 then
        objects.HealthBackground.Visible = false
        return
    end

    local healthPercent = math.clamp(
        humanoid.Health/humanoid.MaxHealth,
        0,
        1
    )

    local height = math.max(1,maxY-minY)

    objects.HealthBackground.Visible = true

    objects.HealthBackground.Position = UDim2.fromOffset(
        minX-7,
        minY
    )

    objects.HealthBackground.Size = UDim2.fromOffset(
        4,
        height
    )

    objects.HealthFill.Size = UDim2.new(
        1,
        0,
        healthPercent,
        0
    )

    objects.HealthFill.BackgroundColor3 =
        Color3.fromRGB(0,255,70)
end

--==================================================
-- WEAPON ICON
--==================================================

local function getEquippedTool(character)
    for _,item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end

    return nil
end

local function updateWeaponIcon(objects,character,minX,maxX,maxY)
    if not C.WeaponIcon then
        objects.WeaponImage.Visible = false
        return
    end

    local tool = getEquippedTool(character)

    if not tool then
        objects.WeaponImage.Visible = false
        return
    end

    local texture = tool.TextureId

    if texture and texture ~= "" then
        objects.WeaponImage.Image = texture
        objects.WeaponImage.Visible = true
    else
        objects.WeaponImage.Visible = false
    end

    objects.WeaponImage.Position = UDim2.fromOffset(
        ((minX+maxX)/2)-21,
        maxY+3
    )
end

--==================================================
-- UPDATE BOXES / TRACERS / HEALTH / WEAPON
--==================================================

local function destroyVisual(target)
    local objects = visualObjects[target]

    if not objects then return end

    objects.Box:Destroy()
    objects.Tracer:Destroy()
    objects.HealthBackground:Destroy()
    objects.WeaponImage:Destroy()

    visualObjects[target] = nil
end

local function updateVisuals()
    for _,target in ipairs(Players:GetPlayers()) do
        if target ~= player and validTarget(target) then
            if not visualObjects[target] then
                createVisual(target)
            end

            local objects = visualObjects[target]

            local minX,minY,maxX,maxY =
                getCharacterBounds(target.Character)

            local validBounds =
                minX ~= nil
                and maxX > minX
                and maxY > minY

            if validBounds then
                if C.Boxes then
                    objects.Box.Visible = true
                    objects.Box.Position = UDim2.fromOffset(minX,minY)

                    objects.Box.Size = UDim2.fromOffset(
                        maxX-minX,
                        maxY-minY
                    )

                    objects.Stroke.Color = C.BoxColor
                else
                    objects.Box.Visible = false
                end

                if C.Tracers then
                    local viewport = camera.ViewportSize

                    local startPosition = Vector2.new(
                        viewport.X/2,
                        0
                    )

                    local endPosition = Vector2.new(
                        (minX+maxX)/2,
                        minY
                    )

                    objects.Tracer.Visible = true
                    objects.Tracer.BackgroundColor3 = C.TracerColor

                    updateTracer(
                        objects.Tracer,
                        startPosition,
                        endPosition
                    )
                else
                    objects.Tracer.Visible = false
                end

                updateHealthBar(
                    objects,
                    target.Character,
                    minX,
                    minY,
                    maxY
                )

                updateWeaponIcon(
                    objects,
                    target.Character,
                    minX,
                    maxX,
                    maxY
                )
            else
                objects.Box.Visible = false
                objects.Tracer.Visible = false
                objects.HealthBackground.Visible = false
                objects.WeaponImage.Visible = false
            end
        elseif visualObjects[target] then
            destroyVisual(target)
        end
    end
end

--==================================================
-- UPDATE LOOP
--==================================================

local elapsed = 0

RunService.RenderStepped:Connect(function(dt)
    if not running then return end

    camera = workspace.CurrentCamera

    circle.Size = UDim2.fromOffset(C.FOV*2,C.FOV*2)
    circle.Visible = C.FOVEnabled
    circleStroke.Color = C.FOVColor

    elapsed += dt

    if elapsed >= 0.2 then
        elapsed = 0
        updateESP()
    end

    if C.Boxes or C.Tracers or C.HealthBar or C.WeaponIcon then
        updateVisuals()
    else
        for _,objects in pairs(visualObjects) do
            objects.Box.Visible = false
            objects.Tracer.Visible = false
            objects.HealthBackground.Visible = false
            objects.WeaponImage.Visible = false
        end
    end

    local target = getClosestTarget()

    if C.SilentAim and target then
        gui:SetAttribute("SilentAimEnabled",true)
        gui:SetAttribute("SilentAimPosition",target.Position)
    else
        gui:SetAttribute("SilentAimEnabled",false)
        gui:SetAttribute("SilentAimPosition",nil)
    end

    if C.Aim and target then
        camera.CFrame = CFrame.lookAt(
            camera.CFrame.Position,
            target.Position
        )
    end
end)

--==================================================
-- CLEANUP
--==================================================

local function cleanupTarget(target)
    if highlights[target] then
        highlights[target]:Destroy()
        highlights[target] = nil
    end

    if labels[target] then
        labels[target]:Destroy()
        labels[target] = nil
    end

    destroyVisual(target)
end

--==================================================
-- LOVABLE KEY MONITOR
--==================================================

local lockScreen = new("Frame", {
    Size = UDim2.fromScale(1,1),
    BackgroundColor3 = Color3.fromRGB(8,8,8),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 100
}, main)

corner(lockScreen,14)

local lockTitle = new("TextLabel", {
    Size = UDim2.new(1,-40,0,65),
    Position = UDim2.fromOffset(20,190),
    BackgroundTransparency = 1,
    Text = "SUA KEY FOI",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 27,
    Font = Enum.Font.GothamBlack,
    ZIndex = 101
}, lockScreen)

local lockReason = new("TextLabel", {
    Size = UDim2.new(1,-40,0,45),
    Position = UDim2.fromOffset(20,250),
    BackgroundTransparency = 1,
    Text = "BLOQUEADA",
    TextColor3 = Color3.fromRGB(220,220,220),
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    ZIndex = 101
}, lockScreen)

local lockInfo = new("TextLabel", {
    Size = UDim2.new(1,-80,0,55),
    Position = UDim2.fromOffset(40,310),
    BackgroundTransparency = 1,
    Text = "Para atualizar seu login entre em nosso Discord e abra ticket.",
    TextColor3 = Color3.fromRGB(155,155,155),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    ZIndex = 101
}, lockScreen)

local function lockKey(reason)
    if keyLocked then return end

    keyLocked = true
    authenticated = false
    keyPaused = true

    if timerBadge then timerBadge.Visible = false end

    if reason == "expired" then
        lockReason.Text = "EXPIRADA"
    elseif reason == "deleted" then
        lockReason.Text = "EXCLUÍDA"
    else
        lockReason.Text = "BLOQUEADA"
    end

    main.Visible = true
    if icon then icon.Visible = false end
    palette.Visible = false
    lockScreen.Visible = true

    warn("SLcheats: key bloqueada - "..reason)
end

local function syncKey()
    local result = verifyKey(userBox.Text, passBox.Text)

    if type(result) ~= "table" then
        error("Resposta inválida do servidor.")
    end

    if result.valid ~= true then
        lockKey(tostring(result.reason or "blocked"))
        return
    end

    keyPaused = result.paused == true

    local serverRemaining = tonumber(result.remainingSeconds)
    if serverRemaining then
        remainingSeconds = math.max(0, serverRemaining)
        lastSync = os.clock()
    end

    if keyPaused then
        timerText.Text = "KEY PAUSADA"
        return
    end

    -- Só expira com confirmação numérica do servidor; falha de rede
    -- ou resposta sem remainingSeconds não deve bloquear a key.
    if serverRemaining and remainingSeconds <= 0 then
        lockKey("expired")
        return
    end

    if not serverRemaining then
        timerText.Text = "TEMPO INDISPONÍVEL"
    end
end

startKeyMonitor = function()
    task.spawn(function()
        while authenticated and not keyLocked and running do
            local success, err = pcall(syncKey)

            if not success then
                warn("Falha ao sincronizar key:", err)
            end

            task.wait(5)
        end
    end)

    task.spawn(function()
        while authenticated and not keyLocked and running do
            if keyPaused then
                timerText.Text = "KEY PAUSADA"
            elseif remainingSeconds > 0 then
                local elapsedTime = os.clock() - lastSync
                local currentTime = math.max(0, remainingSeconds - elapsedTime)
                timerText.Text = "TEMPO: "..formatTime(currentTime)

                if currentTime <= 0 then
                    timerText.Text = "VERIFICANDO..."
                    local success, err = pcall(syncKey)
                    if not success then
                        warn("Falha ao verificar expiração da key:", err)
                    end
                end
            else
                timerText.Text = "TEMPO INDISPONÍVEL"
            end

            task.wait(1)
        end
    end)
end

Players.PlayerRemoving:Connect(cleanupTarget)

--==================================================
-- MINIMIZE / REOPEN
--==================================================

icon = new("TextButton", {
    Size = UDim2.fromOffset(40,40),
    Position = UDim2.new(0,10,0.5,0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Text = "SL",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    Visible = false
}, gui)

corner(icon,50)

minimize.MouseButton1Click:Connect(function()
    closePanel()

    task.delay(0.22,function()
        if not C.Closed then
            icon.Visible = true
        end
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    C.Closed = true
    running = false

    for _,target in ipairs(Players:GetPlayers()) do
        cleanupTarget(target)
    end

    overlay:Destroy()
    gui:Destroy()
end)

icon.MouseButton1Click:Connect(function()
    icon.Visible = false
    openPanel()
end)

UIS.InputBegan:Connect(function(input,processed)
    if C.Closed or processed or not authenticated then
        return
    end

    if input.KeyCode == C.ReopenKey then
        if main.Visible then
            closePanel()

            task.delay(0.22,function()
                if not C.Closed then
                    icon.Visible = true
                end
            end)
        else
            icon.Visible = false
            openPanel()
        end
    end
end)

--==================================================
-- START
--==================================================

showPage("Home")

for name,b in pairs(categoryButtons) do
    b.BackgroundColor3 = name == "Home"
        and Color3.fromRGB(48,48,48)
        or Color3.fromRGB(25,25,25)
end

print("SLcheats Black Edition carregado!")A
