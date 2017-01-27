--3L·mono
local m=37564839
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.leff(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,m)
	e6:SetCost(senya.setgcost)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.activate)
	c:RegisterEffect(e6)
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
function cm.effect_operation_3L(c,chk,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ctlm)
	e1:SetCost(senya.desccost())
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	e1:SetReset(senya.lres(chk))
	c:RegisterEffect(e1,true)
	return e1
end
function cm.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(m-4000)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and cm.filter(tc) then
		senya.lgeff(tc,m)
	end
end
function cm.cfilter(c,e)
	return c:GetOriginalCode()~=m and senya.lefffilter(c,e:GetHandler()) and c:IsHasEffect(37564800)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.cfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		senya.lgeff(c,tc,true)
		if c:GetFlagEffect(m)==0 then
			local tcode=senya.order_table_new({tc:GetOriginalCode()})
			c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2,tcode)
		else
			local copyt=senya.order_table[c:GetFlagEffectLabel(m)]
			table.insert(copyt,tc:GetOriginalCode())
		end
	end
end