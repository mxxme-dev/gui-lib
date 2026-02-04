local library = {}

function library:createwindow(title)
    local screen = instance.new("screengui")
    screen.name = title
    screen.parent = game:getservice("coregui")

    local main = instance.new("frame")
    main.size = udim2.new(0, 500, 0, 300)
    main.position = udim2.new(0.5, -250, 0.5, -150)
    main.backgroundcolor3 = color3.fromrgb(30, 30, 30)
    main.parent = screen

    local label = instance.new("textlabel")
    label.text = title
    label.size = udim2.new(1, 0, 0, 30)
    label.backgroundcolor3 = color3.fromrgb(45, 45, 45)
    label.textcolor3 = color3.fromrgb(255, 255, 255)
    label.parent = main

    local container = instance.new("scrollingframe")
    container.size = udim2.new(1, 0, 1, -30)
    container.position = udim2.new(0, 0, 0, 30)
    container.backgroundtransparency = 1
    container.parent = main

    local layout = instance.new("uilistlayout")
    layout.parent = container

    local elements = {}

    function elements:button(name, callback)
        local btn = instance.new("textbutton")
        btn.text = name
        btn.size = udim2.new(1, -10, 0, 30)
        btn.parent = container
        btn.mousebutton1click:connect(function()
            callback()
        end)
    end

    return elements
end

return library
