--量子网络·征兆之证
function c76541010.initial_effect(c)
	--remove check
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(c76541010.rmcheck)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1,76541010)
	e2:SetTarget(c76541010.target)
	e2:SetOperation(c76541010.activate)
	c:RegisterEffect(e2)
	--use twice
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCost(c76541010.cost2)
	e3:SetTarget(c76541010.target2)
	e3:SetOperation(c76541010.activate2)
	c:RegisterEffect(e3)
end
function c76541010.rmcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetReasonEffect():GetOwner():IsSetCard(0x9d0) then
		c:RegisterFlagEffect(76541000,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c76541010.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(76541000)>0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c76541010.filter(c)
	return c:IsSetCard(0x9d0) and c:IsAbleToRemove() and not c:IsCode(76541010)
end
function c76541010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c76541010.filter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c76541010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c76541010.filter,tp,LOCATION_HAND,0,c)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
	if c:IsAbleToRemove() and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c76541010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c76541010.filter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c76541010.filter,tp,LOCATION_DECK,0,1,c) end
end
function c76541010.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c76541010.filter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(c76541010.filter,tp,LOCATION_DECK,0,c)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end