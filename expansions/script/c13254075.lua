--红草飞球
function c13254075.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254075,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,13254075)
	e1:SetCost(c13254075.cost)
	e1:SetTarget(c13254075.target)
	e1:SetOperation(c13254075.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,23254075)
	e2:SetTarget(c13254075.target2)
	e2:SetOperation(c13254075.operation2)
	c:RegisterEffect(e2)
	
end
function c13254075.costfilter(c)
	return c:IsFaceup() and ((c:IsRace(RACE_PLANT) and c:IsLevelBelow(1)) or c:IsSetCard(0x356))
end
function c13254075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c13254075.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c13254075.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c13254075.spfilter(c,e,tp)
	return ((c:IsRace(RACE_PLANT) and c:IsLevelBelow(1)) or c:IsSetCard(0x356)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13254075.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c13254075.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254075.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		--cannot release
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e12)
		local e13=Effect.CreateEffect(e:GetHandler())
		e13:SetType(EFFECT_TYPE_SINGLE)
		e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e13:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e13:SetValue(1)
		tc:RegisterEffect(e13)
		local e14=e13:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e14)
		local e15=e13:Clone()
		e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e15)
		local e16=Effect.CreateEffect(e:GetHandler())
		e16:SetDescription(aux.Stringid(13254037,2))
		e16:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e16:SetType(EFFECT_TYPE_SINGLE)
		e16:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e16)
	end
end
function c13254075.filter(c)
	return ((c:IsRace(RACE_PLANT) and c:IsLevelBelow(1)) or c:IsSetCard(0x356))
end
function c13254075.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254075.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c13254075.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254075,1))
	local g=Duel.SelectMatchingCard(tp,c13254075.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
