local C = require('Constants')
local composer = require("composer")

local scene = composer.newScene()

-- Variáveis globais para controle do som
local som1
local isSoundOn = true

-- Função para parar o áudio
local function pararAudio()
    if isSoundOn then
        audio.stop()
        isSoundOn = false
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Plano de fundo
    local plano_de_fundo = display.newImage(sceneGroup, "imagens\\capa\\capa.png")
    plano_de_fundo.x = display.contentCenterX
    plano_de_fundo.y = display.contentCenterY

    -- Botão próximo
    local botao_proximo = display.newImage(sceneGroup, "imagens\\botoes\\avancar.png")
    botao_proximo.x = 427
    botao_proximo.y = 988

    -- Função do botão próximo
    function botao_proximo.handle(event)
        pararAudio()
        composer.gotoScene("Pagina01", { effect = "fromRight", time = 1000 })
    end
    botao_proximo:addEventListener('tap', botao_proximo.handle)

    -- Botão de som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 350
    botao_som.y = 980
    botao_som.width = 80
    botao_som.height = 40

    -- Carregar som
    som1 = audio.loadSound("audios\\audio_da_capa.mp3")

    -- Função para ligar/desligar o som
    local function toggleSound(event)
        if event.phase == "began" then
            if isSoundOn then
                pararAudio()
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

    if (phase == "will") then
        -- Código executado quando a cena está prestes a aparecer na tela

    elseif (phase == "did") then
        -- Código executado quando a cena está completamente na tela
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        -- Parar o áudio quando a cena está prestes a sair
        pararAudio()

    elseif (phase == "did") then
        -- Código executado imediatamente após a cena sair completamente da tela
    end
end

-- destroy()
function scene:destroy(event)
    -- Liberar recursos da cena
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

return scene
