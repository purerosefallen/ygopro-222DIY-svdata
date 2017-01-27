--亡灵飞球
function c13254084.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254037,aux.FilterBoolFunction(c13254084.ffilter),1,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254084.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254084.sprcon)
	e2:SetOperation(c13254084.sprop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254084,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCountLimit(1)
	e3:SetOperation(c13254084.atkop)
	c:RegisterEffect(e3)
	
end
function c13254084.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and not c:IsCode(13254037)
end
function c13254084.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254084.spfilter1(c,tp)
	if c:IsFusionCode(13254037) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true) then
		return Duel.IsExistingMatchingCard(c13254084.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
	else return false end
end
function c13254084.spfilter2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and not c:IsCode(13254037) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c13254084.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13254084.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c13254084.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254084,0))
	local g1=Duel.SelectMatchingCard(tp,c13254084.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c13254084.spfilter2,tp,LOCATION_MZONE,0,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254084,1))
	g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c13254084.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
	end
end
