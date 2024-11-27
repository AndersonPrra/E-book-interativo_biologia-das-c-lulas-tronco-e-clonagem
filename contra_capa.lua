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
    local plano_de_fundo = display.newImage(sceneGroup, "imagens\\Contra_capa\\Contra-capa.png")
    plano_de_fundo.x = display.contentCenterX
    plano_de_fundo.y = display.contentCenterY

    -- Botão anterior
    local botao_anterior = display.newImage(sceneGroup, "imagens\\botoes\\retornar.png")
    botao_anterior.x = 495
    botao_anterior.y = 983

    -- Botão início
    local botao_inicio = display.newImage(sceneGroup, "imagens\\botoes\\home.png")
    botao_inicio.x = 410
    botao_inicio.y = 984
    botao_inicio.width = 130
    botao_inicio.height = 29

    -- Botão som
    local botao_som = display.newImage(sceneGroup, "imagens\\botoes\\Botao de audio.png")
    botao_som.x = 290
    botao_som.y = 975
    botao_som.width = 90
    botao_som.height = 48

    -- Carregar som
    som1 = audio.loadSound("audios\\audio_contracapa.mp3")

    -- Função para alternar o som
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

    -- Função do botão anterior
    function botao_anterior.handle(event)
        pararAudio()
        composer.gotoScene("Pagina05", { effect = "fromLeft", time = 1000 })
    end
    botao_anterior:addEventListener('tap', botao_anterior.handle)

    -- Função do botão início
    function botao_inicio.handle(event)
        pararAudio()
        composer.gotoScene("capa", { effect = "fromLeft", time = 1000 })
    end
    botao_inicio:addEventListener('tap', botao_inicio.handle)
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
