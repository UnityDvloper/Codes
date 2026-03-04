-- Hub UI V 6.6

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

function Hub.novo(nome, tema)
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

	local btnX = Instance.new("TextButton")
	btnX.Size=UDim2.new(0,BW,0,BH); btnX.Position=UDim2.new(1,-(BW+8),0.5,-BH/2)
	btnX.Text="X"; btnX.Font=Enum.Font.Arial; btnX.TextSize=14
	btnX.TextColor3=Color3.new(1,1,1); btnX.BackgroundColor3=C.Perigo
	btnX.AutoButtonColor=false; btnX.ZIndex=12; btnX.Parent=topbar
	Cantos(btnX,99); RegCor(btnX,"BackgroundColor3","Perigo")

	btnMin.MouseEnter:Connect(function() Tw(btnMin,0.15,{BackgroundColor3=C.ItemHover,TextColor3=C.Texto}):Play() end)
	btnMin.MouseLeave:Connect(function() Tw(btnMin,0.15,{BackgroundColor3=C.Item,TextColor3=C.Sub}):Play() end)
	btnX.MouseEnter:Connect(function() Tw(btnX,0.15,{BackgroundColor3=Color3.fromRGB(255,80,80),Size=UDim2.new(0,BW+3,0,BH+3)}):Play() end)
	btnX.MouseLeave:Connect(function() Tw(btnX,0.15,{BackgroundColor3=C.Perigo,Size=UDim2.new(0,BW,0,BH)}):Play() end)
	btnX.MouseButton1Down:Connect(function() Tw(btnX,0.07,{Size=UDim2.new(0,BW-3,0,BH-3)}):Play() end)
	btnX.MouseButton1Up:Connect(function() Tw(btnX,0.1,{Size=UDim2.new(0,BW,0,BH)}):Play() end)

	local corpoJanela = F({Size=UDim2.new(1,0,1,-TOPBAR_H),Position=UDim2.new(0,0,0,TOPBAR_H),
		BackgroundTransparency=1,Parent=janela})

	local minimizado = false
	local function AtualizarMinimizado()
		if minimizado then
			corpoJanela.Visible=false; linhaSep.Visible=false
			Tw(janela,0.22,{Size=UDim2.new(0,JANELA_W,0,ALTURA_MIN)}):Play()
			btnMin.Text="+"
		else
			Tw(janela,0.28,{Size=UDim2.new(0,JANELA_W,0,ALTURA_CHEIA)},
			Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
			btnMin.Text="–"; linhaSep.Visible=true
			task.delay(0.28,function() if not minimizado then corpoJanela.Visible=true end end)
		end
	end
	btnMin.MouseButton1Click:Connect(function() minimizado=not minimizado; AtualizarMinimizado() end)

	local drag,dragStart,posStart = false,nil,nil
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
		janela.Position=UDim2.new(posStart.X.Scale,posStart.X.Offset+d.X,posStart.Y.Scale,posStart.Y.Offset+d.Y)
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
	function self:Destruir() Fechar(true) end

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

	local NOTIF_W = IS_MOBILE and math.min(JANELA_W-24, 260) or 320
	local notifHolder = F({
		Size=UDim2.new(0,NOTIF_W,1,-20), Position=UDim2.new(1,-(NOTIF_W+10),0,10),
		BackgroundTransparency=1, ZIndex=300, Parent=gui,
	})
	local notifLayout = Instance.new("UIListLayout", notifHolder)
	notifLayout.VerticalAlignment  = Enum.VerticalAlignment.Bottom
	notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	notifLayout.Padding = UDim.new(0, 6)
	Pad(notifHolder, 0, IS_MOBILE and 6 or 10, 0, 0)

	local NOTIF_W     = IS_MOBILE and math.min(JANELA_W - 20, 270) or 340
	local NOTIF_MAX   = 6
	local NOTIF_GAP   = 8
	local NOTIF_PAD_B = IS_MOBILE and 8 or 12

	local NOTIF_TIPOS = {
		sucesso = {
			icone = "✓",
			cor   = Color3.fromRGB(56,  215, 140),
			corV  = Color3.fromRGB(105, 240, 175),
			corD  = Color3.fromRGB(30,  160,  95),
			bg1   = Color3.fromRGB(8,   30,  18 ),
			bg2   = Color3.fromRGB(13,  42,  26 ),
			glow  = Color3.fromRGB(56,  215, 140),
		},
		erro = {
			icone = "X",
			cor   = Color3.fromRGB(235,  70,  70),
			corV  = Color3.fromRGB(255, 115, 115),
			corD  = Color3.fromRGB(175,  38,  38),
			bg1   = Color3.fromRGB(28,   8,   8 ),
			bg2   = Color3.fromRGB(42,  13,  13 ),
			glow  = Color3.fromRGB(235,  70,  70),
		},
		aviso = {
			icone = "!",
			cor   = Color3.fromRGB(255, 195,  45),
			corV  = Color3.fromRGB(255, 225, 110),
			corD  = Color3.fromRGB(195, 140,  15),
			bg1   = Color3.fromRGB(28,  22,   4 ),
			bg2   = Color3.fromRGB(42,  32,   8 ),
			glow  = Color3.fromRGB(255, 195,  45),
		},
		info = {
			icone = "i",
			cor   = Color3.fromRGB(75,  165, 255),
			corV  = Color3.fromRGB(130, 200, 255),
			corD  = Color3.fromRGB(40,  110, 200),
			bg1   = Color3.fromRGB(6,   18,  38 ),
			bg2   = Color3.fromRGB(10,  26,  54 ),
			glow  = Color3.fromRGB(75,  165, 255),
		},
	}

	local notifFila = {}

	local notifHolder = F({
		Size                   = UDim2.new(0, NOTIF_W, 1, -20),
		Position               = UDim2.new(1, -(NOTIF_W + 12), 0, 10),
		BackgroundTransparency = 1,
		ZIndex                 = 300,
		Parent                 = gui,
	})

	local function Lerp3(a, b, t)
		return Color3.new(
			a.R + (b.R - a.R) * t,
			a.G + (b.G - a.G) * t,
			a.B + (b.B - a.B) * t
		)
	end

	local function ReposicionarFila()
		local baseY = notifHolder.AbsoluteSize.Y - NOTIF_PAD_B
		for i = #notifFila, 1, -1 do
			local e = notifFila[i]
			baseY = baseY - e.altura
			local targetOffsetY = baseY - notifHolder.AbsoluteSize.Y
			Tw(e.card, 0.32, {
				Position = UDim2.new(0, 0, 1, targetOffsetY),
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
			baseY = baseY - NOTIF_GAP
		end
	end

	local function DispensarCard(card, cardBrd, shimmer, imediato)
		for i, e in ipairs(notifFila) do
			if e.card == card then table.remove(notifFila, i); break end
		end
		ReposicionarFila()

		local t = imediato and 0.10 or 0.30
		Tw(card, t, {
			Position           = UDim2.new(0, NOTIF_W + 28, card.Position.Y.Scale, card.Position.Y.Offset),
			BackgroundTransparency = 1,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Play()
		if cardBrd then Tw(cardBrd, t, { Transparency = 1 }):Play() end
		if shimmer and typeof(shimmer) == "RBXScriptConnection" then
			task.delay(t, function() pcall(function() shimmer:Disconnect() end) end)
		end
		task.delay(t + 0.06, function()
			if card and card.Parent then card:Destroy() end
		end)
	end

	function self:Notificar(titulo, mensagem, tipo, duracao, config)
		tipo     = tipo     or "info"
		duracao  = duracao  or 3.5
		config   = config   or {}
		local cfg = NOTIF_TIPOS[tipo] or NOTIF_TIPOS.info

		local aoClicar   = config.aoClicar
		local acoes      = config.acoes
		local semAuto    = config.semAuto
		local icCustom   = config.icone

		if #notifFila >= NOTIF_MAX then
			local oldest = notifFila[1]
			if oldest then DispensarCard(oldest.card, oldest.brd, oldest.shimmer, true) end
		end

		local icSize   = IS_MOBILE and 28 or 32
		local minH     = IS_MOBILE and 58 or 68
		local acaoH    = (acoes and #acoes > 0) and (IS_MOBILE and 34 or 30) or 0
		local shimmerConn = nil

		local card = Instance.new("TextButton")
		card.Size                   = UDim2.new(1, 0, 0, minH)
		card.Position               = UDim2.new(0, NOTIF_W + 28, 1, -(minH + NOTIF_PAD_B))
		card.BackgroundColor3       = cfg.bg2
		card.AutoButtonColor        = false
		card.ClipsDescendants        = true
		card.ZIndex                 = 301
		card.Text                   = ""
		card.Parent                 = notifHolder
		Cantos(card, 14)

		do
			local g = Instance.new("UIGradient")
			g.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,   cfg.bg1),
				ColorSequenceKeypoint.new(0.6, cfg.bg2),
				ColorSequenceKeypoint.new(1,   Lerp3(cfg.bg2, cfg.cor, 0.06)),
			})
			g.Rotation = 135; g.Parent = card
		end

		local cardBrd = Stroke(card, cfg.cor, 1, 0.25)

		local glowFr = F({
			Size                   = UDim2.new(1, 10, 1, 10),
			Position               = UDim2.new(0, -5, 0, -5),
			BackgroundColor3       = cfg.glow,
			BackgroundTransparency = 0.88,
			ZIndex                 = 300,
			Parent                 = card,
		})
		Cantos(glowFr, 18)

		-- ── Reflexo glass (topo) ──────────────────────────────────────────
		local glassShine = F({
			Size                   = UDim2.new(1, 0, 0, 22),
			Position               = UDim2.new(0, 0, 0, 0),
			BackgroundColor3       = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.90,
			ZIndex                 = 310,
			Parent                 = card,
		})
		Cantos(glassShine, 14)
		do
			local g = Instance.new("UIGradient")
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,   0   ),
				NumberSequenceKeypoint.new(0.5, 0.04),
				NumberSequenceKeypoint.new(1,   1   ),
			})
			g.Rotation = 90; g.Parent = glassShine
		end

		local shimmerFr = F({
			Size                   = UDim2.new(0, 60, 1, 20),
			Position               = UDim2.new(0, -80, 0, -10),
			BackgroundColor3       = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.82,
			Rotation               = 22,
			ZIndex                 = 311,
			Parent                 = card,
		})
		do
			local g = Instance.new("UIGradient")
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,   1   ),
				NumberSequenceKeypoint.new(0.45, 0.55),
				NumberSequenceKeypoint.new(0.5,  0.45),
				NumberSequenceKeypoint.new(0.55, 0.55),
				NumberSequenceKeypoint.new(1,   1   ),
			})
			g.Rotation = 0; g.Parent = shimmerFr
		end
		task.delay(0.4, function()
			if not card.Parent then return end
			Tw(shimmerFr, 0.55, {
				Position = UDim2.new(0, NOTIF_W + 20, 0, -10),
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
		end)

		local lateral = F({
			Size             = UDim2.new(0, 3, 1, -10),
			Position         = UDim2.new(0, 1, 0, 5),
			BackgroundColor3 = cfg.cor,
			ZIndex           = 308,
			Parent           = card,
		})
		Cantos(lateral, 99)
		do
			local g = Instance.new("UIGradient")
			g.Color    = ColorSequence.new(cfg.corV, cfg.corD)
			g.Rotation = 90; g.Parent = lateral
		end
		task.spawn(function()
			local alive = true
			card.AncestryChanged:Connect(function() alive = false end)
			while alive and card.Parent do
				Tw(lateral, 1.2, { BackgroundColor3 = cfg.corV }):Play()
				task.wait(1.2)
				if not alive or not card.Parent then break end
				Tw(lateral, 1.2, { BackgroundColor3 = cfg.corD }):Play()
				task.wait(1.2)
			end
		end)

		local halo2 = F({
			Size                   = UDim2.new(0, icSize + 26, 0, icSize + 26),
			Position               = UDim2.new(0, 14, 0.5, -(icSize + 26)/2),
			BackgroundColor3       = cfg.cor,
			BackgroundTransparency = 0.86,
			ZIndex                 = 302,
			Parent                 = card,
		})
		Cantos(halo2, 99)

		local halo1 = F({
			Size                   = UDim2.new(0, icSize + 14, 0, icSize + 14),
			Position               = UDim2.new(0, 20, 0.5, -(icSize + 14)/2),
			BackgroundColor3       = cfg.cor,
			BackgroundTransparency = 0.76,
			ZIndex                 = 303,
			Parent                 = card,
		})
		Cantos(halo1, 99)

		local ic = F({
			Size             = UDim2.new(0, icSize, 0, icSize),
			Position         = UDim2.new(0, 26, 0.5, -icSize/2),
			BackgroundColor3 = cfg.cor,
			ZIndex           = 305,
			Parent           = card,
		})
		Cantos(ic, 99)
		Stroke(ic, cfg.corV, 1, 0.35)
		do
			local g = Instance.new("UIGradient")
			g.Color    = ColorSequence.new(cfg.corV, cfg.corD)
			g.Rotation = 135; g.Parent = ic
		end
		do
			local ics = F({
				Size                   = UDim2.new(0.9, 0, 0.45, 0),
				Position               = UDim2.new(0.05, 0, 0, 0),
				BackgroundColor3       = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.75,
				ZIndex                 = 307,
				Parent                 = ic,
			})
			Cantos(ics, 99)
			local g = Instance.new("UIGradient")
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,   0.2),
				NumberSequenceKeypoint.new(1,   1  ),
			})
			g.Rotation = 90; g.Parent = ics
		end

		if (icCustom == nil) and (tipo == "erro") then
			local esp = IS_MOBILE and 3 or 3
			local comp = IS_MOBILE and 13 or 15
			local l1 = F({
				Size=UDim2.new(0,comp,0,esp), Position=UDim2.new(0.5,-comp/2,0.5,-esp/2),
				BackgroundColor3=Color3.new(1,1,1), Rotation=45, ZIndex=308, Parent=ic,
			}); Cantos(l1,99)
			local l2 = F({
				Size=UDim2.new(0,comp,0,esp), Position=UDim2.new(0.5,-comp/2,0.5,-esp/2),
				BackgroundColor3=Color3.new(1,1,1), Rotation=-45, ZIndex=308, Parent=ic,
			}); Cantos(l2,99)
		else
			L({
				Size=UDim2.new(1,0,1,0), Text=icCustom or cfg.icone,
				TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
				TextSize=IS_MOBILE and 13 or 15, ZIndex=308, Parent=ic,
			})
		end

		local txtX    = 26 + icSize + 13
		local txtMaxW = -(txtX + 16)

		local lblTitulo = L({
			Size             = UDim2.new(1, txtMaxW, 0, 16),
			Position         = UDim2.new(0, txtX, 0, 0),
			Text             = titulo,
			TextColor3       = Color3.new(1, 1, 1),
			Font             = Enum.Font.GothamBold,
			TextSize         = IS_MOBILE and 12 or 13,
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextWrapped      = true,
			AutomaticSize    = Enum.AutomaticSize.Y,
			ZIndex           = 306,
			Parent           = card,
		})
		local lblMsg = L({
			Size             = UDim2.new(1, txtMaxW, 0, 14),
			Position         = UDim2.new(0, txtX, 0, 0),
			Text             = mensagem or "",
			TextColor3       = cfg.corV,
			Font             = Enum.Font.Gotham,
			TextSize         = IS_MOBILE and 10 or 11,
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextWrapped      = true,
			AutomaticSize    = Enum.AutomaticSize.Y,
			ZIndex           = 306,
			Parent           = card,
		})

		local progBg = F({
			Size                   = UDim2.new(1, -4, 0, 3),
			Position               = UDim2.new(0, 2, 1, -4),
			BackgroundColor3       = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.50,
			ZIndex                 = 307,
			Parent                 = card,
		})
		Cantos(progBg, 99)

		local prog = F({
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = cfg.cor,
			ZIndex           = 308,
			Parent           = progBg,
		})
		Cantos(prog, 99)
		do
			local g = Instance.new("UIGradient")
			g.Color    = ColorSequence.new(cfg.corD, cfg.corV)
			g.Rotation = 0; g.Parent = prog
		end
		local progDot = F({
			Size                   = UDim2.new(0, 5, 0, 5),
			Position               = UDim2.new(1, -5, 0.5, -2),
			BackgroundColor3       = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.20,
			ZIndex                 = 309,
			Parent                 = prog,
		})
		Cantos(progDot, 99)

		local btnClose = Instance.new("TextButton")
		btnClose.Size                   = UDim2.new(0, 20, 0, 20)
		btnClose.Position               = UDim2.new(1, -24, 0, 6)
		btnClose.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
		btnClose.BackgroundTransparency = 1
		btnClose.Text                   = "×"
		btnClose.Font                   = Enum.Font.GothamBold
		btnClose.TextSize               = 14
		btnClose.TextColor3             = Color3.new(1, 1, 1)
		btnClose.TextTransparency       = 0.55
		btnClose.AutoButtonColor        = false
		btnClose.ZIndex                 = 315
		btnClose.Parent                 = card
		Cantos(btnClose, 99)
		local closeBrd = Stroke(btnClose, Color3.new(1, 1, 1), 1, 0.72)

		btnClose.BackgroundTransparency = 1
		closeBrd.Transparency           = 1
		btnClose.TextTransparency       = 1

		if acoes and #acoes > 0 then
			local totalBtns = math.min(#acoes, 2)
			local gap2      = 6
			local btnW = (NOTIF_W - txtX - 16 - (totalBtns - 1) * gap2) / totalBtns

			for i, acao in ipairs(acoes) do
				if i > 2 then break end
				local bx = txtX + (i - 1) * (btnW + gap2)
				local isPrimary = (i == 1)

				local ab = Instance.new("TextButton")
				ab.Size                  = UDim2.new(0, btnW, 0, acaoH - 7)
				ab.Position              = UDim2.new(0, bx, 1, -(acaoH - 1))
				ab.BackgroundColor3      = isPrimary and cfg.cor or Color3.fromRGB(28, 28, 42)
				ab.TextColor3            = isPrimary and Color3.fromRGB(8, 8, 16) or cfg.corV
				ab.Text                  = acao.label or "OK"
				ab.Font                  = Enum.Font.GothamBold
				ab.TextSize              = IS_MOBILE and 10 or 11
				ab.AutoButtonColor       = false
				ab.ZIndex                = 312
				ab.Parent                = card
				Cantos(ab, 7)
				if not isPrimary then
					Stroke(ab, cfg.cor, 1, 0.55)
				end
				if isPrimary then
					do
						local g = Instance.new("UIGradient")
						g.Color    = ColorSequence.new(cfg.corV, cfg.cor)
						g.Rotation = 90; g.Parent = ab
					end
				end
				ab.MouseEnter:Connect(function()
					Tw(ab, 0.1, {
						BackgroundColor3 = isPrimary
							and Lerp3(cfg.cor, Color3.new(1,1,1), 0.18)
							or Color3.fromRGB(40, 40, 60),
					}):Play()
					Tw(ab, 0.08, { Size = UDim2.new(0, btnW, 0, acaoH - 5) }):Play()
				end)
				ab.MouseLeave:Connect(function()
					Tw(ab, 0.1, {
						BackgroundColor3 = isPrimary and cfg.cor or Color3.fromRGB(28, 28, 42),
					}):Play()
					Tw(ab, 0.1, { Size = UDim2.new(0, btnW, 0, acaoH - 7) }):Play()
				end)
				ab.MouseButton1Down:Connect(function()
					Tw(ab, 0.06, { Size = UDim2.new(0, btnW - 4, 0, acaoH - 10) }):Play()
				end)
				ab.MouseButton1Up:Connect(function()
					Tw(ab, 0.12, { Size = UDim2.new(0, btnW, 0, acaoH - 7) },
					Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				end)
				ab.MouseButton1Click:Connect(function()
					if acao.fn then pcall(acao.fn) end
					DispensarCard(card, cardBrd, shimmerConn)
				end)
			end
		end

		card.MouseEnter:Connect(function()
			Tw(card,     0.14, { BackgroundColor3 = Lerp3(cfg.bg2, cfg.cor, 0.04) }):Play()
			Tw(cardBrd,  0.14, { Transparency = 0.05 }):Play()
			Tw(glowFr,   0.14, { BackgroundTransparency = 0.78 }):Play()

			Tw(btnClose, 0.14, { TextTransparency = 0 }):Play()
			Tw(closeBrd, 0.14, { Transparency = 0.40 }):Play()
		end)
		card.MouseLeave:Connect(function()
			Tw(card,     0.18, { BackgroundColor3 = cfg.bg2 }):Play()
			Tw(cardBrd,  0.18, { Transparency = 0.25 }):Play()
			Tw(glowFr,   0.18, { BackgroundTransparency = 0.88 }):Play()
			Tw(btnClose, 0.14, { TextTransparency = 1 }):Play()
			Tw(closeBrd, 0.14, { Transparency = 1 }):Play()
		end)
		card.MouseButton1Click:Connect(function()
			if aoClicar then
				pcall(aoClicar)
				DispensarCard(card, cardBrd, shimmerConn)
			end
		end)
		btnClose.MouseEnter:Connect(function()
			Tw(btnClose, 0.1, { BackgroundColor3 = Color3.fromRGB(220, 60, 60), BackgroundTransparency = 0 }):Play()
			Tw(closeBrd, 0.1, { Transparency = 1 }):Play()
		end)
		btnClose.MouseLeave:Connect(function()
			Tw(btnClose, 0.1, { BackgroundTransparency = 1 }):Play()
		end)
		btnClose.MouseButton1Click:Connect(function()
			DispensarCard(card, cardBrd, shimmerConn)
		end)

		local entrada = { card = card, brd = cardBrd, shimmer = nil, altura = minH }
		table.insert(notifFila, entrada)

		task.defer(function()
			if not card.Parent then return end

			local topPad = IS_MOBILE and 9  or 11
			local gap    = 4
			local botPad = IS_MOBILE and 11 or 14

			local altTit   = lblTitulo.TextBounds.Y
			local altMsg   = lblMsg.TextBounds.Y
			local altTotal = math.max(
				topPad + altTit + gap + altMsg + botPad + 4 + acaoH,
				minH
			)
			card.Size      = UDim2.new(1, 0, 0, altTotal)
			entrada.altura = altTotal

			local midY = (altTotal - acaoH) / 2
			ic.Position    = UDim2.new(0, 26,   0, midY - icSize/2)
			halo1.Position = UDim2.new(0, 20,   0, midY - (icSize+14)/2)
			halo2.Position = UDim2.new(0, 14,   0, midY - (icSize+26)/2)

			lblTitulo.Position = UDim2.new(0, txtX, 0, topPad)
			lblMsg.Position    = UDim2.new(0, txtX, 0, topPad + altTit + gap)

			ReposicionarFila()

			Tw(card, 0.42, {
				Position = UDim2.new(0, 0, card.Position.Y.Scale, card.Position.Y.Offset),
			}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
			Tw(glowFr, 0.42, { BackgroundTransparency = 0.88 }):Play()

			ic.Size = UDim2.new(0, 0, 0, 0)
			task.delay(0.22, function()
				if not ic.Parent then return end
				Tw(ic, 0.22, { Size = UDim2.new(0, icSize + 8, 0, icSize + 8) },
				Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				task.delay(0.22, function()
					if not ic.Parent then return end
					Tw(ic, 0.16, { Size = UDim2.new(0, icSize, 0, icSize) },
					Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				end)
			end)

			task.delay(0.22, function()
				if not halo1.Parent then return end
				Tw(halo1, 0.35, { BackgroundTransparency = 0.55 }):Play()
				Tw(halo2, 0.35, { BackgroundTransparency = 0.72 }):Play()
				task.delay(0.35, function()
					if not halo1.Parent then return end
					Tw(halo1, 0.5,  { BackgroundTransparency = 0.76 }):Play()
					Tw(halo2, 0.5,  { BackgroundTransparency = 0.86 }):Play()
				end)
			end)

			task.spawn(function()
				while card and card.Parent do
					Tw(glowFr, 1.8, { BackgroundTransparency = 0.82 },
					Enum.EasingStyle.Sine):Play()
					task.wait(1.8)
					if not card.Parent then break end
					Tw(glowFr, 1.8, { BackgroundTransparency = 0.91 },
					Enum.EasingStyle.Sine):Play()
					task.wait(1.8)
				end
			end)

			if not semAuto then
				Tw(prog, duracao, { Size = UDim2.new(0, 0, 1, 0) },
				Enum.EasingStyle.Linear):Play()
				task.delay(duracao, function()
					if card and card.Parent then
						DispensarCard(card, cardBrd, shimmerConn)
					end
				end)
			else
				progBg.Visible = false
			end
		end)
	end

	local pagArea, scrollTabs
	local SW = SIDEBAR_W

	local sidebar = F({Size=UDim2.new(0,SW,1,0),BackgroundColor3=C.Sidebar,Parent=corpoJanela})
	RegCor(sidebar,"BackgroundColor3","Sidebar")
	Cantos(sidebar,12)
	F({Size=UDim2.new(0.5,0,1,0),BackgroundColor3=C.Sidebar,Parent=sidebar})
	RegCor(F({Size=UDim2.new(0.5,0,1,0),BackgroundColor3=C.Sidebar,Parent=sidebar}),"BackgroundColor3","Sidebar")

	local divSide = F({Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=C.Borda,ZIndex=3,Parent=sidebar})
	RegCor(divSide,"BackgroundColor3","Borda")

	local topOffsetSidebar = IS_MOBILE and 10 or 44
	if not IS_MOBILE then
		local lblNav = L({
			Size=UDim2.new(1,-16,0,26),Position=UDim2.new(0,8,0,10),
			Text="M E N U",TextColor3=C.Destaque,Font=Enum.Font.GothamBold,
			TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=sidebar,
		})
		RegCor(lblNav,"TextColor3","Destaque")
		local linhMenu = F({Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,0,36),BackgroundColor3=C.Borda,ZIndex=3,Parent=sidebar})
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
	Pad(scrollTabs,6,10,IS_MOBILE and 5 or 7,IS_MOBILE and 5 or 7)
	local lyT = Instance.new("UIListLayout",scrollTabs)
	lyT.Padding=UDim.new(0,IS_MOBILE and 4 or 5)
	lyT.HorizontalAlignment=Enum.HorizontalAlignment.Center
	lyT:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollTabs.CanvasSize=UDim2.new(0,0,0,lyT.AbsoluteContentSize.Y+20)
	end)

	pagArea = F({
		Size=UDim2.new(1,-(SW+6),1,-10),
		Position=UDim2.new(0,SW+2,0,5),
		BackgroundTransparency=1,Parent=corpoJanela,
	})

	local todasTabs = {}
	local tabAtiva  = nil
	_todasTabsRef   = todasTabs

	local function AtivarAba(e)
		if tabAtiva == e then return end
		tabAtiva = e
		for _, t in ipairs(todasTabs) do
			local ok = (t == e)
			t._ativo = ok
			t.pagina.Visible = ok
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
				if t.ind then Tw(t.ind,0.15,{Size=UDim2.new(0,3,0,0)}):Play(); task.delay(0.15,function() if not t._ativo then t.ind.BackgroundTransparency=1 end end) end
			end
		end
	end

	local hubSelf = self

	function self:CriarAba(nomeAba, icone)
		local BTN_H = IS_MOBILE and 40 or 42

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

		local btnBrd = Stroke(btn, C.Borda, 1, 0.6)
		RegCor(btnBrd,"Color","Borda")

		local ind = F({
			Size=UDim2.new(0,3,0,0),
			Position=UDim2.new(0,-1,0.5,0),
			AnchorPoint=Vector2.new(0,0.5),
			BackgroundColor3=C.Destaque,
			BackgroundTransparency=1,
			ZIndex=4, Parent=btn,
		})
		Cantos(ind,99); RegCor(ind,"BackgroundColor3","Destaque")

		local glow = F({
			Size=UDim2.new(1,0,1,0),
			BackgroundColor3=C.Destaque,
			BackgroundTransparency=1,
			ZIndex=3, Parent=btn,
		})
		Cantos(glow,9); RegCor(glow,"BackgroundColor3","Destaque")

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

		function Aba:CriarColorPicker(texto, padraoColor3, callback)
			local corAtual = padraoColor3 or Color3.fromRGB(255,255,255)
			local h, s, v  = Color3.toHSV(corAtual)
			local aberto   = false

			local FH     = IS_MOBILE and 44 or 42
			local CVW    = IS_MOBILE and 160 or 190
			local CVH    = IS_MOBILE and 130 or 150
			local BAR_H  = 16
			local PAD    = 10
			local RPAD   = 10
			local RW     = IS_MOBILE and 85 or 100
			local RX     = PAD + CVW + RPAD
			local PICKER_H = PAD + CVH + 8 + BAR_H + 8 + BAR_H + 8 + 18*2 + 4 + PAD
			local AH     = FH + PICKER_H

			local fr = F({
				Size=UDim2.new(1,-6,0,FH),
				BackgroundColor3=C.Cartao,
				ClipsDescendants=false,
				LayoutOrder=PO(),
				Parent=pagina,
			})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

			local cab = Instance.new("TextButton")
			cab.Size=UDim2.new(1,0,0,FH)
			cab.BackgroundColor3=C.Cartao
			cab.BackgroundTransparency=0
			cab.Text=""; cab.AutoButtonColor=false
			cab.ZIndex=2; cab.Parent=fr
			Cantos(cab,10); RC(cab,"BackgroundColor3","Cartao")

			L({
				Size=UDim2.new(0.5,0,1,0),
				Position=UDim2.new(0,14,0,0),
				Text=texto,
				TextColor3=C.Sub,
				Font=Enum.Font.Gotham,
				TextSize=12,
				ZIndex=3,
				TextXAlignment=Enum.TextXAlignment.Left,
				Parent=cab,
			})

			local preview = F({
				Size=UDim2.new(0,24,0,24),
				Position=UDim2.new(1,-54,0.5,-12),
				BackgroundColor3=corAtual,
				ZIndex=3, Parent=cab,
			})
			Cantos(preview,6); Stroke(preview,C.Borda,1,0.4)

			local seta = L({
				Size=UDim2.new(0,20,1,0),
				Position=UDim2.new(1,-26,0,0),
				Text="›", TextColor3=C.Fraco,
				Font=Enum.Font.GothamBold,
				TextSize=16, Rotation=90,
				ZIndex=3, Parent=cab,
			})
			RC(seta,"TextColor3","Fraco")

			local pickerCorpo = F({
				Size=UDim2.new(1,0,0,PICKER_H),
				Position=UDim2.new(0,0,0,FH),
				BackgroundColor3=C.Cartao,
				ZIndex=1,
				Visible=false,
				Parent=fr,
			})
			RC(pickerCorpo,"BackgroundColor3","Cartao")

			local cvFr = F({
				Size=UDim2.new(0,CVW,0,CVH),
				Position=UDim2.new(0,PAD,0,PAD),
				BackgroundColor3=Color3.new(1,1,1),
				ZIndex=2, Parent=pickerCorpo,
			})
			Cantos(cvFr,6); Stroke(cvFr,C.Borda,1,0.5)

			local gradSat = Instance.new("UIGradient")
			gradSat.Color = ColorSequence.new(Color3.new(1,1,1), Color3.fromHSV(h,1,1))
			gradSat.Rotation = 0; gradSat.Parent = cvFr

			local cvDark = F({Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0), ZIndex=3, Parent=cvFr})
			Cantos(cvDark,6)
			local gradDark = Instance.new("UIGradient")
			gradDark.Color = ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
			gradDark.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,1),
				NumberSequenceKeypoint.new(1,0),
			})
			gradDark.Rotation = 90; gradDark.Parent = cvDark

			local cvCursor = F({
				Size=UDim2.new(0,14,0,14), AnchorPoint=Vector2.new(0.5,0.5),
				Position=UDim2.new(s,0,1-v,0),
				BackgroundColor3=Color3.new(1,1,1), ZIndex=6, Parent=cvFr,
			})
			Cantos(cvCursor,99); Stroke(cvCursor,Color3.new(0,0,0),2,0.2)

			local hueY = PAD + CVH + 8
			local hueFr = F({
				Size=UDim2.new(0,CVW,0,BAR_H),
				Position=UDim2.new(0,PAD,0,hueY),
				ZIndex=2, Parent=pickerCorpo,
			})
			Cantos(hueFr,99); Stroke(hueFr,C.Borda,1,0.5)
			local hueKfs={}
			for i=0,6 do hueKfs[i+1]=ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1)) end
			local hueGrad = Instance.new("UIGradient")
			hueGrad.Color = ColorSequence.new(hueKfs)
			hueGrad.Rotation = 0; hueGrad.Parent = hueFr
			local hueCur = F({
				Size=UDim2.new(0,BAR_H+2,0,BAR_H+2), AnchorPoint=Vector2.new(0.5,0.5),
				Position=UDim2.new(h,0,0.5,0),
				BackgroundColor3=Color3.new(1,1,1), ZIndex=4, Parent=hueFr,
			})
			Cantos(hueCur,99); Stroke(hueCur,Color3.new(0,0,0),2,0.2)

			local valY = hueY + BAR_H + 8
			local valFr = F({
				Size=UDim2.new(0,CVW,0,BAR_H),
				Position=UDim2.new(0,PAD,0,valY),
				ZIndex=2, Parent=pickerCorpo,
			})
			Cantos(valFr,99); Stroke(valFr,C.Borda,1,0.5)
			local valGrad = Instance.new("UIGradient")
			valGrad.Color = ColorSequence.new(Color3.new(0,0,0), Color3.fromHSV(h,s,1))
			valGrad.Rotation = 0; valGrad.Parent = valFr
			local valCur = F({
				Size=UDim2.new(0,BAR_H+2,0,BAR_H+2), AnchorPoint=Vector2.new(0.5,0.5),
				Position=UDim2.new(v,0,0.5,0),
				BackgroundColor3=Color3.new(1,1,1), ZIndex=4, Parent=valFr,
			})
			Cantos(valCur,99); Stroke(valCur,Color3.new(0,0,0),2,0.2)

			local presetY = valY + BAR_H + 8
			local presets = {
				Color3.fromRGB(255,59,59), Color3.fromRGB(255,140,0), Color3.fromRGB(255,210,0),
				Color3.fromRGB(74,222,128),Color3.fromRGB(56,189,248),Color3.fromRGB(167,139,250),
				Color3.fromRGB(232,121,249),Color3.fromRGB(255,100,130),Color3.fromRGB(34,211,238),
				Color3.fromRGB(255,255,255),Color3.fromRGB(148,148,165),Color3.fromRGB(0,0,0),
			}
			local PCOLS = 6; local PCELL = IS_MOBILE and 20 or 22; local PGAP = 4

			local bigPrev = F({
				Size=UDim2.new(0,RW,0,44),
				Position=UDim2.new(0,RX,0,PAD),
				BackgroundColor3=corAtual, ZIndex=2, Parent=pickerCorpo,
			})
			Cantos(bigPrev,8); Stroke(bigPrev,C.Borda,1,0.3)

			local function CorParaHex(c)
				return string.format("#%02X%02X%02X",
					math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))
			end
			local function HexParaCor(hex)
				hex=hex:gsub("#","")
				if #hex~=6 then return nil end
				local r=tonumber(hex:sub(1,2),16)
				local g=tonumber(hex:sub(3,4),16)
				local b=tonumber(hex:sub(5,6),16)
				if not r or not g or not b then return nil end
				return Color3.fromRGB(r,g,b)
			end

			local hexFr = F({Size=UDim2.new(0,RW,0,26),
				Position=UDim2.new(0,RX,0,PAD+48),
				BackgroundColor3=C.Item, ZIndex=2, Parent=pickerCorpo})
			Cantos(hexFr,7); Stroke(hexFr,C.Borda,1,0.4); RC(hexFr,"BackgroundColor3","Item")
			local hexBox = Instance.new("TextBox")
			hexBox.Size=UDim2.new(1,-8,1,-4); hexBox.Position=UDim2.new(0,4,0,2)
			hexBox.BackgroundTransparency=1; hexBox.Text=CorParaHex(corAtual)
			hexBox.TextColor3=C.Texto; hexBox.Font=Enum.Font.GothamBold
			hexBox.TextSize=11; hexBox.TextXAlignment=Enum.TextXAlignment.Center
			hexBox.ClearTextOnFocus=false; hexBox.ZIndex=3; hexBox.Parent=hexFr
			RC(hexBox,"TextColor3","Texto")

			local rgbData = {
				{label="R",cor=Color3.fromRGB(220,55,55), prop="r"},
				{label="G",cor=Color3.fromRGB(48,200,100),prop="g"},
				{label="B",cor=Color3.fromRGB(55,140,220),prop="b"},
			}
			local rgbRefs = {}
			local function GetRGB()
				return math.floor(corAtual.R*255+0.5),
				math.floor(corAtual.G*255+0.5),
				math.floor(corAtual.B*255+0.5)
			end
			for i,rd in ipairs(rgbData) do
				local ry = PAD+78+(i-1)*26
				L({Size=UDim2.new(0,12,0,18),Position=UDim2.new(0,RX,0,ry),
					Text=rd.label,TextColor3=rd.cor,Font=Enum.Font.GothamBold,
					TextSize=10,ZIndex=2,Parent=pickerCorpo})
				local rt=F({Size=UDim2.new(0,RW-16,0,8),
					Position=UDim2.new(0,RX+14,0,ry+5),
					BackgroundColor3=C.Item,ZIndex=2,Parent=pickerCorpo})
				Cantos(rt,99); RC(rt,"BackgroundColor3","Item")
				local rg=Instance.new("UIGradient")
				rg.Color=ColorSequence.new(Color3.new(0,0,0),rd.cor); rg.Rotation=0; rg.Parent=rt
				local rf=F({Size=UDim2.new(0.5,0,1,0),BackgroundColor3=rd.cor,ZIndex=3,Parent=rt})
				Cantos(rf,99)
				local rb=F({Size=UDim2.new(0,12,0,12),AnchorPoint=Vector2.new(0.5,0.5),
					Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=4,Parent=rt})
				Cantos(rb,99); Stroke(rb,Color3.new(0,0,0),1,0.6)
				rgbRefs[rd.prop]={trilha=rt,fill=rf,bola=rb}
			end

			local function AtualizarTudo()
				h=math.clamp(h,0,1); s=math.clamp(s,0,1); v=math.clamp(v,0,1)
				corAtual=Color3.fromHSV(h,s,v)
				preview.BackgroundColor3=corAtual
				bigPrev.BackgroundColor3=corAtual
				if not hexBox:IsFocused() then hexBox.Text=CorParaHex(corAtual) end

				gradSat.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(h,1,1))
				cvCursor.Position=UDim2.new(s,0,1-v,0)
				cvCursor.BackgroundColor3=corAtual

				hueCur.Position=UDim2.new(h,0,0.5,0)

				valGrad.Color=ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,s,1))
				valCur.Position=UDim2.new(v,0,0.5,0)

				local r2,g2,b2=GetRGB()
				local rv={r=r2/255,g=g2/255,b=b2/255}
				for prop,ref in pairs(rgbRefs) do
					ref.fill.Size=UDim2.new(rv[prop],0,1,0)
					ref.bola.Position=UDim2.new(rv[prop],0,0.5,0)
				end
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
				pb.MouseButton1Click:Connect(function()
					h,s,v=Color3.toHSV(pc); AtualizarTudo()
				end)
			end

			hexBox.FocusLost:Connect(function()
				local nc=HexParaCor(hexBox.Text)
				if nc then h,s,v=Color3.toHSV(nc); AtualizarTudo()
				else hexBox.Text=CorParaHex(corAtual) end
			end)

			local dragTipo = nil

			local function Arrastar(px, py)
				if dragTipo=="cv" then
					local ap=cvFr.AbsolutePosition; local as=cvFr.AbsoluteSize
					s=math.clamp((px-ap.X)/as.X,0,1)
					v=math.clamp(1-(py-ap.Y)/as.Y,0,1)
					AtualizarTudo()
				elseif dragTipo=="hue" then
					local ap=hueFr.AbsolutePosition; local as=hueFr.AbsoluteSize
					h=math.clamp((px-ap.X)/as.X,0,1); AtualizarTudo()
				elseif dragTipo=="val" then
					local ap=valFr.AbsolutePosition; local as=valFr.AbsoluteSize
					v=math.clamp((px-ap.X)/as.X,0,1); AtualizarTudo()
				elseif dragTipo=="r" or dragTipo=="g" or dragTipo=="b" then
					local ref=rgbRefs[dragTipo]
					local ap=ref.trilha.AbsolutePosition; local as=ref.trilha.AbsoluteSize
					local p=math.clamp((px-ap.X)/as.X,0,1)
					local r2,g2,b2=GetRGB()
					if dragTipo=="r" then r2=math.floor(p*255+0.5)
					elseif dragTipo=="g" then g2=math.floor(p*255+0.5)
					else b2=math.floor(p*255+0.5) end
					h,s,v=Color3.toHSV(Color3.fromRGB(r2,g2,b2)); AtualizarTudo()
				end
			end

			local function IsBegan(i)
				return i.UserInputType==Enum.UserInputType.MouseButton1
					or i.UserInputType==Enum.UserInputType.Touch
			end
			local function IsMoved(i)
				return i.UserInputType==Enum.UserInputType.MouseMovement
					or i.UserInputType==Enum.UserInputType.Touch
			end
			local function IsEnded(i)
				return i.UserInputType==Enum.UserInputType.MouseButton1
					or i.UserInputType==Enum.UserInputType.Touch
			end

			local cvHit = Instance.new("TextButton")
			cvHit.Size=UDim2.new(1,0,1,0); cvHit.BackgroundTransparency=1
			cvHit.Text=""; cvHit.AutoButtonColor=false; cvHit.ZIndex=8; cvHit.Parent=cvFr
			cvHit.InputBegan:Connect(function(i)
				if not IsBegan(i) then return end
				dragTipo="cv"
				Arrastar(i.Position.X,i.Position.Y)
				Tw(cvCursor,0.06,{Size=UDim2.new(0,18,0,18)}):Play()
			end)

			local hueHit = Instance.new("TextButton")
			hueHit.Size=UDim2.new(1,0,1,4); hueHit.Position=UDim2.new(0,0,0,-2)
			hueHit.BackgroundTransparency=1; hueHit.Text=""
			hueHit.AutoButtonColor=false; hueHit.ZIndex=5; hueHit.Parent=hueFr
			hueHit.InputBegan:Connect(function(i)
				if not IsBegan(i) then return end
				dragTipo="hue"; Arrastar(i.Position.X,i.Position.Y)
			end)

			local valHit = Instance.new("TextButton")
			valHit.Size=UDim2.new(1,0,1,4); valHit.Position=UDim2.new(0,0,0,-2)
			valHit.BackgroundTransparency=1; valHit.Text=""
			valHit.AutoButtonColor=false; valHit.ZIndex=5; valHit.Parent=valFr
			valHit.InputBegan:Connect(function(i)
				if not IsBegan(i) then return end
				dragTipo="val"; Arrastar(i.Position.X,i.Position.Y)
			end)

			for prop,ref in pairs(rgbRefs) do
				local p2=prop
				local rHit=Instance.new("TextButton")
				rHit.Size=UDim2.new(1,0,0,24); rHit.Position=UDim2.new(0,0,0.5,-12)
				rHit.BackgroundTransparency=1; rHit.Text=""
				rHit.AutoButtonColor=false; rHit.ZIndex=5; rHit.Parent=ref.trilha
				rHit.InputBegan:Connect(function(i)
					if not IsBegan(i) then return end
					dragTipo=p2; Arrastar(i.Position.X,i.Position.Y)
				end)
			end

			table.insert(hubSelf._conexoes, EntradaUsuario.InputChanged:Connect(function(i)
				if dragTipo==nil then return end
				if IsMoved(i) then Arrastar(i.Position.X,i.Position.Y) end
			end))
			table.insert(hubSelf._conexoes, EntradaUsuario.InputEnded:Connect(function(i)
				if not IsEnded(i) then return end
				if dragTipo=="cv" then
					Tw(cvCursor,0.08,{Size=UDim2.new(0,14,0,14)}):Play()
				end
				dragTipo=nil
			end))

			cab.MouseButton1Click:Connect(function()
				aberto=not aberto
				if aberto then
					pickerCorpo.Visible=true
					Tw(fr,0.28,{Size=UDim2.new(1,-6,0,AH)},
					Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
				else
					Tw(fr,0.2,{Size=UDim2.new(1,-6,0,FH)},
					Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
					task.delay(0.2,function()
						if not aberto then pickerCorpo.Visible=false end
					end)
				end
				Tw(seta,0.2,{Rotation=aberto and -90 or 90}):Play()
			end)
			fr.MouseEnter:Connect(function()
				if not aberto then Tw(cab,0.12,{BackgroundColor3=C.ItemHover}):Play() end
			end)
			fr.MouseLeave:Connect(function()
				Tw(cab,0.12,{BackgroundColor3=C.Cartao}):Play()
			end)

			AtualizarTudo()

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

		function Aba:CriarBotao(texto, callback, config)
			config = config or {}
			local icone  = config.icone
			local perigo = config.perigo
			local BH     = BTN_H

			local function CorFundo()  return perigo and C.Perigo    or C.BotaoFundo  end
			local function CorHover()  return perigo and Color3.fromRGB(
				math.min(C.Perigo.R*255+30,255),
				math.min(C.Perigo.G*255+18,255),
				math.min(C.Perigo.B*255+18,255)
				) or C.BotaoHover end
			local function CorTexto()  return perigo and Color3.new(1,1,1) or C.BotaoTexto end
			local function CorBorda()  return perigo and C.Perigo    or C.Destaque   end
			local function CorGradTop()
				local f = CorFundo()
				return Color3.new(math.min(f.R+0.06,1), math.min(f.G+0.06,1), math.min(f.B+0.06,1))
			end

			local wrap = F({
				Size                   = UDim2.new(1,-6,0,BH),
				BackgroundTransparency = 1,
				LayoutOrder            = PO(),
				ClipsDescendants       = false,
				Parent                 = pagina,
			})

			local glow = F({
				Size                   = UDim2.new(1,14,1,14),
				Position               = UDim2.new(0,-7,0,-7),
				BackgroundColor3       = CorBorda(),
				BackgroundTransparency = 1,
				ZIndex                 = 1,
				Parent                 = wrap,
			})
			Cantos(glow, 16)
			RC(glow, "BackgroundColor3", perigo and "Perigo" or "Destaque")

			local b = Instance.new("TextButton")
			b.Size             = UDim2.new(1,0,1,0)
			b.BackgroundColor3 = CorFundo()
			b.Text             = ""
			b.Font             = Enum.Font.GothamBold
			b.TextSize         = 13
			b.AutoButtonColor  = false
			b.ClipsDescendants = true
			b.ZIndex           = 2
			b.Parent           = wrap
			Cantos(b, 10)
			RC(b, "BackgroundColor3", perigo and "Perigo" or "BotaoFundo")

			local gradFundo = Instance.new("UIGradient")
			gradFundo.Color    = ColorSequence.new(CorGradTop(), CorFundo())
			gradFundo.Rotation = 90
			gradFundo.Parent   = b

			table.insert(_gradRefs, {
				grad = gradFundo,
				k1 = perigo and "Perigo" or "BotaoHover",
				k2 = perigo and "Perigo" or "BotaoFundo",
				rot = 90,
			})

			local brdB = Stroke(b, CorBorda(), 1, 0.45)
			RC(brdB, "Color", perigo and "Perigo" or "Destaque")
			if isRainbow and not perigo then AddRainbow(brdB, "Color", 0.15) end

			local shine = F({
				Size                   = UDim2.new(1,0,0,BH*0.48),
				Position               = UDim2.new(0,0,0,0),
				BackgroundColor3       = Color3.new(1,1,1),
				BackgroundTransparency = 0.88,
				ZIndex                 = 4,
				Parent                 = b,
			})
			Cantos(shine, 10)
			do
				local g = Instance.new("UIGradient")
				g.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0,   0.00),
					NumberSequenceKeypoint.new(0.5, 0.04),
					NumberSequenceKeypoint.new(1,   1.00),
				})
				g.Rotation = 90; g.Parent = shine
			end

			local shimmer = F({
				Size                   = UDim2.new(0,40,1,8),
				Position               = UDim2.new(0,-60,0,-4),
				BackgroundColor3       = Color3.new(1,1,1),
				BackgroundTransparency = 0.78,
				Rotation               = 20,
				ZIndex                 = 5,
				Parent                 = b,
			})
			do
				local g = Instance.new("UIGradient")
				g.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0,    1  ),
					NumberSequenceKeypoint.new(0.45, 0.5),
					NumberSequenceKeypoint.new(0.55, 0.5),
					NumberSequenceKeypoint.new(1,    1  ),
				})
				g.Rotation = 0; g.Parent = shimmer
			end

			local function SpawnRipple(mx, my)
				local rp = F({
					Size                   = UDim2.new(0,0,0,0),
					Position               = UDim2.new(0, mx - b.AbsolutePosition.X,
						0, my - b.AbsolutePosition.Y),
					AnchorPoint            = Vector2.new(0.5,0.5),
					BackgroundColor3       = Color3.new(1,1,1),
					BackgroundTransparency = 0.72,
					ZIndex                 = 6,
					Parent                 = b,
				})
				Cantos(rp, 99)
				local sz = b.AbsoluteSize.X * 2.2
				Tw(rp, 0.50, {
					Size                   = UDim2.new(0,sz,0,sz),
					BackgroundTransparency = 1,
				}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
				task.delay(0.52, function() if rp.Parent then rp:Destroy() end end)
			end

			local lblHolder = F({
				Size                   = UDim2.new(1,-16,1,0),
				Position               = UDim2.new(0,8,0,0),
				BackgroundTransparency = 1,
				ZIndex                 = 7,
				Parent                 = b,
			})

			local lblTexto
			if icone then
				local icoLbl = L({
					Size           = UDim2.new(0,22,1,0),
					Position       = UDim2.new(0,0,0,0),
					Text           = icone,
					TextColor3     = CorTexto(),
					Font           = Enum.Font.GothamBold,
					TextSize       = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex         = 7,
					Parent         = lblHolder,
				})
				RC(icoLbl, "TextColor3", perigo and "Texto" or "BotaoTexto")
				lblTexto = L({
					Size           = UDim2.new(1,-26,1,0),
					Position       = UDim2.new(0,26,0,0),
					Text           = texto,
					TextColor3     = CorTexto(),
					Font           = Enum.Font.GothamBold,
					TextSize       = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex         = 7,
					Parent         = lblHolder,
				})
			else
				lblTexto = L({
					Size       = UDim2.new(1,0,1,0),
					Text       = texto,
					TextColor3 = CorTexto(),
					Font       = Enum.Font.GothamBold,
					TextSize   = 13,
					ZIndex     = 7,
					Parent     = lblHolder,
				})
			end
			RC(lblTexto, "TextColor3", perigo and "Texto" or "BotaoTexto")

			local shimmerTw = nil
			local hovering  = false

			b.MouseEnter:Connect(function()
				hovering = true
				Tw(b,     0.18, { BackgroundColor3 = CorHover()  }):Play()
				Tw(brdB,  0.18, { Transparency = 0.05 }):Play()
				Tw(glow,  0.22, { BackgroundColor3 = CorBorda(), BackgroundTransparency = 0.76 }):Play()
				Tw(shine, 0.18, { BackgroundTransparency = 0.78 }):Play()
				shimmer.Position = UDim2.new(0,-60,0,-4)
				if shimmerTw then shimmerTw:Cancel() end
				shimmerTw = Tw(shimmer, 0.48, {
					Position = UDim2.new(0, b.AbsoluteSize.X + 20, 0, -4),
				}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				shimmerTw:Play()
			end)

			b.MouseLeave:Connect(function()
				hovering = false
				Tw(b,     0.18, { BackgroundColor3 = CorFundo() }):Play()
				Tw(brdB,  0.18, { Transparency = 0.45 }):Play()
				Tw(glow,  0.22, { BackgroundTransparency = 1 }):Play()
				Tw(shine, 0.18, { BackgroundTransparency = 0.88 }):Play()
			end)

			b.MouseButton1Down:Connect(function(x, y)
				SpawnRipple(x, y)
				Tw(b,    0.08, { Size = UDim2.new(1,-8, 0,BH-3) }):Play()
				Tw(wrap, 0.08, { Size = UDim2.new(1,-10,0,BH-3) }):Play()
				Tw(brdB, 0.08, { Transparency = 0 }):Play()
				Tw(glow, 0.08, { BackgroundTransparency = 0.62 }):Play()
			end)

			b.MouseButton1Up:Connect(function()
				Tw(b,    0.18, { Size = UDim2.new(1,0, 0,BH) },
				Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				Tw(wrap, 0.18, { Size = UDim2.new(1,-6,0,BH) },
				Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
				Tw(glow, 0.22, { BackgroundTransparency = hovering and 0.76 or 1 }):Play()
			end)

			b.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
			
			local obj = {}
			function obj:SetTexto(t) if lblTexto then lblTexto.Text = t end end
			function obj:SetAtivo(ativo)
				b.Active = ativo
				Tw(b,    0.15, { BackgroundTransparency = ativo and 0 or 0.50 }):Play()
				Tw(brdB, 0.15, { Transparency           = ativo and 0.45 or 0.80 }):Play()
			end
			return obj
		end

		function Aba:CriarToggle(texto, padrao, callback)
			local estado = (padrao == true)

			local TW, TH = 52, 28
			local BR      = TH - 6

			local fr = F({Size=UDim2.new(1,-6,0,IH), BackgroundColor3=C.Cartao, LayoutOrder=PO(), Parent=pagina})
			Cantos(fr,10)
			local frBrd = Stroke(fr, C.Borda, 1, 0.35); RC(frBrd,"Color","Borda")
			RC(fr,"BackgroundColor3","Cartao")

			local lblTxt = L({
				Size=UDim2.new(1,-(TW+80),1,0), Position=UDim2.new(0,14,0,0),
				Text=texto, TextColor3=C.Texto, Font=Enum.Font.Gotham,
				TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=fr,
			})
			RC(lblTxt,"TextColor3","Texto")

			local trilha = F({
				Size=UDim2.new(0,TW,0,TH),
				Position=UDim2.new(1,-(TW+12),0.5,-(TH/2)),
				BackgroundColor3 = estado and C.Sucesso or C.Fraco,
				ZIndex=2, Parent=fr,
			})
			Cantos(trilha, 99)
			local trilhaBrd = Stroke(trilha, Color3.new(0,0,0), 1, 0.88)

			local trilhaGlow = F({
				Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Sucesso,
				BackgroundTransparency = estado and 0.7 or 1,
				ZIndex=2, Parent=trilha,
			})
			Cantos(trilhaGlow,99)

			local bolinhaX_off = 3
			local bolinhaX_on  = TW - BR - 3
			local bolinha = F({
				Size=UDim2.new(0,BR,0,BR),
				Position=estado and UDim2.new(0,bolinhaX_on,0.5,-(BR/2)) or UDim2.new(0,bolinhaX_off,0.5,-(BR/2)),
				BackgroundColor3=Color3.new(1,1,1), ZIndex=4, Parent=trilha,
			})
			Cantos(bolinha,99)
			Stroke(bolinha, Color3.new(0,0,0), 1, 0.78)

			local lblE = L({
				Size=UDim2.new(0,38,1,0),
				Position=UDim2.new(1,-(TW+56),0,0),
				Text=estado and "ON" or "OFF",
				TextColor3=estado and C.Sucesso or C.Fraco,
				Font=Enum.Font.GothamBold, TextSize=11, Parent=fr,
			})

			local function Sync(anim)
				local d = anim and 0.2 or 0
				local es = Enum.EasingStyle.Back
				local eo = Enum.EasingDirection.Out
				if estado then
					Tw(trilha, d, {BackgroundColor3=C.Sucesso}):Play()
					Tw(trilhaGlow, d, {BackgroundTransparency=0.7}):Play()
					Tw(trilhaBrd, d, {Transparency=0.88}):Play()
					Tw(bolinha, d, {Position=UDim2.new(0,bolinhaX_on,0.5,-(BR/2))}, es, eo):Play()
					if anim then
						Tw(bolinha, d*0.4, {Size=UDim2.new(0,BR+5,0,BR-3)}):Play()
						task.delay(d*0.4, function()
							Tw(bolinha, d*0.6, {Size=UDim2.new(0,BR,0,BR)}, es, eo):Play()
						end)
					end
					Tw(lblE, d, {TextColor3=C.Sucesso}):Play(); lblE.Text="ON"
					Tw(frBrd, d, {Color=C.Sucesso, Transparency=0.55}):Play()
				else
					Tw(trilha, d, {BackgroundColor3=C.Fraco}):Play()
					Tw(trilhaGlow, d, {BackgroundTransparency=1}):Play()
					Tw(trilhaBrd, d, {Transparency=0.88}):Play()
					Tw(bolinha, d, {Position=UDim2.new(0,bolinhaX_off,0.5,-(BR/2))}, es, eo):Play()
					if anim then
						Tw(bolinha, d*0.4, {Size=UDim2.new(0,BR+5,0,BR-3)}):Play()
						task.delay(d*0.4, function()
							Tw(bolinha, d*0.6, {Size=UDim2.new(0,BR,0,BR)}, es, eo):Play()
						end)
					end
					Tw(lblE, d, {TextColor3=C.Fraco}):Play(); lblE.Text="OFF"
					Tw(frBrd, d, {Color=C.Borda, Transparency=0.35}):Play()
				end
				if callback then callback(estado) end
			end

			local THRESH = 8
			local touchStart, touchDrag = nil, false

			fr.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					estado = not estado; Sync(true)
				elseif i.UserInputType == Enum.UserInputType.Touch then
					touchStart = i.Position; touchDrag = false
				end
			end)
			fr.InputChanged:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.Touch and touchStart then
					if math.abs(i.Position.X-touchStart.X)>THRESH
						or math.abs(i.Position.Y-touchStart.Y)>THRESH then
						touchDrag = true
					end
				end
			end)
			fr.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.Touch then
					if touchStart and not touchDrag then estado=not estado; Sync(true) end
					touchStart=nil; touchDrag=false
				end
			end)

			fr.MouseEnter:Connect(function()
				Tw(fr, 0.12, {BackgroundColor3=C.ItemHover}):Play()
				if not estado then Tw(frBrd,0.12,{Transparency=0.15}):Play() end
			end)
			fr.MouseLeave:Connect(function()
				Tw(fr, 0.12, {BackgroundColor3=C.Cartao}):Play()
				Tw(frBrd,0.12,{Transparency= estado and 0.55 or 0.35}):Play()
			end)

			local obj = {}
			function obj:Definir(v) estado=v; Sync(true) end
			function obj:Obter() return estado end
			obj.Set=obj.Definir; obj.Get=obj.Obter
			return obj
		end

		function Aba:CriarSlider(texto, minV, maxV, padrao, callback, config)
			config = config or {}
			local step     = config.step     or 1
			local useFloat = config.float    or false
			local decimais = config.decimais or 1
			local unidade  = config.unidade  or ""

			local function Arredondar(v)
				return math.floor(v/step + 0.5)*step
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

			local labelY = IS_MOBILE and 10 or 9
			L({Size=UDim2.new(0.58,0,0,20), Position=UDim2.new(0,14,0,labelY),
				Text=texto, TextColor3=C.Texto, Font=Enum.Font.Gotham, TextSize=13,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=fr})

			local lblV = L({Size=UDim2.new(0.38,0,0,20), Position=UDim2.new(0.6,-4,0,labelY),
				Text=Formatar(val), TextColor3=C.Destaque, Font=Enum.Font.GothamBold,
				TextSize=13, TextXAlignment=Enum.TextXAlignment.Right, Parent=fr})
			RC(lblV,"TextColor3","Destaque")

			local hintY = IS_MOBILE and 30 or 28
			L({Size=UDim2.new(0,30,0,12), Position=UDim2.new(0,14,0,hintY),
				Text=Formatar(minV), TextColor3=C.Fraco, Font=Enum.Font.Gotham, TextSize=9,
				TextXAlignment=Enum.TextXAlignment.Left, Parent=fr})
			L({Size=UDim2.new(0,30,0,12), Position=UDim2.new(1,-44,0,hintY),
				Text=Formatar(maxV), TextColor3=C.Fraco, Font=Enum.Font.Gotham, TextSize=9,
				TextXAlignment=Enum.TextXAlignment.Right, Parent=fr})

			local trilhaY = IS_MOBILE and 50 or 47
			local trilha=F({Size=UDim2.new(1,-28,0,6), Position=UDim2.new(0,14,0,trilhaY),
				BackgroundColor3=C.Item, Parent=fr})
			RC(trilha,"BackgroundColor3","Item"); Cantos(trilha,99)

			local pct = (val-minV)/(maxV-minV)
			local fill=F({Size=UDim2.new(pct,0,1,0), BackgroundColor3=C.Destaque, Parent=trilha})
			Cantos(fill,99); RC(fill,"BackgroundColor3","Destaque")
			local fillGrad=Grad(fill,C.DestaqueV,C.Destaque,0); RegGrad(fillGrad,"DestaqueV","Destaque",0)
			if isRainbow then AddRainbow(fill,"BackgroundColor3",0.12) end

			local BOLA = IS_MOBILE and 20 or 17
			local bola=F({Size=UDim2.new(0,BOLA,0,BOLA), Position=UDim2.new(pct,0,0.5,0),
				AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), ZIndex=3, Parent=trilha})
			Cantos(bola,99)
			local bolaBrd=Stroke(bola,C.Destaque,2,0.25); RC(bolaBrd,"Color","Destaque")

			local tooltip = F({Size=UDim2.new(0,44,0,20), AnchorPoint=Vector2.new(0.5,1),
				Position=UDim2.new(pct,0,0,-6), BackgroundColor3=C.Destaque,
				ZIndex=6, Visible=false, Parent=trilha})
			Cantos(tooltip,5)
			local tooltipLbl = L({Size=UDim2.new(1,0,1,0), Text=Formatar(val),
				TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
				TextSize=10, ZIndex=7, Parent=tooltip})

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

		function Aba:CriarDropdown(texto, opcoes, callback, multi, search, maxVisible, placeholder)
			if type(multi) == "table" then
				local cfg = multi
				multi       = cfg.multi
				search      = cfg.search
				maxVisible  = cfg.maxVisible
				placeholder = cfg.placeholder
			end

			local multiSelect    = multi      or false
			local useSearch      = search ~= false
			local maxVis         = maxVisible  or 5
			local placeholderTxt = placeholder or opcoes[1] or "-"

			local aberto = false
			local IHd    = IS_MOBILE and 38 or 34
			local FH     = IS_MOBILE and 44 or 44
			local GAP    = 4
			local PAD    = 8
			local SEARCH_H = useSearch and (IS_MOBILE and 36 or 32) or 0

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

			local fr = F({
				Size=UDim2.new(1,-6,0,FH),
				BackgroundColor3=C.Cartao,
				ClipsDescendants=true,
				LayoutOrder=PO(),
				Parent=pagina,
			})
			Cantos(fr,10); Stroke(fr,C.Borda,1,0.35); RC(fr,"BackgroundColor3","Cartao")

			local cab = Instance.new("TextButton")
			cab.Size=UDim2.new(1,0,0,FH)
			cab.BackgroundTransparency=1
			cab.Text=""; cab.AutoButtonColor=false
			cab.ZIndex=2; cab.Parent=fr

			L({Size=UDim2.new(0.45,0,1,0), Position=UDim2.new(0,14,0,0), Text=texto,
				TextColor3=C.Sub, Font=Enum.Font.Gotham, TextSize=12,
				TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3, Parent=cab})

			local lblS = L({Size=UDim2.new(0.42,0,1,0), Position=UDim2.new(0.5,-2,0,0),
				Text=GetLabel(), TextColor3=C.Texto, Font=Enum.Font.GothamBold,
				TextSize=IS_MOBILE and 11 or 12, TextWrapped=true,
				TextXAlignment=Enum.TextXAlignment.Right, ZIndex=3, Parent=cab})
			RC(lblS,"TextColor3","Texto")

			local badge = F({Size=UDim2.new(0,18,0,18), Position=UDim2.new(1,-46,0.5,-9),
				BackgroundColor3=C.Destaque, ZIndex=3, Visible=false, Parent=cab})
			Cantos(badge,99); RC(badge,"BackgroundColor3","Destaque")
			L({Size=UDim2.new(1,0,1,0), Text="0",
				TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=9, ZIndex=4, Parent=badge})
			local badgeLbl = badge:FindFirstChildWhichIsA("TextLabel")

			local seta = L({Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-26,0,0),
				Text="›", TextColor3=C.Fraco, Font=Enum.Font.GothamBold,
				TextSize=16, Rotation=90, ZIndex=3, Parent=cab})
			RC(seta,"TextColor3","Fraco")

			local sep = F({Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,FH),
				BackgroundColor3=C.Borda, ZIndex=2, Parent=fr})
			RC(sep,"BackgroundColor3","Borda")

			local searchBox = nil
			local sfrRef    = nil
			if useSearch then
				sfrRef = F({
					Size=UDim2.new(1,-16,0,SEARCH_H-6),
					Position=UDim2.new(0,8,0,FH+6),
					BackgroundColor3=C.Item, ZIndex=2, Parent=fr,
				})
				Cantos(sfrRef,8); RC(sfrRef,"BackgroundColor3","Item")
				local sbrd = Stroke(sfrRef,C.Borda,1,0.4); RC(sbrd,"Color","Borda")
				L({Size=UDim2.new(0,18,1,0), Position=UDim2.new(0,6,0,0),
					Text="🔍", TextSize=IS_MOBILE and 12 or 11,
					Font=Enum.Font.Gotham, ZIndex=3, Parent=sfrRef})
				searchBox = Instance.new("TextBox")
				searchBox.Size=UDim2.new(1,-30,1,-8); searchBox.Position=UDim2.new(0,26,0,4)
				searchBox.BackgroundTransparency=1; searchBox.Text=""
				searchBox.PlaceholderText="Buscar..."; searchBox.PlaceholderColor3=C.Fraco
				searchBox.TextColor3=C.Texto; searchBox.Font=Enum.Font.Gotham
				searchBox.TextSize=IS_MOBILE and 12 or 11
				searchBox.TextXAlignment=Enum.TextXAlignment.Left
				searchBox.ClearTextOnFocus=false; searchBox.ZIndex=3; searchBox.Parent=sfrRef
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
				badge.Visible=cnt>0
				if badgeLbl then badgeLbl.Text=tostring(cnt) end
			end

			local function CalcAlturaTotal(visCount)
				local linhas = math.min(visCount, maxVis)
				local altLista = linhas*(IHd+GAP) + PAD*2
				return FH + 1 + SEARCH_H + altLista
			end

			local _syncValorRef = {fn = function() end}

			local FecharDropdown

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

					local it = Instance.new("TextButton")
					it.Size=UDim2.new(1,0,0,IHd)
					it.BackgroundColor3 = ativo and C.BotaoFundo or C.Item
					it.Text=""
					it.AutoButtonColor=false; it.ZIndex=3; it.Parent=listaHolder
					Cantos(it,8)

					local itBrd = Stroke(it, ativo and C.Destaque or C.Borda, 1, ativo and 0.5 or 0.7)

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
							selSimples=op; lblS.Text=op
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
							FecharDropdown()
						end
					end)
				end

				if visiveis==0 then
					local empty=F({Size=UDim2.new(1,0,0,IHd),BackgroundTransparency=1,ZIndex=2,Parent=listaHolder})
					L({Size=UDim2.new(1,0,1,0),Text="Nenhum resultado",TextColor3=C.Fraco,Font=Enum.Font.Gotham,TextSize=12,ZIndex=3,Parent=empty})
				end

				local linhas = math.min(visiveis>0 and visiveis or 1, maxVis)
				local altLista = linhas*(IHd+GAP) + PAD*2
				listaHolder.Size=UDim2.new(1,0,0,altLista)
				listaHolder.Position=UDim2.new(0,0,0, FH + 1 + SEARCH_H)
				listaHolder.CanvasSize=UDim2.new(0,0,0,lyL.AbsoluteContentSize.Y+8)
				return visiveis
			end

			ConstruirItens("")

			if searchBox then
				searchBox:GetPropertyChangedSignal("Text"):Connect(function()
					local vis = ConstruirItens(searchBox.Text)
					if aberto then
						Tw(fr, 0.12, {Size=UDim2.new(1,-6,0,CalcAlturaTotal(vis))}):Play()
					end
				end)
			end

			FecharDropdown = function()
				aberto=false
				Tw(fr,0.2,{Size=UDim2.new(1,-6,0,FH)},Enum.EasingStyle.Quart,Enum.EasingDirection.In):Play()
				Tw(seta,0.2,{Rotation=90}):Play()
				task.delay(0.2, function()
					if searchBox and searchBox.Parent then
						searchBox.Text = ""
					end
				end)
			end

			local function AbrirDropdown()
				aberto=true
				local vis = ConstruirItens(searchBox and searchBox.Text or "")
				Tw(fr,0.25,{Size=UDim2.new(1,-6,0,CalcAlturaTotal(vis))},Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
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

			local obj = {}
			obj.valor = multiSelect and {} or selSimples

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
