--腐化飞球·异变
function c13254086.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c13254086.ffilter1),aux.FilterBoolFunction(c13254086.ffilter2),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254086.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254086.sprcon)
	e2:SetOperation(c13254086.sprop)
	c:RegisterEffect(e2)
	--release or damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254086,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13254086)
	e3:SetCondition(c13254086.phcon)
	e3:SetTarget(c13254086.phtg)
	e3:SetOperation(c13254086.phop)
	c:RegisterEffect(e3)
	--warp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_ADD_SETCODE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e12:SetValue(0x356)
	c:RegisterEffect(e12)
	
end
function c13254086.ffilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsType(TYPE_FUSION)
end
function c13254086.ffilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254086.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254086.spfilter1(c,tp)
	if c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsType(TYPE_FUSION) and c:IsReleasable() and c:IsCanBeFusionMaterial(nil,true) then
		return Duel.IsExistingMatchingCard(c13254086.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
	else return false end
end
function c13254086.spfilter2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsReleasable() and c:IsCanBeFusionMaterial()
end
function c13254086.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13254086.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c13254086.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254086,0))
	local g1=Duel.SelectMatchingCard(tp,c13254086.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c13254086.spfilter2,tp,LOCATION_MZONE,0,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254086,1))
	g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c13254086.phcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c13254086.filter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c13254086.phtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254086.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c13254086.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c13254086.phop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13254086.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
