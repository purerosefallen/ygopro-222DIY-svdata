--アゾリウス・チャーム
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9992202.eqtg)
	e1:SetOperation(c9992202.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9992202.equiplimit)
	c:RegisterEffect(e2)
	--Lifelink
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9992202)
	e3:SetDescription(aux.Stringid(9992202,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c9992202.target1)
	e3:SetOperation(c9992202.operation1)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9992202)
	e4:SetDescription(aux.Stringid(9992202,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c9992202.condition2)
	e4:SetTarget(c9992202.target2)
	e4:SetOperation(c9992202.operation2)
	c:RegisterEffect(e4)
	--Kick Out
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,9992202)
	e5:SetDescription(aux.Stringid(9992202,2))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetCondition(c9992202.condition3)
	e5:SetTarget(c9992202.target3)
	e5:SetOperation(c9992202.operation3)
	c:RegisterEffect(e5)
end
c9992202.Dazz_name_Azorius=true
function c9992202.equiplimit(e,c)
	return Dazz.IsAzorius(c)
end
function c9992202.eqfilter(c)
	return c:IsFaceup() and Dazz.IsAzorius(c)
end
function c9992202.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9992202.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9992202.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9992202.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9992202.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c9992202.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local amont=e:GetHandler():GetEquipTarget():GetAttack()
	if chk==0 then return amont~=0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,amont)
end
function c9992202.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER),e:GetHandler():GetEquipTarget():GetAttack()
	if d==0 then return end
	Duel.Recover(p,d,REASON_EFFECT)
end
function c9992202.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return bc and e:GetHandler():GetControler()~=bc:GetControler() and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9992202.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992202.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9992202.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return bc and e:GetHandler():GetControler()~=bc:GetControler() and c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9992202.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc:IsAbleToDeck() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function c9992202.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoDeck(bc,nil,0,REASON_EFFECT)
	end
end