local C = require('Constants')
local composer = require("composer")

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

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Plano de fundo
    local plano_de_fundo = display.newImage(
        sceneGroup,
        "imagens\\pagina2\\pagina_2.png"
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
        composer.gotoScene("Pagina03", { effect = "fromRight", time = 1000 })
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
        composer.gotoScene("Pagina01", { effect = "fromLeft", time = 1000 })
    end
   
    botao_voltar:addEventListener('tap', handleBotaoVoltar)
   
    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 943
    botao_som.width = 80
    botao_som.height = 40
   
    som1 = audio.loadSound("audios\\audio_pagina2.mp3")
   
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

    -- homem
    local homem = display.newImage(sceneGroup, "imagens\\pagina2\\homem.png")
    homem.x = 600
    homem.y = 800
    homem.width = 130
    homem.height = 320

    -- seringa
    local seringaGroup = display.newGroup()
    sceneGroup:insert(seringaGroup)

    -- Corpo da seringa
    local corpoSeringa = display.newRect(seringaGroup, 0, 0, 100, 30)
    corpoSeringa:setFillColor(0.9) -- Cor cinza-claro
    corpoSeringa.strokeWidth = 2
    corpoSeringa:setStrokeColor(0)

    -- Agulha
    local agulha = display.newRect(seringaGroup, 60, 0, 50, 5)
    agulha:setFillColor(0, 0, 0)

    -- Líquido dentro da seringa
    local liquido = display.newRect(seringaGroup, 0, 0, 0, 30) 
    liquido.anchorX = 1
    liquido.x = 50 
    liquido:setFillColor(1, 0, 0) 

    -- Êmbolo
    local embolo = display.newRect(seringaGroup, 50, 0, 10, 30)
    embolo:setFillColor(0.7) 

    seringaGroup.x = display.contentCenterX
    seringaGroup.y = 750    

    
    local seringaCheia = false
    local emContato = false

    -- arrastar a seringa
    local function arrastarSeringa(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.isFocus = true
        elseif event.phase == "moved" and event.target.isFocus then
          
            seringaGroup.x = event.x
            seringaGroup.y = event.y

            -- Detectar se a agulha está tocando a parte superior do homem
            if agulha.x + seringaGroup.x > homem.x - homem.width / 2 and
               agulha.x + seringaGroup.x < homem.x + homem.width / 2 and
               seringaGroup.y > homem.y - homem.height / 2 and
               seringaGroup.y < homem.y then
                if not emContato then
                    emContato = true

                    -- Aspirar líquido
                    transition.to(liquido, { width = 80, time = 500 })
                    transition.to(embolo, { x = 50 - liquido.width, time = 500 })
                end
            else
                if emContato then
                    emContato = false

                    -- Esvaziar líquido
                    transition.to(liquido, { width = 0, time = 500 })
                    transition.to(embolo, { x = 50, time = 500 })
                end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            event.target.isFocus = false
        end
        return true
    end

    -- Adiciona o evento de toque para arrastar a seringa
    seringaGroup:addEventListener("touch", arrastarSeringa)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Preparar a cena
    elseif (phase == "did") then
        -- Ativar sensores ou recursos visuais
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        pararAudio() -- Para o áudio ao sair da cena
    elseif (phase == "did") then
        -- Desativar recursos
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    if sceneGroup then
        sceneGroup:removeSelf()
        sceneGroup = nil
    end
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
