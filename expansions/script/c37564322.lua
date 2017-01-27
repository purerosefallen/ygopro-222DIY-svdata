--Pluto
function c37564322.initial_effect(c)	
	--Activate
	--[[local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37564322+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c37564322.cost)
	e1:SetTarget(c37564322.target)
	e1:SetOperation(c37564322.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(37564322,ACTIVITY_SPSUMMON,c37564322.counterfilter)]]
end
function c37564322.counterfilter(c)
	return c:IsSetCard(0x776)
end
function c37564322.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(37564015,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c37564322.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37564322.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x776)
end
function c37564322.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x776) and c:IsAbleToHand()
end
function c37564322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37564322.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37564322.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c37564322.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
