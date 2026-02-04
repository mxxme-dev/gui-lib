local library = {}

function library:createwindow(title)
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
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
    titlebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    titlebar.BorderSizePixel = 0
    titlebar.Active = true
    titlebar.Parent = main
    
    local titlecorner = Instance.new("UICorner")
    titlecorner.CornerRadius = UDim.new(0, 8)
    titlecorner.Parent = titlebar
    
    local titletext = Instance.new("TextLabel")
    titletext.Name = "Title"
    titletext.Size = UDim2.new(1, -20, 1, 0)
    titletext.Position = UDim2.new(0, 10, 0, 0)
    titletext.BackgroundTransparency = 1
    titletext.Text = title
    titletext.TextColor3 = Color3.fromRGB(255, 255, 255)
    titletext.TextSize = 16
    titletext.Font = Enum.Font.GothamBold
    titletext.TextXAlignment = Enum.TextXAlignment.Left
    titletext.TextScaled = false
    titletext.Parent = titlebar
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local UserInputService = game:GetService("UserInputService")
    
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
    tabcontainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
    contentcontainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentcontainer.BorderSizePixel = 0
    contentcontainer.Parent = main
    
    local contentcorner = Instance.new("UICorner")
    contentcorner.CornerRadius = UDim.new(0, 6)
    contentcorner.Parent = contentcontainer
    
    local windowobj = {
        main = main,
        tabcontainer = tabcontainer,
        contentcontainer = contentcontainer,
        tabs = {}
    }
    
    function windowobj:addtab(name)
        local tab = Instance.new("TextButton")
        tab.Name = name
        tab.Size = UDim2.new(1, 0, 0, 30)
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tab.BorderSizePixel = 0
        tab.Text = name
        tab.TextColor3 = Color3.fromRGB(200, 200, 200)
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
                othertab.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                othertab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                othertab.content.Visible = false
            end
            tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabcontent.Visible = true
        end)
        
        local tabobj = {
            button = tab,
            content = tabcontent
        }
        
        function tabobj:addbutton(text, callback)
            local button = Instance.new("TextButton")
            button.Name = text
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 13
            button.Font = Enum.Font.Gotham
            button.AutoButtonColor = false
            button.TextScaled = false
            button.Parent = self.content
            
            local buttoncorner = Instance.new("UICorner")
            buttoncorner.CornerRadius = UDim.new(0, 4)
            buttoncorner.Parent = button
            
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end)
            
            button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return button
        end
        
        function tabobj:addtoggle(text, default, callback)
            local toggle = Instance.new("Frame")
            toggle.Name = text
            toggle.Size = UDim2.new(1, 0, 0, 35)
            toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = false
            label.Parent = toggle
            
            local state = default or false
            
            local togglebutton = Instance.new("TextButton")
            togglebutton.Size = UDim2.new(0, 40, 0, 20)
            togglebutton.Position = UDim2.new(1, -50, 0.5, -10)
            togglebutton.BackgroundColor3 = state and Color3.fromRGB(60, 170, 80) or Color3.fromRGB(60, 60, 60)
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
            
            togglebutton.MouseButton1Click:Connect(function()
                state = not state
                togglebutton.BackgroundColor3 = state and Color3.fromRGB(60, 170, 80) or Color3.fromRGB(60, 60, 60)
                indicator:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                pcall(callback, state)
            end)
            
            return toggle
        end
        
        function tabobj:addslider(text, min, max, default, callback)
            local slider = Instance.new("Frame")
            slider.Name = text
            slider.Size = UDim2.new(1, 0, 0, 45)
            slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            valuelabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            valuelabel.TextSize = 12
            valuelabel.Font = Enum.Font.Gotham
            valuelabel.TextXAlignment = Enum.TextXAlignment.Right
            valuelabel.TextScaled = false
            valuelabel.Parent = slider
            
            local trackbg = Instance.new("TextButton")
            trackbg.Size = UDim2.new(1, -20, 0, 4)
            trackbg.Position = UDim2.new(0, 10, 1, -12)
            trackbg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
            fill.BackgroundColor3 = Color3.fromRGB(60, 170, 80)
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
            local UserInputService = game:GetService("UserInputService")
            
            local function updateSlider(input)
                local percent = math.clamp((input.Position.X - trackbg.AbsolutePosition.X) / trackbg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * percent)
                
                fill.Size = UDim2.new(percent, 0, 1, 0)
                handle.Position = UDim2.new(percent, -6, 0.5, -6)
                valuelabel.Text = tostring(value)
                
                pcall(callback, value)
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
            
            return slider
        end
        
        function tabobj:addcolorpicker(text, default, callback)
            local picker = Instance.new("Frame")
            picker.Name = text
            picker.Size = UDim2.new(1, 0, 0, 35)
            picker.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            
            return picker
        end
        
        function tabobj:adddropdown(text, options, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Name = text
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.BorderSizePixel = 0
            button.Text = selected
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            
            local optionsframe = Instance.new("Frame")
            optionsframe.Size = UDim2.new(0, 90, 0, 0)
            optionsframe.Position = UDim2.new(1, -100, 1, 5)
            optionsframe.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optionsframe.BorderSizePixel = 0
            optionsframe.Visible = false
            optionsframe.Active = true
            optionsframe.ZIndex = 15
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
                    selected = option
                    button.Text = selected
                    optionsframe.Visible = false
                    isopen = false
                    pcall(callback, selected)
                end)
            end
            
            optionslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                optionsframe.Size = UDim2.new(0, 90, 0, optionslayout.AbsoluteContentSize.Y + 6)
            end)
            
            button.MouseButton1Click:Connect(function()
                isopen = not isopen
                optionsframe.Visible = isopen
            end)
            
            return dropdown
        end
        
        self.tabs[name] = tabobj
        
        if #self.tabs == 1 then
            tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabcontent.Visible = true
        end
        
        return tabobj
    end
    
    return windowobj
end

return library
