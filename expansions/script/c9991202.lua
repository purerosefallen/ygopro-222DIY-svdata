--神天竜－トルネード
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991202.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991202)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9991202.spcost)
	e1:SetTarget(c9991202.sptg)
	e1:SetOperation(c9991202.spop)
	c:RegisterEffect(e1)
	--Destroy Spell & Trap
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(0xfe)
	e2:SetCondition(Dazz.GodraMainFuseEffectCondition)
	e2:SetTarget(c9991202.destg)
	e2:SetOperation(c9991202.desop)
	c:RegisterEffect(e2)
end
c9991202.Dazz_name_Godra=true
function c9991202.filter(c,e,tp)
	return Dazz.IsGodra(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9991202.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_WYRM) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WYRM)
	Duel.Release(sg,REASON_COST)
end
function c9991202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991202.check_box[tp][1] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991202.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	c9991202.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9991202.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991202.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_DEFENSE)
		g:GetFirst():CompleteProcedure()
	end
end
function c9991202.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9991202.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c9991202.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return not c9991202.check_box[tp][2] and sg:GetCount()>=1 end
	c9991202.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c9991202.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9991202.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end