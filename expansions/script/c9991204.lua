--神天竜－サンダー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991204.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991204)
	--Special Summon From Removed
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c9991204.spcost)
	e1:SetTarget(c9991204.sptg)
	e1:SetOperation(c9991204.spop)
	c:RegisterEffect(e1)
	--Destroy Monster
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(0xfe)
	e2:SetCondition(Dazz.GodraMainFuseEffectCondition)
	e2:SetTarget(c9991204.destg)
	e2:SetOperation(c9991204.desop)
	c:RegisterEffect(e2)
end
c9991204.Dazz_name_Godra=true
function c9991204.spfilter(c,e,tp)
	return c:IsFaceup() and Dazz.IsGodra(c) and not c:IsCode(9991204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9991204.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9991204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991204.check_box[tp][1] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991204.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	c9991204.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c9991204.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991204.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_DEFENSE)
		g:GetFirst():CompleteProcedure()
	end
end
function c9991204.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c9991204.check_box[tp][2]
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)~=0 end
	c9991204.check_box[tp][2]=true
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c9991204.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Destroy(rg,REASON_EFFECT)
	end
end