Menu = {}
Menu.items = {
    {
        text = "start",
        func = function()
            State.current = "Game"
        end,
    },
    {
        text = "quit",
        func = function()
            love.event.quit(0)
        end
    }
}
Menu.selected = 1
Menu.cooldown = 0
DesiredCooldown = 0.2


function Menu:keypressed(key)
    if key == menuConfig.upKey then
        Menu.selected = (Menu.selected - 2) % #Menu.items + 1
    elseif key == menuConfig.downKey then
        Menu.selected = Menu.selected % #Menu.items + 1
    end
    if key == menuConfig.selectKey then
        local item = Menu.items[Menu.selected]
        item.func()
    end
end

function Menu:draw()
    for i, item in ipairs(Menu.items) do
        love.graphics.setFont(love.graphics.newFont(24))
        if i == Menu.selected then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0, 1, 1)
        end
        love.graphics.print(item.text, 100, 100 + i * 30)
    end
end

function Menu:update(dt)
    if love.joystick then
        local joysticks = love.joystick.getJoysticks()
        for i, joystick in ipairs(joysticks) do
            local aButton = joystick:isGamepadDown(menuConfig.selectButton)
            local upButton = joystick:isGamepadDown(menuConfig.upButton)
            local downButton = joystick:isGamepadDown(menuConfig.downButton)
            local yAxis = joystick:getGamepadAxis(menuConfig.yAxis)
            if aButton then
                local item = Menu.items[Menu.selected]
                item.func()
            end
            if (yAxis < -0.5 or upButton) and Menu.cooldown <= 0 then
                Menu.cooldown = Menu.cooldown + dt
                Menu.selected = (Menu.selected - 2) % #Menu.items + 1

            end
            if (yAxis > 0.5 or downButton) and Menu.cooldown <= 0 then
                Menu.selected = Menu.selected % #Menu.items + 1
                Menu.cooldown = Menu.cooldown + dt
            end
        end
        
        Menu.cooldown = Menu.cooldown + dt
        if Menu.cooldown >= DesiredCooldown then
            Menu.cooldown = 0
        end
    end
end