--钢牙暴扣
function c10125008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10125005+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10125008.condition)
	e1:SetCost(c10125008.cost)
	e1:SetTarget(c10125008.target)
	e1:SetOperation(c10125008.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c10125008.condition1)
	e2:SetCost(c10125008.cost)
	e2:SetTarget(c10125008.target1)
	e2:SetOperation(c10125008.activate1)
	c:RegisterEffect(e2)	
end
function c10125008.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp~=tp
end
function c10125008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c10125008.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c10125008.condition(e,tp,eg,ep,ev,re,r,rp)
	return ((re:IsActiveType(TYPE_MONSTER)and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c10125008.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9334)
end
function c10125008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10125008.costfilter,1,nil) and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local g=Duel.SelectReleaseGroup(tp,c10125008.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c10125008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c10125008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
	   Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end