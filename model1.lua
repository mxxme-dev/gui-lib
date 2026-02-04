local library = {}

function library:createwindow(title)
    local screen = Instance.new("ScreenGui")
    screen.Name = title
    screen.ResetOnSpawn = false
    
    -- handle coregui with pcall for safety
    local success, err = pcall(function()
        screen.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        screen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    -- immortal logic
    screen.AncestryChanged:Connect(function(_, parent)
        if not parent then
            screen.Parent = game:GetService("CoreGui")
        end
    end)

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 400, 0, 250)
    main.Position = UDim2.new(0.5, -200, 0.5, -125)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true 
    main.Parent = screen

    return main
end

return library
