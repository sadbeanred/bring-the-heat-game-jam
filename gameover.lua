GameOver = { }
GameOver.items = {
    {
        text = "Menu",
        func = function()
            State.current = "Menu"
        end,
    },
    {
        text = "Back to Menu",
        func = function()
            love.event.quit(0)
        end
    }
}
GameOver.selected = 1

local font = love.graphics.newFont(24)


function GameOver:keypressed(key)
    if key == "up" then
        GameOver.selected = (GameOver.selected - 2) % #GameOver.items + 1
    elseif key == "down" then
        GameOver.selected = GameOver.selected % #GameOver.items + 1
    end
    if key == "space" then
        local item = GameOver.items[Menu.selected]
        item.func()
    end
end

function GameOver:draw()
    if Temperature > 0 then
        love.graphics.print("Fire won: " .. Temperature, 100, 100)
    else
        love.graphics.print("Ice won: " .. Temperature, 50, 100)
    end
    for i, item in ipairs(GameOver.items) do
        love.graphics.push("all")
        love.graphics.setFont(font)
        if i == GameOver.selected then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0, 1, 1)
        end
        love.graphics.print(item.text, 100, 100 + i * 30)
        
        love.graphics.pop()
    end
end
