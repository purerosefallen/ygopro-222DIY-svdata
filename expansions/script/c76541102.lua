--)uaio(LCR
function c76541102.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541102.condition)
	e1:SetOperation(c76541102.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c76541102.settg)
	e2:SetOperation(c76541102.setop)
	c:RegisterEffect(e2)
end
c76541102.mikagami_kobato=true
c76541102.desfilter_set={
	function(c) return c:IsFacedown() end,
	function(c) return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,
	function(c) return c:IsFaceup() and c:IsType(TYPE_MONSTER) and math.max(c:GetLevel(),c:GetRank())<=4 end,
	function(c) return c:IsFaceup() and c:IsType(TYPE_MONSTER) and math.max(c:GetLevel(),c:GetRank())>=5 end,
}
function c76541102.check_choice(c)
	local rt=0
	for i,filter in pairs(c76541102.desfilter_set) do
		if filter(c) then
			if rt~=0 then return 0 end
			rt=i
		end
	end
	return rt
end
function c76541102.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=g:Select(tp,1,1,nil)
	local v=c76541102.check_choice(g1:GetFirst())
	if v~=0 then
		g:Remove(c76541102.desfilter_set[v],nil)
	else
		g:Sub(g1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end
function c76541102.setfilter(c)
	return c:IsCode(76541101) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c76541102.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c76541102.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c76541102.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76541102.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_GRAVE) and tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.HintSelection(g)
			return
		end
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,g)
	end
end