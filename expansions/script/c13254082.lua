--腐化飞球·扩散
function c13254082.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c13254082.ffilter1),aux.FilterBoolFunction(c13254082.ffilter2),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254082.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254082.sprcon)
	e2:SetOperation(c13254082.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c13254082.reptg)
	e3:SetValue(c13254082.repval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,13254082)
	e4:SetTarget(c13254082.tgtg)
	e4:SetOperation(c13254082.tgop)
	c:RegisterEffect(e4)
	--warp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_ADD_SETCODE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e12:SetValue(0x356)
	c:RegisterEffect(e12)
	
end
function c13254082.ffilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsType(TYPE_FUSION)
end
function c13254082.ffilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254082.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254082.spfilter1(c,tp)
	if c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsType(TYPE_FUSION) and c:IsReleasable() and c:IsCanBeFusionMaterial(nil,true) then
		return Duel.IsExistingMatchingCard(c13254082.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
	else return false end
end
function c13254082.spfilter2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsReleasable() and c:IsCanBeFusionMaterial()
end
function c13254082.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13254082.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c13254082.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254082,0))
	local g1=Duel.SelectMatchingCard(tp,c13254082.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c13254082.spfilter2,tp,LOCATION_MZONE,0,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254082,1))
	g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c13254082.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function c13254082.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x356) and eg:IsExists(c13254082.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(13254082,2)) then
		local g=eg:Filter(c13254082.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_DECK_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(13254082,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c13254082.thcon)
		e1:SetOperation(c13254082.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function c13254082.repval(e,c)
	return false
end
function c13254082.thfilter(c)
	return c:GetFlagEffect(13254082)~=0
end
function c13254082.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254082.thfilter,1,nil)
end
function c13254082.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13254082.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c13254082.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c13254082.spfilter(c,e,tp)
	return c:IsSetCard(0x356) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254082.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,1-tp,LOCATION_DECK)
end
function c13254082.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13254082.tgfilter,tp,0,LOCATION_DECK,nil)
	if g:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=g:Select(1-tp,3,3,nil)
	local sg=Duel.GetMatchingGroup(c13254082.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if Duel.SendtoGrave(g1,REASON_EFFECT)==3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(13254082,3)) then
			local tc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
