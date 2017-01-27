--アゾリウス・スピリット
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992011.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	Dazz.AddTurnCheckBox(9992011)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9992011.spcon)
	e1:SetOperation(c9992011.spop)
	c:RegisterEffect(e1)
	--Send to Grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c9992011.target)
	e2:SetOperation(c9992011.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c9992011.Dazz_name_Azorius=true
function c9992011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c9992011.check_box[tp][1]
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9992011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	c9992011.check_box[tp][1]=true
end
function c9992011.tgfilter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c9992011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9992011.check_box[tp][2]
		and Duel.IsExistingMatchingCard(c9992011.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	c9992011.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9992011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9992011.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end