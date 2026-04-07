--[[
    Hub UI v7.1
    
    ══════════════════════ COMO CRIAR O HUB ══════════════════════
    local Hub = loadstring(...)()
    
    local janela = Hub.novo("Nome do Hub", "Escuro", {largura=780, altura=520})
    -- Temas: Escuro, Roxo, Carbon, Neon, Rubi, Esmeralda, Crepusculo,
    --        Safira, Rosa, Gelo, Floresta, Ambar
    
    ══════════════════════ COMO CRIAR ABAS ═══════════════════════
    local aba = janela:CriarAba("Nome", "🌟", 3)
    -- "Nome"   = texto da aba
    -- "🌟"     = ícone (opcional, pode ser nil)
    -- 3        = badge numérico (opcional, pode ser nil)
    
    ══════════════════════ ELEMENTOS ═════════════════════════════
    Todos os elementos são criados com:  aba:CriarElemento(...)
    Alguns retornam um objeto com métodos :Definir(v) / :Obter()
    
    ═════════════════════════════════════════════════════════════
]]

local Hub = {}
Hub.__index = Hub

local TweenService   = game:GetService("TweenService")
local EntradaUsuario = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Players        = game:GetService("Players")

local IS_MOBILE = EntradaUsuario.TouchEnabled and not EntradaUsuario.KeyboardEnabled

local function Tw(obj, t, props, es, ed)
    return TweenService:Create(obj,
        TweenInfo.new(t, es or Enum.EasingStyle.Quart, ed or Enum.EasingDirection.Out), props)
end
local function Cantos(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = obj; return c
end
local function Pad(obj, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop=UDim.new(0,t or 0); p.PaddingBottom=UDim.new(0,b or 0)
    p.PaddingLeft=UDim.new(0,l or 0); p.PaddingRight=UDim.new(0,r or 0)
    p.Parent=obj
end
local function Grad(obj, c1, c2, rot)
    local g = Instance.new("UIGradient"); g.Color=ColorSequence.new(c1,c2); g.Rotation=rot or 90; g.Parent=obj; return g
end
local function Stroke(obj, cor, thick, transp)
    local s = Instance.new("UIStroke"); s.Color=cor; s.Thickness=thick or 1
    s.Transparency=transp or 0; s.Parent=obj; return s
end
local function F(props)
    local f = Instance.new("Frame"); f.BorderSizePixel=0
    for k,v in pairs(props) do f[k]=v end; return f
end
local function L(props)
    local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.BorderSizePixel=0
    for k,v in pairs(props) do l[k]=v end; return l
end
local function Lerp3(a, b, t)
    return Color3.new(a.R+(b.R-a.R)*t, a.G+(b.G-a.G)*t, a.B+(b.B-a.B)*t)
end
local function Brilhar(c, amt)
    return Color3.new(math.min(c.R+amt,1), math.min(c.G+amt,1), math.min(c.B+amt,1))
end
local function Escurecer(c, amt)
    return Color3.new(math.max(c.R-amt,0), math.max(c.G-amt,0), math.max(c.B-amt,0))
end

local paletas = {
    Escuro = {
        Janela=Color3.fromRGB(11,12,16), Cartao=Color3.fromRGB(18,19,26),
        Sidebar=Color3.fromRGB(13,14,20), Topbar=Color3.fromRGB(15,16,23),
        Item=Color3.fromRGB(24,25,35), ItemHover=Color3.fromRGB(32,33,47),
        Borda=Color3.fromRGB(38,40,58), Destaque=Color3.fromRGB(0,190,210),
        DestaqueV=Color3.fromRGB(60,215,230), BotaoFundo=Color3.fromRGB(20,75,92),
        BotaoHover=Color3.fromRGB(28,98,118), BotaoTexto=Color3.fromRGB(170,245,255),
        Sucesso=Color3.fromRGB(45,205,125), Aviso=Color3.fromRGB(255,180,35),
        Perigo=Color3.fromRGB(220,58,58), Info=Color3.fromRGB(65,155,255),
        Texto=Color3.fromRGB(232,237,250), Sub=Color3.fromRGB(115,124,152),
        Fraco=Color3.fromRGB(52,56,82), PontoA=Color3.fromRGB(0,190,210),
        PontoB=Color3.fromRGB(60,215,230),
    },
    Roxo = {
        Janela=Color3.fromRGB(10,8,20), Cartao=Color3.fromRGB(17,14,32),
        Sidebar=Color3.fromRGB(12,10,24), Topbar=Color3.fromRGB(14,11,27),
        Item=Color3.fromRGB(24,18,42), ItemHover=Color3.fromRGB(32,26,56),
        Borda=Color3.fromRGB(52,40,88), Destaque=Color3.fromRGB(148,68,255),
        DestaqueV=Color3.fromRGB(185,115,255), BotaoFundo=Color3.fromRGB(58,28,118),
        BotaoHover=Color3.fromRGB(74,38,145), BotaoTexto=Color3.fromRGB(218,192,255),
        Sucesso=Color3.fromRGB(55,200,120), Aviso=Color3.fromRGB(255,180,35),
        Perigo=Color3.fromRGB(225,55,65), Info=Color3.fromRGB(75,150,255),
        Texto=Color3.fromRGB(238,230,255), Sub=Color3.fromRGB(148,128,190),
        Fraco=Color3.fromRGB(72,56,112), PontoA=Color3.fromRGB(148,68,255),
        PontoB=Color3.fromRGB(205,138,255),
    },
    Carbon = {
        Janela=Color3.fromRGB(9,9,10), Cartao=Color3.fromRGB(15,15,17),
        Sidebar=Color3.fromRGB(11,11,13), Topbar=Color3.fromRGB(13,13,15),
        Item=Color3.fromRGB(22,22,25), ItemHover=Color3.fromRGB(30,30,35),
        Borda=Color3.fromRGB(42,42,48), Destaque=Color3.fromRGB(210,90,28),
        DestaqueV=Color3.fromRGB(232,118,50), BotaoFundo=Color3.fromRGB(48,30,14),
        BotaoHover=Color3.fromRGB(62,40,18), BotaoTexto=Color3.fromRGB(255,205,162),
        Sucesso=Color3.fromRGB(48,200,115), Aviso=Color3.fromRGB(235,190,35),
        Perigo=Color3.fromRGB(215,52,52), Info=Color3.fromRGB(58,150,255),
        Texto=Color3.fromRGB(235,230,222), Sub=Color3.fromRGB(128,125,118),
        Fraco=Color3.fromRGB(55,53,50), PontoA=Color3.fromRGB(210,90,28),
        PontoB=Color3.fromRGB(235,142,65),
    },
    Neon = {
        Janela=Color3.fromRGB(6,6,8), Cartao=Color3.fromRGB(11,11,15),
        Sidebar=Color3.fromRGB(8,8,11), Topbar=Color3.fromRGB(9,9,13),
        Item=Color3.fromRGB(15,15,22), ItemHover=Color3.fromRGB(22,22,32),
        Borda=Color3.fromRGB(38,33,60), Destaque=Color3.fromRGB(85,205,205),
        DestaqueV=Color3.fromRGB(125,225,225), BotaoFundo=Color3.fromRGB(24,24,36),
        BotaoHover=Color3.fromRGB(33,33,50), BotaoTexto=Color3.fromRGB(225,225,255),
        Sucesso=Color3.fromRGB(85,215,135), Aviso=Color3.fromRGB(235,195,55),
        Perigo=Color3.fromRGB(215,65,65), Info=Color3.fromRGB(85,165,255),
        Texto=Color3.fromRGB(222,222,242), Sub=Color3.fromRGB(112,112,155),
        Fraco=Color3.fromRGB(44,44,70), PontoA=Color3.fromRGB(85,205,205),
        PontoB=Color3.fromRGB(185,105,255), Rainbow=true,
    },
    Rubi = {
        Janela=Color3.fromRGB(13,7,8), Cartao=Color3.fromRGB(22,13,13),
        Sidebar=Color3.fromRGB(16,9,9), Topbar=Color3.fromRGB(18,11,11),
        Item=Color3.fromRGB(28,17,17), ItemHover=Color3.fromRGB(37,24,24),
        Borda=Color3.fromRGB(65,30,30), Destaque=Color3.fromRGB(205,42,58),
        DestaqueV=Color3.fromRGB(230,78,90), BotaoFundo=Color3.fromRGB(70,18,24),
        BotaoHover=Color3.fromRGB(88,25,33), BotaoTexto=Color3.fromRGB(255,205,210),
        Sucesso=Color3.fromRGB(55,200,120), Aviso=Color3.fromRGB(215,175,48),
        Perigo=Color3.fromRGB(205,42,58), Info=Color3.fromRGB(65,150,255),
        Texto=Color3.fromRGB(248,235,232), Sub=Color3.fromRGB(168,122,122),
        Fraco=Color3.fromRGB(76,42,42), PontoA=Color3.fromRGB(205,42,58),
        PontoB=Color3.fromRGB(215,175,48),
    },
    Esmeralda = {
        Janela=Color3.fromRGB(7,14,10), Cartao=Color3.fromRGB(12,22,16),
        Sidebar=Color3.fromRGB(9,16,12), Topbar=Color3.fromRGB(10,18,14),
        Item=Color3.fromRGB(16,28,20), ItemHover=Color3.fromRGB(22,38,28),
        Borda=Color3.fromRGB(32,62,44), Destaque=Color3.fromRGB(42,210,118),
        DestaqueV=Color3.fromRGB(80,235,148), BotaoFundo=Color3.fromRGB(18,68,40),
        BotaoHover=Color3.fromRGB(24,88,52), BotaoTexto=Color3.fromRGB(168,255,210),
        Sucesso=Color3.fromRGB(42,210,118), Aviso=Color3.fromRGB(215,185,38),
        Perigo=Color3.fromRGB(215,55,55), Info=Color3.fromRGB(55,160,255),
        Texto=Color3.fromRGB(228,248,235), Sub=Color3.fromRGB(108,155,125),
        Fraco=Color3.fromRGB(38,72,52), PontoA=Color3.fromRGB(42,210,118),
        PontoB=Color3.fromRGB(80,235,165),
    },
    Crepusculo = {
        Janela=Color3.fromRGB(12,8,18), Cartao=Color3.fromRGB(20,13,28),
        Sidebar=Color3.fromRGB(14,10,22), Topbar=Color3.fromRGB(16,11,25),
        Item=Color3.fromRGB(28,18,40), ItemHover=Color3.fromRGB(38,25,54),
        Borda=Color3.fromRGB(65,38,90), Destaque=Color3.fromRGB(255,108,168),
        DestaqueV=Color3.fromRGB(255,148,198), BotaoFundo=Color3.fromRGB(88,25,65),
        BotaoHover=Color3.fromRGB(112,35,82), BotaoTexto=Color3.fromRGB(255,210,232),
        Sucesso=Color3.fromRGB(52,205,125), Aviso=Color3.fromRGB(255,185,40),
        Perigo=Color3.fromRGB(220,55,55), Info=Color3.fromRGB(100,165,255),
        Texto=Color3.fromRGB(248,232,245), Sub=Color3.fromRGB(175,130,165),
        Fraco=Color3.fromRGB(78,45,92), PontoA=Color3.fromRGB(255,108,168),
        PontoB=Color3.fromRGB(148,68,255),
    },
    Safira = {
        Janela=Color3.fromRGB(7,10,20), Cartao=Color3.fromRGB(12,16,32),
        Sidebar=Color3.fromRGB(9,12,24), Topbar=Color3.fromRGB(10,14,27),
        Item=Color3.fromRGB(16,22,44), ItemHover=Color3.fromRGB(22,30,60),
        Borda=Color3.fromRGB(30,50,100), Destaque=Color3.fromRGB(60,140,255),
        DestaqueV=Color3.fromRGB(100,175,255), BotaoFundo=Color3.fromRGB(22,55,120),
        BotaoHover=Color3.fromRGB(30,72,155), BotaoTexto=Color3.fromRGB(180,215,255),
        Sucesso=Color3.fromRGB(50,210,120), Aviso=Color3.fromRGB(255,185,35),
        Perigo=Color3.fromRGB(220,55,55), Info=Color3.fromRGB(60,140,255),
        Texto=Color3.fromRGB(228,236,255), Sub=Color3.fromRGB(105,130,190),
        Fraco=Color3.fromRGB(38,52,100), PontoA=Color3.fromRGB(60,140,255),
        PontoB=Color3.fromRGB(100,200,255),
    },
    Rosa = {
        Janela=Color3.fromRGB(16,10,14), Cartao=Color3.fromRGB(26,16,22),
        Sidebar=Color3.fromRGB(20,12,17), Topbar=Color3.fromRGB(22,14,19),
        Item=Color3.fromRGB(36,22,30), ItemHover=Color3.fromRGB(48,28,40),
        Borda=Color3.fromRGB(88,44,66), Destaque=Color3.fromRGB(255,90,180),
        DestaqueV=Color3.fromRGB(255,140,210), BotaoFundo=Color3.fromRGB(95,28,65),
        BotaoHover=Color3.fromRGB(120,38,85), BotaoTexto=Color3.fromRGB(255,215,240),
        Sucesso=Color3.fromRGB(55,210,125), Aviso=Color3.fromRGB(255,190,40),
        Perigo=Color3.fromRGB(220,55,55), Info=Color3.fromRGB(80,165,255),
        Texto=Color3.fromRGB(252,235,248), Sub=Color3.fromRGB(185,130,165),
        Fraco=Color3.fromRGB(88,50,75), PontoA=Color3.fromRGB(255,90,180),
        PontoB=Color3.fromRGB(255,200,80),
    },
    Gelo = {
        Janela=Color3.fromRGB(225,235,248), Cartao=Color3.fromRGB(240,245,255),
        Sidebar=Color3.fromRGB(232,240,252), Topbar=Color3.fromRGB(235,242,255),
        Item=Color3.fromRGB(210,222,242), ItemHover=Color3.fromRGB(198,215,238),
        Borda=Color3.fromRGB(180,200,230), Destaque=Color3.fromRGB(45,120,220),
        DestaqueV=Color3.fromRGB(80,155,240), BotaoFundo=Color3.fromRGB(45,120,220),
        BotaoHover=Color3.fromRGB(60,140,240), BotaoTexto=Color3.fromRGB(255,255,255),
        Sucesso=Color3.fromRGB(30,175,100), Aviso=Color3.fromRGB(210,145,20),
        Perigo=Color3.fromRGB(200,45,45), Info=Color3.fromRGB(45,120,220),
        Texto=Color3.fromRGB(22,35,65), Sub=Color3.fromRGB(80,105,155),
        Fraco=Color3.fromRGB(150,175,210), PontoA=Color3.fromRGB(45,120,220),
        PontoB=Color3.fromRGB(80,200,235), LightMode=true,
    },
    Floresta = {
        Janela=Color3.fromRGB(8,16,10), Cartao=Color3.fromRGB(13,24,15),
        Sidebar=Color3.fromRGB(10,19,12), Topbar=Color3.fromRGB(11,21,13),
        Item=Color3.fromRGB(18,34,20), ItemHover=Color3.fromRGB(25,46,28),
        Borda=Color3.fromRGB(40,75,44), Destaque=Color3.fromRGB(100,210,80),
        DestaqueV=Color3.fromRGB(140,235,115), BotaoFundo=Color3.fromRGB(30,78,24),
        BotaoHover=Color3.fromRGB(40,100,32), BotaoTexto=Color3.fromRGB(185,255,168),
        Sucesso=Color3.fromRGB(100,210,80), Aviso=Color3.fromRGB(225,195,40),
        Perigo=Color3.fromRGB(215,55,55), Info=Color3.fromRGB(60,160,240),
        Texto=Color3.fromRGB(225,248,220), Sub=Color3.fromRGB(110,160,100),
        Fraco=Color3.fromRGB(42,80,38), PontoA=Color3.fromRGB(100,210,80),
        PontoB=Color3.fromRGB(60,220,180),
    },
    Ambar = {
        Janela=Color3.fromRGB(16,12,5), Cartao=Color3.fromRGB(26,20,8),
        Sidebar=Color3.fromRGB(20,15,6), Topbar=Color3.fromRGB(22,17,7),
        Item=Color3.fromRGB(36,27,10), ItemHover=Color3.fromRGB(48,36,14),
        Borda=Color3.fromRGB(88,65,18), Destaque=Color3.fromRGB(255,185,30),
        DestaqueV=Color3.fromRGB(255,215,80), BotaoFundo=Color3.fromRGB(95,68,15),
        BotaoHover=Color3.fromRGB(120,88,20), BotaoTexto=Color3.fromRGB(255,235,160),
        Sucesso=Color3.fromRGB(55,210,125), Aviso=Color3.fromRGB(255,185,30),
        Perigo=Color3.fromRGB(220,60,60), Info=Color3.fromRGB(80,165,255),
        Texto=Color3.fromRGB(252,240,215), Sub=Color3.fromRGB(185,158,90),
        Fraco=Color3.fromRGB(88,65,22), PontoA=Color3.fromRGB(255,185,30),
        PontoB=Color3.fromRGB(235,100,30),
    },
}

Hub.Temas = {}
for k in pairs(paletas) do table.insert(Hub.Temas, k) end
table.sort(Hub.Temas)

local function HueParaCor(h) return Color3.fromHSV(h, 0.55, 0.90) end
local function IniciarRainbow(obj, prop, vel, rodando)
    local t = math.random(0,100)/100
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not rodando() then conn:Disconnect(); return end
        t = (t + dt*(vel or 0.18)) % 1
        pcall(function() obj[prop] = HueParaCor(t) end)
    end)
    return conn
end

function Hub.novo(nome, tema, config)
    config = config or {}
    local self       = setmetatable({}, Hub)
    self._conexoes   = {}
    self._rodando    = true
    self._aoFechar   = nil
    self._fechado    = false
    self._nomeHub    = nome
    self._temaAtual  = tema or "Escuro"

    local _colorRefs = {}
    local function RegCor(obj, prop, chave)
        table.insert(_colorRefs, {obj=obj, prop=prop, key=chave})
    end
    local _gradRefs = {}
    local function RegGrad(grad, k1, k2, rot)
        table.insert(_gradRefs, {grad=grad, k1=k1, k2=k2, rot=rot or 90})
    end

    local C         = paletas[self._temaAtual] or paletas.Escuro
    local isRainbow = C.Rainbow == true
    local _rainbowConns = {}

    local function StopRainbow()
        for _,c in pairs(_rainbowConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
        _rainbowConns = {}
    end
    local function AddRainbow(obj, prop, vel)
        local conn = IniciarRainbow(obj, prop, vel, function() return self._rodando end)
        table.insert(_rainbowConns, conn); return conn
    end

    local gui = Instance.new("ScreenGui")
    gui.Name="HubUI_v71"; gui.ResetOnSpawn=false
    gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset=true
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    self.Gui = gui

    local vp       = workspace.CurrentCamera.ViewportSize
    local TOPBAR_H = 48
    local SIDEBAR_W_FULL = IS_MOBILE and 100 or 162
    local SIDEBAR_W_MIN  = IS_MOBILE and 44 or 48

    local JANELA_W, JANELA_H
    if IS_MOBILE then
        JANELA_W = math.max(math.min(vp.X - 16, 660), 380)
        JANELA_H = math.max(math.min(vp.Y - 80, 430), 300)
    else
        JANELA_W = config.largura or 780
        JANELA_H = config.altura  or 520
    end

    local ALTURA_CHEIA = JANELA_H
    local ALTURA_MIN   = TOPBAR_H
    local posCenter    = UDim2.new(0.5,-JANELA_W/2, 0.5,-JANELA_H/2)

    local janela = F({
        Name="Janela",
        Size=UDim2.new(0,JANELA_W,0,ALTURA_CHEIA),
        Position=UDim2.new(0.5,-JANELA_W/2, 0.5,-JANELA_H/2+28),
        BackgroundColor3=C.Janela, Active=true, ClipsDescendants=false, Parent=gui,
    })
    Cantos(janela, 16)
    local bordaJanela = Stroke(janela, C.Borda, 1.2, 0.15)
    RegCor(janela,"BackgroundColor3","Janela"); RegCor(bordaJanela,"Color","Borda")
    self.Janela = janela

    local shadow = F({
        Size=UDim2.new(1,32,1,32), Position=UDim2.new(0,-16,0,-12),
        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.65,
        ZIndex=-1, Parent=janela,
    })
    Cantos(shadow, 20)
    do local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
       g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(1,1)}); g.Rotation=90; g.Parent=shadow end

    local linhaTop = F({Size=UDim2.new(0.5,0,0,3),Position=UDim2.new(0.25,0,0,0),
        BackgroundColor3=C.Destaque,ZIndex=12,Parent=janela})
    Cantos(linhaTop,99); RegCor(linhaTop,"BackgroundColor3","Destaque")
    local linhaTopGrad = Grad(linhaTop,C.DestaqueV,C.Destaque,0)
    RegGrad(linhaTopGrad,"DestaqueV","Destaque",0)

    Tw(janela,0.45,{Position=posCenter},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()

    local topbar = F({Size=UDim2.new(1,0,0,TOPBAR_H),BackgroundColor3=C.Topbar,ZIndex=10,Parent=janela})
    Cantos(topbar,16); RegCor(topbar,"BackgroundColor3","Topbar")
    F({Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,1,-16),BackgroundColor3=C.Topbar,ZIndex=10,Parent=topbar})
    local linhaSep = F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Borda,ZIndex=11,Parent=topbar})
    RegCor(linhaSep,"BackgroundColor3","Borda")

    local ponto = F({Size=UDim2.new(0,9,0,9),Position=UDim2.new(0,18,0.5,-4),
        BackgroundColor3=C.PontoA,ZIndex=12,Parent=topbar})
    Cantos(ponto,99); RegCor(ponto,"BackgroundColor3","PontoA")
    local pontoGlow = F({Size=UDim2.new(0,18,0,18),Position=UDim2.new(0,13,0.5,-9),
        BackgroundColor3=C.PontoA,BackgroundTransparency=0.75,ZIndex=11,Parent=topbar})
    Cantos(pontoGlow,99); RegCor(pontoGlow,"BackgroundColor3","PontoA")

    if isRainbow then
        AddRainbow(ponto,"BackgroundColor3",0.25)
        AddRainbow(pontoGlow,"BackgroundColor3",0.25)
        AddRainbow(linhaTop,"BackgroundColor3",0.12)
    else
        task.spawn(function()
            while self._rodando do
                Tw(ponto,1.1,{BackgroundColor3=C.PontoB}):Play()
                Tw(pontoGlow,1.1,{BackgroundColor3=C.PontoB,BackgroundTransparency=0.6}):Play()
                task.wait(1.1)
                Tw(ponto,1.1,{BackgroundColor3=C.PontoA}):Play()
                Tw(pontoGlow,1.1,{BackgroundColor3=C.PontoA,BackgroundTransparency=0.75}):Play()
                task.wait(1.1)
            end
        end)
    end

    local BW = IS_MOBILE and 32 or 28
    local BH = IS_MOBILE and 32 or 28

    local lblNome = L({
        Size=UDim2.new(1,-(BW*2+64),1,0), Position=UDim2.new(0,36,0,0),
        Text=nome, TextColor3=C.Texto, Font=Enum.Font.GothamBold, TextSize=IS_MOBILE and 14 or 15,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12, Parent=topbar,
    })
    RegCor(lblNome,"TextColor3","Texto")

    local lblVer = L({
        Size=UDim2.new(0,60,0,14), Position=UDim2.new(0,36,0.5,4),
        Text="v7.1", TextColor3=C.Fraco, Font=Enum.Font.Gotham, TextSize=9,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12, Parent=topbar,
    })
    RegCor(lblVer,"TextColor3","Fraco")

    local btnMin = Instance.new("TextButton")
    btnMin.Size=UDim2.new(0,BW,0,BH); btnMin.Position=UDim2.new(1,-(BW*2+16),0.5,-BH/2)
    btnMin.Text="–"; btnMin.Font=Enum.Font.GothamBold; btnMin.TextSize=16
    btnMin.TextColor3=C.Sub; btnMin.BackgroundColor3=C.Item
    btnMin.AutoButtonColor=false; btnMin.ZIndex=12; btnMin.Parent=topbar
    Cantos(btnMin,99); RegCor(btnMin,"BackgroundColor3","Item"); RegCor(btnMin,"TextColor3","Sub")
    Stroke(btnMin,C.Borda,1,0.5)

    local btnX = Instance.new("TextButton")
    btnX.Size=UDim2.new(0,BW,0,BH); btnX.Position=UDim2.new(1,-(BW+8),0.5,-BH/2)
    btnX.Text="✕"; btnX.Font=Enum.Font.GothamBold; btnX.TextSize=12
    btnX.TextColor3=Color3.new(1,1,1); btnX.BackgroundColor3=C.Perigo
    btnX.AutoButtonColor=false; btnX.ZIndex=12; btnX.Parent=topbar
    Cantos(btnX,99); RegCor(btnX,"BackgroundColor3","Perigo")

    btnMin.MouseEnter:Connect(function() Tw(btnMin,0.12,{BackgroundColor3=C.ItemHover,TextColor3=C.Texto}):Play() end)
    btnMin.MouseLeave:Connect(function() Tw(btnMin,0.12,{BackgroundColor3=C.Item,TextColor3=C.Sub}):Play() end)
    btnMin.MouseButton1Down:Connect(function() Tw(btnMin,0.06,{Size=UDim2.new(0,BW-3,0,BH-3)}):Play() end)
    btnMin.MouseButton1Up:Connect(function() Tw(btnMin,0.1,{Size=UDim2.new(0,BW,0,BH)},Enum.EasingStyle.Back):Play() end)
    btnX.MouseEnter:Connect(function() Tw(btnX,0.12,{BackgroundColor3=Color3.fromRGB(255,80,80),Size=UDim2.new(0,BW+3,0,BH+3)}):Play() end)
    btnX.MouseLeave:Connect(function() Tw(btnX,0.12,{BackgroundColor3=C.Perigo,Size=UDim2.new(0,BW,0,BH)}):Play() end)
    btnX.MouseButton1Down:Connect(function() Tw(btnX,0.07,{Size=UDim2.new(0,BW-3,0,BH-3)}):Play() end)
    btnX.MouseButton1Up:Connect(function() Tw(btnX,0.1,{Size=UDim2.new(0,BW,0,BH)}):Play() end)

    local corpoJanela = F({
        Size=UDim2.new(1,0,1,-TOPBAR_H), Position=UDim2.new(0,0,0,TOPBAR_H),
        BackgroundTransparency=1, ClipsDescendants=true, Parent=janela,
    })

    local minimizado = false
    local function AtualizarMinimizado()
        if minimizado then
            corpoJanela.Visible=false; linhaSep.Visible=false
            Tw(janela,0.22,{Size=UDim2.new(0,JANELA_W,0,ALTURA_MIN)}):Play()
            btnMin.Text="+"
        else
            Tw(janela,0.3,{Size=UDim2.new(0,JANELA_W,0,ALTURA_CHEIA)},
            Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
            btnMin.Text="–"; linhaSep.Visible=true
            task.delay(0.3,function() if not minimizado then corpoJanela.Visible=true end end)
        end
    end
    btnMin.MouseButton1Click:Connect(function() minimizado=not minimizado; AtualizarMinimizado() end)

    local drag, dragStart, posStart = false, nil, nil
    local SNAP_MARGIN = 12

    local function SnapPos(px, py)
        local sw, sh = vp.X, vp.Y
        local jw = JANELA_W; local jh = minimizado and ALTURA_MIN or ALTURA_CHEIA
        if px < SNAP_MARGIN then px = 0
        elseif px + jw > sw - SNAP_MARGIN then px = sw - jw end
        if py < SNAP_MARGIN then py = 0
        elseif py + jh > sh - SNAP_MARGIN then py = sh - jh end
        return px, py
    end

    local dragArea
    if IS_MOBILE then
        dragArea = Instance.new("TextButton")
        dragArea.Size=UDim2.new(1,-(BW*2+60),1,0); dragArea.Position=UDim2.new(0,36,0,0)
        dragArea.BackgroundTransparency=1; dragArea.Text=""; dragArea.AutoButtonColor=false
        dragArea.ZIndex=11; dragArea.Parent=topbar
    else
        dragArea = topbar
    end

    local function IniciarDrag(pos) drag=true; dragStart=pos; posStart=janela.Position end
    local function AtualizarDrag(pos)
        if not drag then return end
        local d=pos-dragStart
        local nx = posStart.X.Offset+d.X
        local ny = posStart.Y.Offset+d.Y
        nx, ny = SnapPos(nx, ny)
        janela.Position=UDim2.new(0,nx,0,ny)
    end
    local function EncerrarDrag() drag=false end

    dragArea.InputBegan:Connect(function(e)
        if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
            IniciarDrag(e.Position)
        end
    end)
    dragArea.InputChanged:Connect(function(e)
        if e.UserInputType==Enum.UserInputType.MouseMovement or e.UserInputType==Enum.UserInputType.Touch then
            AtualizarDrag(e.Position)
        end
    end)
    dragArea.InputEnded:Connect(function(e)
        if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
            EncerrarDrag()
        end
    end)
    table.insert(self._conexoes, EntradaUsuario.InputChanged:Connect(function(e)
        if e.UserInputType==Enum.UserInputType.MouseMovement or e.UserInputType==Enum.UserInputType.Touch then
            AtualizarDrag(e.Position)
        end
    end))
    table.insert(self._conexoes, EntradaUsuario.InputEnded:Connect(function(e)
        if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
            EncerrarDrag()
        end
    end))

    local function Fechar(pararConexoes)
        if self._fechado then return end
        self._fechado=true; self._rodando=false; StopRainbow()
        if pararConexoes~=false then
            for _,c in pairs(self._conexoes) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
        end
        if self._aoFechar then pcall(self._aoFechar) end
        Tw(janela,0.22,{
            Position=UDim2.new(janela.Position.X.Scale,janela.Position.X.Offset,
                               janela.Position.Y.Scale,janela.Position.Y.Offset+30),
            BackgroundTransparency=1,
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Play()
        task.delay(0.25, function() if gui and gui.Parent then gui:Destroy() end end)
    end
    btnX.MouseButton1Click:Connect(function() Fechar(true) end)

    function self:AoFechar(fn) self._aoFechar=fn end
    function self:Fechar(p) Fechar(p) end
    function self:RegistrarConexao(c) table.insert(self._conexoes,c); return c end
    function self:Destruir() Fechar(true) end

    -- ═══════════════════ NOTIFICAÇÕES ════════════════════════════════════════
    --[[
        janela:Notificar(titulo, mensagem, tipo, duracao, opcoes)
    
        tipo: "sucesso" | "erro" | "aviso" | "info" | "custom"
        duracao: segundos (nil = 3.5)
        opcoes (tabela opcional):
          semAuto   = true         → não some automaticamente
          icone     = "🔥"         → ícone personalizado
          cor       = Color3       → cor personalizada
          aoClicar  = function()   → função ao clicar no card
          acoes     = {            → botões de escolha
            {label="Sim",   fn=function() ... end},
            {label="Não",   fn=function() ... end},
          }
    
        Exemplo com escolha:
          janela:Notificar("Confirmar", "Deseja continuar?", "aviso", nil, {
              semAuto = true,
              acoes = {
                  {label="Sim", fn=function() print("confirmou") end},
                  {label="Não", fn=function() print("cancelou") end},
              }
          })
    ]]

    local NOTIF_W     = IS_MOBILE and math.min(JANELA_W - 20, 270) or 345
    local NOTIF_MAX   = 7
    local NOTIF_GAP   = 7
    local NOTIF_PAD_B = IS_MOBILE and 8 or 12

    local NOTIF_TIPOS = {
        sucesso = { icone="✓", cor=Color3.fromRGB(56,215,140), corV=Color3.fromRGB(105,240,175), corD=Color3.fromRGB(30,160,95),  bg1=Color3.fromRGB(8,30,18),  bg2=Color3.fromRGB(13,42,26) },
        erro    = { icone="✕", cor=Color3.fromRGB(235,70,70),  corV=Color3.fromRGB(255,115,115), corD=Color3.fromRGB(175,38,38),  bg1=Color3.fromRGB(28,8,8),   bg2=Color3.fromRGB(42,13,13) },
        aviso   = { icone="!",  cor=Color3.fromRGB(255,195,45), corV=Color3.fromRGB(255,225,110), corD=Color3.fromRGB(195,140,15), bg1=Color3.fromRGB(28,22,4),  bg2=Color3.fromRGB(42,32,8)  },
        info    = { icone="i",  cor=Color3.fromRGB(75,165,255), corV=Color3.fromRGB(130,200,255), corD=Color3.fromRGB(40,110,200), bg1=Color3.fromRGB(6,18,38),  bg2=Color3.fromRGB(10,26,54) },
        custom  = { icone="★",  cor=Color3.fromRGB(255,200,50), corV=Color3.fromRGB(255,230,120), corD=Color3.fromRGB(200,150,10), bg1=Color3.fromRGB(28,22,5),  bg2=Color3.fromRGB(42,33,8)  },
    }

    local notifFila = {}

    local notifHolder = F({
        Size=UDim2.new(0,NOTIF_W,1,-20),
        Position=UDim2.new(1,-(NOTIF_W+12),0,10),
        BackgroundTransparency=1, ZIndex=300, Parent=gui,
    })

    local function ReposicionarFila()
        local baseY = notifHolder.AbsoluteSize.Y - NOTIF_PAD_B
        for i = #notifFila, 1, -1 do
            local e = notifFila[i]
            baseY = baseY - e.altura
            local targetOffsetY = baseY - notifHolder.AbsoluteSize.Y
            Tw(e.card, 0.32, {Position=UDim2.new(0,0,1,targetOffsetY)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
            baseY = baseY - NOTIF_GAP
        end
    end

    local function DispensarCard(card, cardBrd, imediato)
        for i, e in ipairs(notifFila) do
            if e.card==card then table.remove(notifFila,i); break end
        end
        ReposicionarFila()
        local t = imediato and 0.10 or 0.28
        Tw(card, t, {
            Position=UDim2.new(0,NOTIF_W+30,card.Position.Y.Scale,card.Position.Y.Offset),
            BackgroundTransparency=1,
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Play()
        if cardBrd then Tw(cardBrd, t, {Transparency=1}):Play() end
        task.delay(t+0.05, function()
            if card and card.Parent then card:Destroy() end
        end)
    end

    function self:Notificar(titulo, mensagem, tipo, duracao, opcoes)
        tipo    = tipo    or "info"
        duracao = duracao or 3.5
        opcoes  = opcoes  or {}
        local cfg = NOTIF_TIPOS[tipo] or NOTIF_TIPOS.info

        local aoClicar  = opcoes.aoClicar
        local acoes     = opcoes.acoes
        local semAuto   = opcoes.semAuto
        local icCustom  = opcoes.icone
        local corCustom = opcoes.cor

        if corCustom then
            cfg = {
                icone=cfg.icone, cor=corCustom,
                corV=Brilhar(corCustom,0.12), corD=Escurecer(corCustom,0.12),
                bg1=Escurecer(corCustom,0.28), bg2=Escurecer(corCustom,0.22),
            }
        end

        if #notifFila >= NOTIF_MAX then
            local oldest = notifFila[1]
            if oldest then DispensarCard(oldest.card, oldest.brd, true) end
        end

        local icSize  = IS_MOBILE and 28 or 32
        local minH    = IS_MOBILE and 58 or 68
        local acaoH   = (acoes and #acoes>0) and (IS_MOBILE and 34 or 30) or 0

        local card = Instance.new("TextButton")
        card.Size=UDim2.new(1,0,0,minH)
        card.Position=UDim2.new(0,NOTIF_W+28,1,-(minH+NOTIF_PAD_B))
        card.BackgroundColor3=cfg.bg2
        card.AutoButtonColor=false; card.ClipsDescendants=true
        card.ZIndex=301; card.Text=""; card.Parent=notifHolder
        Cantos(card,14)

        do
            local g=Instance.new("UIGradient")
            g.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,cfg.bg1),
                ColorSequenceKeypoint.new(0.6,cfg.bg2),
                ColorSequenceKeypoint.new(1,Lerp3(cfg.bg2,cfg.cor,0.06)),
            }); g.Rotation=135; g.Parent=card
        end

        local cardBrd = Stroke(card,cfg.cor,1,0.25)

        local lateral = F({
            Size=UDim2.new(0,3,1,-10), Position=UDim2.new(0,1,0,5),
            BackgroundColor3=cfg.cor, ZIndex=308, Parent=card,
        })
        Cantos(lateral,99)
        task.spawn(function()
            local alive=true; card.AncestryChanged:Connect(function() alive=false end)
            while alive and card.Parent do
                Tw(lateral,1.2,{BackgroundColor3=cfg.corV}):Play(); task.wait(1.2)
                if not alive or not card.Parent then break end
                Tw(lateral,1.2,{BackgroundColor3=cfg.corD}):Play(); task.wait(1.2)
            end
        end)

        local halo2=F({Size=UDim2.new(0,icSize+26,0,icSize+26),Position=UDim2.new(0,14,0.5,-(icSize+26)/2),
            BackgroundColor3=cfg.cor,BackgroundTransparency=0.86,ZIndex=302,Parent=card}); Cantos(halo2,99)
        local halo1=F({Size=UDim2.new(0,icSize+14,0,icSize+14),Position=UDim2.new(0,20,0.5,-(icSize+14)/2),
            BackgroundColor3=cfg.cor,BackgroundTransparency=0.76,ZIndex=303,Parent=card}); Cantos(halo1,99)
        local ic=F({Size=UDim2.new(0,icSize,0,icSize),Position=UDim2.new(0,26,0.5,-icSize/2),
            BackgroundColor3=cfg.cor,ZIndex=305,Parent=card}); Cantos(ic,99)
        Stroke(ic,cfg.corV,1,0.35)
        Grad(ic,cfg.corV,cfg.corD,135)

        if icCustom then
            L({Size=UDim2.new(1,0,1,0),Text=icCustom,TextColor3=Color3.new(1,1,1),
                Font=Enum.Font.GothamBold,TextSize=IS_MOBILE and 13 or 15,ZIndex=308,Parent=ic})
        elseif tipo=="erro" then
            local sp=3; local cmp=IS_MOBILE and 13 or 15
            F({Size=UDim2.new(0,cmp,0,sp),Position=UDim2.new(0.5,-cmp/2,0.5,-sp/2),
                BackgroundColor3=Color3.new(1,1,1),Rotation=45,ZIndex=308,Parent=ic})
            F({Size=UDim2.new(0,cmp,0,sp),Position=UDim2.new(0.5,-cmp/2,0.5,-sp/2),
                BackgroundColor3=Color3.new(1,1,1),Rotation=-45,ZIndex=308,Parent=ic})
        else
            L({Size=UDim2.new(1,0,1,0),Text=icCustom or cfg.icone,TextColor3=Color3.new(1,1,1),
                Font=Enum.Font.GothamBold,TextSize=IS_MOBILE and 14 or 16,ZIndex=308,Parent=ic})
        end

        local txtX    = 26+icSize+13
        local txtMaxW = -(txtX+16)

        local lblTitulo=L({Size=UDim2.new(1,txtMaxW,0,16),Position=UDim2.new(0,txtX,0,0),
            Text=titulo,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,
            TextSize=IS_MOBILE and 12 or 13,TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=306,Parent=card})
        local lblMsg=L({Size=UDim2.new(1,txtMaxW,0,14),Position=UDim2.new(0,txtX,0,0),
            Text=mensagem or "",TextColor3=cfg.corV,Font=Enum.Font.Gotham,
            TextSize=IS_MOBILE and 10 or 11,TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=306,Parent=card})

        local progBg=F({Size=UDim2.new(1,-4,0,3),Position=UDim2.new(0,2,1,-4),
            BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.50,ZIndex=307,Parent=card})
        Cantos(progBg,99)
        local prog=F({Size=UDim2.new(1,0,1,0),BackgroundColor3=cfg.cor,ZIndex=308,Parent=progBg})
        Cantos(prog,99)
        Grad(prog,cfg.corD,cfg.corV,0)

        local btnClose=Instance.new("TextButton")
        btnClose.Size=UDim2.new(0,20,0,20); btnClose.Position=UDim2.new(1,-24,0,6)
        btnClose.BackgroundTransparency=1; btnClose.Text="×"
        btnClose.Font=Enum.Font.GothamBold; btnClose.TextSize=14
        btnClose.TextColor3=Color3.new(1,1,1); btnClose.TextTransparency=1
        btnClose.AutoButtonColor=false; btnClose.ZIndex=315; btnClose.Parent=card
        Cantos(btnClose,99)
        local closeBrd=Stroke(btnClose,Color3.new(1,1,1),1,1)

        if acoes and #acoes>0 then
            local totalBtns=math.min(#acoes,2); local gap2=6
            local btnW=(NOTIF_W-txtX-16-(totalBtns-1)*gap2)/totalBtns
            for i,acao in ipairs(acoes) do
                if i>2 then break end
                local bx=txtX+(i-1)*(btnW+gap2); local isPrimary=(i==1)
                local ab=Instance.new("TextButton")
                ab.Size=UDim2.new(0,btnW,0,acaoH-7); ab.Position=UDim2.new(0,bx,1,-(acaoH-1))
                ab.BackgroundColor3=isPrimary and cfg.cor or Color3.fromRGB(28,28,42)
                ab.TextColor3=isPrimary and Color3.fromRGB(8,8,16) or cfg.corV
                ab.Text=acao.label or "OK"; ab.Font=Enum.Font.GothamBold
                ab.TextSize=IS_MOBILE and 10 or 11; ab.AutoButtonColor=false
                ab.ZIndex=312; ab.Parent=card; Cantos(ab,7)
                if not isPrimary then Stroke(ab,cfg.cor,1,0.55) end
                ab.MouseButton1Click:Connect(function()
                    if acao.fn then pcall(acao.fn) end
                    DispensarCard(card,cardBrd)
                end)
            end
        end

        card.MouseEnter:Connect(function()
            Tw(card,0.14,{BackgroundColor3=Lerp3(cfg.bg2,cfg.cor,0.04)}):Play()
            Tw(cardBrd,0.14,{Transparency=0.05}):Play()
            Tw(btnClose,0.14,{TextTransparency=0}):Play()
            Tw(closeBrd,0.14,{Transparency=0.4}):Play()
        end)
        card.MouseLeave:Connect(function()
            Tw(card,0.18,{BackgroundColor3=cfg.bg2}):Play()
            Tw(cardBrd,0.18,{Transparency=0.25}):Play()
            Tw(btnClose,0.14,{TextTransparency=1}):Play()
            Tw(closeBrd,0.14,{Transparency=1}):Play()
        end)
        card.MouseButton1Click:Connect(function()
            if aoClicar then pcall(aoClicar); DispensarCard(card,cardBrd) end
        end)
        btnClose.MouseEnter:Connect(function()
            Tw(btnClose,0.1,{BackgroundColor3=Color3.fromRGB(220,60,60),BackgroundTransparency=0}):Play()
            Tw(closeBrd,0.1,{Transparency=1}):Play()
        end)
        btnClose.MouseLeave:Connect(function()
            Tw(btnClose,0.1,{BackgroundTransparency=1}):Play()
        end)
        btnClose.MouseButton1Click:Connect(function() DispensarCard(card,cardBrd) end)

        local entrada={card=card,brd=cardBrd,altura=minH}
        table.insert(notifFila,entrada)

        task.defer(function()
            if not card.Parent then return end
            local topPad=IS_MOBILE and 9 or 11; local gap=4; local botPad=IS_MOBILE and 11 or 14
            local altTit=lblTitulo.TextBounds.Y; local altMsg=lblMsg.TextBounds.Y
            local altTotal=math.max(topPad+altTit+gap+altMsg+botPad+4+acaoH, minH)
            card.Size=UDim2.new(1,0,0,altTotal); entrada.altura=altTotal

            local midY=(altTotal-acaoH)/2
            ic.Position=UDim2.new(0,26,0,midY-icSize/2)
            halo1.Position=UDim2.new(0,20,0,midY-(icSize+14)/2)
            halo2.Position=UDim2.new(0,14,0,midY-(icSize+26)/2)
            lblTitulo.Position=UDim2.new(0,txtX,0,topPad)
            lblMsg.Position=UDim2.new(0,txtX,0,topPad+altTit+gap)

            ReposicionarFila()
            Tw(card,0.42,{Position=UDim2.new(0,0,card.Position.Y.Scale,card.Position.Y.Offset)},
            Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()

            ic.Size=UDim2.new(0,0,0,0)
            task.delay(0.2,function()
                if not ic.Parent then return end
                Tw(ic,0.22,{Size=UDim2.new(0,icSize+8,0,icSize+8)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
                task.delay(0.22,function()
                    if not ic.Parent then return end
                    Tw(ic,0.14,{Size=UDim2.new(0,icSize,0,icSize)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
                end)
            end)

            if not semAuto then
                Tw(prog,duracao,{Size=UDim2.new(0,0,1,0)},Enum.EasingStyle.Linear):Play()
                task.delay(duracao,function()
                    if card and card.Parent then DispensarCard(card,cardBrd) end
                end)
            else
                progBg.Visible=false
            end
        end)
    end

    -- ═══════════════════ SIDEBAR + ABAS ══════════════════════════════════════

    local pagArea
    local scrollTabs
    local SW = SIDEBAR_W_FULL
    local _todasTabsRef = nil

    local sidebar = F({
        Size=UDim2.new(0,SW,1,0),
        BackgroundColor3=C.Sidebar, Parent=corpoJanela,
    })
    RegCor(sidebar,"BackgroundColor3","Sidebar")
    Cantos(sidebar,12)
    F({Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=C.Sidebar,Parent=sidebar})

    local divSide = F({Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=C.Borda,ZIndex=3,Parent=sidebar})
    RegCor(divSide,"BackgroundColor3","Borda")

    local btnCollapse
    if not IS_MOBILE then
        btnCollapse = Instance.new("TextButton")
        btnCollapse.Size=UDim2.new(0,20,0,20)
        btnCollapse.Position=UDim2.new(1,-24,0,9)
        btnCollapse.BackgroundColor3=C.Item; btnCollapse.Text="‹"
        btnCollapse.Font=Enum.Font.GothamBold; btnCollapse.TextSize=14
        btnCollapse.TextColor3=C.Sub; btnCollapse.AutoButtonColor=false
        btnCollapse.ZIndex=5; btnCollapse.Parent=sidebar
        Cantos(btnCollapse,6)
        Stroke(btnCollapse,C.Borda,1,0.5)
        RegCor(btnCollapse,"BackgroundColor3","Item"); RegCor(btnCollapse,"TextColor3","Sub")
    end

    local topOffsetSidebar = IS_MOBILE and 8 or 40
    if not IS_MOBILE then
        local lblNav=L({
            Size=UDim2.new(1,-28,0,22), Position=UDim2.new(0,8,0,10),
            Text="MENU", TextColor3=C.Destaque, Font=Enum.Font.GothamBold,
            TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3, Parent=sidebar,
        })
        RegCor(lblNav,"TextColor3","Destaque")
        local linhMenu=F({Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,0,34),BackgroundColor3=C.Borda,ZIndex=3,Parent=sidebar})
        RegCor(linhMenu,"BackgroundColor3","Borda")
    end

    scrollTabs = Instance.new("ScrollingFrame")
    scrollTabs.Size=UDim2.new(1,0,1,-topOffsetSidebar)
    scrollTabs.Position=UDim2.new(0,0,0,topOffsetSidebar)
    scrollTabs.CanvasSize=UDim2.new(0,0,0,0)
    scrollTabs.ScrollBarThickness=0
    scrollTabs.BackgroundTransparency=1
    scrollTabs.BorderSizePixel=0
    scrollTabs.ScrollingDirection=Enum.ScrollingDirection.Y
    scrollTabs.Parent=sidebar
    Pad(scrollTabs,6,10,IS_MOBILE and 4 or 6,IS_MOBILE and 4 or 6)
    local lyT=Instance.new("UIListLayout",scrollTabs)
    lyT.Padding=UDim.new(0,IS_MOBILE and 4 or 5)
    lyT.HorizontalAlignment=Enum.HorizontalAlignment.Center
    lyT:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollTabs.CanvasSize=UDim2.new(0,0,0,lyT.AbsoluteContentSize.Y+20)
    end)

    pagArea=F({
        Size=UDim2.new(1,-(SW+6),1,-10),
        Position=UDim2.new(0,SW+2,0,5),
        BackgroundTransparency=1, Parent=corpoJanela,
    })

    if btnCollapse then
        local collapsed=false
        btnCollapse.MouseButton1Click:Connect(function()
            collapsed=not collapsed
            local targetW = collapsed and SIDEBAR_W_MIN or SIDEBAR_W_FULL
            Tw(sidebar,0.25,{Size=UDim2.new(0,targetW,1,0)},Enum.EasingStyle.Quart):Play()
            Tw(pagArea,0.25,{
                Size=UDim2.new(1,-(targetW+6),1,-10),
                Position=UDim2.new(0,targetW+2,0,5),
            },Enum.EasingStyle.Quart):Play()
            btnCollapse.Text=collapsed and "›" or "‹"
            SW=targetW
        end)
        btnCollapse.MouseEnter:Connect(function() Tw(btnCollapse,0.1,{BackgroundColor3=C.ItemHover}):Play() end)
        btnCollapse.MouseLeave:Connect(function() Tw(btnCollapse,0.1,{BackgroundColor3=C.Item}):Play() end)
    end

    local todasTabs = {}
    local tabAtiva  = nil
    _todasTabsRef   = todasTabs

    local function AtivarAba(e)
        if tabAtiva==e then return end
        tabAtiva=e
        for _,t in ipairs(todasTabs) do
            local ok=(t==e)
            t._ativo=ok
            t.pagina.Visible=ok
            if ok then
                Tw(t.btn,0.2,{BackgroundColor3=C.Destaque},Enum.EasingStyle.Quart):Play()
                Tw(t.lbl,0.2,{TextColor3=Color3.new(1,1,1)}):Play()
                if t.ico then Tw(t.ico,0.2,{TextColor3=Color3.new(1,1,1)}):Play() end
                t.lbl.Font=Enum.Font.GothamBold
                if t.ind then t.ind.BackgroundTransparency=0; Tw(t.ind,0.22,{Size=UDim2.new(0,3,0.7,0)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play() end
                if t.glow then t.glow.BackgroundTransparency=0.82; Tw(t.glow,0.35,{BackgroundTransparency=1}):Play() end
            else
                Tw(t.btn,0.18,{BackgroundColor3=C.Item}):Play()
                Tw(t.lbl,0.18,{TextColor3=C.Sub}):Play()
                if t.ico then Tw(t.ico,0.18,{TextColor3=C.Fraco}):Play() end
                t.lbl.Font=Enum.Font.Gotham
                if t.ind then Tw(t.ind,0.15,{Size=UDim2.new(0,3,0,0)}):Play()
                    task.delay(0.15,function() if not t._ativo then t.ind.BackgroundTransparency=1 end end) end
            end
        end
    end

    function self:MudarTemaPara(novoTema)
        local P=paletas[novoTema]
        if not P then warn("HubUI: tema '"..tostring(novoTema).."' não existe."); return end
        self._temaAtual=novoTema; C=P; isRainbow=C.Rainbow==true; StopRainbow()
        for _,ref in pairs(_colorRefs) do
            if ref.obj and ref.obj.Parent then
                local cor=P[ref.key]
                if cor then pcall(function() ref.obj[ref.prop]=cor end) end
            end
        end
        for _,gref in pairs(_gradRefs) do
            if gref.grad and gref.grad.Parent then
                local c1=P[gref.k1]; local c2=P[gref.k2]
                if c1 and c2 then pcall(function() gref.grad.Color=ColorSequence.new(c1,c2) end) end
            end
        end
        if isRainbow then
            AddRainbow(ponto,"BackgroundColor3",0.25)
            AddRainbow(pontoGlow,"BackgroundColor3",0.25)
            AddRainbow(linhaTop,"BackgroundColor3",0.12)
        end
        if _todasTabsRef then
            for _,t in pairs(_todasTabsRef) do
                if t._ativo then
                    pcall(function()
                        t.btn.BackgroundColor3=C.Destaque
                        t.lbl.TextColor3=Color3.new(1,1,1)
                        if t.ico then t.ico.TextColor3=Color3.new(1,1,1) end
                    end)
                else
                    pcall(function()
                        t.btn.BackgroundColor3=C.Item
                        t.lbl.TextColor3=C.Sub
                        if t.ico then t.ico.TextColor3=C.Fraco end
                    end)
                end
            end
        end
        self:Notificar("Tema","Alterado para "..novoTema,"info",2.5)
    end

    local hubSelf = self

    -- ═══════════════════ CriarAba ════════════════════════════════════════════
    --[[
        local aba = janela:CriarAba(nome, icone, badge)
    
        nome   = "Configurações"   (texto da aba)
        icone  = "⚙️"              (emoji/texto, pode ser nil)
        badge  = 5                 (número no badge, pode ser nil)
    
        Retorna um objeto "aba" com todos os métodos de criação de elementos.
        Use aba:AtualizarBadge(n) para atualizar o badge pelo código.
    ]]

    function self:CriarAba(nomeAba, icone, badge)
        local BTN_H = IS_MOBILE and 40 or 42

        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,0,BTN_H)
        btn.BackgroundColor3=C.Item; btn.Text=""
        btn.AutoButtonColor=false; btn.ClipsDescendants=false
        btn.ZIndex=2; btn.Parent=scrollTabs
        Cantos(btn,9); RegCor(btn,"BackgroundColor3","Item")
        local btnBrd=Stroke(btn,C.Borda,1,0.6); RegCor(btnBrd,"Color","Borda")

        local ind=F({Size=UDim2.new(0,3,0,0),Position=UDim2.new(0,-1,0.5,0),
            AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=C.Destaque,
            BackgroundTransparency=1,ZIndex=4,Parent=btn})
        Cantos(ind,99); RegCor(ind,"BackgroundColor3","Destaque")

        local glow=F({Size=UDim2.new(1,0,1,0),BackgroundColor3=C.Destaque,
            BackgroundTransparency=1,ZIndex=3,Parent=btn})
        Cantos(glow,9); RegCor(glow,"BackgroundColor3","Destaque")

        local ico=nil; local lblX=10
        if icone then
            ico=L({Size=UDim2.new(0,22,1,0),Position=UDim2.new(0,8,0,0),
                Text=icone,TextColor3=C.Fraco,Font=Enum.Font.GothamBold,
                TextSize=IS_MOBILE and 15 or 16,ZIndex=3,Parent=btn})
            RegCor(ico,"TextColor3","Fraco"); lblX=IS_MOBILE and 32 or 34
        end

        local lbl=L({Size=UDim2.new(1,-(lblX+8),1,0),Position=UDim2.new(0,lblX,0,0),
            Text=nomeAba,TextColor3=C.Sub,Font=Enum.Font.Gotham,
            TextSize=IS_MOBILE and 11 or 12,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=3,Parent=btn})
        RegCor(lbl,"TextColor3","Sub")

        local badgeFr=nil; local badgeLbl2=nil
        if badge then
            badgeFr=F({Size=UDim2.new(0,18,0,14),Position=UDim2.new(1,-22,0.5,-7),
                BackgroundColor3=C.Perigo,ZIndex=5,Parent=btn})
            Cantos(badgeFr,99); RegCor(badgeFr,"BackgroundColor3","Perigo")
            badgeLbl2=L({Size=UDim2.new(1,0,1,0),Text=tostring(badge),
                TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,
                TextSize=8,ZIndex=6,Parent=badgeFr})
        end

        btn.MouseEnter:Connect(function()
            if tabAtiva and tabAtiva.btn~=btn then
                Tw(btn,0.12,{BackgroundColor3=C.ItemHover}):Play()
                Tw(btnBrd,0.12,{Transparency=0.3}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if tabAtiva and tabAtiva.btn~=btn then
                Tw(btn,0.12,{BackgroundColor3=C.Item}):Play()
                Tw(btnBrd,0.12,{Transparency=0.6}):Play()
            end
        end)
        btn.MouseButton1Down:Connect(function()
            Tw(btn,0.07,{Size=UDim2.new(1,-4,0,BTN_H-2)}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            Tw(btn,0.12,{Size=UDim2.new(1,0,0,BTN_H)}):Play()
        end)

        local pagina=Instance.new("ScrollingFrame")
        pagina.Size=UDim2.new(1,0,1,0)
        pagina.CanvasSize=UDim2.new(0,0,0,0)
        pagina.ScrollBarThickness=3
        pagina.ScrollBarImageColor3=C.Destaque
        pagina.Visible=false
        pagina.BackgroundTransparency=1
        pagina.BorderSizePixel=0
        pagina.Parent=pagArea
        Pad(pagina,8,8,IS_MOBILE and 6 or 5,IS_MOBILE and 6 or 5)
        local lyPag=Instance.new("UIListLayout",pagina)
        lyPag.Padding=UDim.new(0,7)
        lyPag.SortOrder=Enum.SortOrder.LayoutOrder
        lyPag:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pagina.CanvasSize=UDim2.new(0,0,0,lyPag.AbsoluteContentSize.Y+20)
        end)

        local entrada={btn=btn,lbl=lbl,ico=ico,ind=ind,glow=glow,pagina=pagina,_ativo=false,badgeFr=badgeFr,badgeLbl=badgeLbl2}
        table.insert(todasTabs,entrada)
        btn.MouseButton1Click:Connect(function() AtivarAba(entrada) end)
        if #todasTabs==1 then AtivarAba(entrada) end

        local IH    = IS_MOBILE and 48 or 46
        local CBTN  = IS_MOBILE and 42 or 40
        local SLH   = IS_MOBILE and 72 or 68

        local Aba = {}
        local ord = 0
        local function PO() ord=ord+1; return ord end
        local function RC(obj,prop,key) RegCor(obj,prop,key) end

        -- ── Atualizar badge da aba pelo código ──────────────────────────────
        --    aba:AtualizarBadge(5)   → mostra "5" no badge
        --    aba:AtualizarBadge(0)   → esconde o badge
        function Aba:AtualizarBadge(n)
            if badgeFr then
                badgeFr.Visible=(n~=nil and n>0)
                if badgeLbl2 then badgeLbl2.Text=tostring(n or "") end
            end
        end

        -- ════════════════ SEÇÃO ══════════════════════════════════════════════
        --[[  aba:CriarSecao("Título", "🔧")
             Cria um separador visual com título na página da aba.
             iconeSecao é opcional. ]]
        function Aba:CriarSecao(titulo, iconeSecao)
            local fr=F({Size=UDim2.new(1,-6,0,24),BackgroundTransparency=1,LayoutOrder=PO(),Parent=pagina})
            local div=F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.Borda,Parent=fr})
            RC(div,"BackgroundColor3","Borda")
            local t=(iconeSecao and (iconeSecao.." ") or "").."  "..string.upper(titulo).."  "
            local lb=L({
                Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundColor3=C.Janela,BorderSizePixel=0,
                Text=t,TextColor3=C.Destaque,Font=Enum.Font.GothamBold,
                TextSize=9,Position=UDim2.new(0,10,0,0),ZIndex=2,Parent=fr,
            })
            lb.BackgroundTransparency=0
            RC(lb,"BackgroundColor3","Janela"); RC(lb,"TextColor3","Destaque")
        end

        -- ════════════════ SEPARADOR ══════════════════════════════════════════
        function Aba:CriarSeparador()
            local sep=F({Size=UDim2.new(1,-6,0,1),BackgroundColor3=C.Borda,LayoutOrder=PO(),Parent=pagina})
            RC(sep,"BackgroundColor3","Borda"); return sep
        end

        -- ════════════════ TEXTO ══════════════════════════════════════════════
        --[[  local txt = aba:CriarTexto("Olá!", cor, tamanho)
             cor     = Color3 opcional
             tamanho = número opcional (padrão 13)
    
             Retorna objeto com:
               txt:Definir("novo texto")
               txt:Obter()  → string ]]
        function Aba:CriarTexto(textoInicial, cor, tamanho)
            local corTexto=cor or C.Sub
            local ts=tamanho or 13
            local fr=F({Size=UDim2.new(1,-6,0,36),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.45); RC(fr,"BackgroundColor3","Cartao")
            Pad(fr,0,0,10,10)
            local lbl=L({Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),
                Text=textoInicial or "",TextColor3=corTexto,Font=Enum.Font.Gotham,
                TextSize=ts,TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true,Parent=fr})
            lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                local h2=math.max(36,math.ceil(lbl.TextBounds.Y/14)*16+12)
                fr.Size=UDim2.new(1,-6,0,h2)
            end)
            local obj={}
            function obj:Definir(v) lbl.Text=v or "" end
            function obj:DefinirCor(c) lbl.TextColor3=c end
            function obj:Obter() return lbl.Text end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ LINK ═══════════════════════════════════════════════
        --[[  local lnk = aba:CriarLink("Clique aqui", "https://exemplo.com", callback)
             callback(url) é chamado ao clicar (use para abrir URL com setclipboard, etc.)
    
             Retorna objeto com:
               lnk:DefinirTexto("novo texto")
               lnk:DefinirUrl("https://...")
               lnk:DefinirCallback(function(url) ... end) ]]
        function Aba:CriarLink(texto, url, callback)
            local _url = url
            local _callback = callback
            local _texto = texto

            local fr=F({Size=UDim2.new(1,-6,0,36),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.45); RC(fr,"BackgroundColor3","Cartao")
            local btn=Instance.new("TextButton")
            btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
            btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=2; btn.Parent=fr
            L({Size=UDim2.new(0,18,1,0),Position=UDim2.new(0,10,0,0),
                Text="🔗",TextSize=12,Font=Enum.Font.Gotham,ZIndex=3,Parent=fr})
            local lbl=L({Size=UDim2.new(1,-36,1,0),Position=UDim2.new(0,30,0,0),
                Text=_texto,TextColor3=C.Destaque,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=fr})
            RC(lbl,"TextColor3","Destaque")
            btn.MouseEnter:Connect(function()
                Tw(fr,0.1,{BackgroundColor3=C.ItemHover}):Play()
                Tw(lbl,0.1,{TextColor3=C.DestaqueV}):Play()
            end)
            btn.MouseLeave:Connect(function()
                Tw(fr,0.1,{BackgroundColor3=C.Cartao}):Play()
                Tw(lbl,0.1,{TextColor3=C.Destaque}):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                if _callback then
                    pcall(_callback, _url)
                else
                    pcall(function() setclipboard(_url) end)
                    hubSelf:Notificar("Link copiado!", _url, "info", 2)
                end
            end)

            local obj={}
            function obj:DefinirTexto(v) _texto=v; lbl.Text=v end
            function obj:DefinirUrl(v) _url=v end
            function obj:DefinirCallback(fn) _callback=fn end
            return obj
        end

        -- ════════════════ CARD ═══════════════════════════════════════════════
        --[[  local card = aba:CriarCard(titulo, subtitulo, opcoes)
             opcoes = {
               icone    = "🎮",
               onClick  = function() ... end,
               destaque = Color3,        -- barra colorida à esquerda
               altura   = 64,            -- altura em pixels
             }
    
             Retorna objeto com:
               card:SetTitulo("novo título")
               card:SetSubtitulo("novo subtítulo")
               card:SetDestaque(Color3)  ]]
        function Aba:CriarCard(titulo, subtitulo, opcoes)
            opcoes=opcoes or {}
            local iconeCard=opcoes.icone; local callback=opcoes.onClick
            local destaque=opcoes.destaque
            local CH=opcoes.altura or (IS_MOBILE and 68 or 64)

            local wrap=F({Size=UDim2.new(1,-6,0,CH),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),ClipsDescendants=true,Parent=pagina})
            Cantos(wrap,12); RC(wrap,"BackgroundColor3","Cartao")
            local wBrd=Stroke(wrap,C.Borda,1,0.35); RC(wBrd,"Color","Borda")

            local barraDest=nil
            if destaque then
                barraDest=F({Size=UDim2.new(0,3,1,0),BackgroundColor3=destaque,ZIndex=2,Parent=wrap})
                Cantos(barraDest,99)
            end

            local off=destaque and 10 or 0
            local lblIco=nil
            if iconeCard then
                lblIco=L({Size=UDim2.new(0,32,1,0),Position=UDim2.new(0,10+off,0,0),
                    Text=iconeCard,TextColor3=C.Destaque,Font=Enum.Font.GothamBold,
                    TextSize=IS_MOBILE and 18 or 20,ZIndex=2,Parent=wrap})
                RC(lblIco,"TextColor3","Destaque")
                off=off+36
            end

            local lblT=L({Size=UDim2.new(1,-(off+16),0,22),Position=UDim2.new(0,10+off,0,8),
                Text=titulo,TextColor3=C.Texto,Font=Enum.Font.GothamBold,
                TextSize=IS_MOBILE and 12 or 13,TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=2,Parent=wrap})
            RC(lblT,"TextColor3","Texto")

            local lblSub=nil
            if subtitulo then
                lblSub=L({Size=UDim2.new(1,-(off+16),0,18),Position=UDim2.new(0,10+off,0,28),
                    Text=subtitulo,TextColor3=C.Sub,Font=Enum.Font.Gotham,
                    TextSize=IS_MOBILE and 10 or 11,TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=2,Parent=wrap})
                RC(lblSub,"TextColor3","Sub")
            end

            if callback then
                local hit=Instance.new("TextButton")
                hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1
                hit.Text=""; hit.AutoButtonColor=false; hit.ZIndex=5; hit.Parent=wrap
                hit.MouseEnter:Connect(function() Tw(wrap,0.1,{BackgroundColor3=C.ItemHover}):Play(); Tw(wBrd,0.1,{Transparency=0.1}):Play() end)
                hit.MouseLeave:Connect(function() Tw(wrap,0.1,{BackgroundColor3=C.Cartao}):Play(); Tw(wBrd,0.1,{Transparency=0.35}):Play() end)
                hit.MouseButton1Click:Connect(function() pcall(callback) end)
            end

            local obj={}
            function obj:SetTitulo(t) lblT.Text=t end
            function obj:SetSubtitulo(t)
                if lblSub then lblSub.Text=t
                elseif t then
                    lblSub=L({Size=UDim2.new(1,-(off+16),0,18),Position=UDim2.new(0,10+off,0,28),
                        Text=t,TextColor3=C.Sub,Font=Enum.Font.Gotham,
                        TextSize=IS_MOBILE and 10 or 11,TextXAlignment=Enum.TextXAlignment.Left,
                        ZIndex=2,Parent=wrap})
                end
            end
            function obj:SetDestaque(cor)
                if barraDest then barraDest.BackgroundColor3=cor
                else
                    barraDest=F({Size=UDim2.new(0,3,1,0),BackgroundColor3=cor,ZIndex=2,Parent=wrap})
                    Cantos(barraDest,99)
                end
            end
            return obj
        end

        -- ════════════════ BADGES / CHIPS ═════════════════════════════════════
        --[[  local badges = aba:CriarBadges({
               {texto="Online",  cor=Color3.fromRGB(45,205,125), icone="✓"},
               {texto="Premium", cor=Color3.fromRGB(148,68,255)},
               {texto="Beta"},
             })
    
             Cada item da lista aceita:
               texto = "texto do badge"    (obrigatório)
               cor   = Color3              (opcional, usa Destaque do tema se nil)
               icone = "🔥"               (opcional, aparece antes do texto)
    
             Retorna lista de referências (raramente necessário alterar) ]]
        function Aba:CriarBadges(badges)
            local alturaTotal=IS_MOBILE and 34 or 32
            local wrap=F({Size=UDim2.new(1,-6,0,alturaTotal),BackgroundTransparency=1,
                LayoutOrder=PO(),Parent=pagina})
            local lyt=Instance.new("UIListLayout",wrap)
            lyt.FillDirection=Enum.FillDirection.Horizontal
            lyt.VerticalAlignment=Enum.VerticalAlignment.Center
            lyt.Padding=UDim.new(0,6); lyt.SortOrder=Enum.SortOrder.LayoutOrder

            local refs={}
            for i,bd in ipairs(badges) do
                local bCor=bd.cor or C.Destaque
                local txt=(bd.icone and bd.icone.." " or "")..bd.texto
                local bfr=F({Size=UDim2.new(0,0,0,IS_MOBILE and 24 or 22),
                    BackgroundColor3=Lerp3(bCor,Color3.new(0,0,0),0.65),
                    LayoutOrder=i,Parent=wrap})
                Cantos(bfr,99); Stroke(bfr,bCor,1,0.35)
                local bl=L({Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,6,0,0),
                    Text=txt,TextColor3=bCor,Font=Enum.Font.GothamBold,
                    TextSize=IS_MOBILE and 9 or 10,ZIndex=2,Parent=bfr})
                task.defer(function()
                    if bl.Parent then
                        local tw2=bl.TextBounds.X+14
                        bfr.Size=UDim2.new(0,tw2,0,IS_MOBILE and 24 or 22)
                    end
                end)
                table.insert(refs,{fr=bfr,lbl=bl,cor=bCor})
            end
            return refs
        end

        -- ════════════════ PROGRESSO ══════════════════════════════════════════
        --[[  local prog = aba:CriarProgresso("Download", 40, 100, opcoes)
             valor = valor atual
             max   = valor máximo
             opcoes = {
               cor               = Color3,  -- cor da barra
               mostrarPorcentagem = true,
               animado            = true,
             }
    
             Retorna objeto com:
               prog:Definir(valor, max)  → atualiza a barra
               prog:Obter()              → retorna 0.0 a 1.0 (porcentagem) ]]
        function Aba:CriarProgresso(texto, valor, max, opcoes)
            opcoes=opcoes or {}
            local cor=opcoes.cor or C.Destaque
            local mostrarPct=opcoes.mostrarPorcentagem~=false
            local animado=opcoes.animado~=false
            local pct=math.clamp((valor or 0)/(max or 100),0,1)

            local PH=IS_MOBILE and 52 or 48
            local fr=F({Size=UDim2.new(1,-6,0,PH),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local lblT=L({Size=UDim2.new(0.6,0,0,18),Position=UDim2.new(0,14,0,8),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(lblT,"TextColor3","Texto")
            local lblP=L({Size=UDim2.new(0.38,0,0,18),Position=UDim2.new(0.6,-4,0,8),
                Text=string.format("%d%%",math.floor(pct*100)),
                TextColor3=cor,Font=Enum.Font.GothamBold,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Right,Parent=fr,
                Visible=mostrarPct})

            local trilha=F({Size=UDim2.new(1,-28,0,8),Position=UDim2.new(0,14,0,PH-20),
                BackgroundColor3=C.Item,Parent=fr})
            RC(trilha,"BackgroundColor3","Item"); Cantos(trilha,99)

            local fill=F({Size=UDim2.new(0,0,1,0),BackgroundColor3=cor,Parent=trilha})
            Cantos(fill,99); Grad(fill,Brilhar(cor,0.1),cor,0)

            if animado then
                task.defer(function()
                    if fill.Parent then
                        Tw(fill,0.6,{Size=UDim2.new(pct,0,1,0)},Enum.EasingStyle.Quart):Play()
                    end
                end)
            else
                fill.Size=UDim2.new(pct,0,1,0)
            end

            local obj={}
            function obj:Definir(v, m)
                local p2=math.clamp((v or 0)/(m or max or 100),0,1)
                pct=p2
                Tw(fill,0.4,{Size=UDim2.new(p2,0,1,0)},Enum.EasingStyle.Quart):Play()
                lblP.Text=string.format("%d%%",math.floor(p2*100))
            end
            function obj:Obter() return pct end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ RATING (estrelas) ══════════════════════════════════
        --[[  local rat = aba:CriarRating("Avaliação", 3, 5, function(valor, metade)
               -- valor = 1 a 5 (inteiro)
               -- metade = true se for meia estrela
               print("Escolheu:", valor, "meia?", metade)
             end)
    
             padrao  = valor inicial (pode ser 0, 2, 3.5, etc.)
             max     = quantidade de estrelas (padrão 5)
    
             Suporte a meias estrelas: clique na metade esquerda da estrela = meia estrela
    
             Retorna objeto com:
               rat:Definir(3.5)   → 3 cheias + meia
               rat:Obter()        → número (pode ser .5) ]]
        function Aba:CriarRating(texto, padrao, max, callback)
            max=max or 5
            local atual=padrao or 0

            local RH=IS_MOBILE and 52 or 48
            local fr=F({Size=UDim2.new(1,-6,0,RH),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            L({Size=UDim2.new(0.5,0,0,18),Position=UDim2.new(0,14,0.5,-9),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(L({Size=UDim2.new(0.5,0,0,18),Position=UDim2.new(0,14,0.5,-9),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr}),"TextColor3","Texto")

            local STAR_SIZE=IS_MOBILE and 22 or 20; local STAR_GAP=4
            local totalW=(STAR_SIZE+STAR_GAP)*max-STAR_GAP

            local starsHolder=F({Size=UDim2.new(0,totalW,0,STAR_SIZE),
                Position=UDim2.new(1,-(totalW+14),0.5,-STAR_SIZE/2),
                BackgroundTransparency=1,Parent=fr})

            local function UpdateVisual(v)
                for i=1,max do
                    local child=starsHolder:FindFirstChild("s"..i)
                    if not child then continue end
                    local cheia=i<=math.floor(v)
                    local meia=(not cheia) and (i == math.ceil(v)) and (v%1 >= 0.25)
                    if cheia then
                        child.TextColor3=C.Aviso
                        child.Text="★"
                    elseif meia then
                        child.TextColor3=C.Aviso
                        child.Text="⯨"
                    else
                        child.TextColor3=C.Fraco
                        child.Text="★"
                    end
                end
            end

            for i=1,max do
                local sb=Instance.new("TextButton")
                sb.Name="s"..i
                sb.Size=UDim2.new(0,STAR_SIZE,0,STAR_SIZE)
                sb.Position=UDim2.new(0,(i-1)*(STAR_SIZE+STAR_GAP),0,0)
                sb.BackgroundTransparency=1; sb.Text="★"
                sb.Font=Enum.Font.GothamBold; sb.TextSize=STAR_SIZE
                sb.TextColor3=C.Fraco; sb.AutoButtonColor=false; sb.ZIndex=2
                sb.Parent=starsHolder

                local hitLeft=Instance.new("TextButton")
                hitLeft.Size=UDim2.new(0.5,0,1,0); hitLeft.Position=UDim2.new(0,0,0,0)
                hitLeft.BackgroundTransparency=1; hitLeft.Text=""
                hitLeft.AutoButtonColor=false; hitLeft.ZIndex=3; hitLeft.Parent=sb

                local hitRight=Instance.new("TextButton")
                hitRight.Size=UDim2.new(0.5,0,1,0); hitRight.Position=UDim2.new(0.5,0,0,0)
                hitRight.BackgroundTransparency=1; hitRight.Text=""
                hitRight.AutoButtonColor=false; hitRight.ZIndex=3; hitRight.Parent=sb

                hitLeft.MouseButton1Click:Connect(function()
                    local novoValor=i-0.5
                    if novoValor<0.5 then novoValor=0.5 end
                    atual=novoValor; UpdateVisual(atual)
                    if callback then callback(atual, true) end
                end)
                hitRight.MouseButton1Click:Connect(function()
                    atual=i; UpdateVisual(atual)
                    if callback then callback(atual, false) end
                end)

                sb.MouseEnter:Connect(function() UpdateVisual(i) end)
                sb.MouseLeave:Connect(function() UpdateVisual(atual) end)
            end

            UpdateVisual(atual)

            local obj={}
            function obj:Definir(v) atual=v; UpdateVisual(v) end
            function obj:Obter() return atual end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ AVATAR ═════════════════════════════════════════════
        --[[  local av = aba:CriarAvatar(userId, nome, subtitulo)
             userId   = número do UserId do Roblox (ou nil para ícone genérico)
             nome     = texto do nome exibido
             subtitulo = texto secundário (opcional)
    
             Retorna objeto com:
               av:SetUserId(12345)
               av:SetNome("Pedro")
               av:SetSubtitulo("Admin") ]]
        function Aba:CriarAvatar(userId, nomeExibido, subtituloExtra)
            local _userId=userId; local _nome=nomeExibido; local _sub=subtituloExtra
            local AH=IS_MOBILE and 64 or 60
            local fr=F({Size=UDim2.new(1,-6,0,AH),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,12); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local AS=IS_MOBILE and 44 or 40
            local imgFr=F({Size=UDim2.new(0,AS,0,AS),Position=UDim2.new(0,10,0.5,-AS/2),
                BackgroundColor3=C.Item,ZIndex=2,Parent=fr})
            Cantos(imgFr,99); Stroke(imgFr,C.Destaque,1,0.4)

            local imgLabel=nil
            local iconLabel=nil

            local function CarregarImagem(uid)
                if imgLabel then imgLabel:Destroy(); imgLabel=nil end
                if iconLabel then iconLabel:Destroy(); iconLabel=nil end
                if uid then
                    local ok,thumb=pcall(function()
                        return Players:GetUserThumbnailAsync(uid,
                            Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
                    end)
                    if ok and thumb then
                        imgLabel=Instance.new("ImageLabel")
                        imgLabel.Size=UDim2.new(1,0,1,0); imgLabel.BackgroundTransparency=1
                        imgLabel.Image=thumb; imgLabel.ZIndex=3; imgLabel.Parent=imgFr
                        Cantos(imgLabel,99)
                    end
                else
                    iconLabel=L({Size=UDim2.new(1,0,1,0),Text="👤",TextSize=IS_MOBILE and 18 or 16,
                        Font=Enum.Font.Gotham,ZIndex=3,Parent=imgFr})
                end
            end

            CarregarImagem(_userId)

            local onl=F({Size=UDim2.new(0,10,0,10),Position=UDim2.new(1,-2,1,-2),
                BackgroundColor3=C.Sucesso,ZIndex=4,Parent=imgFr})
            Cantos(onl,99); Stroke(onl,C.Cartao,2,0)

            local txtOff=AS+18
            local lblN=L({Size=UDim2.new(1,-txtOff-14,0,IS_MOBILE and 18 or 16),
                Position=UDim2.new(0,txtOff,0,IS_MOBILE and 10 or 11),
                Text=_nome or "Usuário",TextColor3=C.Texto,
                Font=Enum.Font.GothamBold,TextSize=IS_MOBILE and 13 or 13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=fr})
            RC(lblN,"TextColor3","Texto")

            local lblSubAv=nil
            if _sub then
                lblSubAv=L({Size=UDim2.new(1,-txtOff-14,0,14),Position=UDim2.new(0,txtOff,0,IS_MOBILE and 30 or 28),
                    Text=_sub,TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=fr})
                RC(lblSubAv,"TextColor3","Sub")
            end

            local obj={}
            function obj:SetUserId(uid)
                _userId=uid
                task.spawn(function() CarregarImagem(uid) end)
            end
            function obj:SetNome(v) lblN.Text=v end
            function obj:SetSubtitulo(v)
                if lblSubAv then lblSubAv.Text=v
                elseif v then
                    lblSubAv=L({Size=UDim2.new(1,-txtOff-14,0,14),Position=UDim2.new(0,txtOff,0,IS_MOBILE and 30 or 28),
                        Text=v,TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=11,
                        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=fr})
                end
            end
            return obj
        end

        -- ════════════════ TABELA ══════════════════════════════════════════════
        --[[  local tbl = aba:CriarTabela(
               {"Nome", "Valor", "Status"},
               {
                 {"Alice", "100",  "OK"},
                 {"Bob",   "200",  "Erro"},
               }
             )
    
             colunas = lista de strings com os títulos das colunas
             linhas  = lista de listas com os valores de cada linha
               (valores "ok"/"true" ficam verdes, "erro"/"false" ficam vermelhos)
    
             Retorna objeto com:
               tbl:SetLinhas({{"A","1","OK"},{"B","2","Erro"}})  → substitui todas as linhas ]]
        function Aba:CriarTabela(colunas, linhas)
            local ROW_H=IS_MOBILE and 32 or 28
            local _linhas=linhas or {}

            local function Build(container, ls)
                for _,ch in ipairs(container:GetChildren()) do
                    if not ch:IsA("UIListLayout") and not ch:IsA("UIGridLayout") then ch:Destroy() end
                end
                local numCols=#colunas; local colW=1/numCols
                local alturaTotal=ROW_H*(#ls+1)+8
                container.Size=UDim2.new(1,-6,0,alturaTotal)

                local header=F({Size=UDim2.new(1,0,0,ROW_H),BackgroundColor3=C.Item,ZIndex=2,Parent=container})
                RC(header,"BackgroundColor3","Item")
                local sep=F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Borda,ZIndex=3,Parent=header})
                RC(sep,"BackgroundColor3","Borda")
                for i,col in ipairs(colunas) do
                    L({Size=UDim2.new(colW,0,1,0),Position=UDim2.new(colW*(i-1),0,0,0),
                        Text=col,TextColor3=C.Destaque,Font=Enum.Font.GothamBold,TextSize=10,
                        ZIndex=3,Parent=header})
                end

                for ri,row in ipairs(ls) do
                    local isEven=(ri%2==0)
                    local rFr=F({Size=UDim2.new(1,0,0,ROW_H),
                        Position=UDim2.new(0,0,0,ROW_H*ri),
                        BackgroundColor3=isEven and C.Item or C.Cartao,
                        ZIndex=2,Parent=container})
                    RC(rFr,"BackgroundColor3",isEven and "Item" or "Cartao")
                    for ci,cell in ipairs(row) do
                        local corCell=C.Texto
                        local cellStr=tostring(cell):lower()
                        if cellStr=="erro" or cellStr=="false" then corCell=C.Perigo
                        elseif cellStr=="ok" or cellStr=="true" then corCell=C.Sucesso end
                        L({Size=UDim2.new(colW,0,1,0),Position=UDim2.new(colW*(ci-1),0,0,0),
                            Text=tostring(cell),TextColor3=corCell,Font=Enum.Font.Gotham,
                            TextSize=IS_MOBILE and 10 or 11,ZIndex=3,Parent=rFr})
                    end
                end
            end

            local altInicial=ROW_H*(#_linhas+1)+8
            local container=F({Size=UDim2.new(1,-6,0,altInicial),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),ClipsDescendants=true,Parent=pagina})
            Cantos(container,10); Stroke(container,C.Borda,1,0.35); RC(container,"BackgroundColor3","Cartao")

            Build(container, _linhas)

            local obj={}
            function obj:SetLinhas(novasLinhas)
                _linhas=novasLinhas
                Build(container, _linhas)
            end
            return obj
        end

        -- ════════════════ BOTÃO ═══════════════════════════════════════════════
        --[[  local btn = aba:CriarBotao("Executar", function() ... end, opcoes)
             opcoes = {
               icone    = "🚀",
               perigo   = false,   -- vermelho se true
               destaque = false,   -- mais brilhante se true
             }
    
             Retorna objeto com:
               btn:SetTexto("Novo texto")
               btn:SetAtivo(false)       → desabilita visualmente
               btn:SetCarregando(true)   → mostra "Carregando..." ]]
        function Aba:CriarBotao(texto, callback, opcoes)
            opcoes=opcoes or {}
            local icone   = opcoes.icone
            local perigo  = opcoes.perigo
            local destaque2= opcoes.destaque
            local BH      = CBTN

            local function CorFundo()
                if perigo then return C.Perigo
                elseif destaque2 then return C.BotaoHover
                else return C.BotaoFundo end
            end
            local function CorHover()
                if perigo then return Brilhar(C.Perigo,0.08)
                else return C.BotaoHover end
            end
            local function CorTexto()  return perigo and Color3.new(1,1,1) or C.BotaoTexto end
            local function CorBorda()  return perigo and C.Perigo or C.Destaque end

            local wrap=F({Size=UDim2.new(1,-6,0,BH),BackgroundTransparency=1,
                LayoutOrder=PO(),ClipsDescendants=false,Parent=pagina})

            local glow=F({Size=UDim2.new(1,14,1,14),Position=UDim2.new(0,-7,0,-7),
                BackgroundColor3=CorBorda(),BackgroundTransparency=1,ZIndex=1,Parent=wrap})
            Cantos(glow,16)

            local b=Instance.new("TextButton")
            b.Size=UDim2.new(1,0,1,0); b.BackgroundColor3=CorFundo()
            b.Text=""; b.Font=Enum.Font.GothamBold; b.TextSize=13
            b.AutoButtonColor=false; b.ClipsDescendants=true; b.ZIndex=2; b.Parent=wrap
            Cantos(b,10)

            local brdB=Stroke(b,CorBorda(),1,0.45)
            if isRainbow and not perigo then AddRainbow(brdB,"Color",0.15) end

            local shine=F({Size=UDim2.new(1,0,0,BH*0.48),Position=UDim2.new(0,0,0,0),
                BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.88,ZIndex=4,Parent=b})
            Cantos(shine,10)

            local function SpawnRipple(mx,my)
                local rp=F({Size=UDim2.new(0,0,0,0),
                    Position=UDim2.new(0,mx-b.AbsolutePosition.X,0,my-b.AbsolutePosition.Y),
                    AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),
                    BackgroundTransparency=0.72,ZIndex=6,Parent=b})
                Cantos(rp,99)
                local sz=b.AbsoluteSize.X*2.2
                Tw(rp,0.5,{Size=UDim2.new(0,sz,0,sz),BackgroundTransparency=1},Enum.EasingStyle.Quart):Play()
                task.delay(0.52,function() if rp.Parent then rp:Destroy() end end)
            end

            local lblHolder=F({Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
                BackgroundTransparency=1,ZIndex=7,Parent=b})
            local lblTexto
            if icone then
                L({Size=UDim2.new(0,22,1,0),Position=UDim2.new(0,0,0,0),Text=icone,
                    TextColor3=CorTexto(),Font=Enum.Font.GothamBold,TextSize=14,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=lblHolder})
                lblTexto=L({Size=UDim2.new(1,-26,1,0),Position=UDim2.new(0,26,0,0),Text=texto,
                    TextColor3=CorTexto(),Font=Enum.Font.GothamBold,TextSize=13,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=lblHolder})
            else
                lblTexto=L({Size=UDim2.new(1,0,1,0),Text=texto,TextColor3=CorTexto(),
                    Font=Enum.Font.GothamBold,TextSize=13,ZIndex=7,Parent=lblHolder})
            end

            local hovering=false
            b.MouseEnter:Connect(function()
                hovering=true
                Tw(b,0.16,{BackgroundColor3=CorHover()}):Play()
                Tw(brdB,0.16,{Transparency=0.05}):Play()
                Tw(glow,0.2,{BackgroundTransparency=0.76}):Play()
                Tw(shine,0.16,{BackgroundTransparency=0.78}):Play()
            end)
            b.MouseLeave:Connect(function()
                hovering=false
                Tw(b,0.16,{BackgroundColor3=CorFundo()}):Play()
                Tw(brdB,0.16,{Transparency=0.45}):Play()
                Tw(glow,0.2,{BackgroundTransparency=1}):Play()
                Tw(shine,0.16,{BackgroundTransparency=0.88}):Play()
            end)
            b.MouseButton1Down:Connect(function(x,y)
                SpawnRipple(x,y)
                Tw(b,0.08,{Size=UDim2.new(1,-8,0,BH-3)}):Play()
                Tw(wrap,0.08,{Size=UDim2.new(1,-10,0,BH-3)}):Play()
                Tw(glow,0.08,{BackgroundTransparency=0.62}):Play()
            end)
            b.MouseButton1Up:Connect(function()
                Tw(b,0.18,{Size=UDim2.new(1,0,0,BH)},Enum.EasingStyle.Back):Play()
                Tw(wrap,0.18,{Size=UDim2.new(1,-6,0,BH)},Enum.EasingStyle.Back):Play()
                Tw(glow,0.2,{BackgroundTransparency=hovering and 0.76 or 1}):Play()
            end)
            b.MouseButton1Click:Connect(function() if callback then callback() end end)

            local obj={}
            function obj:SetTexto(t) if lblTexto then lblTexto.Text=t end end
            function obj:SetAtivo(ativo)
                b.Active=ativo
                Tw(b,0.15,{BackgroundTransparency=ativo and 0 or 0.5}):Play()
                Tw(brdB,0.15,{Transparency=ativo and 0.45 or 0.8}):Play()
            end
            function obj:SetCarregando(carregando)
                b.Active=not carregando
                if lblTexto then lblTexto.Text=carregando and "Carregando..." or texto end
            end
            return obj
        end

        -- ════════════════ TOGGLE ══════════════════════════════════════════════
        --[[  local tog = aba:CriarToggle("Modo noturno", false, function(valor)
               print("Toggle:", valor)  -- true ou false
             end)
    
             padrao  = true/false (estado inicial)
             opcoes = { iconeOn="✓", iconeOff="×" }
    
             Retorna objeto com:
               tog:Definir(true)
               tog:Obter()   → true ou false ]]
        function Aba:CriarToggle(texto, padrao, callback, opcoes)
            opcoes=opcoes or {}
            local iconeOn  = opcoes.iconeOn  or ""
            local iconeOff = opcoes.iconeOff or ""
            local estado   = (padrao==true)

            local TW2,TH2 = 52,28; local BR=TH2-6
            local fr=F({Size=UDim2.new(1,-6,0,IH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local lblTxt=L({Size=UDim2.new(1,-(TW2+100),1,0),Position=UDim2.new(0,14,0,0),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(lblTxt,"TextColor3","Texto")

            local trilha=F({Size=UDim2.new(0,TW2,0,TH2),Position=UDim2.new(1,-(TW2+12),0.5,-(TH2/2)),
                BackgroundColor3=estado and C.Sucesso or C.Fraco,ZIndex=2,Parent=fr})
            Cantos(trilha,99); Stroke(trilha,Color3.new(0,0,0),1,0.88)

            local trilhaGlow=F({Size=UDim2.new(1,0,1,0),BackgroundColor3=C.Sucesso,
                BackgroundTransparency=estado and 0.7 or 1,ZIndex=2,Parent=trilha})
            Cantos(trilhaGlow,99)

            local bx_off=3; local bx_on=TW2-BR-3
            local bolinha=F({Size=UDim2.new(0,BR,0,BR),
                Position=estado and UDim2.new(0,bx_on,0.5,-(BR/2)) or UDim2.new(0,bx_off,0.5,-(BR/2)),
                BackgroundColor3=Color3.new(1,1,1),ZIndex=4,Parent=trilha})
            Cantos(bolinha,99); Stroke(bolinha,Color3.new(0,0,0),1,0.78)

            local icoToggle=L({Size=UDim2.new(1,0,1,0),
                Text=estado and iconeOn or iconeOff,
                TextColor3=Color3.fromRGB(80,80,80),Font=Enum.Font.GothamBold,
                TextSize=IS_MOBILE and 12 or 11,ZIndex=5,Parent=bolinha})

            local lblE=L({Size=UDim2.new(0,38,1,0),Position=UDim2.new(1,-(TW2+56),0,0),
                Text=estado and "ON" or "OFF",TextColor3=estado and C.Sucesso or C.Fraco,
                Font=Enum.Font.GothamBold,TextSize=11,Parent=fr})
            local frBrd=Stroke(fr,C.Borda,1,0.35)

            local function Sync(anim)
                local d=anim and 0.2 or 0
                local es=Enum.EasingStyle.Back; local eo=Enum.EasingDirection.Out
                icoToggle.Text=estado and iconeOn or iconeOff
                if estado then
                    Tw(trilha,d,{BackgroundColor3=C.Sucesso}):Play()
                    Tw(trilhaGlow,d,{BackgroundTransparency=0.7}):Play()
                    Tw(bolinha,d,{Position=UDim2.new(0,bx_on,0.5,-(BR/2))},es,eo):Play()
                    if anim then
                        Tw(bolinha,d*0.4,{Size=UDim2.new(0,BR+5,0,BR-3)}):Play()
                        task.delay(d*0.4,function() Tw(bolinha,d*0.6,{Size=UDim2.new(0,BR,0,BR)},es,eo):Play() end)
                    end
                    Tw(lblE,d,{TextColor3=C.Sucesso}):Play(); lblE.Text="ON"
                    Tw(frBrd,d,{Color=C.Sucesso,Transparency=0.55}):Play()
                else
                    Tw(trilha,d,{BackgroundColor3=C.Fraco}):Play()
                    Tw(trilhaGlow,d,{BackgroundTransparency=1}):Play()
                    Tw(bolinha,d,{Position=UDim2.new(0,bx_off,0.5,-(BR/2))},es,eo):Play()
                    if anim then
                        Tw(bolinha,d*0.4,{Size=UDim2.new(0,BR+5,0,BR-3)}):Play()
                        task.delay(d*0.4,function() Tw(bolinha,d*0.6,{Size=UDim2.new(0,BR,0,BR)},es,eo):Play() end)
                    end
                    Tw(lblE,d,{TextColor3=C.Fraco}):Play(); lblE.Text="OFF"
                    Tw(frBrd,d,{Color=C.Borda,Transparency=0.35}):Play()
                end
                if callback then callback(estado) end
            end

            local THRESH=8; local touchStart,touchDrag=nil,false
            fr.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then
                    estado=not estado; Sync(true)
                elseif i.UserInputType==Enum.UserInputType.Touch then
                    touchStart=i.Position; touchDrag=false
                end
            end)
            fr.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Touch and touchStart then
                    if math.abs(i.Position.X-touchStart.X)>THRESH or math.abs(i.Position.Y-touchStart.Y)>THRESH then
                        touchDrag=true end
                end
            end)
            fr.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Touch then
                    if touchStart and not touchDrag then estado=not estado; Sync(true) end
                    touchStart=nil; touchDrag=false
                end
            end)
            fr.MouseEnter:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.ItemHover}):Play() end)
            fr.MouseLeave:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.Cartao}):Play() end)

            local obj={}
            function obj:Definir(v) estado=v; Sync(true) end
            function obj:Obter() return estado end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ SLIDER ══════════════════════════════════════════════
        --[[  local sl = aba:CriarSlider("Volume", 0, 100, 50, function(valor)
               print("Slider:", valor)
             end, opcoes)
    
             opcoes = {
               step     = 1,       -- incremento mínimo
               float    = false,   -- se true, retorna decimal
               decimais = 1,       -- casas decimais (quando float=true)
               unidade  = "%",     -- sufixo exibido
               cor      = Color3,  -- cor personalizada
             }
    
             Retorna objeto com:
               sl:Definir(75)
               sl:Obter()   → número ]]
        function Aba:CriarSlider(texto, minV, maxV, padrao, callback, opcoes)
            opcoes=opcoes or {}
            local step      = opcoes.step     or 1
            local useFloat  = opcoes.float    or false
            local decimais  = opcoes.decimais or 1
            local unidade   = opcoes.unidade  or ""
            local cor       = opcoes.cor      or nil

            local function Arredondar(v) return math.floor(v/step+0.5)*step end
            local function Formatar(v)
                v=math.clamp(v,minV,maxV)
                return useFloat and string.format("%."..decimais.."f",v)..unidade
                                or tostring(math.floor(v))..unidade
            end

            local val=Arredondar(math.clamp(padrao or minV,minV,maxV))
            local corDestaque=cor or C.Destaque
            local corDestaqueV=cor and Brilhar(cor,0.1) or C.DestaqueV

            local fr=F({Size=UDim2.new(1,-6,0,SLH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local labelY=IS_MOBILE and 10 or 9
            L({Size=UDim2.new(0.58,0,0,20),Position=UDim2.new(0,14,0,labelY),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(L({Size=UDim2.new(0.58,0,0,20),Position=UDim2.new(0,14,0,labelY),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr}),"TextColor3","Texto")
            local lblV=L({Size=UDim2.new(0.38,0,0,20),Position=UDim2.new(0.6,-4,0,labelY),
                Text=Formatar(val),TextColor3=corDestaque,Font=Enum.Font.GothamBold,
                TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,Parent=fr})

            local hintY=IS_MOBILE and 30 or 28
            L({Size=UDim2.new(0,30,0,12),Position=UDim2.new(0,14,0,hintY),
                Text=Formatar(minV),TextColor3=C.Fraco,Font=Enum.Font.Gotham,TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            L({Size=UDim2.new(0,30,0,12),Position=UDim2.new(1,-44,0,hintY),
                Text=Formatar(maxV),TextColor3=C.Fraco,Font=Enum.Font.Gotham,TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Right,Parent=fr})

            local trilhaY=IS_MOBILE and 50 or 47
            local trilha=F({Size=UDim2.new(1,-28,0,6),Position=UDim2.new(0,14,0,trilhaY),
                BackgroundColor3=C.Item,Parent=fr})
            RC(trilha,"BackgroundColor3","Item"); Cantos(trilha,99)

            local pct=(val-minV)/(maxV-minV)
            local fill=F({Size=UDim2.new(pct,0,1,0),BackgroundColor3=corDestaque,Parent=trilha})
            Cantos(fill,99)
            Grad(fill,corDestaqueV,corDestaque,0)
            if isRainbow and not cor then AddRainbow(fill,"BackgroundColor3",0.12) end

            local BOLA=IS_MOBILE and 20 or 17
            local bola=F({Size=UDim2.new(0,BOLA,0,BOLA),Position=UDim2.new(pct,0,0.5,0),
                AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),ZIndex=3,Parent=trilha})
            Cantos(bola,99); Stroke(bola,corDestaque,2,0.25)

            local tooltip=F({Size=UDim2.new(0,48,0,20),AnchorPoint=Vector2.new(0.5,1),
                Position=UDim2.new(pct,0,0,-6),BackgroundColor3=corDestaque,
                ZIndex=6,Visible=false,Parent=trilha})
            Cantos(tooltip,5); Grad(tooltip,corDestaqueV,corDestaque,90)
            local tooltipLbl=L({Size=UDim2.new(1,0,1,0),Text=Formatar(val),
                TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=10,ZIndex=7,Parent=tooltip})

            local hitbox=F({Size=UDim2.new(1,0,0,IS_MOBILE and 36 or 28),
                Position=UDim2.new(0,0,0.5,-(IS_MOBILE and 18 or 14)),
                BackgroundTransparency=1,ZIndex=5,Parent=trilha})

            local ativo=false
            local function Upd(px)
                local p=math.clamp((px-trilha.AbsolutePosition.X)/trilha.AbsoluteSize.X,0,1)
                val=Arredondar(minV+(maxV-minV)*p)
                val=math.clamp(val,minV,maxV)
                local p2=(val-minV)/(maxV-minV)
                fill.Size=UDim2.new(p2,0,1,0)
                bola.Position=UDim2.new(p2,0,0.5,0)
                tooltip.Position=UDim2.new(p2,0,0,-6)
                lblV.Text=Formatar(val); tooltipLbl.Text=Formatar(val)
                if callback then callback(useFloat and val or math.floor(val)) end
            end

            hitbox.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    ativo=true; Upd(i.Position.X)
                    Tw(bola,0.1,{Size=UDim2.new(0,BOLA+5,0,BOLA+5)}):Play()
                    tooltip.Visible=true
                end
            end)
            table.insert(hubSelf._conexoes, EntradaUsuario.InputChanged:Connect(function(i)
                if not ativo then return end
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    Upd(i.Position.X)
                end
            end))
            table.insert(hubSelf._conexoes, EntradaUsuario.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    if ativo then
                        ativo=false
                        Tw(bola,0.1,{Size=UDim2.new(0,BOLA,0,BOLA)}):Play()
                        tooltip.Visible=false
                    end
                end
            end))
            fr.MouseEnter:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.ItemHover}):Play() end)
            fr.MouseLeave:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.Cartao}):Play() end)

            local obj={}
            function obj:Definir(v)
                val=Arredondar(math.clamp(v,minV,maxV))
                local p2=(val-minV)/(maxV-minV)
                fill.Size=UDim2.new(p2,0,1,0); bola.Position=UDim2.new(p2,0,0.5,0)
                lblV.Text=Formatar(val)
            end
            function obj:Obter() return useFloat and val or math.floor(val) end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ DROPDOWN ════════════════════════════════════════════
        --[[  local dd = aba:CriarDropdown("Modo", {"Opção A","Opção B","Opção C"}, function(valor)
               print("Escolheu:", valor)
             end, opcoes)
    
             opcoes = {
               multi       = false,  -- seleção múltipla
               search      = true,   -- campo de busca
               maxVisible  = 5,      -- itens visíveis sem scroll
               placeholder = "Escolha...",
             }
    
             Retorna objeto com:
               dd:Definir("Opção A")           → seleciona opção
               dd:Definir({"A","B"})           → multi-seleção
               dd:Obter()                      → valor atual (string ou tabela)
               dd:AtualizarOpcoes({"X","Y"})   → troca as opções
               dd:LimparSelecao()
               dd:Fechar() ]]
        function Aba:CriarDropdown(texto, opcoes, callback, cfg)
            cfg=cfg or {}
            local multiSelect=cfg.multi or false
            local useSearch=cfg.search~=false
            local maxVis=cfg.maxVisible or 5
            local placeholderTxt=cfg.placeholder or opcoes[1] or "-"

            local aberto=false
            local IHd=IS_MOBILE and 38 or 34; local FH=IS_MOBILE and 44 or 44
            local GAP=4; local PAD=8
            local SEARCH_H=useSearch and (IS_MOBILE and 36 or 32) or 0

            local selSimples=opcoes[1] or placeholderTxt
            local selMulti={}

            local function GetLabel()
                if multiSelect then
                    local t={}
                    for _,op in ipairs(opcoes) do if selMulti[op] then table.insert(t,op) end end
                    return #t==0 and placeholderTxt or table.concat(t,", ")
                else return selSimples end
            end

            local fr=F({Size=UDim2.new(1,-6,0,FH),BackgroundColor3=C.Cartao,
                ClipsDescendants=true,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local cab=Instance.new("TextButton")
            cab.Size=UDim2.new(1,0,0,FH); cab.BackgroundTransparency=1
            cab.Text=""; cab.AutoButtonColor=false; cab.ZIndex=2; cab.Parent=fr

            L({Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,14,0,0),Text=texto,
                TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=cab})
            local lblS=L({Size=UDim2.new(0.42,0,1,0),Position=UDim2.new(0.5,-2,0,0),
                Text=GetLabel(),TextColor3=C.Texto,Font=Enum.Font.GothamBold,
                TextSize=IS_MOBILE and 11 or 12,TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Right,ZIndex=3,Parent=cab})
            RC(lblS,"TextColor3","Texto")

            local badge2=F({Size=UDim2.new(0,18,0,18),Position=UDim2.new(1,-46,0.5,-9),
                BackgroundColor3=C.Destaque,ZIndex=3,Visible=false,Parent=cab})
            Cantos(badge2,99); RC(badge2,"BackgroundColor3","Destaque")
            local badgeLbl3=L({Size=UDim2.new(1,0,1,0),Text="0",TextColor3=Color3.new(1,1,1),
                Font=Enum.Font.GothamBold,TextSize=9,ZIndex=4,Parent=badge2})

            local seta=L({Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-26,0,0),
                Text="›",TextColor3=C.Fraco,Font=Enum.Font.GothamBold,
                TextSize=16,Rotation=90,ZIndex=3,Parent=cab})
            RC(seta,"TextColor3","Fraco")

            F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,FH),
                BackgroundColor3=C.Borda,ZIndex=2,Parent=fr})

            local searchBox=nil
            if useSearch then
                local sfrRef=F({Size=UDim2.new(1,-16,0,SEARCH_H-6),Position=UDim2.new(0,8,0,FH+6),
                    BackgroundColor3=C.Item,ZIndex=2,Parent=fr})
                Cantos(sfrRef,8); RC(sfrRef,"BackgroundColor3","Item")
                local sbrd=Stroke(sfrRef,C.Borda,1,0.4); RC(sbrd,"Color","Borda")
                L({Size=UDim2.new(0,18,1,0),Position=UDim2.new(0,6,0,0),
                    Text="🔍",TextSize=IS_MOBILE and 12 or 11,Font=Enum.Font.Gotham,ZIndex=3,Parent=sfrRef})
                searchBox=Instance.new("TextBox")
                searchBox.Size=UDim2.new(1,-30,1,-8); searchBox.Position=UDim2.new(0,26,0,4)
                searchBox.BackgroundTransparency=1; searchBox.Text=""
                searchBox.PlaceholderText="Buscar..."; searchBox.PlaceholderColor3=C.Fraco
                searchBox.TextColor3=C.Texto; searchBox.Font=Enum.Font.Gotham
                searchBox.TextSize=IS_MOBILE and 12 or 11
                searchBox.TextXAlignment=Enum.TextXAlignment.Left
                searchBox.ClearTextOnFocus=false; searchBox.ZIndex=3; searchBox.Parent=sfrRef
                RC(searchBox,"TextColor3","Texto")
                searchBox.Focused:Connect(function() Tw(sbrd,0.15,{Color=C.Destaque,Transparency=0}):Play() end)
                searchBox.FocusLost:Connect(function() Tw(sbrd,0.15,{Color=C.Borda,Transparency=0.4}):Play() end)
            end

            local listaHolder=Instance.new("ScrollingFrame")
            listaHolder.BackgroundTransparency=1; listaHolder.BorderSizePixel=0
            listaHolder.ScrollBarThickness=IS_MOBILE and 0 or 3
            listaHolder.ScrollBarImageColor3=C.Destaque
            listaHolder.ScrollingDirection=Enum.ScrollingDirection.Y
            listaHolder.ZIndex=2; listaHolder.Parent=fr
            Pad(listaHolder,4,4,8,8)
            local lyL=Instance.new("UIListLayout",listaHolder)
            lyL.Padding=UDim.new(0,GAP); lyL.SortOrder=Enum.SortOrder.LayoutOrder

            local todosItens={}

            local function AtualizarBadge2()
                if not multiSelect then return end
                local cnt=0
                for _,op in ipairs(opcoes) do if selMulti[op] then cnt=cnt+1 end end
                badge2.Visible=cnt>0
                badgeLbl3.Text=tostring(cnt)
            end

            local function CalcAltura(visCount)
                local linhas=math.min(visCount,maxVis)
                local altLista=linhas*(IHd+GAP)+PAD*2
                return FH+1+SEARCH_H+altLista
            end

            local _syncRef={fn=function() end}
            local FecharDropdown

            local function ConstruirItens(filtro)
                for _,ch in ipairs(listaHolder:GetChildren()) do
                    if ch:IsA("TextButton") or ch:IsA("Frame") then ch:Destroy() end
                end
                todosItens={}; local visiveis=0

                for _,op in ipairs(opcoes) do
                    local passou=not filtro or filtro==""
                        or string.find(string.lower(op),string.lower(filtro),1,true)
                    if not passou then continue end
                    visiveis=visiveis+1

                    local ativo2=multiSelect and selMulti[op] or (not multiSelect and op==selSimples)
                    local it=Instance.new("TextButton")
                    it.Size=UDim2.new(1,0,0,IHd); it.BackgroundColor3=ativo2 and C.BotaoFundo or C.Item
                    it.Text=""; it.AutoButtonColor=false; it.ZIndex=3; it.Parent=listaHolder
                    Cantos(it,8)
                    local itBrd=Stroke(it,ativo2 and C.Destaque or C.Borda,1,ativo2 and 0.5 or 0.7)
                    local itLbl=L({Size=UDim2.new(1,-36,1,0),Position=UDim2.new(0,12,0,0),
                        Text=op,TextColor3=ativo2 and C.BotaoTexto or C.Texto,
                        Font=ativo2 and Enum.Font.GothamBold or Enum.Font.Gotham,
                        TextSize=IS_MOBILE and 12 or 13,TextXAlignment=Enum.TextXAlignment.Left,
                        ZIndex=4,Parent=it})
                    local chk=L({Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-26,0,0),
                        Text="✓",TextColor3=C.Sucesso,Font=Enum.Font.GothamBold,
                        TextSize=14,ZIndex=4,Visible=ativo2,Parent=it})
                    table.insert(todosItens,{btn=it,lbl=itLbl,brd=itBrd,op=op,chk=chk})

                    it.MouseEnter:Connect(function()
                        local isAtivo2=multiSelect and selMulti[op] or (not multiSelect and op==selSimples)
                        if not isAtivo2 then Tw(it,0.1,{BackgroundColor3=C.ItemHover}):Play()
                            Tw(itBrd,0.1,{Transparency=0.3}):Play() end
                    end)
                    it.MouseLeave:Connect(function()
                        local isAtivo2=multiSelect and selMulti[op] or (not multiSelect and op==selSimples)
                        Tw(it,0.1,{BackgroundColor3=isAtivo2 and C.BotaoFundo or C.Item}):Play()
                        Tw(itBrd,0.1,{Transparency=isAtivo2 and 0.5 or 0.7}):Play()
                    end)
                    it.MouseButton1Click:Connect(function()
                        if multiSelect then
                            selMulti[op]=not selMulti[op]
                            local isNow=selMulti[op]
                            Tw(it,0.12,{BackgroundColor3=isNow and C.BotaoFundo or C.Item}):Play()
                            Tw(itBrd,0.12,{Transparency=isNow and 0.5 or 0.7,Color=isNow and C.Destaque or C.Borda}):Play()
                            itLbl.TextColor3=isNow and C.BotaoTexto or C.Texto
                            itLbl.Font=isNow and Enum.Font.GothamBold or Enum.Font.Gotham
                            chk.Visible=isNow; AtualizarBadge2(); lblS.Text=GetLabel(); _syncRef.fn()
                            if callback then callback(GetLabel(),selMulti) end
                        else
                            selSimples=op; lblS.Text=op
                            for _,entry in ipairs(todosItens) do
                                local sel2=entry.op==op
                                entry.btn.BackgroundColor3=sel2 and C.BotaoFundo or C.Item
                                entry.lbl.TextColor3=sel2 and C.BotaoTexto or C.Texto
                                entry.lbl.Font=sel2 and Enum.Font.GothamBold or Enum.Font.Gotham
                                entry.chk.Visible=sel2
                                Tw(entry.brd,0.1,{Transparency=sel2 and 0.5 or 0.7,Color=sel2 and C.Destaque or C.Borda}):Play()
                            end
                            _syncRef.fn()
                            if callback then callback(selSimples) end
                            FecharDropdown()
                        end
                    end)
                end

                if visiveis==0 then
                    local empty=F({Size=UDim2.new(1,0,0,IHd),BackgroundTransparency=1,ZIndex=2,Parent=listaHolder})
                    L({Size=UDim2.new(1,0,1,0),Text="Nenhum resultado",TextColor3=C.Fraco,
                        Font=Enum.Font.Gotham,TextSize=12,ZIndex=3,Parent=empty})
                end

                local linhas=math.min(visiveis>0 and visiveis or 1,maxVis)
                local altLista=linhas*(IHd+GAP)+PAD*2
                listaHolder.Size=UDim2.new(1,0,0,altLista)
                listaHolder.Position=UDim2.new(0,0,0,FH+1+SEARCH_H)
                listaHolder.CanvasSize=UDim2.new(0,0,0,lyL.AbsoluteContentSize.Y+8)
                return visiveis
            end

            ConstruirItens("")

            if searchBox then
                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local vis=ConstruirItens(searchBox.Text)
                    if aberto then Tw(fr,0.12,{Size=UDim2.new(1,-6,0,CalcAltura(vis))}):Play() end
                end)
            end

            FecharDropdown=function()
                aberto=false
                Tw(fr,0.2,{Size=UDim2.new(1,-6,0,FH)},Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
                Tw(seta,0.2,{Rotation=90}):Play()
                task.delay(0.22,function() if searchBox and searchBox.Parent then searchBox.Text="" end end)
            end

            local function AbrirDropdown()
                aberto=true
                local vis=ConstruirItens(searchBox and searchBox.Text or "")
                Tw(fr,0.25,{Size=UDim2.new(1,-6,0,CalcAltura(vis))},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
                Tw(seta,0.2,{Rotation=-90}):Play()
            end

            cab.MouseButton1Click:Connect(function()
                if aberto then FecharDropdown() else AbrirDropdown() end
            end)
            fr.MouseEnter:Connect(function()
                if not aberto then Tw(fr,0.12,{BackgroundColor3=C.ItemHover}):Play() end
            end)
            fr.MouseLeave:Connect(function()
                if not aberto then Tw(fr,0.12,{BackgroundColor3=C.Cartao}):Play() end
            end)

            local obj={}
            obj.valor=multiSelect and {} or selSimples
            local function SyncValor()
                if multiSelect then
                    local t={}
                    for _,op in ipairs(opcoes) do if selMulti[op] then table.insert(t,op) end end
                    obj.valor=t
                else obj.valor=selSimples end
            end
            SyncValor(); _syncRef.fn=SyncValor
            function obj:Definir(v)
                if multiSelect then
                    selMulti={}
                    if type(v)=="table" then for _,k in ipairs(v) do selMulti[k]=true end
                    else selMulti[v]=true end
                else selSimples=v end
                lblS.Text=GetLabel(); AtualizarBadge2(); ConstruirItens(""); SyncValor()
            end
            function obj:Obter()
                if multiSelect then local t={}; for op in pairs(selMulti) do table.insert(t,op) end; return t
                else return selSimples end
            end
            function obj:AtualizarOpcoes(novasOps)
                opcoes=novasOps
                if not multiSelect then
                    local existe=false
                    for _,n in ipairs(novasOps) do if n==selSimples then existe=true; break end end
                    if not existe then selSimples=novasOps[1] or placeholderTxt; lblS.Text=selSimples end
                end
                FecharDropdown()
                task.delay(0.22,function() ConstruirItens(""); SyncValor() end)
            end
            function obj:LimparSelecao()
                if multiSelect then selMulti={}; AtualizarBadge2() else selSimples=placeholderTxt end
                lblS.Text=GetLabel(); ConstruirItens(""); SyncValor()
            end
            function obj:Fechar() FecharDropdown() end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            obj.UpdateOptions=obj.AtualizarOpcoes; obj.Clear=obj.LimparSelecao
            return obj
        end

        -- ════════════════ ENTRADA (Input) ════════════════════════════════════
        --[[  local inp = aba:CriarEntrada("Digite algo...", function(valor)
               print("Confirmado:", valor)  -- chamado ao pressionar Enter
             end, opcoes)
    
             opcoes = {
               icone = "🔍",     -- ícone à esquerda
               senha = false,    -- oculta o texto com ●●●
             }
    
             Retorna objeto com:
               inp:Definir("texto inicial")
               inp:Obter()   → string ]]
        function Aba:CriarEntrada(placeholder, callback, opcoes)
            opcoes=opcoes or {}
            local icone=opcoes.icone; local senha=opcoes.senha
            local EH=IS_MOBILE and 48 or 44
            local fr=F({Size=UDim2.new(1,-6,0,EH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); RC(fr,"BackgroundColor3","Cartao")
            local brd=Stroke(fr,C.Borda,1,0.35); RC(brd,"Color","Borda")

            local offX=12
            if icone then
                L({Size=UDim2.new(0,24,1,0),Position=UDim2.new(0,10,0,0),
                    Text=icone,TextColor3=C.Fraco,Font=Enum.Font.GothamBold,
                    TextSize=IS_MOBILE and 15 or 14,ZIndex=2,Parent=fr})
                offX=36
            end

            local tb=Instance.new("TextBox")
            tb.Size=UDim2.new(1,-(offX+12),1,-14); tb.Position=UDim2.new(0,offX,0,7)
            tb.BackgroundTransparency=1; tb.Text=""
            tb.PlaceholderText=placeholder or "Digite aqui..."
            tb.PlaceholderColor3=C.Fraco; tb.TextColor3=C.Texto
            tb.Font=Enum.Font.Gotham; tb.TextSize=13
            tb.TextXAlignment=Enum.TextXAlignment.Left
            tb.ClearTextOnFocus=false
            if senha then tb.TextTransparency=1 end
            tb.ZIndex=2; tb.Parent=fr
            RC(tb,"TextColor3","Texto"); RC(tb,"PlaceholderColor3","Fraco")

            if senha then
                local shown=false
                local dots=L({Size=UDim2.new(1,-(offX+40),1,0),Position=UDim2.new(0,offX,0,0),
                    Text=string.rep("●",8),
                    TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=fr})
                RC(dots,"TextColor3","Texto")
                tb:GetPropertyChangedSignal("Text"):Connect(function()
                    if not shown then dots.Text=string.rep("●",#tb.Text) end
                end)
                local eyeBtn=Instance.new("TextButton")
                eyeBtn.Size=UDim2.new(0,24,0,24); eyeBtn.Position=UDim2.new(1,-30,0.5,-12)
                eyeBtn.BackgroundTransparency=1; eyeBtn.Text="👁"
                eyeBtn.TextSize=14; eyeBtn.AutoButtonColor=false; eyeBtn.ZIndex=4; eyeBtn.Parent=fr
                eyeBtn.MouseButton1Click:Connect(function()
                    shown=not shown
                    if shown then dots.Visible=false; tb.TextTransparency=0
                    else dots.Visible=true; tb.TextTransparency=1 end
                    eyeBtn.Text=shown and "🙈" or "👁"
                end)
            end

            tb.Focused:Connect(function() Tw(brd,0.15,{Color=C.Destaque,Transparency=0}):Play() end)
            tb.FocusLost:Connect(function(enter)
                Tw(brd,0.15,{Color=C.Borda,Transparency=0.35}):Play()
                if enter and callback then callback(tb.Text) end
            end)

            local obj={}
            function obj:Definir(t) tb.Text=t or "" end
            function obj:Obter() return tb.Text end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ COLOR PICKER ════════════════════════════════════════
        --[[  local cp = aba:CriarColorPicker("Cor", Color3.fromRGB(255,0,0), function(cor)
               print("Cor:", cor)
             end)
    
             Retorna objeto com:
               cp:Definir(Color3.fromRGB(0,255,0))
               cp:Obter()   → Color3 ]]
        function Aba:CriarColorPicker(texto, padraoColor3, callback)
            local corAtual=padraoColor3 or Color3.fromRGB(255,255,255)
            local h,s,v2=Color3.toHSV(corAtual)
            local aberto=false

            local FH2=IS_MOBILE and 44 or 42
            local CVW=IS_MOBILE and 160 or 190; local CVH=IS_MOBILE and 130 or 150
            local BAR_H=16; local PAD=10; local RPAD=10
            local RW=IS_MOBILE and 85 or 100; local RX=PAD+CVW+RPAD
            local PICKER_H=PAD+CVH+8+BAR_H+8+BAR_H+8+18*2+4+PAD
            local AH=FH2+PICKER_H

            local fr=F({Size=UDim2.new(1,-6,0,FH2),BackgroundColor3=C.Cartao,
                ClipsDescendants=false,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local cab=Instance.new("TextButton")
            cab.Size=UDim2.new(1,0,0,FH2); cab.BackgroundColor3=C.Cartao
            cab.BackgroundTransparency=0; cab.Text=""; cab.AutoButtonColor=false
            cab.ZIndex=2; cab.Parent=fr; Cantos(cab,10); RC(cab,"BackgroundColor3","Cartao")

            L({Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,14,0,0),Text=texto,
                TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=cab})

            local preview=F({Size=UDim2.new(0,24,0,24),Position=UDim2.new(1,-54,0.5,-12),
                BackgroundColor3=corAtual,ZIndex=3,Parent=cab})
            Cantos(preview,6); Stroke(preview,C.Borda,1,0.4)

            local seta2=L({Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-26,0,0),
                Text="›",TextColor3=C.Fraco,Font=Enum.Font.GothamBold,
                TextSize=16,Rotation=90,ZIndex=3,Parent=cab})

            local pickerCorpo=F({Size=UDim2.new(1,0,0,PICKER_H),Position=UDim2.new(0,0,0,FH2),
                BackgroundColor3=C.Cartao,ZIndex=1,Visible=false,Parent=fr})
            RC(pickerCorpo,"BackgroundColor3","Cartao")

            local cvFr=F({Size=UDim2.new(0,CVW,0,CVH),Position=UDim2.new(0,PAD,0,PAD),
                BackgroundColor3=Color3.new(1,1,1),ZIndex=2,Parent=pickerCorpo})
            Cantos(cvFr,6); Stroke(cvFr,C.Borda,1,0.5)

            local gradSat=Instance.new("UIGradient")
            gradSat.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(h,1,1))
            gradSat.Rotation=0; gradSat.Parent=cvFr

            local cvDark=F({Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),ZIndex=3,Parent=cvFr})
            Cantos(cvDark,6)
            local gradDark=Instance.new("UIGradient")
            gradDark.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
            gradDark.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
            gradDark.Rotation=90; gradDark.Parent=cvDark

            local cvCursor=F({Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(s,0,1-v2,0),BackgroundColor3=Color3.new(1,1,1),
                ZIndex=6,Parent=cvFr})
            Cantos(cvCursor,99); Stroke(cvCursor,Color3.new(0,0,0),2,0.2)

            local hueY=PAD+CVH+8
            local hueFr=F({Size=UDim2.new(0,CVW,0,BAR_H),Position=UDim2.new(0,PAD,0,hueY),
                ZIndex=2,Parent=pickerCorpo})
            Cantos(hueFr,99); Stroke(hueFr,C.Borda,1,0.5)
            local hueKfs={}; for i=0,6 do hueKfs[i+1]=ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1)) end
            local hueGrad=Instance.new("UIGradient"); hueGrad.Color=ColorSequence.new(hueKfs); hueGrad.Rotation=0; hueGrad.Parent=hueFr
            local hueCur=F({Size=UDim2.new(0,BAR_H+2,0,BAR_H+2),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(h,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=4,Parent=hueFr})
            Cantos(hueCur,99); Stroke(hueCur,Color3.new(0,0,0),2,0.2)

            local valY=hueY+BAR_H+8
            local valFr=F({Size=UDim2.new(0,CVW,0,BAR_H),Position=UDim2.new(0,PAD,0,valY),ZIndex=2,Parent=pickerCorpo})
            Cantos(valFr,99); Stroke(valFr,C.Borda,1,0.5)
            local valGrad=Instance.new("UIGradient")
            valGrad.Color=ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,s,1))
            valGrad.Rotation=0; valGrad.Parent=valFr
            local valCur=F({Size=UDim2.new(0,BAR_H+2,0,BAR_H+2),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(v2,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=4,Parent=valFr})
            Cantos(valCur,99); Stroke(valCur,Color3.new(0,0,0),2,0.2)

            local bigPrev=F({Size=UDim2.new(0,RW,0,44),Position=UDim2.new(0,RX,0,PAD),
                BackgroundColor3=corAtual,ZIndex=2,Parent=pickerCorpo})
            Cantos(bigPrev,8); Stroke(bigPrev,C.Borda,1,0.3)

            local function CorParaHex(c)
                return string.format("#%02X%02X%02X",
                    math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))
            end
            local function HexParaCor(hex)
                hex=hex:gsub("#",""); if #hex~=6 then return nil end
                local r2=tonumber(hex:sub(1,2),16); local g2=tonumber(hex:sub(3,4),16); local b2=tonumber(hex:sub(5,6),16)
                if not r2 or not g2 or not b2 then return nil end
                return Color3.fromRGB(r2,g2,b2)
            end

            local hexFr=F({Size=UDim2.new(0,RW,0,26),Position=UDim2.new(0,RX,0,PAD+48),
                BackgroundColor3=C.Item,ZIndex=2,Parent=pickerCorpo})
            Cantos(hexFr,7); Stroke(hexFr,C.Borda,1,0.4); RC(hexFr,"BackgroundColor3","Item")
            local hexBox=Instance.new("TextBox")
            hexBox.Size=UDim2.new(1,-8,1,-4); hexBox.Position=UDim2.new(0,4,0,2)
            hexBox.BackgroundTransparency=1; hexBox.Text=CorParaHex(corAtual)
            hexBox.TextColor3=C.Texto; hexBox.Font=Enum.Font.GothamBold
            hexBox.TextSize=11; hexBox.TextXAlignment=Enum.TextXAlignment.Center
            hexBox.ClearTextOnFocus=false; hexBox.ZIndex=3; hexBox.Parent=hexFr
            RC(hexBox,"TextColor3","Texto")

            local presets={
                Color3.fromRGB(255,59,59),Color3.fromRGB(255,140,0),Color3.fromRGB(255,210,0),
                Color3.fromRGB(74,222,128),Color3.fromRGB(56,189,248),Color3.fromRGB(167,139,250),
                Color3.fromRGB(232,121,249),Color3.fromRGB(255,100,130),Color3.fromRGB(34,211,238),
                Color3.fromRGB(255,255,255),Color3.fromRGB(148,148,165),Color3.fromRGB(0,0,0),
            }
            local PCOLS=6; local PCELL=IS_MOBILE and 20 or 22; local PGAP=4
            local presetY=valY+BAR_H+8

            local function AtualizarTudo()
                h=math.clamp(h,0,1); s=math.clamp(s,0,1); v2=math.clamp(v2,0,1)
                corAtual=Color3.fromHSV(h,s,v2)
                preview.BackgroundColor3=corAtual; bigPrev.BackgroundColor3=corAtual
                if not hexBox:IsFocused() then hexBox.Text=CorParaHex(corAtual) end
                gradSat.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(h,1,1))
                cvCursor.Position=UDim2.new(s,0,1-v2,0); cvCursor.BackgroundColor3=corAtual
                hueCur.Position=UDim2.new(h,0,0.5,0)
                valGrad.Color=ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,s,1))
                valCur.Position=UDim2.new(v2,0,0.5,0)
                if callback then callback(corAtual) end
            end

            for i,pc in ipairs(presets) do
                local col=(i-1)%PCOLS; local row=math.floor((i-1)/PCOLS)
                local pb=Instance.new("TextButton")
                pb.Size=UDim2.new(0,PCELL,0,PCELL)
                pb.Position=UDim2.new(0,PAD+col*(PCELL+PGAP),0,presetY+row*(PCELL+PGAP))
                pb.BackgroundColor3=pc; pb.Text=""; pb.AutoButtonColor=false
                pb.ZIndex=3; pb.Parent=pickerCorpo; Cantos(pb,5)
                local pbBrd=Stroke(pb,Color3.new(0,0,0),1,0.7)
                pb.MouseEnter:Connect(function()
                    Tw(pb,0.08,{Size=UDim2.new(0,PCELL+3,0,PCELL+3),
                        Position=UDim2.new(0,PAD+col*(PCELL+PGAP)-1,0,presetY+row*(PCELL+PGAP)-1)}):Play()
                    Tw(pbBrd,0.08,{Transparency=0.1}):Play()
                end)
                pb.MouseLeave:Connect(function()
                    Tw(pb,0.08,{Size=UDim2.new(0,PCELL,0,PCELL),
                        Position=UDim2.new(0,PAD+col*(PCELL+PGAP),0,presetY+row*(PCELL+PGAP))}):Play()
                    Tw(pbBrd,0.08,{Transparency=0.7}):Play()
                end)
                pb.MouseButton1Click:Connect(function() h,s,v2=Color3.toHSV(pc); AtualizarTudo() end)
            end

            hexBox.FocusLost:Connect(function()
                local nc=HexParaCor(hexBox.Text)
                if nc then h,s,v2=Color3.toHSV(nc); AtualizarTudo()
                else hexBox.Text=CorParaHex(corAtual) end
            end)

            local dragTipo=nil
            local function Arrastar(px,py)
                if dragTipo=="cv" then
                    local ap=cvFr.AbsolutePosition; local as=cvFr.AbsoluteSize
                    s=math.clamp((px-ap.X)/as.X,0,1); v2=math.clamp(1-(py-ap.Y)/as.Y,0,1); AtualizarTudo()
                elseif dragTipo=="hue" then
                    local ap=hueFr.AbsolutePosition; local as=hueFr.AbsoluteSize
                    h=math.clamp((px-ap.X)/as.X,0,1); AtualizarTudo()
                elseif dragTipo=="val" then
                    local ap=valFr.AbsolutePosition; local as=valFr.AbsoluteSize
                    v2=math.clamp((px-ap.X)/as.X,0,1); AtualizarTudo()
                end
            end

            local function IsBegan(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
            local function IsMoved(i) return i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch end
            local function IsEnded(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end

            local cvHit=Instance.new("TextButton"); cvHit.Size=UDim2.new(1,0,1,0)
            cvHit.BackgroundTransparency=1; cvHit.Text=""; cvHit.AutoButtonColor=false; cvHit.ZIndex=8; cvHit.Parent=cvFr
            cvHit.InputBegan:Connect(function(i) if not IsBegan(i) then return end; dragTipo="cv"; Arrastar(i.Position.X,i.Position.Y) end)

            local hueHit=Instance.new("TextButton"); hueHit.Size=UDim2.new(1,0,1,4); hueHit.Position=UDim2.new(0,0,0,-2)
            hueHit.BackgroundTransparency=1; hueHit.Text=""; hueHit.AutoButtonColor=false; hueHit.ZIndex=5; hueHit.Parent=hueFr
            hueHit.InputBegan:Connect(function(i) if not IsBegan(i) then return end; dragTipo="hue"; Arrastar(i.Position.X,i.Position.Y) end)

            local valHit=Instance.new("TextButton"); valHit.Size=UDim2.new(1,0,1,4); valHit.Position=UDim2.new(0,0,0,-2)
            valHit.BackgroundTransparency=1; valHit.Text=""; valHit.AutoButtonColor=false; valHit.ZIndex=5; valHit.Parent=valFr
            valHit.InputBegan:Connect(function(i) if not IsBegan(i) then return end; dragTipo="val"; Arrastar(i.Position.X,i.Position.Y) end)

            table.insert(hubSelf._conexoes, EntradaUsuario.InputChanged:Connect(function(i)
                if dragTipo==nil then return end
                if IsMoved(i) then Arrastar(i.Position.X,i.Position.Y) end
            end))
            table.insert(hubSelf._conexoes, EntradaUsuario.InputEnded:Connect(function(i)
                if not IsEnded(i) then return end
                dragTipo=nil
            end))

            cab.MouseButton1Click:Connect(function()
                aberto=not aberto
                if aberto then
                    pickerCorpo.Visible=true
                    Tw(fr,0.28,{Size=UDim2.new(1,-6,0,AH)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
                else
                    Tw(fr,0.2,{Size=UDim2.new(1,-6,0,FH2)},Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
                    task.delay(0.2,function() if not aberto then pickerCorpo.Visible=false end end)
                end
                Tw(seta2,0.2,{Rotation=aberto and -90 or 90}):Play()
            end)
            fr.MouseEnter:Connect(function()
                if not aberto then Tw(cab,0.12,{BackgroundColor3=C.ItemHover}):Play() end
            end)
            fr.MouseLeave:Connect(function() Tw(cab,0.12,{BackgroundColor3=C.Cartao}):Play() end)

            AtualizarTudo()
            local obj={}
            function obj:Definir(c) corAtual=c; h,s,v2=Color3.toHSV(c); AtualizarTudo() end
            function obj:Obter() return corAtual end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ TECLA DE ATALHO ════════════════════════════════════
        --[[  local kb = aba:CriarTeclaDeAtalho("Abrir menu", Enum.KeyCode.F, function()
               print("Tecla pressionada!")
             end)
    
             Retorna objeto com:
               kb:Definir(Enum.KeyCode.G)
               kb:Obter()   → Enum.KeyCode ]]
        function Aba:CriarTeclaDeAtalho(texto, teclaPadrao, callback)
            local teclaAtual=teclaPadrao or Enum.KeyCode.F
            local aguardando=false
            local KH=IS_MOBILE and 52 or 46
            local fr=F({Size=UDim2.new(1,-6,0,KH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")
            local reserva=IS_MOBILE and 150 or 108
            L({Size=UDim2.new(1,-reserva,1,0),Position=UDim2.new(0,14,0,0),Text=texto,
                TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(L({Size=UDim2.new(1,-reserva,1,0),Position=UDim2.new(0,14,0,0),Text=texto,
                TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr}),"TextColor3","Texto")
            local BKW=IS_MOBILE and 70 or 88; local BKH=IS_MOBILE and 32 or 28
            local btnTecla=Instance.new("TextButton")
            btnTecla.Size=UDim2.new(0,BKW,0,BKH); btnTecla.Position=UDim2.new(1,-(BKW+8),0.5,-BKH/2)
            btnTecla.BackgroundColor3=C.Item; btnTecla.TextColor3=C.Destaque
            btnTecla.Text=tostring(teclaAtual.Name); btnTecla.Font=Enum.Font.GothamBold; btnTecla.TextSize=12
            btnTecla.AutoButtonColor=false; btnTecla.Parent=fr; Cantos(btnTecla,7)
            RC(btnTecla,"BackgroundColor3","Item"); RC(btnTecla,"TextColor3","Destaque")
            local brdTecla=Stroke(btnTecla,C.Borda,1,0.3); RC(brdTecla,"Color","Borda")

            local function EntrarCaptura()
                aguardando=true; btnTecla.Text="..."; btnTecla.TextColor3=C.Aviso
                Tw(brdTecla,0.15,{Color=C.Aviso,Transparency=0}):Play()
            end
            local function SairCaptura(nome)
                aguardando=false; btnTecla.Text=nome or tostring(teclaAtual.Name)
                btnTecla.TextColor3=C.Destaque; Tw(brdTecla,0.15,{Color=C.Borda,Transparency=0.3}):Play()
            end

            if not IS_MOBILE then
                btnTecla.MouseButton1Click:Connect(function()
                    if not aguardando then EntrarCaptura() else SairCaptura() end
                end)
                btnTecla.MouseEnter:Connect(function()
                    if not aguardando then Tw(btnTecla,0.12,{BackgroundColor3=C.ItemHover}):Play() end
                end)
                btnTecla.MouseLeave:Connect(function() Tw(btnTecla,0.12,{BackgroundColor3=C.Item}):Play() end)
                table.insert(hubSelf._conexoes, EntradaUsuario.InputBegan:Connect(function(input,gp)
                    if gp then return end
                    if input.UserInputType~=Enum.UserInputType.Keyboard then return end
                    if aguardando then
                        if input.KeyCode==Enum.KeyCode.Escape then SairCaptura()
                        else teclaAtual=input.KeyCode; SairCaptura(tostring(teclaAtual.Name)) end
                    else
                        if input.KeyCode==teclaAtual then if callback then callback() end end
                    end
                end))
            end

            if IS_MOBILE then
                local btnEm=Instance.new("TextButton")
                btnEm.Size=UDim2.new(0,56,0,32); btnEm.Position=UDim2.new(1,-64,0.5,-16)
                btnEm.BackgroundColor3=C.BotaoFundo; btnEm.TextColor3=C.BotaoTexto
                btnEm.Text="▶"; btnEm.Font=Enum.Font.GothamBold; btnEm.TextSize=14
                btnEm.AutoButtonColor=false; btnEm.Parent=fr
                Cantos(btnEm,9); RC(btnEm,"BackgroundColor3","BotaoFundo"); RC(btnEm,"TextColor3","BotaoTexto")
                local brdEm=Stroke(btnEm,C.Destaque,1,0.4); RC(brdEm,"Color","Destaque")
                if isRainbow then AddRainbow(brdEm,"Color",0.2) end
                btnEm.MouseButton1Down:Connect(function() Tw(btnEm,0.07,{Size=UDim2.new(0,52,0,28)}):Play() end)
                btnEm.MouseButton1Up:Connect(function() Tw(btnEm,0.12,{Size=UDim2.new(0,56,0,32)}):Play() end)
                btnEm.MouseButton1Click:Connect(function() if callback then callback() end end)
            end

            local obj={}
            function obj:Definir(kc) teclaAtual=kc; SairCaptura(tostring(kc.Name)) end
            function obj:Obter() return teclaAtual end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ CONTADOR ════════════════════════════════════════════
        --[[  local cnt = aba:CriarContador("Velocidade", 0, 10, 1, function(valor)
               print("Confirmado:", valor)  -- chamado somente ao clicar em "✓"
             end, opcoes)
    
             opcoes = {
               step = 0.5,   -- incremento por clique (pode ser decimal)
             }
    
             O valor só é enviado ao callback quando o jogador clicar no botão ✓
    
             Retorna objeto com:
               cnt:Definir(5)
               cnt:Obter()   → número ]]
        function Aba:CriarContador(texto, minV, maxV, padrao, callback, opcoes)
            opcoes=opcoes or {}
            local step2=opcoes.step or 1
            padrao=padrao or minV
            local val2=math.clamp(padrao,minV,maxV)
            local pendente=val2

            local CH2=IS_MOBILE and 72 or 66
            local fr=F({Size=UDim2.new(1,-6,0,CH2),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            L({Size=UDim2.new(0.5,0,0,22),Position=UDim2.new(0,14,0,7),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
            RC(L({Size=UDim2.new(0.5,0,0,22),Position=UDim2.new(0,14,0,7),
                Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=fr}),"TextColor3","Texto")

            local BW2=IS_MOBILE and 32 or 28
            local CTRL_Y=CH2-BW2-10

            local function FormatarVal(v)
                if step2 < 1 then
                    local dec=math.ceil(-math.log10(step2))
                    return string.format("%."..dec.."f", v)
                end
                return tostring(math.floor(v+0.5))
            end

            local lblVal2=L({Size=UDim2.new(0,60,0,BW2),
                Position=UDim2.new(0.5,-30,0,CTRL_Y),
                Text=FormatarVal(val2),TextColor3=C.Texto,Font=Enum.Font.GothamBold,
                TextSize=IS_MOBILE and 15 or 14,Parent=fr})
            RC(lblVal2,"TextColor3","Texto")

            local function MakeBtn(txt, xPos)
                local b2=Instance.new("TextButton")
                b2.Size=UDim2.new(0,BW2,0,BW2)
                b2.Position=UDim2.new(0,xPos,0,CTRL_Y)
                b2.BackgroundColor3=C.Item; b2.TextColor3=C.Destaque
                b2.Text=txt; b2.Font=Enum.Font.GothamBold; b2.TextSize=16
                b2.AutoButtonColor=false; b2.Parent=fr; Cantos(b2,8)
                RC(b2,"BackgroundColor3","Item"); RC(b2,"TextColor3","Destaque")
                Stroke(b2,C.Borda,1,0.4)
                return b2
            end

            local totalW=BW2*3+8+10
            local startX=(JANELA_W - SW - totalW)/2
            startX=math.max(startX, 14)

            local btnMenos=MakeBtn("−", startX)
            local btnMais=MakeBtn("+", startX+BW2+8)
            local btnOk=MakeBtn("✓", startX+BW2*2+16)
            btnOk.TextColor3=C.Sucesso
            btnOk.BackgroundColor3=Lerp3(C.Sucesso,Color3.new(0,0,0),0.7)
            Stroke(btnOk,C.Sucesso,1,0.35)

            lblVal2.Position=UDim2.new(0,startX+BW2+8,0,CTRL_Y-22)
            lblVal2.Size=UDim2.new(0,BW2,0,20)

            local function Upd2()
                lblVal2.Text=FormatarVal(val2)
            end
            local function Animar(btn3)
                Tw(btn3,0.07,{Size=UDim2.new(0,BW2-4,0,BW2-4)}):Play()
                task.delay(0.07,function() Tw(btn3,0.1,{Size=UDim2.new(0,BW2,0,BW2)},Enum.EasingStyle.Back):Play() end)
            end
            btnMenos.MouseButton1Click:Connect(function()
                if val2>minV then
                    val2=val2-step2
                    if val2<minV then val2=minV end
                    val2=math.floor(val2/step2+0.5)*step2
                    Upd2()
                end
                Animar(btnMenos)
            end)
            btnMais.MouseButton1Click:Connect(function()
                if val2<maxV then
                    val2=val2+step2
                    if val2>maxV then val2=maxV end
                    val2=math.floor(val2/step2+0.5)*step2
                    Upd2()
                end
                Animar(btnMais)
            end)
            btnOk.MouseButton1Click:Connect(function()
                Animar(btnOk)
                Tw(btnOk,0.1,{BackgroundColor3=C.Sucesso}):Play()
                task.delay(0.3,function() Tw(btnOk,0.2,{BackgroundColor3=Lerp3(C.Sucesso,Color3.new(0,0,0),0.7)}):Play() end)
                if callback then callback(val2) end
            end)

            local function HoverEffect(btn3, corBase)
                btn3.MouseEnter:Connect(function() Tw(btn3,0.1,{BackgroundColor3=C.ItemHover}):Play() end)
                btn3.MouseLeave:Connect(function() Tw(btn3,0.1,{BackgroundColor3=corBase or C.Item}):Play() end)
            end
            HoverEffect(btnMenos)
            HoverEffect(btnMais)
            fr.MouseEnter:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.ItemHover}):Play() end)
            fr.MouseLeave:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.Cartao}):Play() end)

            local obj={}
            function obj:Definir(v)
                val2=math.clamp(v,minV,maxV)
                val2=math.floor(val2/step2+0.5)*step2
                Upd2()
            end
            function obj:Obter() return val2 end
            obj.Set=obj.Definir; obj.Get=obj.Obter
            return obj
        end

        -- ════════════════ GRUPO DE RADIO ══════════════════════════════════════
        --[[  local rad = aba:CriarRadio("Dificuldade", {"Fácil","Médio","Difícil"}, "Médio", function(escolha)
               print("Escolheu:", escolha)
             end)
    
             titulo  = texto do cabeçalho do grupo (pode ser "" para omitir)
             opcoes  = lista de strings
             padrao  = valor inicial
    
             Retorna objeto com:
               rad:Obter()          → string selecionada
               rad:Definir("Fácil") ]]
        function Aba:CriarRadio(titulo, opcoes2, padrao, callback)
            local selecao=padrao or opcoes2[1]
            local RH2=IS_MOBILE and 38 or 34; local RS=IS_MOBILE and 18 or 16

            local wrap=F({Size=UDim2.new(1,-6,0,0),BackgroundColor3=C.Cartao,
                AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=PO(),
                ClipsDescendants=false,Parent=pagina})
            Cantos(wrap,10); Stroke(wrap,C.Borda,1,0.35); RC(wrap,"BackgroundColor3","Cartao")
            Pad(wrap,8,8,0,0)
            local wLyt=Instance.new("UIListLayout",wrap); wLyt.Padding=UDim.new(0,0)

            if titulo and titulo~="" then
                local hdr=F({Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=wrap})
                L({Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,14,0,0),
                    Text=titulo,TextColor3=C.Sub,Font=Enum.Font.GothamBold,TextSize=10,
                    TextXAlignment=Enum.TextXAlignment.Left,Parent=hdr})
            end

            local radioItems={}
            for _,op2 in ipairs(opcoes2) do
                local isSelected=(op2==selecao)
                local row=F({Size=UDim2.new(1,0,0,RH2),BackgroundTransparency=1,Parent=wrap})
                local hit2=Instance.new("TextButton")
                hit2.Size=UDim2.new(1,0,1,0); hit2.BackgroundTransparency=1
                hit2.Text=""; hit2.AutoButtonColor=false; hit2.ZIndex=2; hit2.Parent=row

                local circle=F({Size=UDim2.new(0,RS,0,RS),Position=UDim2.new(0,14,0.5,-RS/2),
                    BackgroundColor3=isSelected and C.Destaque or C.Item,ZIndex=2,Parent=row})
                Cantos(circle,99); Stroke(circle,isSelected and C.Destaque or C.Borda,2,0.2)

                local dot2=F({Size=UDim2.new(0,RS-8,0,RS-8),AnchorPoint=Vector2.new(0.5,0.5),
                    Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),
                    BackgroundTransparency=isSelected and 0 or 1,ZIndex=3,Parent=circle})
                Cantos(dot2,99)

                local lblOp=L({Size=UDim2.new(1,-(RS+28),1,0),Position=UDim2.new(0,RS+22,0,0),
                    Text=op2,TextColor3=isSelected and C.Texto or C.Sub,
                    Font=isSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                    TextSize=IS_MOBILE and 12 or 13,TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=2,Parent=row})

                table.insert(radioItems,{op=op2,circle=circle,dot=dot2,lbl=lblOp,row=row})

                hit2.MouseButton1Click:Connect(function()
                    selecao=op2
                    for _,ri in ipairs(radioItems) do
                        local sel2=ri.op==op2
                        Tw(ri.circle,0.15,{BackgroundColor3=sel2 and C.Destaque or C.Item}):Play()
                        Tw(ri.dot,0.15,{BackgroundTransparency=sel2 and 0 or 1}):Play()
                        ri.lbl.TextColor3=sel2 and C.Texto or C.Sub
                        ri.lbl.Font=sel2 and Enum.Font.GothamBold or Enum.Font.Gotham
                    end
                    if callback then callback(selecao) end
                end)
                hit2.MouseEnter:Connect(function() Tw(row,0.1,{BackgroundColor3=C.ItemHover}):Play() end)
                hit2.MouseLeave:Connect(function() Tw(row,0.1,{BackgroundTransparency=1}):Play() end)
            end

            local obj={}
            function obj:Obter() return selecao end
            function obj:Definir(v)
                selecao=v
                for _,ri in ipairs(radioItems) do
                    local sel2=ri.op==v
                    ri.circle.BackgroundColor3=sel2 and C.Destaque or C.Item
                    ri.dot.BackgroundTransparency=sel2 and 0 or 1
                    ri.lbl.TextColor3=sel2 and C.Texto or C.Sub
                    ri.lbl.Font=sel2 and Enum.Font.GothamBold or Enum.Font.Gotham
                end
            end
            obj.Get=obj.Obter; obj.Set=obj.Definir
            return obj
        end

        -- ════════════════ EXPANSÍVEL (antigo Acordeão) ════════════════════════
        --[[  local exp = aba:CriarExpansivel("Mais informações", "Texto de conteúdo aqui...")
    
             conteudo pode ser uma string ou function() return "texto" end
    
             Retorna objeto com:
               exp:SetTitulo("Novo título")
               exp:SetConteudo("Novo texto")
               exp:Abrir()
               exp:Fechar() ]]
        function Aba:CriarExpansivel(titulo2, conteudo)
            local _titulo=titulo2
            local _conteudo=type(conteudo)=="function" and conteudo() or (conteudo or "")
            local aberto2=false
            local AH2=IS_MOBILE and 44 or 40
            local fr=F({Size=UDim2.new(1,-6,0,AH2),BackgroundColor3=C.Cartao,
                LayoutOrder=PO(),ClipsDescendants=true,Parent=pagina})
            Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

            local cab2=Instance.new("TextButton")
            cab2.Size=UDim2.new(1,0,0,AH2); cab2.BackgroundTransparency=1
            cab2.Text=""; cab2.AutoButtonColor=false; cab2.ZIndex=2; cab2.Parent=fr

            local lblTitExp=L({Size=UDim2.new(1,-40,1,0),Position=UDim2.new(0,14,0,0),Text=_titulo,
                TextColor3=C.Texto,Font=Enum.Font.GothamBold,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=cab2})
            RC(lblTitExp,"TextColor3","Texto")
            local chevron=L({Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-28,0,0),
                Text="›",TextColor3=C.Fraco,Font=Enum.Font.GothamBold,
                TextSize=16,Rotation=90,ZIndex=3,Parent=cab2})
            RC(chevron,"TextColor3","Fraco")

            local corpo2=F({Size=UDim2.new(1,-28,0,0),Position=UDim2.new(0,14,0,AH2+4),
                BackgroundTransparency=1,ZIndex=2,Parent=fr})
            local lbl2=L({Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                Text=_conteudo,
                TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=IS_MOBILE and 11 or 12,
                TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=3,Parent=corpo2})
            RC(lbl2,"TextColor3","Sub")

            local function RecalcularAltura()
                task.defer(function()
                    if not lbl2.Parent then return end
                    local contentH=lbl2.TextBounds.Y+8
                    local targetH=aberto2 and AH2+contentH+12 or AH2
                    Tw(fr,0.25,{Size=UDim2.new(1,-6,0,targetH)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
                end)
            end

            cab2.MouseButton1Click:Connect(function()
                aberto2=not aberto2
                Tw(chevron,0.2,{Rotation=aberto2 and -90 or 90}):Play()
                RecalcularAltura()
            end)
            cab2.MouseEnter:Connect(function() Tw(fr,0.1,{BackgroundColor3=C.ItemHover}):Play() end)
            cab2.MouseLeave:Connect(function() Tw(fr,0.1,{BackgroundColor3=C.Cartao}):Play() end)

            local obj={}
            function obj:SetTitulo(t) lblTitExp.Text=t end
            function obj:SetConteudo(t)
                lbl2.Text=t
                if aberto2 then RecalcularAltura() end
            end
            function obj:Abrir()
                if not aberto2 then aberto2=true; Tw(chevron,0.2,{Rotation=-90}):Play(); RecalcularAltura() end
            end
            function obj:Fechar()
                if aberto2 then aberto2=false; Tw(chevron,0.2,{Rotation=90}):Play(); RecalcularAltura() end
            end
            return obj
        end

        return Aba
    end

    -- ─────────────── Dropdown de temas ──────────────────────────────────────
    function self:CriarDropdownTemas(aba)
        return aba:CriarDropdown(
            "Tema", Hub.Temas,
            function(novoTema) self:MudarTemaPara(novoTema) end,
            {search=true, maxVisible=6, placeholder="Escolher tema..."}
        )
    end

    self.EhMobile = IS_MOBILE
    return self
end

Hub.new = Hub.novo

return Hub
