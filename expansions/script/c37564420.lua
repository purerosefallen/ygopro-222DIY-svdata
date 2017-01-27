--Taqumi
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c37564420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c37564420.condition)
	e1:SetCost(senya.discost(1))
	e1:SetTarget(c37564420.target)
	e1:SetOperation(c37564420.activate)
	c:RegisterEffect(e1)
end
function c37564420.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c37564420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c37564420.filter(c,e,tp)
	return c:IsHasEffect(37564573) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c37564420.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c37564420.filter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c37564420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c37564420.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37564420.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37564420.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c37564420.filter2,tp,LOCATION_DECK,0,1,nil,g:GetFirst():GetCode()) then
			local g1=Duel.SelectMatchingCard(tp,c37564420.filter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
			if g1:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			end
		end
	end
end
