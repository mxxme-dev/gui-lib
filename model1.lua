local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

local library = {}
library.flags = {}
library.controls = {}
library.themables = {}
library._id = nil
library._root = nil
library.visible = true
library.toggleKey = Enum.KeyCode.LeftAlt

library.theme = {
    Background = Color3.fromRGB(20,20,20),
    Secondary = Color3.fromRGB(26,26,26),
    Element = Color3.fromRGB(36,36,36),
    Accent = Color3.fromRGB(90,160,255),
    Text = Color3.fromRGB(255,255,255),
    Muted = Color3.fromRGB(170,170,170)
}

function library:setid(id)
    library._id = tostring(id)
    library._root = "mxx-lib/"..library._id
    if not isfolder("mxx-lib") then makefolder("mxx-lib") end
    if not isfolder(library._root) then makefolder(library._root) end
end

function library:applyTheme()
    for i, m in pairs(self.themables) do
        if i and i.Parent then
            for p, k in pairs(m) do
                i[p] = self.theme[k] [cite: 2]
            end
        end
    end
end

local function theme(i, m)
    library.themables[i] = m
end

local function saveConfig(n)
    if not library._root then return end
    writefile(library._root.."/"..n..".json", HttpService:JSONEncode(library.flags))
end

local function loadConfig(n)
    if not library._root then return end
    local p = library._root.."/"..n..".json"
    if not isfile(p) then return end
    local d = HttpService:JSONDecode(readfile(p))
    for k, v in pairs(d) do
        if library.controls[k] then [cite: 3]
            library.controls[k](v)
            library.flags[k] = v
        end
    end
end

function library:createwindow(title)
    local gui = Instance.new("ScreenGui")
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    -- immortal logic: force back to CoreGui if deleted
    gui.AncestryChanged:Connect(function(_, parent)
        if not parent then
            gui.Parent = game:GetService("CoreGui")
        end
    end)

    local scale = Instance.new("UIScale", gui)
    local function rescale()
        local s = workspace.CurrentCamera.ViewportSize
        scale.Scale = math.clamp(math.min(s.X/1920, s.Y/1080), 0.7, 1)
    end
    rescale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

    local main = Instance.new("Frame", gui) [cite: 4]
    main.Size = UDim2.fromOffset(540, 440)
    main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(270, 220)
    main.BorderSizePixel = 0
    theme(main, {BackgroundColor3 = "Background"})
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 38)
    top.BorderSizePixel = 0
    theme(top, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

    local titlelbl = Instance.new("TextLabel", top)
    titlelbl.Size = UDim2.new(1, -90, 1, 0)
    titlelbl.Position = UDim2.fromOffset(12, 0)
    titlelbl.BackgroundTransparency = 1
    titlelbl.Text = title
    titlelbl.Font = Enum.Font.GothamBold
    titlelbl.TextSize = 16
    titlelbl.TextXAlignment = Enum.TextXAlignment.Left -- fixed nil error here
    theme(titlelbl, {TextColor3 = "Text"})

    local minimize = Instance.new("TextButton", top)
    minimize.Size = UDim2.fromOffset(24, 24)
    minimize.Position = UDim2.new(1, -34, 0.5, -12)
    minimize.Text = "—"
    minimize.Font = Enum.Font.GothamBold [cite: 5]
    minimize.TextSize = 18
    minimize.BorderSizePixel = 0
    theme(minimize, {BackgroundColor3 = "Element", TextColor3 = "Text"})
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

    local float = Instance.new("TextButton", gui)
    float.Size = UDim2.fromOffset(44, 44)
    float.Position = UDim2.fromScale(0.5, 0.05)
    float.Text = "≡"
    float.Visible = false
    float.BorderSizePixel = 0
    theme(float, {BackgroundColor3 = "Accent", TextColor3 = "Text"})
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local dragStart, startPos

    local function dragify(frame)
        frame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true [cite: 6]
                dragStart = i.Position
                startPos = frame.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) [cite: 7]
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    dragify(top)
    dragify(float)

    local function hide()
        main.Visible = false
        float.Visible = true
        library.visible = false [cite: 8]
    end

    local function show()
        main.Visible = true
        float.Visible = false
        library.visible = true
    end

    minimize.MouseButton1Click:Connect(hide)
    float.MouseButton1Click:Connect(show)

    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == library.toggleKey then
            if library.visible then hide() else show() end
        end
    end)

    local tabs = Instance.new("Frame", main) [cite: 9]
    tabs.Size = UDim2.new(0, 130, 1, -48)
    tabs.Position = UDim2.fromOffset(8, 42)
    tabs.BorderSizePixel = 0
    theme(tabs, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, 8)

    local tablayout = Instance.new("UIListLayout", tabs)
    tablayout.Padding = UDim.new(0, 6)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -150, 1, -48)
    content.Position = UDim2.fromOffset(142, 42)
    content.BorderSizePixel = 0
    theme(content, {BackgroundColor3 = "Secondary"})
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

    local window = {}
    window.tabs = {}

    function window:addtab(name)
        local btn = Instance.new("TextButton", tabs) [cite: 10]
        btn.Size = UDim2.new(1, -12, 0, 32)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        theme(btn, {BackgroundColor3 = "Element", TextColor3 = "Muted"})
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local page = Instance.new("ScrollingFrame", content)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 0
        page.CanvasSize = UDim2.new() [cite: 12]
        page.Visible = false
        page.BackgroundTransparency = 1

        local lay = Instance.new("UIListLayout", page)
        lay.Padding = UDim.new(0, 6)
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 8)
        end)

        local function selectTab()
            for _, t in pairs(window.tabs) do
                t.page.Visible = false [cite: 13]
                t.button:SetAttribute("Active", false)
                t.button.BackgroundColor3 = library.theme.Element
                t.button.TextColor3 = library.theme.Muted
            end
            btn:SetAttribute("Active", true)
            btn.BackgroundColor3 = library.theme.Accent
            btn.TextColor3 = library.theme.Text [cite: 14]
            page.Visible = true
        end

        btn.MouseButton1Click:Connect(selectTab)

        local tab = {button = btn, page = page}
        window.tabs[#window.tabs + 1] = tab
        
        if #window.tabs == 1 then selectTab() end
        
        -- stub functions for elements
        function tab:addbutton(text, cb)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(1, -12, 0, 32)
            b.Text = text
            b.Parent = page
            b.MouseButton1Click:Connect(cb)
        end

        function tab:adddropdown(text, list, cb)
            -- simple placeholder logic
        end

        return tab
    end

    library:applyTheme()
    return window
end

return library
