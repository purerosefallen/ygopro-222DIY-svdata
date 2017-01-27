--アゾリウス・ギルド・ゲート
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992200.initial_effect(c)
	Dazz.AddTurnCheckBox(9992200)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9992200.activate)
	c:RegisterEffect(e1)
	--Attack & Defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c9992200.condition)
	e4:SetTarget(c9992200.target)
	e4:SetOperation(c9992200.operation)
	c:RegisterEffect(e4)
end
c9992200.Dazz_name_Azorius=true
function c9992200.searchfilter(c)
	return Dazz.IsAzorius(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9992200.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if c9992200.check_box[tp][1] then return end
	local g=Duel.GetMatchingGroup(c9992200.searchfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9992200,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		c9992200.check_box[tp][1]=true
	end
end
function c9992200.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c9992200.conditionfilter,1,nil)
end
function c9992200.conditionfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function c9992200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9992200.check_box[tp][2]
		and Duel.IsPlayerCanDraw(tp,1) end
	c9992200.check_box[tp][2]=true
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992200.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end