GameOver = {}
GameOver.items = {
    {
        text = "Menu",
        func = function()
            State.current = "Menu"
        end,
    },
    {
        text = "quit",
        func = function()
            love.event.quit(0)
        end
    }
}
GameOver.selected = 1


function GameOver:keypressed(key)
    if key == "up" then
        GameOver.selected = (Menu.selected - 2) % #Menu.items + 1
    elseif key == "down" then
        GameOver.selected = Menu.selected % #Menu.items + 1
    end
    if key == "space" then
        local item = GameOver.items[Menu.selected]
        item.func()
    end
end

function GameOver:draw()
    if Temperature > 0 then
        love.graphics.print("Fire won: "..Temperature, 100, 100)
    else
        love.graphics.print("Ice won: "..Temperature, 50, 100)
    end
    for i, item in ipairs(GameOver.items) do
        love.graphics.setFont(love.graphics.newFont(24))
        if i == GameOver.selected then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0, 1, 1)
        end
        love.graphics.print(item.text, 100, 100 + i * 30)
    end
end
