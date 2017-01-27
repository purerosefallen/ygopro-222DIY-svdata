--飞球之仁慈
function c13254072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254072,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c13254072.condition)
	e1:SetTarget(c13254072.target)
	e1:SetOperation(c13254072.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254072,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c13254072.condition1)
	e2:SetTarget(c13254072.target1)
	e2:SetOperation(c13254072.activate1)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c13254072.handcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c13254072.drcon)
	e4:SetTarget(c13254072.drtg)
	e4:SetOperation(c13254072.drop)
	c:RegisterEffect(e4)
	
end
function c13254072.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_COUNTER) and Duel.IsChainNegatable(ev)
end
function c13254072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsCanTurnSet() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	end
end
function c13254072.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsCanTurnSet() and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		rc:SetStatus(STATUS_SET_TURN,false)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.BreakEffect()
		Duel.Recover(tp,2000,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e1:SetValue(1)
		rc:RegisterEffect(e1)
	end
end
function c13254072.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_QUICKPLAY) and Duel.IsChainNegatable(ev)
end
function c13254072.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	end
end
function c13254072.activate1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
end
function c13254072.handcon(e)
	return Duel.IsExistingMatchingCard(c13254072.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c13254072.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x356)
end
function c13254072.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c13254072.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13254072.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
