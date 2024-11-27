local C = require('Constants')
local composer = require("composer")

local scene = composer.newScene()

-- Variável para controlar o estado do som
local isSoundOn = true
local som1

-- Função para parar o áudio
local function pararAudio()
    if isSoundOn then
        audio.stop()
        isSoundOn = false
    end
end

-- Função para criar uma bactéria
local function criarBacteria(x, y, sceneGroup)
    local bacteria = display.newImage(sceneGroup, "imagens\\pagina4\\bacteria.png")
    bacteria.x = x
    bacteria.y = 600
    bacteria.width = 100
    bacteria.height = 100

    -- Função que é chamada ao clicar na bactéria
    local function handleBacteriaClick(event)
        if event.phase == "began" then
            -- Cria duas novas bactérias em posições ligeiramente deslocadas
            for _ = 1, 2 do
                local novaX = bacteria.x + math.random(-50, 50)
                local novaY = bacteria.y + math.random(-50, 50)
                criarBacteria(novaX, novaY, sceneGroup)
            end
        end
        return true
    end

    -- Adiciona o evento de toque à bactéria
    bacteria:addEventListener("touch", handleBacteriaClick)

    return bacteria
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Plano de fundo
    local plano_de_fundo = display.newImage(
        sceneGroup,
        "imagens\\pagina4\\pagina4.png"
    )
    plano_de_fundo.x = display.contentCenterX
    plano_de_fundo.y = display.contentCenterY

    -- Botão de próximo
    local botao_proximo = display.newImage(sceneGroup, "imagens\\botoes\\avancar.png")
    botao_proximo.x = 486
    botao_proximo.y = 950
    botao_proximo.width = 88
    botao_proximo.height = 29

    local function handleBotaoProximo(event)
        pararAudio() -- Parar áudio antes de trocar de cena
        composer.gotoScene("Pagina05", { effect = "fromRight", time = 1000 })
    end

    botao_proximo:addEventListener('tap', handleBotaoProximo)

    -- Botão de voltar
    local botao_voltar = display.newImage(sceneGroup, "imagens\\botoes\\retornar.png")
    botao_voltar.x = 388
    botao_voltar.y = 950
    botao_voltar.width = 90
    botao_voltar.height = 30

    local function handleBotaoVoltar(event)
        pararAudio() -- Parar áudio antes de trocar de cena
        composer.gotoScene("Pagina03", { effect = "fromLeft", time = 1000 })
    end

    botao_voltar:addEventListener('tap', handleBotaoVoltar)

    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 943
    botao_som.width = 80
    botao_som.height = 40

    som1 = audio.loadSound("audios\\audio_pagina4.mp3")

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

    -- Criação inicial da bactéria
    criarBacteria(display.contentCenterX, display.contentCenterY, sceneGroup)
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        pararAudio() -- Parar o áudio ao sair da cena
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    -- Liberar recursos de áudio
    if som1 then
        audio.dispose(som1)
        som1 = nil
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
