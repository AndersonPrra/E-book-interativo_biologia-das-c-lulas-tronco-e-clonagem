local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

-- Variável global para gerenciar o áudio
local isSoundOn = true
local som1

-- Função para parar o áudio se estiver ativo
local function pararAudio()
    if isSoundOn then
        audio.stop()
        isSoundOn = false
    end
end

function scene:create(event)
    local sceneGroup = self.view

    -- Início do sistema de física
    physics.start()
    physics.pause() -- Física iniciada, mas pausada

    -- Plano de fundo
    local background = display.newImage(sceneGroup, "imagens\\pagina1\\Pagina_1.png") 
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.width = display.contentWidth
    background.height = display.contentHeight

    -- Botão de próximo
    local botao_proximo = display.newImage(sceneGroup, "imagens\\botoes\\avancar.png")
    botao_proximo.x = 486
    botao_proximo.y = 950
    botao_proximo.width = 88
    botao_proximo.height = 29

    -- Função para avançar página
    local function goToNextPage()
        pararAudio() -- Para o áudio antes de trocar de cena
        composer.gotoScene("Pagina02", { effect = "fromRight", time = 1000 })
    end
    botao_proximo:addEventListener('tap', goToNextPage)

    -- Botão de voltar
    local botaovoltar = display.newImage(sceneGroup, "imagens\\botoes\\retornar.png")
    botaovoltar.x = 388
    botaovoltar.y = 950
    botaovoltar.width = 90
    botaovoltar.height = 30

    -- Função para voltar página
    local function goToPreviousPage()
        pararAudio() -- Para o áudio antes de trocar de cena
        composer.gotoScene("capa", { effect = "fromLeft", time = 1000 })
    end
    botaovoltar:addEventListener('tap', goToPreviousPage)

    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 943
    botao_som.width = 80
    botao_som.height = 40

    som1 = audio.loadSound("audios\\audio_pagina1.mp3")

    -- Função para ligar/desligar o som
    local function toggleSound(event)
        if event.phase == "began" then
            if isSoundOn then
                audio.stop()
                isSoundOn = false
            else
                audio.play(som1)
                isSoundOn = true
            end
        end
        return true
    end
    botao_som:addEventListener("touch", toggleSound)

    -- Criação do óvulo
    local ovulo = display.newImage(sceneGroup, "imagens\\pagina1\\ovulo.png")
    ovulo.x = display.contentCenterX
    ovulo.y = display.contentHeight - 200
    ovulo.width = 150
    ovulo.height = 150
    physics.addBody(ovulo, "static")

    -- Botão ao lado do óvulo
    local botaoCorrida = display.newImage(sceneGroup, "imagens\\pagina1\\corrida.png")
    botaoCorrida.x = ovulo.x + 230
    botaoCorrida.y = ovulo.y
    botaoCorrida.width = 160
    botaoCorrida.height = 55

    -- Criação do zigoto (inicialmente invisível)
    local zigoto = display.newImage(sceneGroup, "imagens\\pagina1\\zigoto.png")
    zigoto.x = ovulo.x
    zigoto.y = ovulo.y
    zigoto.width = 230
    zigoto.height = 180
    zigoto.isVisible = false

    -- Gerar vários espermatozoides (invisíveis inicialmente)
    local espermatozoides = {}
    for i = 1, 10 do
        local es = display.newImage(sceneGroup, "imagens\\pagina1\\espermatozoide.png")
        es.x = math.random(50, display.contentWidth - 50)
        es.y = math.random(50, display.contentHeight / 2)
        es.width = 50
        es.height = 50
        es.isVisible = false -- Tornar invisível inicialmente
        physics.addBody(es, "dynamic", { radius = 25, bounce = 0.5 })
        es.isAwake = false
        es:setLinearVelocity(math.random(-50, 50), math.random(50, 150))
        es.isFixedRotation = true
        table.insert(espermatozoides, es)
    end

    -- Função para iniciar a corrida
    local function iniciarCorrida()
        physics.start()
        for _, es in ipairs(espermatozoides) do
            es.isVisible = true -- Tornar visível
            es.isAwake = true
        end
    end

    -- Detectar colisão entre espermatozoide e óvulo
    local function onCollision(event)
        if event.phase == "began" then
            local obj1 = event.object1
            local obj2 = event.object2

            -- Verificar se a colisão é entre espermatozoide e óvulo
            if (obj1 == ovulo and table.indexOf(espermatozoides, obj2)) or 
               (obj2 == ovulo and table.indexOf(espermatozoides, obj1)) then
                ovulo.isVisible = false
                zigoto.isVisible = true

                -- Remover espermatozoides da cena
                for _, es in ipairs(espermatozoides) do
                    es:removeSelf()
                end
                espermatozoides = {}

                -- Parar física após a fecundação
                physics.pause()
            end
        end
    end

    Runtime:addEventListener("collision", onCollision)

    -- Detectar toque no botão para iniciar corrida
    botaoCorrida:addEventListener("tap", iniciarCorrida)
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        physics.pause()
        pararAudio() -- Para o áudio ao sair da cena
    end
end

function scene:destroy(event)
    physics.stop()
    if som1 then
        audio.dispose(som1)
        som1 = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
