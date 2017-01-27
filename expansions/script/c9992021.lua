--アゾリウス・セレステー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992021.initial_effect(c)
	Dazz.AddTurnCheckBox(9992021)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9992021.spcon)
	e1:SetOperation(c9992021.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9992021,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c9992021.schtg)
	e2:SetOperation(c9992021.schop)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9992021,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9992021.condition)
	e3:SetTarget(c9992021.target)
	e3:SetOperation(c9992021.operation)
	c:RegisterEffect(e3)
end
c9992021.Dazz_name_Azorius=true
function c9992021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c9992021.check_box[tp][1]
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9992021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	c9992021.check_box[tp][1]=true
end
function c9992021.schtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9992021.check_box[tp][2]
		and Duel.IsExistingMatchingCard(c9992021.schfilter,tp,LOCATION_DECK,0,1,nil) end
	c9992021.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9992021.schop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9992021.schfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9992021.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil):FilterCount(Dazz.IsAzorius,nil)>=3
end
function c9992021.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp and c:IsAbleToHand()
end
function c9992021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsExists(c9992021.filter,1,nil,tp) and e:GetHandler():IsAbleToHand() end
	local g=eg:Filter(c9992021.filter,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9992021.filter2(c,e,tp)
	return c9992021.filter(c,tp) and c:IsRelateToEffect(e)
end
function c9992021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c9992021.filter2,nil,e,tp)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c9992021.schfilter(c)
	return c:IsCode(9992001,9992002) and c:IsAbleToHand()
end