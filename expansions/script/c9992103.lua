--Ａ・大判事アウグスティンⅣ（アゾリウス・アービタ）（フォー）
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992103.initial_effect(c)
	c:EnableReviveLimit()
	--Summon Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--Negate Spell
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(TYPE_SPELL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9992103.discon)
	e2:SetTarget(c9992103.distg)
	e2:SetOperation(c9992103.disop)
	c:RegisterEffect(e2)
	--Negate Trap
	local e3=e2:Clone()
	e3:SetLabel(TYPE_TRAP)
	c:RegisterEffect(e3)
	--Activation Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(function(e,re,tp)
		local ec=re:GetHandler()
		return ec:GetControler()~=e:GetHandlerPlayer()
			and ec:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
	end)
	c:RegisterEffect(e4)
end
c9992103.Dazz_name_Azorius=true
c9992103.mat_filter=Dazz.IsAzorius
function c9992103.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(e:GetLabel()) and Duel.IsChainNegatable(ev)
end
function c9992103.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992103.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.NegateActivation(ev)
end