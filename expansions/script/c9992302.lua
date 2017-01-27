--アゾリウス・エランド
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992302.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992302+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		return true
	end)
	e1:SetTarget(c9992302.target)
	e1:SetOperation(c9992302.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
c9992302.Dazz_name_Azorius=true
function c9992302.cfilter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToRemoveAsCost()
end
function c9992302.tgfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9992302.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if chkc:IsLocation(LOCATION_MZONE) then
			return chkc:IsAbleToHand()
		else
			return chkc:IsAbleToDeck()
		end
	end
	if chk==0 and e:GetLabel()~=1 then return false else e:SetLabel(0) end
	local cg=Duel.GetMatchingGroup(c9992302.cfilter,tp,LOCATION_GRAVE,0,nil)
	local v1,v2=
		Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()),
		Duel.IsExistingTarget(c9992302.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	if chk==0 then return cg:GetCount()>0 and (v1 or v2) end
	e:SetLabel(0)
	local param=1
	if v1 and v2 and cg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(9992302,3)) then param=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=cg:Select(tp,param,param,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	local category,sel=0,3
	if param==1 then
		if v1 and v2 then
			sel=Duel.SelectOption(tp,aux.Stringid(9992302,0),aux.Stringid(9992302,1))+1
		elseif v1 and not v2 then
			sel=Duel.SelectOption(tp,aux.Stringid(9992302,0))+1
		elseif v2 and not v1 then
			sel=Duel.SelectOption(tp,aux.Stringid(9992302,1))+2
		end
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9992302,2))
	end
	if sel~=2 then
		category=category+CATEGORY_TOHAND
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	if sel~=1 then
		category=category+CATEGORY_TODECK
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c9992302.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
	e:SetCategory(category)
end
function c9992302.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if ex1 and g1:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoHand(g1:GetFirst(),nil,REASON_EFFECT)
	end
	if ex2 and g2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoDeck(g2:GetFirst(),nil,2,REASON_EFFECT)
	end
end