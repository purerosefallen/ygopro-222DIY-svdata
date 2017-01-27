--量子网络·英知之证
function c76541008.initial_effect(c)
	--remove check
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(c76541008.rmcheck)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,76541008)
	e2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e2:SetCost(c76541008.cost1)
	e2:SetTarget(c76541008.target)
	e2:SetOperation(c76541008.activate)
	c:RegisterEffect(e2)
	--use twice
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetLabel(1)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCost(c76541008.cost2)
	e3:SetTarget(c76541008.target2)
	e3:SetOperation(c76541008.activate2)
	c:RegisterEffect(e3)
end
function c76541008.rmcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetReasonEffect():GetOwner():IsSetCard(0x9d0) then
		c:RegisterFlagEffect(76541000,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c76541008.cfilter(c)
	return c:IsSetCard(0x9d0) and not c:IsPublic()
end
function c76541008.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76541008.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c76541008.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c76541008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(76541000)>0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c76541008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c76541008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsAbleToRemove() and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c76541008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c76541008.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end