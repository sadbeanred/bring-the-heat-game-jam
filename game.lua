Game = {}

Temperature = 0


function ChangeScore(value)
    Temperature = Temperature + value
end


function KillPlayer(player)
    local playertype = player.config.name;
    -- local score_change = 0
    --
    ChangeScore(({
      Fire = function() return -5 end,
      Ice = function() return 5 end
    })[playertype]())
    player:respawn()
end

function DestroyCrystal(faction)
    local scoreChange = ({
      Fire = function() return 5 end,
      Ice = function() return -5 end
    })[faction]()
    Temperature = Temperature + scoreChange
end

function Game:draw()
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print(Temperature, 100, 100)
end

