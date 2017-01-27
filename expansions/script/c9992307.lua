--アゾリウス・キャンセル
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992307.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9992307+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9992307.cost)
	e1:SetTarget(c9992307.target)
	e1:SetOperation(c9992307.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,9992307+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0
	end)
	e2:SetCost(c9992307.cost)
	e2:SetTarget(c9992307.target2)
	e2:SetOperation(c9992307.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
c9992307.Dazz_name_Azorius=true
function c9992307.cfilter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToRemoveAsCost()
end
function c9992307.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992307.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9992307.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c9992307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) and ep~=tp end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9992307.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9992307.filter1(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c9992307.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=eg:Filter(c9992307.filter1,nil,tp)
	if chk==0 then return rg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,rg,rg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rg,rg:GetCount(),0,0)
end
function c9992307.activate2(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(c9992307.filter1,nil,tp)
	Duel.NegateSummon(rg)
	Duel.Destroy(rg,REASON_EFFECT)
end