--犯罪中止
function c9990801.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9990801.target)
	e1:SetOperation(c9990801.activate)
	c:RegisterEffect(e1)
end
function c9990801.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9990801.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local sg=Duel.GetMatchingGroup(c9990801.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return sg:GetCount()~=0 and eg:GetCount()==1 and tc:IsLevelAbove(7) and tc:IsAttribute(ATTRIBUTE_DARK)
		and tc:IsPreviousLocation(LOCATION_HAND) and tc:GetPreviousControler()==tp end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c9990801.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9990801.filter,tp,0,LOCATION_MZONE,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end