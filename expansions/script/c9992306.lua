--アゾリウス・サイレンス
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992306.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9992306+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9992306.condition)
	e1:SetTarget(c9992306.target)
	e1:SetOperation(c9992306.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
c9992306.Dazz_name_Azorius=true
function c9992306.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9992306.conditionfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c9992306.conditionfilter(c)
	return Dazz.IsAzorius(c) and c:IsFaceup()
end
function c9992306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) and ep~=tp end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9992306.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local typ=bit.band(re:GetHandler():GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(typ)
	e1:SetValue(function(e,re,tp)
		return re:IsActiveType(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
	end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end