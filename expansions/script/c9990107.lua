--真面の熾天使（シンメンノセラフィム）
function c9990107.initial_effect(c)
	--Spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	--Tribute Limit
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_SINGLE)
	ex1:SetCode(EFFECT_TRIBUTE_LIMIT)
	ex1:SetValue(function(e,c)
		return not c9990107.rsfilter(c)
	end)
	c:RegisterEffect(ex1)
	--Special Summon Limit
	local ex2=Effect.CreateEffect(c)
	ex2:SetType(EFFECT_TYPE_SINGLE)
	ex2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex2:SetCode(EFFECT_SPSUMMON_CONDITION)
	ex2:SetValue(function(e,se,sp,st)
		return se:IsHasType(EFFECT_TYPE_ACTIONS) and se:IsActiveType(TYPE_MONSTER)
			and c9990107.rsfilter(se:GetHandler())
	end)
	c:RegisterEffect(ex2)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c9990107.target)
	e1:SetOperation(c9990107.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c9990107.rsfilter(c)
	return c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9990107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c9990107.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
		return e:GetLabel()~=c:GetFieldID()
	end)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end