--アゾリウス・タクティクス
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992201.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9992201+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9992201.target)
	e1:SetOperation(c9992201.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	--Immunity
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(1)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c9992201.cost)
	e3:SetTarget(c9992201.target)
	e3:SetOperation(c9992201.operation)
	c:RegisterEffect(e3)
end
c9992201.Dazz_name_Azorius=true
function c9992201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9992201.filter1(c)
	return Dazz.IsAzorius(c) and c:IsFaceup()
end
function c9992201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE
	if e:GetLabel()==1 then loc=loc+LOCATION_SZONE end
	if chkc then return chkc:IsLocation(loc) and c9992201.filter1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c9992201.filter1,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9992201.filter1,tp,loc,0,1,1,nil)
end
function c9992201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9992201,0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetOperation(c9992201.backtohand)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c9992201.backtohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not tc then return end
	if not c:IsRelateToBattle() or not tc:IsRelateToBattle() then return end
	local g=Group.FromCards(c,tc)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c9992201.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9992201,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(function(e,te)
			return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
		end)
		tc:RegisterEffect(e1)
	end
end