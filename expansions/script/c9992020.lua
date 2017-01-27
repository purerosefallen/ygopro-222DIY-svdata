--アゾリウス・ジュリー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992020.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	Dazz.AddTurnCheckBox(9992020)
	--Ignition
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(HINTMSG_TODECK)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetLabel(1)
	e1:SetCost(c9992020.cost)
	e1:SetTarget(c9992020.target)
	e1:SetOperation(c9992020.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(HINTMSG_RTOHAND)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
c9992020.Dazz_name_Azorius=true
function c9992020.filter(c,lab)
	if c:IsFacedown() then return false end
	if lab==1 then
		if not c:IsAbleToDeck() then return false end
	else
		if not c:IsAbleToHand() then return false end
	end
	return Dazz.IsAzorius(c)
end
function c9992020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c9992020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lab=e:GetLabel()
	if chk==0 then return not c9992020.check_box[tp][lab]
		and Duel.IsExistingMatchingCard(c9992020.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),lab) end
	c9992020.check_box[tp][lab]=true
	Duel.SetOperationInfo(0,e:GetCategory(),nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9992020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,e:GetDescription())
	local g=Duel.SelectMatchingCard(tp,c9992020.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,lab)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if lab==1 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end