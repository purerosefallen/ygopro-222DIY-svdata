--冰灵世界
function c80001014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c80001014.adtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c80001014.adtg1)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(-300)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)  
	--replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c80001014.indtg)
	e6:SetValue(c80001014.indval)
	c:RegisterEffect(e6)  
	--lv
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80001014,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c80001014.lvcost)
	e7:SetTarget(c80001014.lvtg)
	e7:SetOperation(c80001014.lvop)
	c:RegisterEffect(e7)
	--inactivatable
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_INACTIVATE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetValue(c80001014.efilter)
	c:RegisterEffect(e8)
	--Pos Change
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SET_POSITION)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e10)
end
function c80001014.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return ((te:IsActiveType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_WATER)) or tc:IsSetCard(0x2dc))
end
function c80001014.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT)
		and (c:IsSetCard(0x2dc) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c80001014.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80001014.indfilter,1,nil,tp) end
	return true
end
function c80001014.indval(e,c)
	return c80001014.indfilter(c,e:GetHandlerPlayer())
end
function c80001014.adtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001014.adtg1(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001014.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80001014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80001014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80001014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetAttribute()~=ATTRIBUTE_WATER 
end
function c80001014.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsType(TYPE_XYZ)
end
function c80001014.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c80001014.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80001014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end