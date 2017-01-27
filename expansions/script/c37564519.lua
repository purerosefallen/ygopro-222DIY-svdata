--Nanahira & 3L
local m=37564519
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.leff(c,m)
	senya.nnhrset(c,37564800)
	senya.neg(c,1,m,senya.sermcost,senya.nncon(true),nil,LOCATION_GRAVE,false)
	senya.neg(c,1,m,senya.serlcost,cm.discon,nil,LOCATION_HAND,false)
end
function cm.effect_operation_3L(c,chk,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ctlm)
	e1:SetCost(senya.desccost())
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	e1:SetReset(senya.lres(chk))
	c:RegisterEffect(e1,true)
	return e1
end
cm.reset_operation_3L={
function(e,c)
	local copym=c:GetFlagEffectLabel(m)
	if not copym then return end
	local copyt=senya.order_table[copym]
	for i,rcode in pairs(copyt) do
		Duel.Hint(HINT_OPSELECTED,c:GetControler(),m*16+2)
		senya.lreseff(c,rcode)
	end
	c:ResetFlagEffect(m)
end,
}
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg then return false end
	return Duel.IsChainNegatable(ev) and tg:IsExists(cm.f,1,nil,tp)
end
function cm.f(c,tp)
	if c:IsControler(1-tp) or c:IsFacedown() then return false end
	if c:IsCode(37564765) and c:IsLocation(LOCATION_ONFIELD) then return true end
	if c:IsHasEffect(37564800) and c:IsLocation(LOCATION_MZONE) then return true end
	return false
end
function cm.cfilter(c,e)
	return not c:IsPublic() and cd~=m and senya.lefffilter(c,e:GetHandler()) and c:IsHasEffect(37564800)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetParam(g:GetFirst():GetOriginalCode())
	Duel.ShuffleHand(tp)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local cd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	senya.lgeff(c,cd,true)
	if c:GetFlagEffect(m)==0 then
		local tcode=senya.order_table_new({cd})
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2,tcode)
	else
		local copyt=senya.order_table[c:GetFlagEffectLabel(m)]
		table.insert(copyt,cd)
	end
end