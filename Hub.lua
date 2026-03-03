-- ╔══════════════════════════════════════════════════════════╗
-- ║               HUB UI — MÓDULO v6.6                      ║
-- ║  + CriarDropdown v3.0 — parâmetros diretos              ║
-- ║  + Botão fechar com X unicode limpo                     ║
-- ║  + Slider v2 — steps, snap, valor float, label unidade  ║
-- ║  + dropdown.valor — propriedade sempre atualizada       ║
-- ╚══════════════════════════════════════════════════════════╝

local Hub = {}
Hub.__index = Hub

local TweenService   = game:GetService("TweenService")
local EntradaUsuario = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")

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
	local s = Instance.new("UIStroke"); s.Color=cor; s.Thickness=thick or 1; s.Transparency=transp or 0; s.Parent=obj; return s
end
local function F(props)
	local f = Instance.new("Frame"); f.BorderSizePixel=0
	for k,v in pairs(props) do f[k]=v end; return f
end
local function L(props)
	local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.BorderSizePixel=0
	for k,v in pairs(props) do l[k]=v end; return l
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
		obj[prop] = HueParaCor(t)
	end)
	return conn
end

function Hub.novo(nome, tema, velocidade)
	local self       = setmetatable({}, Hub)
	self._conexoes   = {}
	self._rodando    = true
	self._aoFechar   = nil
	self._fechado    = false
	self._nomeHub    = nome
	self._temaAtual  = tema or "Escuro"

	local _colorRefs = {}
	local function RegCor(obj, prop, chave) table.insert(_colorRefs,{obj=obj,prop=prop,key=chave}) end
	local _gradRefs = {}
	local function RegGrad(grad,k1,k2,rot) table.insert(_gradRefs,{grad=grad,k1=k1,k2=k2,rot=rot or 90}) end

	local C         = paletas[self._temaAtual] or paletas.Escuro
	local isRainbow = C.Rainbow == true
	local _rainbowConns = {}

	local function StopRainbow()
		for _,c in pairs(_rainbowConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
		_rainbowConns = {}
	end
	local function AddRainbow(obj,prop,vel)
		local conn = IniciarRainbow(obj,prop,vel,function() return self._rodando end)
		table.insert(_rainbowConns,conn); return conn
	end

	local gui = Instance.new("ScreenGui")
	gui.Name="HubUI"; gui.ResetOnSpawn=false
	gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset=true
	gui.Parent=game.Players.LocalPlayer:WaitForChild("PlayerGui")
	self.Gui = gui

	local vp       = workspace.CurrentCamera.ViewportSize
	local TOPBAR_H = 48
	local SIDEBAR_W = IS_MOBILE and 100 or 158

	local JANELA_W, JANELA_H
	if IS_MOBILE then
		JANELA_W = math.max(math.min(vp.X - 16, 660), 400)
		JANELA_H = math.max(math.min(vp.Y - 80, 400), 320)
	else
		JANELA_W = 745
		JANELA_H = 500
	end

	local ALTURA_CHEIA = JANELA_H
	local ALTURA_MIN   = TOPBAR_H
	local posCenter    = UDim2.new(0.5,-JANELA_W/2, 0.5,-JANELA_H/2)

	local janela = F({
		Name="Janela",
		Size=UDim2.new(0,JANELA_W,0,ALTURA_CHEIA),
		Position=UDim2.new(0.5,-JANELA_W/2, 0.5,-JANELA_H/2+22),
		BackgroundColor3=C.Janela, Active=true, ClipsDescendants=true, Parent=gui,
	})
	Cantos(janela,14)
	local bordaJanela = Stroke(janela,C.Borda,1,0.18)
	RegCor(janela,"BackgroundColor3","Janela"); RegCor(bordaJanela,"Color","Borda")
	self.Janela = janela

	local linhaTop = F({Size=UDim2.new(0.5,0,0,3),Position=UDim2.new(0.25,0,0,0),
		BackgroundColor3=C.Destaque,ZIndex=12,Parent=janela})
	Cantos(linhaTop,99); RegCor(linhaTop,"BackgroundColor3","Destaque")
	local linhaTopGrad = Grad(linhaTop,C.DestaqueV,C.Destaque,0)
	RegGrad(linhaTopGrad,"DestaqueV","Destaque",0)

	Tw(janela,0.45,{Position=posCenter},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()

	local topbar = F({Size=UDim2.new(1,0,0,TOPBAR_H),BackgroundColor3=C.Topbar,ZIndex=10,Parent=janela})
	Cantos(topbar,14); RegCor(topbar,"BackgroundColor3","Topbar")
	F({Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=C.Topbar,ZIndex=10,Parent=topbar})
	local linhaSep = F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Borda,ZIndex=11,Parent=topbar})
	RegCor(linhaSep,"BackgroundColor3","Borda")

	local ponto = F({Size=UDim2.new(0,9,0,9),Position=UDim2.new(0,16,0.5,-4),
		BackgroundColor3=C.PontoA,ZIndex=12,Parent=topbar})
	Cantos(ponto,99); RegCor(ponto,"BackgroundColor3","PontoA")

	if isRainbow then
		AddRainbow(ponto,"BackgroundColor3",0.25)
	else
		task.spawn(function()
			while self._rodando do
				Tw(ponto,1.1,{BackgroundColor3=C.PontoB}):Play(); task.wait(1.1)
				Tw(ponto,1.1,{BackgroundColor3=C.PontoA}):Play(); task.wait(1.1)
			end
		end)
	end

	local BW = IS_MOBILE and 32 or 28
	local BH = IS_MOBILE and 32 or 28

	local lblNome = L({Size=UDim2.new(1,-(BW*2+60),1,0),Position=UDim2.new(0,33,0,0),
		Text=nome,TextColor3=C.Texto,Font=Enum.Font.GothamBold,TextSize=15,
		TextXAlignment=Enum.TextXAlignment.Left,ZIndex=12,Parent=topbar})
	RegCor(lblNome,"TextColor3","Texto")

	local btnMin = Instance.new("TextButton")
	btnMin.Size=UDim2.new(0,BW,0,BH); btnMin.Position=UDim2.new(1,-(BW*2+16),0.5,-BH/2)
	btnMin.Text="–"; btnMin.Font=Enum.Font.GothamBold; btnMin.TextSize=16
	btnMin.TextColor3=C.Sub; btnMin.BackgroundColor3=C.Item
	btnMin.AutoButtonColor=false; btnMin.ZIndex=12; btnMin.Parent=topbar
	Cantos(btnMin,99); RegCor(btnMin,"BackgroundColor3","Item"); RegCor(btnMin,"TextColor3","Sub")

	-- ✦ MODIFICAÇÃO: botão fechar com X unicode limpo
	local btnX = Instance.new("TextButton")
	btnX.Size=UDim2.new(0,BW,0,BH); btnX.Position=UDim2.new(1,-(BW+8),0.5,-BH/2)
	btnX.Text="✕"; btnX.Font=Enum.Font.GothamBold; btnX.TextSize=14
	btnX.TextColor3=Color3.new(1,1,1); btnX.BackgroundColor3=C.Perigo
	btnX.AutoButtonColor=false; btnX.ZIndex=12; btnX.Parent=topbar
	Cantos(btnX,99); RegCor(btnX,"BackgroundColor3","Perigo")

	btnMin.MouseEnter:Connect(function() Tw(btnMin,0.15,{BackgroundColor3=C.ItemHover,TextColor3=C.Texto}):Play() end)
	btnMin.MouseLeave:Connect(function() Tw(btnMin,0.15,{BackgroundColor3=C.Item,TextColor3=C.Sub}):Play() end)
	btnX.MouseEnter:Connect(function() Tw(btnX,0.15,{BackgroundColor3=Color3.fromRGB(255,80,80),Size=UDim2.new(0,BW+3,0,BH+3)}):Play() end)
	btnX.MouseLeave:Connect(function() Tw(btnX,0.15,{BackgroundColor3=C.Perigo,Size=UDim2.new(0,BW,0,BH)}):Play() end)
	btnX.MouseButton1Down:Connect(function() Tw(btnX,0.07,{Size=UDim2.new(0,BW-3,0,BH-3)}):Play() end)
	btnX.MouseButton1Up:Connect(function() Tw(btnX,0.1,{Size=UDim2.new(0,BW,0,BH)}):Play() end)

	local corpo = F({Size=UDim2.new(1,0,1,-TOPBAR_H),Position=UDim2.new(0,0,0,TOPBAR_H),
		BackgroundTransparency=1,Parent=janela})

	local minimizado = false
	local function AtualizarMinimizado()
		if minimizado then
			corpo.Visible=false; linhaSep.Visible=false
			Tw(janela,0.22,{Size=UDim2.new(0,JANELA_W,0,ALTURA_MIN)}):Play()
			btnMin.Text="+"
		else
			Tw(janela,0.28,{Size=UDim2.new(0,JANELA_W,0,ALTURA_CHEIA)},
			Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
			btnMin.Text="–"; linhaSep.Visible=true
			task.delay(0.28,function() if not minimizado then corpo.Visible=true end end)
		end
	end
	btnMin.MouseButton1Click:Connect(function() minimizado=not minimizado; AtualizarMinimizado() end)

	local drag,dragStart,posStart = false,nil,nil
	local fatorVel = (velocidade == "Lento") and 0.7 or 1
	local dragArea
	if IS_MOBILE then
		dragArea = Instance.new("TextButton")
		dragArea.Size=UDim2.new(1,-(BW*2+60),1,0); dragArea.Position=UDim2.new(0,33,0,0)
		dragArea.BackgroundTransparency=1; dragArea.Text=""; dragArea.AutoButtonColor=false
		dragArea.ZIndex=11; dragArea.Parent=topbar
	else
		dragArea = topbar
	end
	local function IniciarDrag(pos) drag=true; dragStart=pos; posStart=janela.Position end
	local function AtualizarDrag(pos)
		if not drag then return end
		local d=pos-dragStart
		janela.Position=UDim2.new(posStart.X.Scale,posStart.X.Offset+d.X*fatorVel,posStart.Y.Scale,posStart.Y.Offset+d.Y*fatorVel)
	end
	local function EncerrarDrag() drag=false end
	dragArea.InputBegan:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then IniciarDrag(e.Position) end
	end)
	dragArea.InputChanged:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseMovement or e.UserInputType==Enum.UserInputType.Touch then AtualizarDrag(e.Position) end
	end)
	dragArea.InputEnded:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then EncerrarDrag() end
	end)
	EntradaUsuario.InputChanged:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseMovement or e.UserInputType==Enum.UserInputType.Touch then AtualizarDrag(e.Position) end
	end)
	EntradaUsuario.InputEnded:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then EncerrarDrag() end
	end)

	local function Fechar(pararConexoes)
		if self._fechado then return end
		self._fechado=true; self._rodando=false; StopRainbow()
		if pararConexoes~=false then
			for _,c in pairs(self._conexoes) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
		end
		if self._aoFechar then pcall(self._aoFechar) end
		Tw(janela,0.22,{Position=UDim2.new(janela.Position.X.Scale,janela.Position.X.Offset,janela.Position.Y.Scale,janela.Position.Y.Offset+26),BackgroundTransparency=1},
		Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
		task.delay(0.24,function() if gui and gui.Parent then gui:Destroy() end end)
	end
	btnX.MouseButton1Click:Connect(function() Fechar(true) end)

	function self:AoFechar(fn) self._aoFechar=fn end
	function self:Fechar(p) Fechar(p) end
	function self:RegistrarConexao(c) table.insert(self._conexoes,c); return c end

	local _todasTabsRef = nil

	function self:MudarTemaPara(novoTema)
		local P = paletas[novoTema]
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
		if isRainbow then AddRainbow(ponto,"BackgroundColor3",0.25); AddRainbow(linhaTop,"BackgroundColor3",0.12) end
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
		self:Notificar("Tema","Tema alterado para "..novoTema,"info",2.5)
	end

	local NOTIF_W = IS_MOBILE and math.min(JANELA_W-24, 240) or 310
	local notifHolder = F({
		Size=UDim2.new(0,NOTIF_W,1,-20), Position=UDim2.new(1,-(NOTIF_W+4),0,10),
		BackgroundTransparency=1, ZIndex=300, Parent=gui,
	})
	local notifLayout = Instance.new("UIListLayout",notifHolder)
	notifLayout.VerticalAlignment=Enum.VerticalAlignment.Bottom
	notifLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
	notifLayout.Padding=UDim.new(0,5)
	Pad(notifHolder,0,IS_MOBILE and 6 or 8,0,0)

	local NOTIF_TIPOS = {
		sucesso={icone="✓",cor=Color3.fromRGB(48,205,125)},
		erro   ={icone="✕",cor=Color3.fromRGB(215,58,58)},
		aviso  ={icone="!",cor=Color3.fromRGB(255,178,35)},
		info   ={icone="i",cor=Color3.fromRGB(65,155,255)},
	}

	function self:Notificar(titulo, mensagem, tipo, duracao)
		tipo=tipo or "info"; duracao=duracao or 3.5
		local cfg=NOTIF_TIPOS[tipo] or NOTIF_TIPOS.info
		local icSize=IS_MOBILE and 24 or 28
		local offsetX=icSize+16
		local padX=offsetX+8
		local minH=IS_MOBILE and 50 or 60
		local card=F({Size=UDim2.new(1,0,0,minH),BackgroundColor3=C.Cartao,ZIndex=301,Parent=notifHolder})
		Cantos(card,9); Stroke(card,cfg.cor,1,0.5)
		card.Position=UDim2.new(0,NOTIF_W+10,0,0)
		local ic=F({Size=UDim2.new(0,icSize,0,icSize),Position=UDim2.new(0,9,0,0),BackgroundColor3=cfg.cor,ZIndex=302,Parent=card})
		Cantos(ic,99)
		L({Size=UDim2.new(1,0,1,0),Text=cfg.icone,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=IS_MOBILE and 11 or 12,ZIndex=303,Parent=ic})
		local lblTitulo=L({Size=UDim2.new(1,-(padX+8),0,16),Position=UDim2.new(0,offsetX,0,IS_MOBILE and 6 or 8),
			Text=titulo,TextColor3=C.Texto,Font=Enum.Font.GothamBold,TextSize=IS_MOBILE and 11 or 12,
			TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=302,Parent=card})
		local lblMsg=L({Size=UDim2.new(1,-(padX+8),0,14),Position=UDim2.new(0,offsetX,0,IS_MOBILE and 22 or 26),
			Text=mensagem or "",TextColor3=C.Sub,Font=Enum.Font.Gotham,TextSize=IS_MOBILE and 10 or 11,
			TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=302,Parent=card})
		local base=F({Size=UDim2.new(1,-12,0,2),Position=UDim2.new(0,6,1,-4),BackgroundColor3=C.Fraco,ZIndex=302,Parent=card})
		Cantos(base,99)
		local fill=F({Size=UDim2.new(1,0,1,0),BackgroundColor3=cfg.cor,ZIndex=303,Parent=base})
		Cantos(fill,99)
		task.defer(function()
			local altTitulo=lblTitulo.TextBounds.Y; local altMsg=lblMsg.TextBounds.Y
			local topPad=IS_MOBILE and 6 or 8; local gap=4; local botPad=10
			local altTotal=math.max(topPad+altTitulo+gap+altMsg+botPad+4,minH)
			card.Size=UDim2.new(1,0,0,altTotal)
			ic.Position=UDim2.new(0,9,0,altTotal/2-icSize/2)
			lblMsg.Position=UDim2.new(0,offsetX,0,topPad+altTitulo+gap)
			Tw(card,0.3,{Position=UDim2.new(0,0,0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
			task.spawn(function()
				Tw(fill,duracao,{Size=UDim2.new(0,0,1,0)},Enum.EasingStyle.Linear):Play()
				task.wait(duracao)
				Tw(card,0.2,{Position=UDim2.new(0,NOTIF_W+10,0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
				task.wait(0.22); card:Destroy()
			end)
		end)
	end

	-- ══════════════════════════════════════════════
	--  SIDEBAR REDESENHADA
	-- ══════════════════════════════════════════════
	local pagArea, scrollTabs
	local SW = SIDEBAR_W

	local sidebar = F({
		Size=UDim2.new(0,SW,1,0),
		BackgroundColor3=C.Sidebar, Parent=corpo,
	})
	RegCor(sidebar,"BackgroundColor3","Sidebar")
	Cantos(sidebar,12)
	-- tampa os cantos arredondados da esquerda
	F({Size=UDim2.new(0.5,0,1,0), BackgroundColor3=C.Sidebar, Parent=sidebar})
	RegCor(F({Size=UDim2.new(0.5,0,1,0), BackgroundColor3=C.Sidebar, Parent=sidebar}),"BackgroundColor3","Sidebar")

	-- divisor direito com gradiente sutil
	local divSide = F({
		Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
		BackgroundColor3=C.Borda, ZIndex=3, Parent=sidebar,
	})
	RegCor(divSide,"BackgroundColor3","Borda")

	-- label "MENU" no topo da sidebar (só desktop)
	local topOffsetSidebar = IS_MOBILE and 10 or 44
	if not IS_MOBILE then
		local lblNav = L({
			Size=UDim2.new(1,-16,0,26), Position=UDim2.new(0,8,0,10),
			Text="M E N U", TextColor3=C.Destaque, Font=Enum.Font.GothamBold,
			TextSize=9, TextXAlignment=Enum.TextXAlignment.Left,
			ZIndex=3, Parent=sidebar,
		})
		RegCor(lblNav,"TextColor3","Destaque")
		-- linha abaixo do label
		local linhMenu = F({
			Size=UDim2.new(1,-16,0,1), Position=UDim2.new(0,8,0,36),
			BackgroundColor3=C.Borda, ZIndex=3, Parent=sidebar,
		})
		RegCor(linhMenu,"BackgroundColor3","Borda")
	end

	scrollTabs = Instance.new("ScrollingFrame")
	scrollTabs.Size = UDim2.new(1,0,1,-topOffsetSidebar)
	scrollTabs.Position = UDim2.new(0,0,0,topOffsetSidebar)
	scrollTabs.CanvasSize = UDim2.new(0,0,0,0)
	scrollTabs.ScrollBarThickness = 0
	scrollTabs.BackgroundTransparency = 1
	scrollTabs.BorderSizePixel = 0
	scrollTabs.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollTabs.Parent = sidebar
	Pad(scrollTabs, 6, 10, IS_MOBILE and 5 or 7, IS_MOBILE and 5 or 7)
	local lyT = Instance.new("UIListLayout", scrollTabs)
	lyT.Padding = UDim.new(0, IS_MOBILE and 4 or 5)
	lyT.HorizontalAlignment = Enum.HorizontalAlignment.Center
	lyT:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollTabs.CanvasSize = UDim2.new(0,0,0,lyT.AbsoluteContentSize.Y+20)
	end)

	pagArea = F({
		Size=UDim2.new(1,-(SW+6),1,-10),
		Position=UDim2.new(0,SW+2,0,5),
		BackgroundTransparency=1, Parent=corpo,
	})

	local todasTabs = {}
	local tabAtiva  = nil
	_todasTabsRef   = todasTabs

	local function AtivarAba(e)
		if tabAtiva == e then return end
		local anterior = tabAtiva
		tabAtiva = e

		for _, t in ipairs(todasTabs) do
			local ok = (t == e)
			t._ativo = ok
			t.pagina.Visible = ok

			if ok then
				-- ativa: fundo destaque + texto branco + indicador cresce
				Tw(t.btn, 0.2, {BackgroundColor3=C.Destaque}, Enum.EasingStyle.Quart):Play()
				Tw(t.lbl, 0.2, {TextColor3=Color3.new(1,1,1)}):Play()
				if t.ico then Tw(t.ico, 0.2, {TextColor3=Color3.new(1,1,1)}):Play() end
				t.lbl.Font = Enum.Font.GothamBold
				-- indicador lateral
				if t.ind then
					t.ind.BackgroundTransparency = 0
					Tw(t.ind, 0.22, {Size=UDim2.new(0,3,0.7,0)},
						Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				end
				-- brilho pontual no botão
				if t.glow then
					t.glow.BackgroundTransparency = 0.82
					Tw(t.glow, 0.35, {BackgroundTransparency=1}):Play()
				end
			else
				Tw(t.btn, 0.18, {BackgroundColor3=C.Item}):Play()
				Tw(t.lbl, 0.18, {TextColor3=C.Sub}):Play()
				if t.ico then Tw(t.ico, 0.18, {TextColor3=C.Fraco}):Play() end
				t.lbl.Font = Enum.Font.Gotham
				if t.ind then
					Tw(t.ind, 0.15, {Size=UDim2.new(0,3,0,0)}):Play()
					task.delay(0.15, function()
						if not t._ativo then t.ind.BackgroundTransparency=1 end
					end)
				end
			end
		end
	end

	local hubSelf = self

	function self:CriarAba(nomeAba, icone)
		local BTN_H = IS_MOBILE and 40 or 42

		-- container do botão (para permitir overflow do indicador)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,BTN_H)
		btn.BackgroundColor3 = C.Item
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ClipsDescendants = false
		btn.ZIndex = 2
		btn.Parent = scrollTabs
		Cantos(btn, 9)
		RegCor(btn,"BackgroundColor3","Item")

		-- borda sutil
		local btnBrd = Stroke(btn, C.Borda, 1, 0.6)
		RegCor(btnBrd,"Color","Borda")

		-- indicador lateral esquerdo
		local ind = F({
			Size=UDim2.new(0,3,0,0),
			Position=UDim2.new(0,-1,0.5,0),
			AnchorPoint=Vector2.new(0,0.5),
			BackgroundColor3=C.Destaque,
			BackgroundTransparency=1,
			ZIndex=4, Parent=btn,
		})
		Cantos(ind,99); RegCor(ind,"BackgroundColor3","Destaque")

		-- glow de clique (flash)
		local glow = F({
			Size=UDim2.new(1,0,1,0),
			BackgroundColor3=C.Destaque,
			BackgroundTransparency=1,
			ZIndex=3, Parent=btn,
		})
		Cantos(glow,9); RegCor(glow,"BackgroundColor3","Destaque")

		-- ícone (se tiver)
		local ico = nil
		local lblX = 10
		if icone then
			ico = L({
				Size=UDim2.new(0,22,1,0),
				Position=UDim2.new(0,8,0,0),
				Text=icone,
				TextColor3=C.Fraco,
				Font=Enum.Font.GothamBold,
				TextSize=IS_MOBILE and 15 or 16,
				ZIndex=3, Parent=btn,
			})
			RegCor(ico,"TextColor3","Fraco")
			lblX = IS_MOBILE and 32 or 34
		end

		-- label do nome
		local lbl = L({
			Size=UDim2.new(1,-(lblX+6),1,0),
			Position=UDim2.new(0,lblX,0,0),
			Text=nomeAba,
			TextColor3=C.Sub,
			Font=Enum.Font.Gotham,
			TextSize=IS_MOBILE and 11 or 12,
			TextXAlignment=Enum.TextXAlignment.Left,
			TextTruncate=Enum.TextTruncate.AtEnd,
			ZIndex=3, Parent=btn,
		})
		RegCor(lbl,"TextColor3","Sub")

		-- hover (só quando não ativo)
		btn.MouseEnter:Connect(function()
			if tabAtiva and tabAtiva.btn ~= btn then
				Tw(btn, 0.12, {BackgroundColor3=C.ItemHover}):Play()
				Tw(btnBrd, 0.12, {Transparency=0.3}):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			if tabAtiva and tabAtiva.btn ~= btn then
				Tw(btn, 0.12, {BackgroundColor3=C.Item}):Play()
				Tw(btnBrd, 0.12, {Transparency=0.6}):Play()
			end
		end)
		btn.MouseButton1Down:Connect(function()
			Tw(btn, 0.07, {Size=UDim2.new(1,-4,0,BTN_H-2)}):Play()
		end)
		btn.MouseButton1Up:Connect(function()
			Tw(btn, 0.12, {Size=UDim2.new(1,0,0,BTN_H)}):Play()
		end)

		-- página de conteúdo
		local pagina = Instance.new("ScrollingFrame")
		pagina.Size = UDim2.new(1,0,1,0)
		pagina.CanvasSize = UDim2.new(0,0,0,0)
		pagina.ScrollBarThickness = 3
		pagina.ScrollBarImageColor3 = C.Destaque
		pagina.Visible = false
		pagina.BackgroundTransparency = 1
		pagina.BorderSizePixel = 0
		pagina.Parent = pagArea
		Pad(pagina, 8, 8, IS_MOBILE and 6 or 5, IS_MOBILE and 6 or 5)
		local lyPag = Instance.new("UIListLayout", pagina)
		lyPag.Padding = UDim.new(0,7)
		lyPag.SortOrder = Enum.SortOrder.LayoutOrder
		lyPag:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			pagina.CanvasSize = UDim2.new(0,0,0,lyPag.AbsoluteContentSize.Y+20)
		end)

		local entrada = {btn=btn, lbl=lbl, ico=ico, ind=ind, glow=glow, pagina=pagina, _ativo=false}
		table.insert(todasTabs, entrada)
		btn.MouseButton1Click:Connect(function() AtivarAba(entrada) end)
		if #todasTabs == 1 then AtivarAba(entrada) end

		local IH    = IS_MOBILE and 48 or 46
		local BTN_H = IS_MOBILE and 42 or 40
		local SLH   = IS_MOBILE and 72 or 68

		local Aba = {}
		local ord = 0
		local function PO() ord+=1; return ord end
		local function RC(obj,prop,key) RegCor(obj,prop,key) end

		-- ╔══════════════════════════════════════════════════════════╗
		-- ║  CriarColorPicker                                       ║
		-- ╚══════════════════════════════════════════════════════════╝
		function Aba:CriarColorPicker(texto, padraoColor3, callback)
			local corAtual = padraoColor3 or Color3.fromRGB(255,255,255)
			local h, s, v  = Color3.toHSV(corAtual)
			local aberto   = false
			local FH       = IS_MOBILE and 44 or 40
			local PICKER_H = IS_MOBILE and 240 or 175
			local AH       = FH + PICKER_H + 8

			local fr = F({Size=UDim2.new(1,-6,0,FH), BackgroundColor3=C.Cartao,
				ClipsDescendants=true, LayoutOrder=PO(), Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

			local cab = Instance.new("TextButton")
			cab.Size=UDim2.new(1,0,0,FH); cab.BackgroundTransparency=1
			cab.Text=""; cab.AutoButtonColor=false; cab.Parent=fr

			L({Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0,14,0,0), Text=texto,
				TextColor3=C.Sub, Font=Enum.Font.Gotham, TextSize=12,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=cab})

			local preview = F({Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-52,0.5,-11),
				BackgroundColor3=corAtual, ZIndex=2, Parent=cab})
			Cantos(preview,6); Stroke(preview,C.Borda,1,0.2)

			local seta = L({Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-26,0,0),
				Text="›", TextColor3=C.Fraco, Font=Enum.Font.GothamBold,
				TextSize=16, Rotation=90, Parent=cab})
			RC(seta,"TextColor3","Fraco")

			local corpo2 = F({Size=UDim2.new(1,0,0,PICKER_H),
				Position=UDim2.new(0,0,0,FH), BackgroundTransparency=1, Parent=fr})

			local slH_ref, slS_ref, slV_ref
			local bigPreview_ref, lblHex_ref

			local function CorParaHex(c)
				return string.format("#%02X%02X%02X",
					math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
			end
			local function HueGrad()
				local kfs={}
				for i=0,6 do
					table.insert(kfs, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6,1,1)))
				end
				return ColorSequence.new(kfs)
			end

			local function AtualizarTudo()
				h = math.clamp(h,0,1); s = math.clamp(s,0,1); v = math.clamp(v,0,1)
				corAtual = Color3.fromHSV(h,s,v)
				preview.BackgroundColor3 = corAtual
				if bigPreview_ref then bigPreview_ref.BackgroundColor3 = corAtual end
				if lblHex_ref     then lblHex_ref.Text = CorParaHex(corAtual) end
				if slH_ref then slH_ref.setPos(h); slH_ref.grad.Color = HueGrad() end
				if slS_ref then slS_ref.setPos(s); slS_ref.grad.Color = ColorSequence.new(Color3.fromHSV(h,0,v), Color3.fromHSV(h,1,v)) end
				if slV_ref then slV_ref.setPos(v); slV_ref.grad.Color = ColorSequence.new(Color3.fromHSV(h,s,0), Color3.fromHSV(h,s,1)) end
				if callback then callback(corAtual) end
			end

			local function CriarSliderHSV(label, yPos, xPos, largura, bolaSize, lblSize, hitH, prop)
				L({Size=UDim2.new(0,largura,0,14), Position=UDim2.new(0,xPos,0,yPos),
					Text=label, TextColor3=C.Sub, Font=Enum.Font.GothamBold, TextSize=lblSize,
					TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=corpo2})
				local trilha = F({Size=UDim2.new(0,largura,0,IS_MOBILE and 6 or 5),
					Position=UDim2.new(0,xPos,0,yPos+(IS_MOBILE and 16 or 14)),
					BackgroundColor3=C.Item, ZIndex=2, Parent=corpo2})
				Cantos(trilha,99); RC(trilha,"BackgroundColor3","Item")
				local grad = Instance.new("UIGradient"); grad.Rotation=0; grad.Parent=trilha
				local bola = F({Size=UDim2.new(0,bolaSize,0,bolaSize), Position=UDim2.new(0,0,0.5,0),
					AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), ZIndex=4, Parent=trilha})
				Cantos(bola,99); Stroke(bola,Color3.new(0,0,0),1,0.7)
				local hitbox = F({Size=UDim2.new(1,0,0,hitH), Position=UDim2.new(0,0,0.5,-hitH/2),
					BackgroundTransparency=1, ZIndex=5, Parent=trilha})
				local ativo = false
				local function setPos(p) bola.Position = UDim2.new(math.clamp(p,0,1), 0, 0.5, 0) end
				local function getP(inputX) return math.clamp((inputX - trilha.AbsolutePosition.X) / trilha.AbsoluteSize.X, 0, 1) end
				hitbox.InputBegan:Connect(function(i)
					if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
						ativo=true; local p=getP(i.Position.X)
						if prop=="h" then h=p elseif prop=="s" then s=p else v=p end
						AtualizarTudo(); Tw(bola,0.08,{Size=UDim2.new(0,bolaSize+4,0,bolaSize+4)}):Play()
					end
				end)
				table.insert(hubSelf._conexoes, EntradaUsuario.InputChanged:Connect(function(i)
					if not ativo then return end
					if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
						local p=getP(i.Position.X)
						if prop=="h" then h=p elseif prop=="s" then s=p else v=p end
						AtualizarTudo()
					end
				end))
				table.insert(hubSelf._conexoes, EntradaUsuario.InputEnded:Connect(function(i)
					if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
						if ativo then ativo=false; Tw(bola,0.08,{Size=UDim2.new(0,bolaSize,0,bolaSize)}):Play() end
					end
				end))
				return {trilha=trilha, bola=bola, grad=grad, setPos=setPos}
			end

			local cores = {
				Color3.fromRGB(255,59,59),Color3.fromRGB(220,38,38),Color3.fromRGB(185,28,28),
				Color3.fromRGB(255,100,130),Color3.fromRGB(236,72,153),Color3.fromRGB(190,24,93),
				Color3.fromRGB(255,140,0),Color3.fromRGB(234,88,12),Color3.fromRGB(194,65,12),
				Color3.fromRGB(255,210,0),Color3.fromRGB(234,179,8),Color3.fromRGB(161,98,7),
				Color3.fromRGB(74,222,128),Color3.fromRGB(34,197,94),Color3.fromRGB(22,163,74),
				Color3.fromRGB(163,230,53),Color3.fromRGB(132,204,22),Color3.fromRGB(77,124,15),
				Color3.fromRGB(56,189,248),Color3.fromRGB(14,165,233),Color3.fromRGB(2,132,199),
				Color3.fromRGB(34,211,238),Color3.fromRGB(6,182,212),Color3.fromRGB(8,145,178),
				Color3.fromRGB(167,139,250),Color3.fromRGB(139,92,246),Color3.fromRGB(109,40,217),
				Color3.fromRGB(232,121,249),Color3.fromRGB(192,38,211),Color3.fromRGB(134,25,143),
				Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,210),Color3.fromRGB(148,148,165),
				Color3.fromRGB(80,80,100),Color3.fromRGB(30,30,45),Color3.fromRGB(0,0,0),
			}

			local function CriarGrid(parent, cell, gap, cols, maxH)
				local totalRows=math.ceil(#cores/cols); local gridW=cols*(cell+gap)-gap; local gridH=totalRows*(cell+gap)-gap
				local container
				if maxH and gridH > maxH then
					local gs=Instance.new("ScrollingFrame"); gs.Size=UDim2.new(0,gridW+6,0,maxH)
					gs.CanvasSize=UDim2.new(0,0,0,gridH+4); gs.ScrollBarThickness=2; gs.ScrollBarImageColor3=C.Destaque
					gs.BackgroundTransparency=1; gs.BorderSizePixel=0; gs.ScrollingDirection=Enum.ScrollingDirection.Y
					gs.ZIndex=2; gs.Parent=parent; container=gs
				else
					container=F({Size=UDim2.new(0,gridW,0,math.min(gridH,maxH or gridH)),BackgroundTransparency=1,ZIndex=2,Parent=parent})
				end
				for i,cor in ipairs(cores) do
					local col=(i-1)%cols; local row=math.floor((i-1)/cols)
					local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,cell,0,cell)
					btn.Position=UDim2.new(0,col*(cell+gap),0,row*(cell+gap)); btn.BackgroundColor3=cor
					btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=3; btn.Parent=container; Cantos(btn,5)
					local brdCell=Stroke(btn,Color3.new(0,0,0),1,0.75)
					btn.MouseEnter:Connect(function() Tw(btn,0.1,{Size=UDim2.new(0,cell+3,0,cell+3),Position=UDim2.new(0,col*(cell+gap)-1,0,row*(cell+gap)-1)}):Play(); Tw(brdCell,0.1,{Transparency=0.15}):Play() end)
					btn.MouseLeave:Connect(function() Tw(btn,0.1,{Size=UDim2.new(0,cell,0,cell),Position=UDim2.new(0,col*(cell+gap),0,row*(cell+gap))}):Play(); Tw(brdCell,0.1,{Transparency=0.75}):Play() end)
					btn.MouseButton1Click:Connect(function() h,s,v=Color3.toHSV(cor); AtualizarTudo() end)
				end
				return container
			end

			if not IS_MOBILE then
				local CELL=22; local GAP=4; local COLS=6
				local gridContainer=CriarGrid(corpo2,CELL,GAP,COLS,PICKER_H-16)
				gridContainer.Position=UDim2.new(0,10,0,8)
				local rightX=COLS*(CELL+GAP)-GAP+22; local rightW=115
				local bp=F({Size=UDim2.new(0,rightW,0,40),Position=UDim2.new(0,rightX,0,8),BackgroundColor3=corAtual,ZIndex=2,Parent=corpo2})
				Cantos(bp,8); Stroke(bp,C.Borda,1,0.25); bigPreview_ref=bp
				local lh=L({Size=UDim2.new(0,rightW,0,14),Position=UDim2.new(0,rightX,0,52),Text=CorParaHex(corAtual),TextColor3=C.Sub,Font=Enum.Font.GothamBold,TextSize=10,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=2,Parent=corpo2})
				RC(lh,"TextColor3","Sub"); lblHex_ref=lh
				slH_ref=CriarSliderHSV("H",70,rightX,rightW,13,9,28,"h")
				slS_ref=CriarSliderHSV("S",100,rightX,rightW,13,9,28,"s")
				slV_ref=CriarSliderHSV("V",130,rightX,rightW,13,9,28,"v")
			else
				local CELL=26; local GAP=4; local COLS=9; local gridVisW=180
				local gs=Instance.new("ScrollingFrame"); gs.Size=UDim2.new(0,gridVisW,0,150); gs.Position=UDim2.new(0,125,0,10)
				gs.ScrollBarThickness=3; gs.ScrollBarImageColor3=C.Destaque; gs.BackgroundTransparency=1; gs.BorderSizePixel=0
				gs.ScrollingDirection=Enum.ScrollingDirection.XY; gs.ZIndex=2; gs.Parent=corpo2
				local totalRows=math.ceil(#cores/COLS); gs.CanvasSize=UDim2.new(0,COLS*(CELL+GAP)-GAP+4,0,totalRows*(CELL+GAP)-GAP+4)
				for i,cor in ipairs(cores) do
					local col=(i-1)%COLS; local row=math.floor((i-1)/COLS)
					local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,CELL,0,CELL)
					btn.Position=UDim2.new(0,col*(CELL+GAP),0,row*(CELL+GAP)); btn.BackgroundColor3=cor
					btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=3; btn.Parent=gs; Cantos(btn,5)
					local brdCell=Stroke(btn,Color3.new(0,0,0),1,0.75)
					btn.MouseEnter:Connect(function() Tw(btn,0.1,{Size=UDim2.new(0,CELL+4,0,CELL+4),Position=UDim2.new(0,col*(CELL+GAP)-2,0,row*(CELL+GAP)-2)}):Play(); Tw(brdCell,0.1,{Transparency=0.2}):Play() end)
					btn.MouseLeave:Connect(function() Tw(btn,0.1,{Size=UDim2.new(0,CELL,0,CELL),Position=UDim2.new(0,col*(CELL+GAP),0,row*(CELL+GAP))}):Play(); Tw(brdCell,0.1,{Transparency=0.75}):Play() end)
					btn.MouseButton1Click:Connect(function() h,s,v=Color3.toHSV(cor); AtualizarTudo() end)
				end
				local sliderW=105; local sliderX=10; local lblSize=10; local bolaM=16
				local bp=F({Size=UDim2.new(0,sliderW,0,55),Position=UDim2.new(0,sliderX,0,168),BackgroundColor3=corAtual,ZIndex=2,Parent=corpo2})
				Cantos(bp,8); Stroke(bp,C.Borda,1,0.3); bigPreview_ref=bp
				local lh=L({Size=UDim2.new(0,sliderW,0,16),Position=UDim2.new(0,sliderX,0,150),Text=CorParaHex(corAtual),TextColor3=C.Sub,Font=Enum.Font.GothamBold,TextSize=lblSize,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=2,Parent=corpo2})
				RC(lh,"TextColor3","Sub"); lblHex_ref=lh
				slH_ref=CriarSliderHSV("H",8,sliderX,sliderW,bolaM,lblSize,36,"h")
				slS_ref=CriarSliderHSV("S",46,sliderX,sliderW,bolaM,lblSize,36,"s")
				slV_ref=CriarSliderHSV("V",84,sliderX,sliderW,bolaM,lblSize,36,"v")
			end

			AtualizarTudo()

			cab.MouseButton1Click:Connect(function()
				aberto=not aberto
				Tw(fr,0.2,{Size=UDim2.new(1,-6,0,aberto and AH or FH)}):Play()
				Tw(seta,0.2,{Rotation=aberto and -90 or 90}):Play()
			end)
			fr.MouseEnter:Connect(function() if not aberto then Tw(fr,0.12,{BackgroundColor3=C.ItemHover}):Play() end end)
			fr.MouseLeave:Connect(function() Tw(fr,0.12,{BackgroundColor3=C.Cartao}):Play() end)

			local obj={}
			function obj:Definir(c) corAtual=c; h,s,v=Color3.toHSV(c); AtualizarTudo() end
			function obj:Obter() return corAtual end
			obj.Set=obj.Definir; obj.Get=obj.Obter
			return obj
		end

		function Aba:CriarSecao(titulo)
			local fr=F({Size=UDim2.new(1,-6,0,22),BackgroundTransparency=1,LayoutOrder=PO(),Parent=pagina})
			local div=F({Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.Borda,Parent=fr})
			RC(div,"BackgroundColor3","Borda")
			local lb=L({Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=C.Janela,BorderSizePixel=0,
				Text="  "..string.upper(titulo).."  ",TextColor3=C.Sub,Font=Enum.Font.GothamBold,TextSize=9,Position=UDim2.new(0,10,0,0),ZIndex=2,Parent=fr})
			lb.BackgroundTransparency=0; RC(lb,"BackgroundColor3","Janela"); RC(lb,"TextColor3","Sub")
		end

		function Aba:CriarSeparador()
			local sep=F({Size=UDim2.new(1,-6,0,1),BackgroundColor3=C.Borda,LayoutOrder=PO(),Parent=pagina})
			RC(sep,"BackgroundColor3","Borda"); return sep
		end

		function Aba:CriarBotao(texto, callback)
			local b=Instance.new("TextButton")
			b.Size=UDim2.new(1,-6,0,BTN_H); b.BackgroundColor3=C.BotaoFundo; b.TextColor3=C.BotaoTexto
			b.Text=texto; b.Font=Enum.Font.GothamBold; b.TextSize=13
			b.AutoButtonColor=false; b.LayoutOrder=PO(); b.Parent=pagina
			Cantos(b,10); RC(b,"BackgroundColor3","BotaoFundo"); RC(b,"TextColor3","BotaoTexto")
			local brdB=Stroke(b,C.Destaque,1,0.55); RC(brdB,"Color","Destaque")
			if isRainbow then AddRainbow(brdB,"Color",0.15) end
			b.MouseEnter:Connect(function() Tw(b,0.15,{BackgroundColor3=C.BotaoHover}):Play(); Tw(brdB,0.15,{Transparency=0.1}):Play() end)
			b.MouseLeave:Connect(function() Tw(b,0.15,{BackgroundColor3=C.BotaoFundo}):Play(); Tw(brdB,0.15,{Transparency=0.55}):Play() end)
			b.MouseButton1Down:Connect(function() Tw(b,0.07,{Size=UDim2.new(1,-10,0,BTN_H-2)}):Play() end)
			b.MouseButton1Up:Connect(function() Tw(b,0.12,{Size=UDim2.new(1,-6,0,BTN_H)}):Play() end)
			b.MouseButton1Click:Connect(function() if callback then callback() end end)
			return b
		end

		function Aba:CriarToggle(texto, padrao, callback)
			local estado=(padrao==true)
			local fr=F({Size=UDim2.new(1,-6,0,IH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")
			L({Size=UDim2.new(1,-100,1,0),Position=UDim2.new(0,14,0,0),Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
			local TW,TH,BR=50,28,22
			local trilha=F({Size=UDim2.new(0,TW,0,TH),Position=UDim2.new(1,-(TW+12),0.5,-(TH/2)),BackgroundColor3=estado and C.Sucesso or C.Item,Parent=fr})
			Cantos(trilha,99)
			local bolinha=F({Size=UDim2.new(0,BR,0,BR),Position=estado and UDim2.new(1,-(BR+3),0.5,-(BR/2)) or UDim2.new(0,3,0.5,-(BR/2)),BackgroundColor3=Color3.new(1,1,1),ZIndex=2,Parent=trilha})
			Cantos(bolinha,99); Stroke(bolinha,Color3.new(0,0,0),1,0.82)
			local lblE=L({Size=UDim2.new(0,36,1,0),Position=UDim2.new(1,-(TW+56),0,0),Text=estado and "ON" or "OFF",TextColor3=estado and C.Sucesso or C.Fraco,Font=Enum.Font.GothamBold,TextSize=11,Parent=fr})
			local function Sync(anim)
				local d=anim and 0.18 or 0
				if estado then Tw(trilha,d,{BackgroundColor3=C.Sucesso}):Play(); Tw(bolinha,d,{Position=UDim2.new(1,-(BR+3),0.5,-(BR/2))}):Play(); Tw(lblE,d,{TextColor3=C.Sucesso}):Play(); lblE.Text="ON"
				else Tw(trilha,d,{BackgroundColor3=C.Item}):Play(); Tw(bolinha,d,{Position=UDim2.new(0,3,0.5,-(BR/2))}):Play(); Tw(lblE,d,{TextColor3=C.Fraco}):Play(); lblE.Text="OFF" end
				if callback then callback(estado) end
			end
			local THRESH=8; local touchStart,touchDrag=nil,false
			fr.InputBegan:Connect(function(i)
				if i.UserInputType==Enum.UserInputType.MouseButton1 then estado=not estado; Sync(true)
				elseif i.UserInputType==Enum.UserInputType.Touch then touchStart=i.Position; touchDrag=false end
			end)
			fr.InputChanged:Connect(function(i)
				if i.UserInputType==Enum.UserInputType.Touch and touchStart then
					if math.abs(i.Position.X-touchStart.X)>THRESH or math.abs(i.Position.Y-touchStart.Y)>THRESH then touchDrag=true end
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

		-- ╔══════════════════════════════════════════════════════════╗
		-- ║  CriarSlider v2                                         ║
		-- ║  CriarSlider(texto, min, max, padrao, callback, config) ║
		-- ║  config = {                                             ║
		-- ║    step    = 1,      -- incremento (ex: 0.1, 5, 10)    ║
		-- ║    float   = false,  -- mostrar casas decimais          ║
		-- ║    decimais= 1,      -- quantas casas decimais          ║
		-- ║    unidade = "",     -- sufixo ex: "ms", "x", "%"       ║
		-- ║  }                                                      ║
		-- ╚══════════════════════════════════════════════════════════╝
		function Aba:CriarSlider(texto, minV, maxV, padrao, callback, config)
			config = config or {}
			local step     = config.step     or 1
			local useFloat = config.float    or false
			local decimais = config.decimais or 1
			local unidade  = config.unidade  or ""

			local function Arredondar(v)
				if useFloat then
					local fator = 10^decimais
					return math.floor(v/step + 0.5)*step
					-- snap ao step mas mantém float
				else
					return math.floor(v/step + 0.5)*step
				end
			end
			local function Formatar(v)
				v = math.clamp(v, minV, maxV)
				if useFloat then
					return string.format("%."..decimais.."f", v)..unidade
				else
					return tostring(math.floor(v))..unidade
				end
			end

			local val = Arredondar(math.clamp(padrao or minV, minV, maxV))

			local fr=F({Size=UDim2.new(1,-6,0,SLH), BackgroundColor3=C.Cartao, LayoutOrder=PO(), Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

			-- labels de label + valor
			local labelY = IS_MOBILE and 10 or 9
			L({Size=UDim2.new(0.58,0,0,20), Position=UDim2.new(0,14,0,labelY),
				Text=texto, TextColor3=C.Texto, Font=Enum.Font.Gotham, TextSize=13,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=fr})

			local lblV = L({Size=UDim2.new(0.38,0,0,20), Position=UDim2.new(0.6,-4,0,labelY),
				Text=Formatar(val), TextColor3=C.Destaque, Font=Enum.Font.GothamBold,
				TextSize=13, TextXAlignment=Enum.TextXAlignment.Right, Parent=fr})
			RC(lblV,"TextColor3","Destaque")

			-- min/max hints
			local hintY = IS_MOBILE and 30 or 28
			L({Size=UDim2.new(0,30,0,12), Position=UDim2.new(0,14,0,hintY),
				Text=Formatar(minV), TextColor3=C.Fraco, Font=Enum.Font.Gotham, TextSize=9,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=fr})
			L({Size=UDim2.new(0,30,0,12), Position=UDim2.new(1,-44,0,hintY),
				Text=Formatar(maxV), TextColor3=C.Fraco, Font=Enum.Font.Gotham, TextSize=9,
				TextXAlignment=Enum.TextXAlignment.Right, Parent=fr})

			-- trilha
			local trilhaY = IS_MOBILE and 50 or 47
			local trilha=F({Size=UDim2.new(1,-28,0,6), Position=UDim2.new(0,14,0,trilhaY),
				BackgroundColor3=C.Item, Parent=fr})
			RC(trilha,"BackgroundColor3","Item"); Cantos(trilha,99)

			-- fill com gradiente
			local pct = (val-minV)/(maxV-minV)
			local fill=F({Size=UDim2.new(pct,0,1,0), BackgroundColor3=C.Destaque, Parent=trilha})
			Cantos(fill,99); RC(fill,"BackgroundColor3","Destaque")
			local fillGrad=Grad(fill,C.DestaqueV,C.Destaque,0); RegGrad(fillGrad,"DestaqueV","Destaque",0)
			if isRainbow then AddRainbow(fill,"BackgroundColor3",0.12) end

			-- bola
			local BOLA = IS_MOBILE and 20 or 17
			local bola=F({Size=UDim2.new(0,BOLA,0,BOLA), Position=UDim2.new(pct,0,0.5,0),
				AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), ZIndex=3, Parent=trilha})
			Cantos(bola,99)
			local bolaBrd=Stroke(bola,C.Destaque,2,0.25); RC(bolaBrd,"Color","Destaque")

			-- tooltip acima da bola
			local tooltip = F({Size=UDim2.new(0,44,0,20), AnchorPoint=Vector2.new(0.5,1),
				Position=UDim2.new(pct,0,0,-6), BackgroundColor3=C.Destaque,
				ZIndex=6, Visible=false, Parent=trilha})
			Cantos(tooltip,5)
			local tooltipLbl = L({Size=UDim2.new(1,0,1,0), Text=Formatar(val),
				TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
				TextSize=10, ZIndex=7, Parent=tooltip})

			-- hitbox
			local hitbox=F({Size=UDim2.new(1,0,0,IS_MOBILE and 36 or 28),
				Position=UDim2.new(0,0,0.5,-(IS_MOBILE and 18 or 14)),
				BackgroundTransparency=1, ZIndex=5, Parent=trilha})

			local ativo=false
			local function Upd(px)
				local p = math.clamp((px - trilha.AbsolutePosition.X) / trilha.AbsoluteSize.X, 0, 1)
				val = Arredondar(minV + (maxV - minV) * p)
				val = math.clamp(val, minV, maxV)
				local p2 = (val - minV) / (maxV - minV)
				fill.Size = UDim2.new(p2,0,1,0)
				bola.Position = UDim2.new(p2,0,0.5,0)
				tooltip.Position = UDim2.new(p2,0,0,-6)
				lblV.Text = Formatar(val)
				tooltipLbl.Text = Formatar(val)
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

		-- ╔══════════════════════════════════════════════════════════╗
		-- ║  CriarDropdown v3.0 — parâmetros diretos                ║
		-- ║  CriarDropdown(texto, opcoes, callback,                 ║
		-- ║    multi, search, maxVisible, placeholder)              ║
		-- ╚══════════════════════════════════════════════════════════╝
		function Aba:CriarDropdown(texto, opcoes, callback, multi, search, maxVisible, placeholder)
			-- compatibilidade: se 4º arg for tabela, lê como config antiga
			if type(multi) == "table" then
				local cfg = multi
				multi       = cfg.multi
				search      = cfg.search
				maxVisible  = cfg.maxVisible
				placeholder = cfg.placeholder
			end

			local multiSelect = multi      or false
			local useSearch   = search ~= false
			local maxVis      = maxVisible  or 5
			local placeholderTxt = placeholder or opcoes[1] or "-"

			local aberto    = false
			local IHd       = IS_MOBILE and 38 or 34
			local FH        = IS_MOBILE and 44 or 44
			local GAP       = 4
			local PAD       = 8
			local SEARCH_H  = useSearch and (IS_MOBILE and 36 or 32) or 0

			local selSimples = opcoes[1] or placeholderTxt
			local selMulti   = {}

			local function GetLabel()
				if multiSelect then
					local t={}
					for _,op in ipairs(opcoes) do if selMulti[op] then table.insert(t,op) end end
					return #t==0 and placeholderTxt or table.concat(t,", ")
				else
					return selSimples
				end
			end

			local fr = F({Size=UDim2.new(1,-6,0,FH), BackgroundColor3=C.Cartao,
				ClipsDescendants=false, LayoutOrder=PO(), Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

			local cab = Instance.new("TextButton")
			cab.Size=UDim2.new(1,0,0,FH); cab.BackgroundTransparency=1
			cab.Text=""; cab.AutoButtonColor=false; cab.Parent=fr

			L({Size=UDim2.new(0.45,0,1,0), Position=UDim2.new(0,14,0,0), Text=texto,
				TextColor3=C.Sub, Font=Enum.Font.Gotham, TextSize=12,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=cab})

			local lblS = L({Size=UDim2.new(0.42,0,1,0), Position=UDim2.new(0.5,-2,0,0),
				Text=GetLabel(), TextColor3=C.Texto, Font=Enum.Font.GothamBold,
				TextSize=IS_MOBILE and 11 or 12, TextWrapped=true,
				TextXAlignment=Enum.TextXAlignment.Right, Parent=cab})
			RC(lblS,"TextColor3","Texto")

			local badge = F({Size=UDim2.new(0,18,0,18), Position=UDim2.new(1,-46,0.5,-9),
				BackgroundColor3=C.Destaque, ZIndex=2, Visible=false, Parent=cab})
			Cantos(badge,99); RC(badge,"BackgroundColor3","Destaque")
			local badgeLbl = L({Size=UDim2.new(1,0,1,0), Text="0",
				TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=9, ZIndex=3, Parent=badge})

			local seta = L({Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-26,0,0),
				Text="›", TextColor3=C.Fraco, Font=Enum.Font.GothamBold,
				TextSize=16, Rotation=90, Parent=cab})
			RC(seta,"TextColor3","Fraco")

			local searchBox = nil
			if useSearch then
				local sfr = F({Size=UDim2.new(1,-16,0,SEARCH_H-4), Position=UDim2.new(0,8,0,FH+4),
					BackgroundColor3=C.Item, ZIndex=2, Parent=fr})
				Cantos(sfr,8); RC(sfr,"BackgroundColor3","Item")
				local sbrd = Stroke(sfr,C.Borda,1,0.4); RC(sbrd,"Color","Borda")
				L({Size=UDim2.new(0,18,1,0), Position=UDim2.new(0,6,0,0),
					Text="🔍", TextSize=IS_MOBILE and 12 or 11, Font=Enum.Font.Gotham, ZIndex=3, Parent=sfr})
				searchBox = Instance.new("TextBox")
				searchBox.Size=UDim2.new(1,-30,1,-8); searchBox.Position=UDim2.new(0,26,0,4)
				searchBox.BackgroundTransparency=1; searchBox.Text=""
				searchBox.PlaceholderText="Buscar..."; searchBox.PlaceholderColor3=C.Fraco
				searchBox.TextColor3=C.Texto; searchBox.Font=Enum.Font.Gotham
				searchBox.TextSize=IS_MOBILE and 12 or 11
				searchBox.TextXAlignment=Enum.TextXAlignment.Left
				searchBox.ClearTextOnFocus=false; searchBox.ZIndex=3; searchBox.Parent=sfr
				RC(searchBox,"TextColor3","Texto"); RC(searchBox,"PlaceholderColor3","Fraco")
				searchBox.Focused:Connect(function() Tw(sbrd,0.15,{Color=C.Destaque,Transparency=0}):Play() end)
				searchBox.FocusLost:Connect(function() Tw(sbrd,0.15,{Color=C.Borda,Transparency=0.4}):Play() end)
			end

			local listaHolder = Instance.new("ScrollingFrame")
			listaHolder.BackgroundTransparency=1; listaHolder.BorderSizePixel=0
			listaHolder.ScrollBarThickness=IS_MOBILE and 0 or 3
			listaHolder.ScrollBarImageColor3=C.Destaque
			listaHolder.ScrollingDirection=Enum.ScrollingDirection.Y
			listaHolder.ZIndex=2; listaHolder.Parent=fr
			Pad(listaHolder,4,4,8,8)
			local lyL = Instance.new("UIListLayout", listaHolder)
			lyL.Padding=UDim.new(0,GAP); lyL.SortOrder=Enum.SortOrder.LayoutOrder

			local todosItens = {}

			local function AtualizarBadge()
				if not multiSelect then return end
				local cnt=0
				for _,op in ipairs(opcoes) do if selMulti[op] then cnt+=1 end end
				badge.Visible=cnt>0; badgeLbl.Text=tostring(cnt)
			end

			local function CalcAltura(visCount)
				return FH + SEARCH_H + math.min(visCount, maxVis) * (IHd + GAP) + PAD * 2
			end

			local _syncValorRef = {fn = function() end}

			local function ConstruirItens(filtro)
				for _,ch in ipairs(listaHolder:GetChildren()) do
					if ch:IsA("TextButton") or ch:IsA("Frame") then ch:Destroy() end
				end
				todosItens = {}
				local visiveis = 0

				for _,op in ipairs(opcoes) do
					local passou = not filtro or filtro==""
						or string.find(string.lower(op), string.lower(filtro), 1, true)
					if not passou then continue end
					visiveis += 1

					local ativo = multiSelect and selMulti[op]
						or (not multiSelect and op==selSimples)

					-- container do item (evita flicker de hover nos labels filhos)
					local it = Instance.new("TextButton")
					it.Size=UDim2.new(1,0,0,IHd)
					it.BackgroundColor3 = ativo and C.BotaoFundo or C.Item
					it.Text=""
					it.AutoButtonColor=false; it.ZIndex=3; it.Parent=listaHolder
					Cantos(it,8)

					-- borda sutil no item
					local itBrd = Stroke(it, ativo and C.Destaque or C.Borda, 1, ativo and 0.5 or 0.7)

					-- label do texto (não bloqueia eventos do pai)
					local itLbl = L({
						Size=UDim2.new(1,-36,1,0), Position=UDim2.new(0,12,0,0),
						Text=op,
						TextColor3 = ativo and C.BotaoTexto or C.Texto,
						Font = ativo and Enum.Font.GothamBold or Enum.Font.Gotham,
						TextSize=IS_MOBILE and 12 or 13,
						TextXAlignment=Enum.TextXAlignment.Left,
						ZIndex=4, Parent=it,
					})

					local chk = L({Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-26,0,0),
						Text="✓", TextColor3=C.Sucesso, Font=Enum.Font.GothamBold,
						TextSize=14, ZIndex=4, Visible=ativo, Parent=it})

					table.insert(todosItens, {btn=it, lbl=itLbl, brd=itBrd, op=op, chk=chk})

					-- hover limpo: só no TextButton, sem conflito de labels
					it.MouseEnter:Connect(function()
						local isAtivo = multiSelect and selMulti[op] or (not multiSelect and op==selSimples)
						if not isAtivo then
							Tw(it,  0.1, {BackgroundColor3=C.ItemHover}):Play()
							Tw(itBrd,0.1,{Transparency=0.3}):Play()
						end
					end)
					it.MouseLeave:Connect(function()
						local isAtivo = multiSelect and selMulti[op] or (not multiSelect and op==selSimples)
						Tw(it,  0.1, {BackgroundColor3 = isAtivo and C.BotaoFundo or C.Item}):Play()
						Tw(itBrd,0.1,{Transparency = isAtivo and 0.5 or 0.7}):Play()
					end)

					it.MouseButton1Click:Connect(function()
						if multiSelect then
							selMulti[op]=not selMulti[op]
							local isNow=selMulti[op]
							Tw(it,   0.12,{BackgroundColor3=isNow and C.BotaoFundo or C.Item}):Play()
							Tw(itBrd,0.12,{Transparency=isNow and 0.5 or 0.7, Color=isNow and C.Destaque or C.Borda}):Play()
							itLbl.TextColor3 = isNow and C.BotaoTexto or C.Texto
							itLbl.Font       = isNow and Enum.Font.GothamBold or Enum.Font.Gotham
							chk.Visible=isNow; AtualizarBadge(); lblS.Text=GetLabel()
							_syncValorRef.fn()
							if callback then callback(GetLabel(), selMulti) end
						else
							selSimples=op; lblS.Text=op; aberto=false
							Tw(fr,0.18,{Size=UDim2.new(1,-6,0,FH)}):Play()
							Tw(seta,0.18,{Rotation=90}):Play()
							if searchBox then task.delay(0.2,function() if searchBox and searchBox.Parent then searchBox.Text="" end end) end
							for _,entry in ipairs(todosItens) do
								local sel2=entry.op==op
								entry.btn.BackgroundColor3 = sel2 and C.BotaoFundo or C.Item
								entry.lbl.TextColor3       = sel2 and C.BotaoTexto or C.Texto
								entry.lbl.Font             = sel2 and Enum.Font.GothamBold or Enum.Font.Gotham
								entry.chk.Visible=sel2
								Tw(entry.brd,0.1,{Transparency=sel2 and 0.5 or 0.7, Color=sel2 and C.Destaque or C.Borda}):Play()
							end
							_syncValorRef.fn()
							if callback then callback(selSimples) end
						end
					end)
				end

				if visiveis==0 then
					local empty=F({Size=UDim2.new(1,0,0,IHd),BackgroundTransparency=1,ZIndex=2,Parent=listaHolder})
					L({Size=UDim2.new(1,0,1,0),Text="Nenhum resultado",TextColor3=C.Fraco,Font=Enum.Font.Gotham,TextSize=12,ZIndex=3,Parent=empty})
				end

				local altLista = math.min(visiveis>0 and visiveis or 1, maxVis) * (IHd+GAP) + PAD*2
				listaHolder.Size=UDim2.new(1,0,0,altLista)
				listaHolder.Position=UDim2.new(0,0,0,FH+SEARCH_H)
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

			-- lista começa escondida (sem ClipsDescendants precisamos controlar manualmente)
			listaHolder.Visible = false
			if searchBox then searchBox.Parent.Visible = false end

			local function FecharDropdown()
				aberto=false
				Tw(fr,0.2,{Size=UDim2.new(1,-6,0,FH)},Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
				Tw(seta,0.2,{Rotation=90}):Play()
				task.delay(0.2, function()
					listaHolder.Visible = false
					if searchBox and searchBox.Parent then
						searchBox.Parent.Visible = false
						searchBox.Text = ""
					end
				end)
			end

			local function AbrirDropdown()
				aberto=true
				listaHolder.Visible = true
				if searchBox and searchBox.Parent then searchBox.Parent.Visible = true end
				local cnt=0
				for _,ch in ipairs(listaHolder:GetChildren()) do
					if ch:IsA("TextButton") or ch:IsA("Frame") then cnt+=1 end
				end
				Tw(fr,0.25,{Size=UDim2.new(1,-6,0,CalcAltura(cnt))},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
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

			-- .valor atualiza automaticamente sempre que a seleção muda
			-- simples → string        ex: drop.valor == "Maçã"
			-- multi   → tabela/array  ex: drop.valor == {"Voar", "ESP"}
			local obj = {}
			obj.valor = multiSelect and {} or selSimples

			-- SyncValor é chamada diretamente nos cliques (via _syncValorRef)
			-- e nos métodos abaixo — sem patch em ConstruirItens
			local function SyncValor()
				if multiSelect then
					local t = {}
					for _, op in ipairs(opcoes) do if selMulti[op] then table.insert(t, op) end end
					obj.valor = t
				else
					obj.valor = selSimples
				end
			end
			SyncValor()
			_syncValorRef.fn = SyncValor

			function obj:Definir(v)
				if multiSelect then
					selMulti = {}
					if type(v) == "table" then for _,k in ipairs(v) do selMulti[k]=true end else selMulti[v]=true end
				else selSimples = v end
				lblS.Text = GetLabel(); AtualizarBadge(); ConstruirItens(""); SyncValor()
			end
			function obj:Obter()
				if multiSelect then local t={}; for op in pairs(selMulti) do table.insert(t,op) end; return t
				else return selSimples end
			end
			function obj:AtualizarOpcoes(novasOps)
				opcoes = novasOps
				if not multiSelect then
					local existe = false
					for _, n in ipairs(novasOps) do if n == selSimples then existe = true; break end end
					if not existe then selSimples = novasOps[1] or placeholderTxt; lblS.Text = selSimples end
				end
				FecharDropdown()
				task.delay(0.22, function() ConstruirItens(""); SyncValor() end)
			end
			function obj:LimparSelecao()
				if multiSelect then selMulti = {}; AtualizarBadge() else selSimples = placeholderTxt end
				lblS.Text = GetLabel(); ConstruirItens(""); SyncValor()
			end
			function obj:Fechar() FecharDropdown() end
			obj.Set = obj.Definir; obj.Get = obj.Obter
			obj.UpdateOptions = obj.AtualizarOpcoes; obj.Clear = obj.LimparSelecao
			return obj
		end

		function Aba:CriarTexto(textoInicial, cor)
			local corTexto=cor or C.Sub
			local fr=F({Size=UDim2.new(1,-6,0,36),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.45); RC(fr,"BackgroundColor3","Cartao")
			local lbl=L({Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,10,0,0),Text=textoInicial or "",TextColor3=corTexto,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=fr})
			lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
				local h2=math.max(36,math.ceil(lbl.TextBounds.Y/14)*16+12); fr.Size=UDim2.new(1,-6,0,h2)
			end)
			local obj={}
			function obj:Definir(v) lbl.Text=v or "" end
			function obj:DefinirCor(c) corTexto=c; lbl.TextColor3=c end
			function obj:Obter() return lbl.Text end
			obj.Set=obj.Definir; obj.SetCor=obj.DefinirCor; obj.Get=obj.Obter
			return obj
		end

		function Aba:CriarEntrada(placeholder, callback)
			local fr=F({Size=UDim2.new(1,-6,0,IS_MOBILE and 48 or 44),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
			Cantos(fr,10); RC(fr,"BackgroundColor3","Cartao")
			local brd=Stroke(fr,C.Borda,1,0.35); RC(brd,"Color","Borda")
			local tb=Instance.new("TextBox")
			tb.Size=UDim2.new(1,-24,1,-14); tb.Position=UDim2.new(0,12,0,7)
			tb.BackgroundTransparency=1; tb.Text=""
			tb.PlaceholderText=placeholder or "Digite aqui..."
			tb.PlaceholderColor3=C.Fraco; tb.TextColor3=C.Texto
			tb.Font=Enum.Font.Gotham; tb.TextSize=13
			tb.TextXAlignment=Enum.TextXAlignment.Left
			tb.ClearTextOnFocus=false; tb.Parent=fr
			RC(tb,"TextColor3","Texto"); RC(tb,"PlaceholderColor3","Fraco")
			tb.Focused:Connect(function() Tw(brd,0.15,{Color=C.Destaque,Transparency=0}):Play() end)
			tb.FocusLost:Connect(function(enter) Tw(brd,0.15,{Color=C.Borda,Transparency=0.35}):Play(); if enter and callback then callback(tb.Text) end end)
			local obj={}
			function obj:Definir(t) tb.Text=t or "" end
			function obj:Obter() return tb.Text end
			obj.Set=obj.Definir; obj.Get=obj.Obter
			return obj
		end

		function Aba:CriarTeclaDeAtalho(texto, teclaPadrao, callback)
			local teclaAtual=teclaPadrao or Enum.KeyCode.F
			local aguardando=false
			local KH=IS_MOBILE and 52 or 46
			local fr=F({Size=UDim2.new(1,-6,0,KH),BackgroundColor3=C.Cartao,LayoutOrder=PO(),Parent=pagina})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")
			local reserva=IS_MOBILE and 150 or 108
			L({Size=UDim2.new(1,-reserva,1,0),Position=UDim2.new(0,14,0,0),Text=texto,TextColor3=C.Texto,Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=fr})
			local BKW=IS_MOBILE and 70 or 88; local BKH=IS_MOBILE and 32 or 28
			local BKoffsetX=BKW+8
			local btnTecla=Instance.new("TextButton")
			btnTecla.Size=UDim2.new(0,BKW,0,BKH); btnTecla.Position=UDim2.new(1,-BKoffsetX,0.5,-BKH/2)
			btnTecla.BackgroundColor3=C.Item; btnTecla.TextColor3=C.Destaque
			btnTecla.Text=tostring(teclaAtual.Name); btnTecla.Font=Enum.Font.GothamBold; btnTecla.TextSize=12
			btnTecla.AutoButtonColor=false; btnTecla.Parent=fr; Cantos(btnTecla,7)
			RC(btnTecla,"BackgroundColor3","Item"); RC(btnTecla,"TextColor3","Destaque")
			local brdTecla=Stroke(btnTecla,C.Borda,1,0.3); RC(brdTecla,"Color","Borda")
			local function EntrarCaptura() aguardando=true; btnTecla.Text="..."; btnTecla.TextColor3=C.Aviso; Tw(brdTecla,0.15,{Color=C.Aviso,Transparency=0}):Play() end
			local function SairCaptura(nome) aguardando=false; btnTecla.Text=nome or tostring(teclaAtual.Name); btnTecla.TextColor3=C.Destaque; Tw(brdTecla,0.15,{Color=C.Borda,Transparency=0.3}):Play() end
			if not IS_MOBILE then
				btnTecla.MouseButton1Click:Connect(function() if not aguardando then EntrarCaptura() else SairCaptura() end end)
				btnTecla.MouseEnter:Connect(function() if not aguardando then Tw(btnTecla,0.12,{BackgroundColor3=C.ItemHover}):Play() end end)
				btnTecla.MouseLeave:Connect(function() Tw(btnTecla,0.12,{BackgroundColor3=C.Item}):Play() end)
				table.insert(hubSelf._conexoes,EntradaUsuario.InputBegan:Connect(function(input,gp)
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

		return Aba
	end

	function self:CriarDropdownTemas(aba)
		return aba:CriarDropdown(
			"Tema", Hub.Temas,
			function(novoTema) self:MudarTemaPara(novoTema) end,
			false, true, 5, "Escolher tema..."
		)
	end

	self.EhMobile = IS_MOBILE
	return self
end
Hub.new = Hub.novo
return Hub
