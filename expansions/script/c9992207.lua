--イスペリアの啟示
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992207.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,9992207+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9992207.target)
	e1:SetOperation(c9992207.activate)
	c:RegisterEffect(e1)
	--Ignition
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c9992207.cost)
	e2:SetTarget(c9992207.target2)
	e2:SetOperation(c9992207.operation2)
	c:RegisterEffect(e2)
end
function c9992207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9992207.filter(c)
	return Dazz.IsAzorius(c) and c:IsDiscardable()
end
function c9992207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992207.filter,tp,LOCATION_HAND,0,2,nil) and Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c9992207.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:FilterCount(Card.IsDiscardable,nil)==0 then return end
	if Duel.IsExistingMatchingCard(c9992207.filter,tp,LOCATION_HAND,0,2,nil) then
		Duel.DiscardHand(tp,c9992207.filter,2,2,REASON_EFFECT+REASON_DISCARD)
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	else
		Duel.ConfirmCards(1-tp,hg)
		Duel.ShuffleHand(tp)
	end
end
function c9992207.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992207.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9992207.operation2(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:FilterCount(Card.IsDiscardable,nil)==0 then return end
	if Duel.IsExistingMatchingCard(c9992207.filter,tp,LOCATION_HAND,0,1,nil) then
		Duel.DiscardHand(tp,c9992207.filter,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	else
		Duel.ConfirmCards(1-tp,hg)
		Duel.ShuffleHand(tp)
	end
end