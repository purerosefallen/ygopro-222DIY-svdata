--アゾリウス・デクラレーション
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992305.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,9992305+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0
	end)
	e1:SetCost(c9992305.cost)
	e1:SetTarget(c9992305.target1)
	e1:SetOperation(c9992305.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,9992305+EFFECT_COUNT_CODE_OATH)
	e3:SetCost(c9992305.cost)
	e3:SetTarget(c9992305.target2)
	e3:SetOperation(c9992305.activate2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
c9992305.Dazz_name_Azorius=true
function c9992305.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992305.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9992305.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c9992305.cfilter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToRemoveAsCost()
end
function c9992305.filter1(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c9992305.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=eg:Filter(c9992305.filter1,nil,tp)
	if chk==0 then return rg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,rg,rg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,rg,rg:GetCount(),0,0)
end
function c9992305.activate1(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(c9992305.filter1,nil,tp)
	Duel.NegateSummon(rg)
	rg:ForEach(Card.CancelToGrave)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
end
function c9992305.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) and ep~=tp end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToHand() and re:GetHandler():IsRelateToEffect(re) and re:GetActivateLocation()==LOCATION_MZONE then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function c9992305.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsAbleToHand() and re:GetHandler():IsRelateToEffect(re) and re:GetActivateLocation()==LOCATION_MZONE then
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
	end
end