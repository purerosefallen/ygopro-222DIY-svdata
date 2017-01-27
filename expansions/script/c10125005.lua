--钢牙啮咬
function c10125005.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10125005+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10125005.cost)
	e1:SetTarget(c10125005.target)
	e1:SetOperation(c10125005.operation)
	c:RegisterEffect(e1)   
	--summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10125005,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c10125005.smcost)
	e2:SetTarget(c10125005.smtg)
	e2:SetOperation(c10125005.smop)
	c:RegisterEffect(e2)  
end
function c10125005.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10125005.filter,tp,LOCATION_HAND,0,1,nil,e,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10125005.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10125005.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c10125005.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10125005.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9334) and Duel.IsExistingMatchingCard(c10125005.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,c) 
end
function c10125005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10125005.filter(c,e,tp,tc)
	local rg=Duel.GetTributeGroup(c)
	if rg:GetCount()>0 and tc then rg:RemoveCard(tc) end
	local n1,n2=c:GetTributeRequirement()
	return c:IsSetCard(0x9334) and c:IsSummonable(true,nil) and Duel.GetTributeCount(c,rg,false)>=n1
end
function c10125005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 or Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)~=0 then return false end
		   e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c10125005.costfilter,1,nil,e,tp) 
	end
	local g=Duel.SelectReleaseGroup(tp,c10125005.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10125005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10125005.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end