--決戦兵器－Coronata（コロナタ）
function c9990316.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	--ATK & DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c9990316.condition)
	e1:SetValue(c9990316.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c9990316.condition(e)
	return not e:GetHandler():IsHasEffect(EFFECT_FORBIDDEN)
end
function c9990316.val(e,c)
	local i=1
	if c:GetControler()~=e:GetHandler():GetControler() then i=-1 end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)*500*i
end