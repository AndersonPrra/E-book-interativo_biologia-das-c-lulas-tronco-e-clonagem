local C = require('Constants')
local composer = require("composer")

local scene = composer.newScene()

-- Variável global para gerenciar o áudio
local isSoundOn = true
local som1

-- Variáveis para o controle das imagens e do estado da interação
local cliqueCount = 0
local imagem1, imagem2, imagem3

-- Função para parar o áudio se estiver ativo
local function pararAudio()
    if isSoundOn then
        audio.stop()
        isSoundOn = false
    end
end

-- Função para gerenciar os cliques
local function onClick(event)
    cliqueCount = cliqueCount + 1

    -- Primeira interação: imagem1 aumenta de tamanho
    if cliqueCount == 1 then
        transition.to(imagem1, { time = 500, xScale = 1.5, yScale = 1.5 })
    -- Segunda interação: imagem1 continua aumentando
    elseif cliqueCount == 2 then
        transition.to(imagem1, { time = 500, xScale = 2, yScale = 2 })
    -- Terceira interação: imagem1 mantém o tamanho, imagem2 some, imagem3 aparece
    elseif cliqueCount == 3 then
        imagem2.isVisible = false
        imagem3.isVisible = true
        -- Não fazer mais transição de tamanho para imagem1
    end

    return true
end

-- create()
function scene:create(event)

    local sceneGroup = self.view

    -- Plano de fundo
    local plano_de_fundo = display.newImage(
        sceneGroup,
        "imagens\\pagina5\\pagina_5.png"
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
        pararAudio() -- Para o áudio antes de trocar de cena
        composer.gotoScene("contra_capa", { effect = "fromRight", time = 1000 })
    end

    botao_proximo:addEventListener('tap', handleBotaoProximo)

    -- Botão de voltar
    local botao_voltar = display.newImage(sceneGroup, "imagens\\botoes\\retornar.png")
    botao_voltar.x = 388
    botao_voltar.y = 950
    botao_voltar.width = 90
    botao_voltar.height = 30

    local function handleBotaoVoltar(event)
        pararAudio() -- Para o áudio antes de trocar de cena
        composer.gotoScene("Pagina04", { effect = "fromLeft", time = 1000 })
    end

    botao_voltar:addEventListener('tap', handleBotaoVoltar)

    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 943
    botao_som.width = 80
    botao_som.height = 40

    som1 = audio.loadSound("audios\\audio_pagina5.mp3")

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

    -- Adicionando imagens interativas
    imagem1 = display.newImage(sceneGroup, "imagens\\pagina5\\coracao.png")
    imagem1.x = display.contentCenterX + 15
    imagem1.y = 710
    imagem1.width = 90
    imagem1.height = 90

    imagem2 = display.newImage(sceneGroup, "imagens\\pagina5\\joao.png")
    imagem2.x = 620
    imagem2.y = 700
    imagem2.width = 150
    imagem2.height = 300

    imagem3 = display.newImage(sceneGroup, "imagens\\pagina5\\joao_feliz.png")
    imagem3.x = 620
    imagem3.y = 700
    imagem3.width = 200
    imagem3.height = 350
    imagem3.isVisible = false 

    
    Runtime:addEventListener("tap", onClick)
end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen

    end
end

-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Para o áudio se a cena estiver saindo da tela
        pararAudio()

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end

-- destroy()
function scene:destroy(event)

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    if sceneGroup then
        sceneGroup:removeSelf()
        sceneGroup = nil
    end

    -- Libera o áudio da memória
    if som1 then
        audio.dispose(som1)
        som1 = nil
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
