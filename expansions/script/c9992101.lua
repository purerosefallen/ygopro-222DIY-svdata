--アゾリウス・モビル・アーカイヴ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992101.initial_effect(c)
	c:EnableReviveLimit()
	--Return to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c9992101.condition)
	e1:SetTarget(c9992101.target)
	e1:SetOperation(c9992101.operation)
	c:RegisterEffect(e1)
	--Recycling
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetLabel(LOCATION_GRAVE)
	e2:SetCondition(c9992101.condition2)
	e2:SetTarget(c9992101.target2)
	e2:SetOperation(c9992101.operation2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetLabel(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
c9992101.Dazz_name_Azorius=true
function c9992101.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c9992101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9992101.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9992101.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_RETURN) then return false end
	if e:GetLabel()==LOCATION_GRAVE then
		return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
	else
		return not c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousPosition(POS_FACEUP)
	end
end
function c9992101.filter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToDeck()
end
function c9992101.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=e:GetLabel()
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(loc) and chkc:IsControler(tp) and c9992101.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c9992101.filter,tp,loc,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9992101.filter,tp,loc,0,1,99,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,loc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992101.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	tg:AddCard(c)
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)==0 then return end
	if Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
		Duel.ShuffleDeck(tp)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end