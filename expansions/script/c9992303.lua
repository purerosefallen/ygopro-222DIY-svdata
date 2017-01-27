--アゾリウス・ディテンション
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992303.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992303+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9992303.condition)
	e1:SetTarget(c9992303.target)
	e1:SetOperation(c9992303.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
c9992303.Dazz_name_Azorius=true
function c9992303.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9992303.conditionfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9992303.conditionfilter(c)
	return Dazz.IsAzorius(c) and c:IsFaceup()
end
function c9992303.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9992303.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e3)
		local t={
			EFFECT_CANNOT_BE_FUSION_MATERIAL,
			EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,
			EFFECT_CANNOT_BE_XYZ_MATERIAL
		}
		for i,code in pairs(t) do
			local te=e2:Clone()
			te:SetCode(code)
			te:SetValue(1)
			tc:RegisterEffect(te)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(9992303,0))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetOperation(c9992303.backtohand)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
	end
end
function c9992303.backtohand(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end