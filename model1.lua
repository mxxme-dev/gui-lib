local library = {}


local notificationQueue = {}
local activeNotifications = {}

local function createNotification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local colors = {
        info = Color3.fromRGB(60, 130, 220),
        success = Color3.fromRGB(60, 170, 80),
        warning = Color3.fromRGB(220, 160, 60),
        error = Color3.fromRGB(220, 60, 60)
    }
    
    local notifColor = colors[notifType] or colors.info
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999
    
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not screenGui.Parent then
        screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 320, 0, 10 + (#activeNotifications * 90))
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = notifColor
    accent.BorderSizePixel = 0
    accent.Parent = notification
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8)
    accentCorner.Parent = accent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = false
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -20, 1, -40)
    messageLabel.Position = UDim2.new(0, 15, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.TextScaled = false
    messageLabel.Parent = notification
    
    table.insert(activeNotifications, notification)
    

    notification:TweenPosition(
        UDim2.new(1, -310, 0, 10 + ((#activeNotifications - 1) * 90)),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    

    task.delay(duration, function()
        notification:TweenPosition(
            UDim2.new(1, 320, 0, notification.Position.Y.Offset),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true,
            function()
                for i, notif in ipairs(activeNotifications) do
                    if notif == notification then
                        table.remove(activeNotifications, i)
                        break
                    end
                end
                

                for i, notif in ipairs(activeNotifications) do
                    notif:TweenPosition(
                        UDim2.new(1, -310, 0, 10 + ((i - 1) * 90)),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                end
                
                screenGui:Destroy()
            end
        )
    end)
end


local themes = {
    Dark = {
        background = Color3.fromRGB(20, 20, 20),
        secondary = Color3.fromRGB(25, 25, 25),
        tertiary = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(60, 170, 80),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 200, 200),
        border = Color3.fromRGB(15, 15, 15),
        hover = Color3.fromRGB(45, 45, 45),
        slider = Color3.fromRGB(50, 50, 50)
    },
    Blue = {
        background = Color3.fromRGB(15, 20, 35),
        secondary = Color3.fromRGB(20, 25, 40),
        tertiary = Color3.fromRGB(25, 30, 45),
        accent = Color3.fromRGB(60, 130, 220),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(180, 190, 210),
        border = Color3.fromRGB(10, 15, 25),
        hover = Color3.fromRGB(35, 45, 60),
        slider = Color3.fromRGB(40, 50, 70)
    },
    Purple = {
        background = Color3.fromRGB(25, 15, 35),
        secondary = Color3.fromRGB(30, 20, 40),
        tertiary = Color3.fromRGB(35, 25, 45),
        accent = Color3.fromRGB(150, 80, 200),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 180, 220),
        border = Color3.fromRGB(20, 10, 30),
        hover = Color3.fromRGB(50, 35, 65),
        slider = Color3.fromRGB(55, 40, 70)
    },
    Red = {
        background = Color3.fromRGB(30, 15, 15),
        secondary = Color3.fromRGB(35, 20, 20),
        tertiary = Color3.fromRGB(40, 25, 25),
        accent = Color3.fromRGB(220, 60, 60),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(220, 180, 180),
        border = Color3.fromRGB(25, 10, 10),
        hover = Color3.fromRGB(55, 35, 35),
        slider = Color3.fromRGB(60, 40, 40)
    }
}

local currentTheme = themes.Dark


local HttpService = game:GetService("HttpService")
local configFolder = nil
local configSaveName = "default"

local function initConfigFolder(id)
    local success, folder = pcall(function()
        if not isfolder("mxx-lib") then
            makefolder("mxx-lib")
        end
        if not isfolder("mxx-lib/" .. id) then
            makefolder("mxx-lib/" .. id)
        end
        return "mxx-lib/" .. id
    end)
    
    if success then
        configFolder = folder
        return true
    else
        warn("[MXX-LIB] Failed to create config folder. Config saving disabled.")
        return false
    end
end

local function saveConfig(windowobj, name)
    if not configFolder then return end
    
    local config = {}
    for tabName, tab in pairs(windowobj.configElements) do
        config[tabName] = {}
        for elementName, element in pairs(tab) do
            if element.type == "toggle" then
                config[tabName][elementName] = {type = "toggle", value = element.state}
            elseif element.type == "slider" then
                config[tabName][elementName] = {type = "slider", value = element.value}
            elseif element.type == "dropdown" then
                config[tabName][elementName] = {type = "dropdown", value = element.selected}
            end
        end
    end
    
    local success, err = pcall(function()
        writefile(configFolder .. "/" .. name .. ".json", HttpService:JSONEncode(config))
    end)
    
    if success then
        print("[MXX-LIB] Config saved: " .. name)
    else
        warn("[MXX-LIB] Failed to save config: " .. err)
    end
end

local function loadConfig(windowobj, name)
    if not configFolder then return end
    
    local success, config = pcall(function()
        if isfile(configFolder .. "/" .. name .. ".json") then
            return HttpService:JSONDecode(readfile(configFolder .. "/" .. name .. ".json"))
        end
        return nil
    end)
    
    if not success or not config then
        warn("[MXX-LIB] Failed to load config: " .. name)
        return
    end
    
    for tabName, elements in pairs(config) do
        if windowobj.configElements[tabName] then
            for elementName, data in pairs(elements) do
                local element = windowobj.configElements[tabName][elementName]
                if element then
                    if element.type == data.type then
                        if data.type == "toggle" and element.set then
                            element.set(data.value)
                        elseif data.type == "slider" and element.set then
                            element.set(data.value)
                        elseif data.type == "dropdown" and element.set then
                            element.set(data.value)
                        end
                    else
                        warn("[MXX-LIB] Type mismatch for " .. elementName .. " in config")
                    end
                end
            end
        end
    end
    
    print("[MXX-LIB] Config loaded: " .. name)
end

local function getConfigList()
    if not configFolder then return {} end
    
    local configs = {}
    local success, files = pcall(function()
        return listfiles(configFolder)
    end)
    
    if success then
        for _, file in ipairs(files) do
            local name = file:match("([^/]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end
    
    return configs
end

local function deleteConfig(name)
    if not configFolder then return end
    
    local success = pcall(function()
        if isfile(configFolder .. "/" .. name .. ".json") then
            delfile(configFolder .. "/" .. name .. ".json")
        end
    end)
    
    if success then
        print("[MXX-LIB] Config deleted: " .. name)
    else
        warn("[MXX-LIB] Failed to delete config: " .. name)
    end
end

function library:createwindow(title, configId)
    configId = configId or "default"
    initConfigFolder(configId)
    
    local screen = Instance.new("ScreenGui")
    screen.Name = title
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    
    local success, err = pcall(function()
        screen.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        screen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    screen.AncestryChanged:Connect(function(_, parent)
        if not parent then
            screen.Parent = game:GetService("CoreGui")
        end
    end)
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 500, 0, 400)
    main.Position = UDim2.new(0.5, -250, 0.5, -200)
    main.BackgroundColor3 = currentTheme.background
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = screen
    
    local scale = Instance.new("UIScale")
    scale.Parent = main
    
    local function updateScale()
        local viewport = workspace.CurrentCamera.ViewportSize
        local minDimension = math.min(viewport.X, viewport.Y)
        local baseSize = 800
        local scaleFactor = math.clamp(minDimension / baseSize, 0.6, 1.2)
        scale.Scale = scaleFactor
    end
    
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    local titlebar = Instance.new("Frame")
    titlebar.Name = "TitleBar"
    titlebar.Size = UDim2.new(1, 0, 0, 35)
    titlebar.BackgroundColor3 = currentTheme.border
    titlebar.BorderSizePixel = 0
    titlebar.Active = true
    titlebar.Parent = main
    
    local titlecorner = Instance.new("UICorner")
    titlecorner.CornerRadius = UDim.new(0, 8)
    titlecorner.Parent = titlebar
    
    local titletext = Instance.new("TextLabel")
    titletext.Name = "Title"
    titletext.Size = UDim2.new(1, -80, 1, 0)
    titletext.Position = UDim2.new(0, 10, 0, 0)
    titletext.BackgroundTransparency = 1
    titletext.Text = title
    titletext.TextColor3 = currentTheme.text
    titletext.TextSize = 16
    titletext.Font = Enum.Font.GothamBold
    titletext.TextXAlignment = Enum.TextXAlignment.Left
    titletext.TextScaled = false
    titletext.Parent = titlebar
    

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 25)
    minimizeButton.Position = UDim2.new(1, -35, 0.5, -12.5)
    minimizeButton.BackgroundColor3 = currentTheme.tertiary
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = currentTheme.text
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.AutoButtonColor = false
    minimizeButton.Parent = titlebar
    
    local minbuttoncorner = Instance.new("UICorner")
    minbuttoncorner.CornerRadius = UDim.new(0, 4)
    minbuttoncorner.Parent = minimizeButton
    

    local floatingButton = Instance.new("TextButton")
    floatingButton.Name = "FloatingButton"
    floatingButton.Size = UDim2.new(0, 50, 0, 50)
    floatingButton.Position = UDim2.new(0.5, -25, 0, 10)
    floatingButton.BackgroundColor3 = currentTheme.accent
    floatingButton.BorderSizePixel = 0
    floatingButton.Text = "+"
    floatingButton.TextColor3 = currentTheme.text
    floatingButton.TextSize = 24
    floatingButton.Font = Enum.Font.GothamBold
    floatingButton.AutoButtonColor = false
    floatingButton.Visible = false
    floatingButton.ZIndex = 100
    floatingButton.Parent = screen
    
    local floatcorner = Instance.new("UICorner")
    floatcorner.CornerRadius = UDim.new(1, 0)
    floatcorner.Parent = floatingButton
    

    local floatDragging = false
    local floatDragStart = nil
    local floatStartPos = nil
    local UserInputService = game:GetService("UserInputService")
    
    floatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = true
            floatDragStart = input.Position
            floatStartPos = floatingButton.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatDragStart
            floatingButton.Position = UDim2.new(
                floatStartPos.X.Scale,
                floatStartPos.X.Offset + delta.X,
                floatStartPos.Y.Scale,
                floatStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = false
        end
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        main.Visible = false
        floatingButton.Visible = true
    end)
    
    floatingButton.MouseButton1Click:Connect(function()
        main.Visible = true
        floatingButton.Visible = false
    end)
    

    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local tabcontainer = Instance.new("Frame")
    tabcontainer.Name = "TabContainer"
    tabcontainer.Size = UDim2.new(0, 120, 1, -40)
    tabcontainer.Position = UDim2.new(0, 5, 0, 37)
    tabcontainer.BackgroundColor3 = currentTheme.secondary
    tabcontainer.BorderSizePixel = 0
    tabcontainer.Parent = main
    
    local tabcorner = Instance.new("UICorner")
    tabcorner.CornerRadius = UDim.new(0, 6)
    tabcorner.Parent = tabcontainer
    
    local tablayout = Instance.new("UIListLayout")
    tablayout.SortOrder = Enum.SortOrder.LayoutOrder
    tablayout.Padding = UDim.new(0, 3)
    tablayout.Parent = tabcontainer
    
    local tabpadding = Instance.new("UIPadding")
    tabpadding.PaddingTop = UDim.new(0, 5)
    tabpadding.PaddingLeft = UDim.new(0, 5)
    tabpadding.PaddingRight = UDim.new(0, 5)
    tabpadding.Parent = tabcontainer
    
    local contentcontainer = Instance.new("Frame")
    contentcontainer.Name = "ContentContainer"
    contentcontainer.Size = UDim2.new(1, -135, 1, -40)
    contentcontainer.Position = UDim2.new(0, 130, 0, 37)
    contentcontainer.BackgroundColor3 = currentTheme.secondary
    contentcontainer.BorderSizePixel = 0
    contentcontainer.Parent = main
    
    local contentcorner = Instance.new("UICorner")
    contentcorner.CornerRadius = UDim.new(0, 6)
    contentcorner.Parent = contentcontainer
    
    local windowobj = {
        main = main,
        tabcontainer = tabcontainer,
        contentcontainer = contentcontainer,
        tabs = {},
        configElements = {},
        themeElements = {},
        toggleKey = Enum.KeyCode.LeftAlt
    }
    

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == windowobj.toggleKey then
            main.Visible = not main.Visible
            if not main.Visible then
                floatingButton.Visible = true
            else
                floatingButton.Visible = false
            end
        end
    end)
    
    local function applyTheme(theme)
        currentTheme = theme
        

        for _, element in pairs(windowobj.themeElements) do
            if element.type == "background" then
                element.obj.BackgroundColor3 = theme.background
            elseif element.type == "secondary" then
                element.obj.BackgroundColor3 = theme.secondary
            elseif element.type == "tertiary" then
                element.obj.BackgroundColor3 = theme.tertiary
            elseif element.type == "border" then
                element.obj.BackgroundColor3 = theme.border
            elseif element.type == "text" then
                element.obj.TextColor3 = theme.text
            elseif element.type == "textSecondary" then
                element.obj.TextColor3 = theme.textSecondary
            elseif element.type == "hover" then
                element.obj.BackgroundColor3 = theme.hover
            elseif element.type == "slider" then
                element.obj.BackgroundColor3 = theme.slider
            elseif element.type == "accent" then
                element.obj.BackgroundColor3 = theme.accent
            end
        end
    end
    

    table.insert(windowobj.themeElements, {type = "background", obj = main})
    table.insert(windowobj.themeElements, {type = "border", obj = titlebar})
    table.insert(windowobj.themeElements, {type = "text", obj = titletext})
    table.insert(windowobj.themeElements, {type = "secondary", obj = tabcontainer})
    table.insert(windowobj.themeElements, {type = "secondary", obj = contentcontainer})
    table.insert(windowobj.themeElements, {type = "tertiary", obj = minimizeButton})
    table.insert(windowobj.themeElements, {type = "accent", obj = floatingButton})
    
    function windowobj:addtab(name)
        local tab = Instance.new("TextButton")
        tab.Name = name
        tab.Size = UDim2.new(1, 0, 0, 30)
        tab.BackgroundColor3 = currentTheme.tertiary
        tab.BorderSizePixel = 0
        tab.Text = name
        tab.TextColor3 = currentTheme.textSecondary
        tab.TextSize = 14
        tab.Font = Enum.Font.Gotham
        tab.AutoButtonColor = false
        tab.TextScaled = false
        tab.Parent = self.tabcontainer
        
        local tabcorner = Instance.new("UICorner")
        tabcorner.CornerRadius = UDim.new(0, 4)
        tabcorner.Parent = tab
        
        local tabcontent = Instance.new("ScrollingFrame")
        tabcontent.Name = name .. "Content"
        tabcontent.Size = UDim2.new(1, 0, 1, 0)
        tabcontent.BackgroundTransparency = 1
        tabcontent.BorderSizePixel = 0
        tabcontent.ScrollBarThickness = 4
        tabcontent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        tabcontent.Visible = false
        tabcontent.Parent = self.contentcontainer
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = tabcontent
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = tabcontent
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabcontent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
        end)
        
        tab.MouseButton1Click:Connect(function()
            for _, othertab in pairs(self.tabs) do
                othertab.button.BackgroundColor3 = currentTheme.tertiary
                othertab.button.TextColor3 = currentTheme.textSecondary
                othertab.content.Visible = false

                if othertab.closeAllDropdowns then
                    othertab.closeAllDropdowns()
                end
            end
            tab.BackgroundColor3 = currentTheme.hover
            tab.TextColor3 = currentTheme.text
            tabcontent.Visible = true
        end)
        

        table.insert(windowobj.themeElements, {type = "tertiary", obj = tab})
        table.insert(windowobj.themeElements, {type = "textSecondary", obj = tab, isProp = "TextColor3"})
        
        local tabobj = {
            button = tab,
            content = tabcontent,
            name = name,
            dropdowns = {}
        }
        

        function tabobj:closeAllDropdowns()
            for _, dropdown in ipairs(self.dropdowns) do
                if dropdown.close then
                    dropdown.close()
                end
            end
        end
        

        if not windowobj.configElements[name] then
            windowobj.configElements[name] = {}
        end
        
        function tabobj:addbutton(text, callback)
            local button = Instance.new("TextButton")
            button.Name = text
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = currentTheme.tertiary
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = currentTheme.text
            button.TextSize = 13
            button.Font = Enum.Font.Gotham
            button.AutoButtonColor = false
            button.TextScaled = false
            button.Parent = self.content
            
            local buttoncorner = Instance.new("UICorner")
            buttoncorner.CornerRadius = UDim.new(0, 4)
            buttoncorner.Parent = button
            
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = currentTheme.hover
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = currentTheme.tertiary
            end)
            
            button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            table.insert(windowobj.themeElements, {type = "tertiary", obj = button})
            table.insert(windowobj.themeElements, {type = "text", obj = button, isProp = "TextColor3"})
            
            return button
        end
        
        function tabobj:addtoggle(text, default, callback)
            local toggle = Instance.new("Frame")
            toggle.Name = text
            toggle.Size = UDim2.new(1, 0, 0, 35)
            toggle.BackgroundColor3 = currentTheme.tertiary
            toggle.BorderSizePixel = 0
            toggle.Parent = self.content
            
            local togglecorner = Instance.new("UICorner")
            togglecorner.CornerRadius = UDim.new(0, 4)
            togglecorner.Parent = toggle
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = false
            label.Parent = toggle
            
            local state = default or false
            
            local togglebutton = Instance.new("TextButton")
            togglebutton.Size = UDim2.new(0, 40, 0, 20)
            togglebutton.Position = UDim2.new(1, -50, 0.5, -10)
            togglebutton.BackgroundColor3 = state and currentTheme.accent or Color3.fromRGB(60, 60, 60)
            togglebutton.BorderSizePixel = 0
            togglebutton.Text = ""
            togglebutton.AutoButtonColor = false
            togglebutton.Parent = toggle
            
            local togglecorner2 = Instance.new("UICorner")
            togglecorner2.CornerRadius = UDim.new(1, 0)
            togglecorner2.Parent = togglebutton
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 16, 0, 16)
            indicator.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            indicator.BorderSizePixel = 0
            indicator.Parent = togglebutton
            
            local indicatorcorner = Instance.new("UICorner")
            indicatorcorner.CornerRadius = UDim.new(1, 0)
            indicatorcorner.Parent = indicator
            
            local function updateToggle(newState)
                state = newState
                togglebutton.BackgroundColor3 = state and currentTheme.accent or Color3.fromRGB(60, 60, 60)
                indicator:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                pcall(callback, state)
            end
            
            togglebutton.MouseButton1Click:Connect(function()
                updateToggle(not state)
            end)
            
            table.insert(windowobj.themeElements, {type = "tertiary", obj = toggle})
            table.insert(windowobj.themeElements, {type = "text", obj = label})
            

            windowobj.configElements[self.name][text] = {
                type = "toggle",
                state = state,
                set = updateToggle
            }
            
            return toggle
        end
        
        function tabobj:addslider(text, min, max, default, callback)
            local slider = Instance.new("Frame")
            slider.Name = text
            slider.Size = UDim2.new(1, 0, 0, 45)
            slider.BackgroundColor3 = currentTheme.tertiary
            slider.BorderSizePixel = 0
            slider.Active = true
            slider.Parent = self.content
            
            local slidercorner = Instance.new("UICorner")
            slidercorner.CornerRadius = UDim.new(0, 4)
            slidercorner.Parent = slider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = false
            label.Parent = slider
            
            local value = default or min
            
            local valuelabel = Instance.new("TextLabel")
            valuelabel.Size = UDim2.new(0, 60, 0, 20)
            valuelabel.Position = UDim2.new(1, -70, 0, 5)
            valuelabel.BackgroundTransparency = 1
            valuelabel.Text = tostring(value)
            valuelabel.TextColor3 = currentTheme.textSecondary
            valuelabel.TextSize = 12
            valuelabel.Font = Enum.Font.Gotham
            valuelabel.TextXAlignment = Enum.TextXAlignment.Right
            valuelabel.TextScaled = false
            valuelabel.Parent = slider
            
            local trackbg = Instance.new("TextButton")
            trackbg.Size = UDim2.new(1, -20, 0, 4)
            trackbg.Position = UDim2.new(0, 10, 1, -12)
            trackbg.BackgroundColor3 = currentTheme.slider
            trackbg.BorderSizePixel = 0
            trackbg.Text = ""
            trackbg.AutoButtonColor = false
            trackbg.Active = true
            trackbg.Parent = slider
            
            local trackcorner = Instance.new("UICorner")
            trackcorner.CornerRadius = UDim.new(1, 0)
            trackcorner.Parent = trackbg
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = currentTheme.accent
            fill.BorderSizePixel = 0
            fill.Parent = trackbg
            
            local fillcorner = Instance.new("UICorner")
            fillcorner.CornerRadius = UDim.new(1, 0)
            fillcorner.Parent = fill
            
            local handle = Instance.new("Frame")
            handle.Size = UDim2.new(0, 12, 0, 12)
            handle.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
            handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            handle.BorderSizePixel = 0
            handle.Parent = trackbg
            
            local handlecorner = Instance.new("UICorner")
            handlecorner.CornerRadius = UDim.new(1, 0)
            handlecorner.Parent = handle
            
            local sliderdragging = false
            
            local function updateSliderValue(newValue)
                value = newValue
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                handle.Position = UDim2.new(percent, -6, 0.5, -6)
                valuelabel.Text = tostring(value)
                pcall(callback, value)
            end
            
            local function updateSlider(input)
                local percent = math.clamp((input.Position.X - trackbg.AbsolutePosition.X) / trackbg.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + (max - min) * percent)
                updateSliderValue(newValue)
            end
            
            trackbg.MouseButton1Down:Connect(function()
                sliderdragging = true
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                updateSlider({Position = Vector2.new(mouse.X, mouse.Y)})
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliderdragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliderdragging = false
                end
            end)
            
            table.insert(windowobj.themeElements, {type = "tertiary", obj = slider})
            table.insert(windowobj.themeElements, {type = "text", obj = label})
            table.insert(windowobj.themeElements, {type = "textSecondary", obj = valuelabel})
            table.insert(windowobj.themeElements, {type = "slider", obj = trackbg})
            table.insert(windowobj.themeElements, {type = "accent", obj = fill})
            

            windowobj.configElements[self.name][text] = {
                type = "slider",
                value = value,
                set = updateSliderValue
            }
            
            return slider
        end
        
        function tabobj:addcolorpicker(text, default, callback)
            local picker = Instance.new("Frame")
            picker.Name = text
            picker.Size = UDim2.new(1, 0, 0, 35)
            picker.BackgroundColor3 = currentTheme.tertiary
            picker.BorderSizePixel = 0
            picker.Parent = self.content
            
            local pickercorner = Instance.new("UICorner")
            pickercorner.CornerRadius = UDim.new(0, 4)
            pickercorner.Parent = picker
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = false
            label.Parent = picker
            
            local color = default or Color3.fromRGB(255, 255, 255)
            
            local colorbox = Instance.new("TextButton")
            colorbox.Size = UDim2.new(0, 30, 0, 20)
            colorbox.Position = UDim2.new(1, -40, 0.5, -10)
            colorbox.BackgroundColor3 = color
            colorbox.BorderSizePixel = 0
            colorbox.Text = ""
            colorbox.AutoButtonColor = false
            colorbox.Parent = picker
            
            local colorboxcorner = Instance.new("UICorner")
            colorboxcorner.CornerRadius = UDim.new(0, 4)
            colorboxcorner.Parent = colorbox
            
            colorbox.MouseButton1Click:Connect(function()
                pcall(callback, color)
            end)
            
            table.insert(windowobj.themeElements, {type = "tertiary", obj = picker})
            table.insert(windowobj.themeElements, {type = "text", obj = label})
            
            return picker
        end
        
        function tabobj:adddropdown(text, options, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Name = text
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            dropdown.BackgroundColor3 = currentTheme.tertiary
            dropdown.BorderSizePixel = 0
            dropdown.Active = true
            dropdown.Parent = self.content
            dropdown.ClipsDescendants = false
            dropdown.ZIndex = 10
            
            local dropdowncorner = Instance.new("UICorner")
            dropdowncorner.CornerRadius = UDim.new(0, 4)
            dropdowncorner.Parent = dropdown
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -100, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = false
            label.ZIndex = 10
            label.Parent = dropdown
            
            local selected = options[1] or "None"
            local isopen = false
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 90, 0, 25)
            button.Position = UDim2.new(1, -100, 0.5, -12.5)
            button.BackgroundColor3 = currentTheme.hover
            button.BorderSizePixel = 0
            button.Text = selected
            button.TextColor3 = currentTheme.text
            button.TextSize = 12
            button.Font = Enum.Font.Gotham
            button.AutoButtonColor = false
            button.TextScaled = false
            button.Active = true
            button.ZIndex = 10
            button.Parent = dropdown
            
            local buttoncorner = Instance.new("UICorner")
            buttoncorner.CornerRadius = UDim.new(0, 4)
            buttoncorner.Parent = button
            

            local optionsframe = Instance.new("ScrollingFrame")
            optionsframe.Size = UDim2.new(0, 90, 0, 0)
            optionsframe.Position = UDim2.new(1, -100, 1, 5)
            optionsframe.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optionsframe.BorderSizePixel = 0
            optionsframe.Visible = false
            optionsframe.Active = true
            optionsframe.ZIndex = 15
            optionsframe.ScrollBarThickness = 0
            optionsframe.CanvasSize = UDim2.new(0, 0, 0, 0)
            optionsframe.Parent = dropdown
            
            local optionscorner = Instance.new("UICorner")
            optionscorner.CornerRadius = UDim.new(0, 4)
            optionscorner.Parent = optionsframe
            
            local optionslayout = Instance.new("UIListLayout")
            optionslayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionslayout.Padding = UDim.new(0, 2)
            optionslayout.Parent = optionsframe
            
            local optionspadding = Instance.new("UIPadding")
            optionspadding.PaddingTop = UDim.new(0, 3)
            optionspadding.PaddingBottom = UDim.new(0, 3)
            optionspadding.PaddingLeft = UDim.new(0, 3)
            optionspadding.PaddingRight = UDim.new(0, 3)
            optionspadding.Parent = optionsframe
            
            local function closeDropdown()
                isopen = false
                optionsframe.Visible = false
            end
            
            local function updateDropdownValue(newValue)
                selected = newValue
                button.Text = selected
                closeDropdown()
                pcall(callback, selected)
            end
            
            for i, option in ipairs(options) do
                local optionbutton = Instance.new("TextButton")
                optionbutton.Size = UDim2.new(1, 0, 0, 25)
                optionbutton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                optionbutton.BorderSizePixel = 0
                optionbutton.Text = option
                optionbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionbutton.TextSize = 12
                optionbutton.Font = Enum.Font.Gotham
                optionbutton.AutoButtonColor = false
                optionbutton.TextScaled = false
                optionbutton.Active = true
                optionbutton.ZIndex = 15
                optionbutton.Parent = optionsframe
                
                local optioncorner = Instance.new("UICorner")
                optioncorner.CornerRadius = UDim.new(0, 3)
                optioncorner.Parent = optionbutton
                
                optionbutton.MouseEnter:Connect(function()
                    optionbutton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end)
                
                optionbutton.MouseLeave:Connect(function()
                    optionbutton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end)
                
                optionbutton.MouseButton1Click:Connect(function()
                    updateDropdownValue(option)
                end)
            end
            
            optionslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local contentSize = optionslayout.AbsoluteContentSize.Y + 6
                local maxHeight = 150
                optionsframe.Size = UDim2.new(0, 90, 0, math.min(contentSize, maxHeight))
                optionsframe.CanvasSize = UDim2.new(0, 0, 0, contentSize)
            end)
            
            button.MouseButton1Click:Connect(function()

                for _, otherDropdown in ipairs(self.dropdowns) do
                    if otherDropdown ~= dropdownObj and otherDropdown.close then
                        otherDropdown.close()
                    end
                end
                
                isopen = not isopen
                optionsframe.Visible = isopen
            end)
            
            table.insert(windowobj.themeElements, {type = "tertiary", obj = dropdown})
            table.insert(windowobj.themeElements, {type = "text", obj = label})
            table.insert(windowobj.themeElements, {type = "hover", obj = button})
            

            windowobj.configElements[self.name][text] = {
                type = "dropdown",
                selected = selected,
                set = updateDropdownValue
            }
            

            local dropdownObj = {
                close = closeDropdown,
                element = dropdown
            }
            

            table.insert(self.dropdowns, dropdownObj)
            
            return dropdown
        end
        
        self.tabs[name] = tabobj
        
        if #self.tabs == 1 then
            tab.BackgroundColor3 = currentTheme.hover
            tab.TextColor3 = currentTheme.text
            tabcontent.Visible = true
        end
        
        return tabobj
    end
    

    local settingsTab = windowobj:addtab("Settings")
    

    settingsTab:adddropdown("Theme", {"Dark", "Blue", "Purple", "Red"}, function(selected)
        if themes[selected] then
            applyTheme(themes[selected])
            createNotification("Theme Changed", "Applied " .. selected .. " theme", 2, "success")
        end
    end)
    

    settingsTab:adddropdown("Toggle Key", {"LeftAlt", "RightAlt", "LeftControl", "RightControl", "LeftShift", "RightShift", "Insert", "Delete", "End", "Home"}, function(selected)
        windowobj.toggleKey = Enum.KeyCode[selected]
        createNotification("Keybind Changed", "Toggle key set to " .. selected, 2, "info")
    end)
    

    local configNameInput = Instance.new("Frame")
    configNameInput.Name = "ConfigNameInput"
    configNameInput.Size = UDim2.new(1, 0, 0, 35)
    configNameInput.BackgroundColor3 = currentTheme.tertiary
    configNameInput.BorderSizePixel = 0
    configNameInput.Parent = settingsTab.content
    
    local configInputCorner = Instance.new("UICorner")
    configInputCorner.CornerRadius = UDim.new(0, 4)
    configInputCorner.Parent = configNameInput
    
    local configInputLabel = Instance.new("TextLabel")
    configInputLabel.Size = UDim2.new(0, 80, 1, 0)
    configInputLabel.Position = UDim2.new(0, 10, 0, 0)
    configInputLabel.BackgroundTransparency = 1
    configInputLabel.Text = "Config Name"
    configInputLabel.TextColor3 = currentTheme.text
    configInputLabel.TextSize = 13
    configInputLabel.Font = Enum.Font.Gotham
    configInputLabel.TextXAlignment = Enum.TextXAlignment.Left
    configInputLabel.Parent = configNameInput
    
    local configTextBox = Instance.new("TextBox")
    configTextBox.Size = UDim2.new(1, -100, 0, 25)
    configTextBox.Position = UDim2.new(0, 95, 0.5, -12.5)
    configTextBox.BackgroundColor3 = currentTheme.hover
    configTextBox.BorderSizePixel = 0
    configTextBox.Text = configSaveName
    configTextBox.TextColor3 = currentTheme.text
    configTextBox.TextSize = 12
    configTextBox.Font = Enum.Font.Gotham
    configTextBox.PlaceholderText = "Enter config name"
    configTextBox.PlaceholderColor3 = currentTheme.textSecondary
    configTextBox.ClearTextOnFocus = false
    configTextBox.Parent = configNameInput
    
    local configTextBoxCorner = Instance.new("UICorner")
    configTextBoxCorner.CornerRadius = UDim.new(0, 4)
    configTextBoxCorner.Parent = configTextBox
    
    configTextBox:GetPropertyChangedSignal("Text"):Connect(function()
        configSaveName = configTextBox.Text:gsub("[^%w_-]", "")
        if configSaveName == "" then
            configSaveName = "default"
        end
        configTextBox.Text = configSaveName
    end)
    
    table.insert(windowobj.themeElements, {type = "tertiary", obj = configNameInput})
    table.insert(windowobj.themeElements, {type = "text", obj = configInputLabel})
    table.insert(windowobj.themeElements, {type = "hover", obj = configTextBox})
    

    settingsTab:addbutton("Save Config", function()
        saveConfig(windowobj, configSaveName)
        createNotification("Config Saved", "Configuration '" .. configSaveName .. "' saved successfully", 3, "success")

        task.wait(0.1)
        if configDropdownRef and configDropdownRef.refresh then
            configDropdownRef.refresh()
        end
    end)
    
    settingsTab:addbutton("Load Config", function()
        loadConfig(windowobj, configSaveName)
        createNotification("Config Loaded", "Configuration '" .. configSaveName .. "' loaded", 3, "success")
    end)
    

    local configDropdownRef = nil
    

    local configDropdown = Instance.new("Frame")
    configDropdown.Name = "Select Config"
    configDropdown.Size = UDim2.new(1, 0, 0, 35)
    configDropdown.BackgroundColor3 = currentTheme.tertiary
    configDropdown.BorderSizePixel = 0
    configDropdown.Active = true
    configDropdown.Parent = settingsTab.content
    configDropdown.ClipsDescendants = false
    configDropdown.ZIndex = 10
    
    local configDropdownCorner = Instance.new("UICorner")
    configDropdownCorner.CornerRadius = UDim.new(0, 4)
    configDropdownCorner.Parent = configDropdown
    
    local configDropdownLabel = Instance.new("TextLabel")
    configDropdownLabel.Size = UDim2.new(1, -100, 1, 0)
    configDropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    configDropdownLabel.BackgroundTransparency = 1
    configDropdownLabel.Text = "Select Config"
    configDropdownLabel.TextColor3 = currentTheme.text
    configDropdownLabel.TextSize = 13
    configDropdownLabel.Font = Enum.Font.Gotham
    configDropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    configDropdownLabel.ZIndex = 10
    configDropdownLabel.Parent = configDropdown
    
    local configButton = Instance.new("TextButton")
    configButton.Size = UDim2.new(0, 90, 0, 25)
    configButton.Position = UDim2.new(1, -100, 0.5, -12.5)
    configButton.BackgroundColor3 = currentTheme.hover
    configButton.BorderSizePixel = 0
    configButton.Text = configSaveName
    configButton.TextColor3 = currentTheme.text
    configButton.TextSize = 12
    configButton.Font = Enum.Font.Gotham
    configButton.AutoButtonColor = false
    configButton.ZIndex = 10
    configButton.Parent = configDropdown
    
    local configButtonCorner = Instance.new("UICorner")
    configButtonCorner.CornerRadius = UDim.new(0, 4)
    configButtonCorner.Parent = configButton
    
    local configOptionsFrame = Instance.new("ScrollingFrame")
    configOptionsFrame.Size = UDim2.new(0, 90, 0, 0)
    configOptionsFrame.Position = UDim2.new(1, -100, 1, 5)
    configOptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    configOptionsFrame.BorderSizePixel = 0
    configOptionsFrame.Visible = false
    configOptionsFrame.Active = true
    configOptionsFrame.ZIndex = 15
    configOptionsFrame.ScrollBarThickness = 0
    configOptionsFrame.Parent = configDropdown
    
    local configOptionsCorner = Instance.new("UICorner")
    configOptionsCorner.CornerRadius = UDim.new(0, 4)
    configOptionsCorner.Parent = configOptionsFrame
    
    local configOptionsLayout = Instance.new("UIListLayout")
    configOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    configOptionsLayout.Padding = UDim.new(0, 2)
    configOptionsLayout.Parent = configOptionsFrame
    
    local configOptionsPadding = Instance.new("UIPadding")
    configOptionsPadding.PaddingTop = UDim.new(0, 3)
    configOptionsPadding.PaddingBottom = UDim.new(0, 3)
    configOptionsPadding.PaddingLeft = UDim.new(0, 3)
    configOptionsPadding.PaddingRight = UDim.new(0, 3)
    configOptionsPadding.Parent = configOptionsFrame
    
    local function refreshConfigDropdown()

        for _, child in ipairs(configOptionsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        

        local configs = getConfigList()
        if #configs == 0 then
            configs = {"default"}
        end
        

        for _, configName in ipairs(configs) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            optionButton.BorderSizePixel = 0
            optionButton.Text = configName
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 12
            optionButton.Font = Enum.Font.Gotham
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 15
            optionButton.Parent = configOptionsFrame
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 3)
            optionCorner.Parent = optionButton
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                configSaveName = configName
                configButton.Text = configName
                configTextBox.Text = configName
                configOptionsFrame.Visible = false
                createNotification("Config Selected", "Selected config: " .. configName, 2, "info")
            end)
        end
        

        configOptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local contentSize = configOptionsLayout.AbsoluteContentSize.Y + 6
            local maxHeight = 150
            configOptionsFrame.Size = UDim2.new(0, 90, 0, math.min(contentSize, maxHeight))
            configOptionsFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize)
        end)
        

        local contentSize = configOptionsLayout.AbsoluteContentSize.Y + 6
        local maxHeight = 150
        configOptionsFrame.Size = UDim2.new(0, 90, 0, math.min(contentSize, maxHeight))
        configOptionsFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize)
    end
    
    configButton.MouseButton1Click:Connect(function()

        if settingsTab.closeAllDropdowns then
            settingsTab.closeAllDropdowns()
        end
        
        configOptionsFrame.Visible = not configOptionsFrame.Visible
        if configOptionsFrame.Visible then
            refreshConfigDropdown()
        end
    end)
    

    configDropdownRef = {
        refresh = refreshConfigDropdown,
        close = function()
            configOptionsFrame.Visible = false
        end
    }
    
    table.insert(settingsTab.dropdowns, configDropdownRef)
    table.insert(windowobj.themeElements, {type = "tertiary", obj = configDropdown})
    table.insert(windowobj.themeElements, {type = "text", obj = configDropdownLabel})
    table.insert(windowobj.themeElements, {type = "hover", obj = configButton})
    

    refreshConfigDropdown()
    
    settingsTab:addbutton("Delete Config", function()
        if configSaveName ~= "default" then
            deleteConfig(configSaveName)
            createNotification("Config Deleted", "Configuration '" .. configSaveName .. "' deleted", 3, "warning")
            configSaveName = "default"
            configTextBox.Text = "default"
            configButton.Text = "default"

            task.wait(0.1)
            if configDropdownRef and configDropdownRef.refresh then
                configDropdownRef.refresh()
            end
        else
            createNotification("Cannot Delete", "Cannot delete default config", 3, "error")
        end
    end)
    
    settingsTab:addtoggle("Auto Load Config", false, function(state)
        if state then
            loadConfig(windowobj, configSaveName)
            createNotification("Auto Load Enabled", "Config will auto-load on startup", 2, "info")
        end
    end)
    

    windowobj.notify = createNotification
    
    return windowobj
end

return library
