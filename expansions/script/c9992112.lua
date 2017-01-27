--アゾリウス・ウィンド・ブレイカー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992112.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,function(c) return Dazz.IsAzorius(c,Card.GetFusionCode) end,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9992112.splimit)
	c:RegisterEffect(e1)
	--Defense Battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		if not d or not e:GetHandler():IsRelateToBattle() then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(a:GetDefense())
		a:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetValue(d:GetDefense())
		d:RegisterEffect(e2,true)
	end)
	c:RegisterEffect(e2)
	--Boundaries
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c9992112.aclimit)
	e3:SetCondition(c9992112.actcon)
	c:RegisterEffect(e3)
	--Leave Field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c9992112.thcon)
	e4:SetTarget(c9992112.thtg)
	e4:SetOperation(c9992112.thop)
	c:RegisterEffect(e4)
end
c9992112.Dazz_name_Azorius=true
function c9992112.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then 
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c9992112.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c9992112.actcon(e)
	local p=e:GetHandler():GetControler()
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return a and d and (Dazz.IsAzorius(a) and a:IsControler(p) or Dazz.IsAzorius(d) and d:IsControler(p))
end
function c9992112.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c9992112.filter(c,tp,fus)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x40008)~=0x40008 or c:GetReasonCard()~=fus
		or not c:IsAbleToHand() or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9992112.thfilter(c,tp)
	local mg=c:GetMaterial()
	local sumtype=c:GetSummonType()
	if bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and mg:GetCount()~=0 and not mg:IsExists(c9992112.filter,1,nil,tp,c) then
		return mg
	end
end
function c9992112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local mg=c9992112.thfilter(e:GetHandler(),tp)
	if mg then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,mg,mg:GetCount(),0,0)
	end
end
function c9992112.thop(e,tp,eg,ep,ev,re,r,rp)
	local mg=c9992112.thfilter(e:GetHandler(),tp)
	if mg then
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end
