local C = require('Constants')
local composer = require("composer")

local scene = composer.newScene()

-- Variáveis globais
local isSoundOn = true
local som1

-- Função para verificar se a imagem foi arrastada para o centro
local function verificarInterseccao(obj1, obj2)
    if obj1 and obj2 then
        local dx = obj1.x - obj2.x
        local dy = obj1.y - obj2.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local maxDistance = (obj1.width + obj2.width) * 0.5
        return distance < maxDistance
    end
    return false
end

-- Função para parar o áudio
local function pararAudio()
    if isSoundOn then
        audio.stop()
        isSoundOn = false
    end
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Plano de fundo
    local plano_de_fundo = display.newImage(sceneGroup, "imagens\\pagina3\\pagina_3.png")
    plano_de_fundo.x = display.contentCenterX
    plano_de_fundo.y = display.contentCenterY

    -- Imagem 1 (núcleo)
    local imagem1 = display.newImage(sceneGroup, "imagens\\pagina3\\nucleo.png")
    imagem1.x = 290
    imagem1.y = 670
    imagem1.width = 50
    imagem1.height = 50

    -- Imagem 2 (célula anucleada)
    local imagem2 = display.newImage(sceneGroup, "imagens\\pagina3\\anucleada.png")
    imagem2.x = 530
    imagem2.y = 670
    imagem2.width = 100
    imagem2.height = 100

    -- Imagem 3 (ovelha - inicialmente invisível)
    local imagem3 = display.newImage(sceneGroup, "imagens\\pagina3\\ovelha.png")
    imagem3.x = 530
    imagem3.y = 480
    imagem3.width = 180
    imagem3.height = 180
    imagem3.isVisible = false

    -- Função para arrastar a imagem1
    local function arrastarImagem(event)
        local imagem = event.target
        local phase = event.phase

        if phase == "began" then
            display.currentStage:setFocus(imagem)
            imagem.touchOffsetX = event.x - imagem.x
            imagem.touchOffsetY = event.y - imagem.y

        elseif phase == "moved" then
            imagem.x = event.x - imagem.touchOffsetX
            imagem.y = event.y - imagem.touchOffsetY

        elseif phase == "ended" or phase == "cancelled" then
            display.currentStage:setFocus(nil)
            -- Verificar se a imagem1 foi movida para o centro da imagem2
            if verificarInterseccao(imagem1, imagem2) then
                imagem3.isVisible = true
            end
        end

        return true
    end

    -- Adicionar evento de toque à imagem1
    imagem1:addEventListener("touch", arrastarImagem)

    -- Botão de voltar
    local botao_voltar = display.newImage(sceneGroup, "imagens\\botoes\\retornar.png")
    botao_voltar.x = 388
    botao_voltar.y = 950
    botao_voltar.width = 90
    botao_voltar.height = 30

    local function handleBotaoVoltar(event)
        pararAudio()
        composer.gotoScene("Pagina02", { effect = "fromLeft", time = 1000 })
    end

    botao_voltar:addEventListener('tap', handleBotaoVoltar)

    -- Botão de próximo
    local botao_proximo = display.newImage(sceneGroup, "imagens\\botoes\\avancar.png")
    botao_proximo.x = 486
    botao_proximo.y = 950
    botao_proximo.width = 88
    botao_proximo.height = 29

    local function handleBotaoProximo(event)
        pararAudio()
        composer.gotoScene("Pagina04", { effect = "fromRight", time = 1000 })
    end

    botao_proximo:addEventListener('tap', handleBotaoProximo)

    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 943
    botao_som.width = 80
    botao_som.height = 40

    som1 = audio.loadSound("audios\\audio_pagina3.mp3")

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
end

-- show()
function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        -- Código executado quando a cena está completamente na tela
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        pararAudio() -- Para o áudio ao sair da cena
    end
end

-- destroy()
function scene:destroy(event)
    -- Libera o áudio da memória
    if som1 then
        audio.dispose(som1)
        som1 = nil
    end
end

-- Adicionar listeners para eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
