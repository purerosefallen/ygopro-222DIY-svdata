--神天竜－イルトーノ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991220.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c,9991220)
	--Synchro
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Dazz.IsGodra))
	c:EnableReviveLimit()
	--Fuck Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991220,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9991220.cost1)
	e1:SetTarget(c9991220.tg1)
	e1:SetOperation(c9991220.op1)
	c:RegisterEffect(e1)
end
c9991220.Dazz_name_Godra=true
function c9991220.filter(c)
	return c:IsAbleToDeckAsCost() and c:IsRace(RACE_WYRM)
end
function c9991220.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991220.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9991220.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,g) else Duel.HintSelection(g) end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9991220.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991220.check_box[tp][1]
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	c9991220.check_box[tp][1]=true
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c9991220.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Destroy(rg,REASON_EFFECT)
	end
end