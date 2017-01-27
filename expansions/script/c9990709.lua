--星隠れ
function c9990709.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990709)
	e1:SetCost(c9990709.cost)
	e1:SetTarget(c9990709.target)
	e1:SetOperation(c9990709.activate)
	c:RegisterEffect(e1)
end
function c9990709.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,te,tp)
		return te:IsHasType(EFFECT_TYPE_ACTIVATE)
	end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9990709.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9990709.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	if not tc:IsLocation(LOCATION_REMOVED) then return end
	local ph=Duel.GetCurrentPhase()
	if bit.band(ph,0xf8)~=0 then ph=PHASE_BATTLE end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(9990709,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+ph)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetOperation(function(e,cp)
		if Duel.GetLocationCount(cp,LOCATION_MZONE)==0 or not tc:IsType(TYPE_MONSTER) then
			Duel.SendtoGrave(tc,REASON_RULE)
			return
		end
		Duel.MoveToField(tc,cp,cp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
	end)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
end