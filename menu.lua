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


function Menu:keypressed(key)
    if key == "up" then
        Menu.selected = (Menu.selected - 2) % #Menu.items + 1
    elseif key == "down" then
        Menu.selected = Menu.selected % #Menu.items + 1
    end
    if key == "space" then
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
