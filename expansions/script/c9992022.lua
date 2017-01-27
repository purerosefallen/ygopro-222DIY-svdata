--アゾリウス・ローメイジ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992022.initial_effect(c)
	Dazz.AddTurnCheckBox(9992022)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9992022.spcon)
	e1:SetOperation(c9992022.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c9992022.schtg)
	e2:SetOperation(c9992022.schop)
	c:RegisterEffect(e2)
	--To Deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCondition(c9992022.condition)
	e3:SetTarget(c9992022.target)
	e3:SetOperation(c9992022.operation)
	c:RegisterEffect(e3)
end
c9992022.Dazz_name_Azorius=true
function c9992022.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c9992022.check_box[tp][1]
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9992022.spop(e,tp,eg,ep,ev,re,r,rp,c)
	c9992022.check_box[tp][1]=true
end
function c9992022.schtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9992022.check_box[tp][2]
		and Duel.IsExistingMatchingCard(c9992022.schfilter,tp,LOCATION_DECK,0,1,nil) end
	c9992022.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9992022.schop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9992022.schfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9992022.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and bit.band(r,REASON_EFFECT)~=0 and Dazz.IsAzorius(c:GetReasonEffect():GetHandler())
end
function c9992022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9992022.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c9992022.schfilter(c)
	return c:IsAbleToHand() and (c:IsCode(9992204)
		or (bit.band(c:GetType(),TYPE_MONSTER+TYPE_RITUAL)==TYPE_MONSTER+TYPE_RITUAL and Dazz.IsAzorius(c)))
end