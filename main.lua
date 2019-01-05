rect = love.graphics.rectangle
balle = love.graphics.circle
--definition des variables de sonds
local sndRebond
local sndMur
local sndPoints
--definition de la largeur et hauteur
local largeur = love.graphics.getWidth()
local hauteur = love.graphics.getHeight()
--definition de qui a la balle 
local Joueur1pert = true
local Joueur2pert = false

--variables
Pad = {}
Ball = {}
Player = {}
Fillet = {}

Pad.x = 0
Pad.y = 0
Pad.largeur = 20
Pad.hauteur = 80

Ball.x = 0
Ball.y = 0
Ball.vx = 0
Ball.vy = 0
Ball.rayon = 10
Ball.colle = false

Player.scoreJoueur1 = 0
Player.scoreJoueur2 = 0

Fillet.largeur = 10
Fillet.hauteur = 600

function demare()
    Ball.colle = true
end

function love.load()
    sndMur = love.audio.newSource("sonds/mur.wav")
    sndPoints = love.audio.newSource("sonds/point.wav")
    sndRebond = love.audio.newSource("sonds/rebond.wav")
    --suprime l affichage de la souris sur la fenetre
    love.mouse.setVisible()
    demare()
end

function love.update(dt)
    --deplacement des pads a la souris
    Pad.y = love.mouse.getY()
  
    --empeche aux pad de sortir de l ecran
    if Pad.y < 0 + (Pad.hauteur / 2) then
        Pad.y = 0 + (Pad.hauteur / 2)
    end
  
    --empeche aux pad de sortir de l ecran
    if Pad.y > hauteur - (Pad.hauteur / 2) then
        Pad.y = hauteur - (Pad.hauteur / 2)
    end
  
    --donne une vitesse a la ball si elle n est pas colle
    if Ball.colle == true then
        Ball.y = Pad.y
        if Joueur1pert == true then
            Ball.x = 0 + Pad.largeur + Ball.rayon
            Joueur1pert = false
        elseif Joueur2pert == true then
            Ball.x = largeur - Pad.largeur - Ball.rayon
            Joueur2pert = false
        end
    else
        Ball.x = Ball.x + (Ball.vx * dt)
        Ball.y = Ball.y + (Ball.vy * dt)
    end
  
  --rebond en bas
    if Ball.y > hauteur then
        Ball.vy = 0 - Ball.vy
        sndMur:play()
        Ball.y = hauteur
      
    end
  
  --rebond en haut
    if Ball.y < 0 then
        Ball.vy = 0 - Ball.vy
        sndMur:play()
        Ball.y = 0
       
    end
  
  --rebond sur la raquette de droite
    if Ball.x > (largeur - Pad.largeur) then
        if math.abs(Pad.y - Ball.y) < (Pad.hauteur / 2) then
            Ball.vx = 0 - Ball.vx
            sndRebond:play()
            Ball.x = largeur - Pad.largeur
        else
            Ball.colle = true
            Player.scoreJoueur1 = Player.scoreJoueur1 + 1
            sndPoints:play()
            Joueur2pert = true
        end
    end
  
  --rebond sur la raquette de gauche
    if Ball.x < (0 + Pad.largeur) then
        if math.abs(Pad.y - Ball.y) < (Pad.hauteur / 2) then
            Ball.vx = 0 - Ball.vx
            sndRebond:play()
            Ball.x = 0 + Pad.largeur
        else
            Ball.colle = true
            Player.scoreJoueur2 = Player.scoreJoueur2 + 1
             sndPoints:play()
            Joueur1pert = true
        end
    end
end

function love.draw()
    
    rect('fill', Pad.x, Pad.y - (Pad.hauteur / 2), Pad.largeur, Pad.hauteur)
    rect('fill', 800 - Pad.largeur, Pad.y - (Pad.hauteur / 2), Pad.largeur, Pad.hauteur)
    rect('fill', (largeur / 2), 0, Fillet.largeur, Fillet.hauteur)
    balle('fill', Ball.x, Ball.y, Ball.rayon)

    local score1 = ""
    local score2 = ""

    score1 = score1.." joueur 1 : "..tostring(Player.scoreJoueur1)
    score2 = score2.." joueur 2 : "..tostring(Player.scoreJoueur2)

    love.graphics.print(score1,(largeur / 4),0)
    love.graphics.print(score2, (largeur / 2)+(largeur / 4),0)
end

function love.mousepressed()
  
    if Ball.colle == true then
        Ball.colle = false
        Ball.vx = 200
        Ball.vy = 200
    end
end