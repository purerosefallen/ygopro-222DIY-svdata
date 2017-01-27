--元始飞球
function c13254059.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254059.sprcon)
	e2:SetOperation(c13254059.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c13254059.efilter)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--attribute
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_ADD_ATTRIBUTE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(0x2f)
	c:RegisterEffect(e11)
	
end
function c13254059.spfilter(c,code)
	return c:IsCode(code) and c:IsCanBeFusionMaterial() and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c13254059.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local i=13254031
	for i=13254031,13254036 do
		if not Duel.IsExistingMatchingCard(c13254059.spfilter,tp,LOCATION_REMOVED,0,1,nil,i) then return false end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c13254059.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	for i=13254031,13254036 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,c13254059.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,i)
		g:Merge(g1)
	end
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c13254059.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
