local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

local library = {
    flags = {},
    controls = {},
    themables = {},
    _id = "default",
    _root = "mxx-lib",
    visible = true,
    toggleKey = Enum.KeyCode.LeftAlt,
    theme = {
        Background = Color3.fromRGB(18, 18, 18),
        Secondary = Color3.fromRGB(24, 24, 24),
        Element = Color3.fromRGB(32, 32, 32),
        Accent = Color3.fromRGB(90, 160, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(160, 160, 160)
    }
}

-- internal file system
local function setupFolders()
    if not isfolder(library._root) then makefolder(library._root) end
    local path = library._root .. "/" .. library._id
    if not isfolder(path) then makefolder(path) end
    return path
end

function library:setid(id)
    self._id = tostring(id)
    setupFolders()
end

function library:applyTheme()
    for instance, props in pairs(self.themables) do
        pcall(function()
            if instance and instance.Parent then
                for prop, themeKey in pairs(props) do
                    instance[prop] = self.theme[themeKey]
                end
            end
        end)
    end
end

local function reg(instance, props)
    library.themables[instance] = props
end

function library:createwindow(title)
    local screen = Instance.new("ScreenGui")
    screen.Name = title
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    
    local success, _ = pcall(function()
        screen.Parent = game:GetService("CoreGui")
    end)
    if not success then screen.Parent = Player:WaitForChild("PlayerGui") end

    -- immortal logic
    screen.AncestryChanged:Connect(function(_, parent)
        if not parent then screen.Parent = game:GetService("CoreGui") end
    end)

    local main = Instance.new("Frame", screen)
    main.Size = UDim2.fromOffset(540, 430)
    main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(270, 215)
    main.BorderSizePixel = 0
    reg(main, {BackgroundColor3 = "Background"})
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 9)

    local scale = Instance.new("UIScale", main)
    local function rescale()
        local v = workspace.CurrentCamera.ViewportSize
        scale.Scale = math.clamp(math.min(v.X/1920, v.Y/1080) * 1.1, 0.75, 1)
    end
    rescale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 38)
    top.BorderSizePixel = 0
    reg(top, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 9)

    local titlelbl = Instance.new("TextLabel", top)
    titlelbl.Size = UDim2.new(1, -20, 1, 0)
    titlelbl.Position = UDim2.fromOffset(12, 0)
    titlelbl.BackgroundTransparency = 1
    titlelbl.Text = title
    titlelbl.Font = Enum.Font.GothamBold
    titlelbl.TextSize = 15
    titlelbl.TextXAlignment = Enum.TextXAlignment.Left
    reg(titlelbl, {TextColor3 = "Text"})

    -- dragging
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local tabframe = Instance.new("Frame", main)
    tabframe.Size = UDim2.new(0, 135, 1, -48)
    tabframe.Position = UDim2.fromOffset(6, 42)
    reg(tabframe, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", tabframe).CornerRadius = UDim.new(0, 7)

    local tablayout = Instance.new("UIListLayout", tabframe)
    tablayout.Padding = UDim.new(0, 5)
    Instance.new("UIPadding", tabframe).PaddingTop = UDim.new(0, 6)

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -152, 1, -48)
    container.Position = UDim2.fromOffset(146, 42)
    reg(container, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 7)

    local window = {tabs = {}}

    function window:addtab(name)
        local btn = Instance.new("TextButton", tabframe)
        btn.Size = UDim2.new(1, -12, 0, 32)
        btn.Position = UDim2.fromOffset(6, 0)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        reg(btn, {BackgroundColor3 = "Element", TextColor3 = "Muted"})
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        local page = Instance.new("ScrollingFrame", container)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 0
        page.Visible = false
        
        local playout = Instance.new("UIListLayout", page)
        playout.Padding = UDim.new(0, 6)
        Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 6)

        playout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, playout.AbsoluteContentSize.Y + 12)
        end)

        btn.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                t.page.Visible = false
                t.btn.TextColor3 = library.theme.Muted
                t.btn.BackgroundColor3 = library.theme.Element
            end
            page.Visible = true
            btn.TextColor3 = library.theme.Accent
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)

        local tab = {btn = btn, page = page}

        function tab:addbutton(text, cb)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(1, -16, 0, 36)
            b.Position = UDim2.fromOffset(8, 0)
            b.Text = "  " .. text
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.TextSize = 13
            reg(b, {BackgroundColor3 = "Element", TextColor3 = "Text"})
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function() pcall(cb) end)
        end

        function tab:adddropdown(text, options, cb)
            local drop = Instance.new("Frame", page)
            drop.Size = UDim2.new(1, -16, 0, 36)
            drop.Position = UDim2.fromOffset(8, 0)
            reg(drop, {BackgroundColor3 = "Element"})
            Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 5)
            drop.ClipsDescendants = false

            local lbl = Instance.new("TextLabel", drop)
            lbl.Size = UDim2.new(1, -10, 1, 0)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.Text = text .. " : " .. (options[1] or "None")
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            reg(lbl, {TextColor3 = "Text"})

            local scroll = Instance.new("ScrollingFrame", drop)
            scroll.Size = UDim2.new(1, 0, 0, 0)
            scroll.Position = UDim2.fromScale(0, 1.05)
            scroll.Visible = false
            scroll.ZIndex = 100
            scroll.ScrollBarThickness = 0
            reg(scroll, {BackgroundColor3 = "Secondary"})
            Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 5)
            
            local slay = Instance.new("UIListLayout", scroll)
            
            local open = false
            drop.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    open = not open
                    scroll.Visible = open
                    scroll.Size = open and UDim2.new(1, 0, 0, math.min(#options * 28, 120)) or UDim2.new(1, 0, 0, 0)
                end
            end)

            for _, o_text in pairs(options) do
                local o = Instance.new("TextButton", scroll)
                o.Size = UDim2.new(1, 0, 0, 28)
                o.Text = o_text
                o.ZIndex = 101
                o.BorderSizePixel = 0
                o.Font = Enum.Font.Gotham
                o.TextSize = 12
                reg(o, {BackgroundColor3 = "Element", TextColor3 = "Muted"})
                o.MouseButton1Click:Connect(function()
                    lbl.Text = text .. " : " .. o_text
                    open = false; scroll.Visible = false
                    pcall(cb, o_text)
                end)
            end
        end

        table.insert(window.tabs, tab)
        if #window.tabs == 1 then
            page.Visible = true
            btn.TextColor3 = library.theme.Accent
        end
        return tab
    end

    local settings = window:addtab("Settings")
    
    settings:addbutton("Save Config", function()
        local path = setupFolders() .. "/config.json"
        writefile(path, HttpService:JSONEncode(library.flags))
    end)

    settings:addbutton("Load Config", function()
        local path = setupFolders() .. "/config.json"
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for k, v in pairs(data) do
                if library.controls[k] then library.controls[k](v) end
            end
        end
    end)

    settings:adddropdown("UI Theme", {"Blue", "Green", "Red"}, function(v)
        if v == "Blue" then library.theme.Accent = Color3.fromRGB(90, 160, 255)
        elseif v == "Green" then library.theme.Accent = Color3.fromRGB(60, 170, 80)
        elseif v == "Red" then library.theme.Accent = Color3.fromRGB(200, 60, 60) end
        library:applyTheme()
    end)

    library:applyTheme()
    return window
end

return library
