--Ａ・審判者イスペリア（アゾリウス・ジャージ）
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992104.initial_effect(c)
	c:EnableReviveLimit()
	--Summon Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--Negate Effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9992104.discon)
	e2:SetTarget(c9992104.distg)
	e2:SetOperation(c9992104.disop)
	c:RegisterEffect(e2)
	--Negate Attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c9992104.atktg)
	e3:SetOperation(c9992104.atkop)
	c:RegisterEffect(e3)
	--Activation Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not eg then return end
		local tg=eg:Filter(function(c,e,tp)
			return not c:IsImmuneToEffect(e) and c:GetFlagEffect(9992104)==0 and c:IsControler(1-tp)
		end,nil,e,tp)
		if tg:GetCount()==0 then return end
		local c,tc=e:GetHandler(),tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(9992104,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9992104,0))
			tc=tg:GetNext()
		end
	end)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c9992104.Dazz_name_Azorius=true
c9992104.mat_filter=Dazz.IsAzorius
function c9992104.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c9992104.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992104.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.NegateActivation(ev)
end
function c9992104.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return tp~=Duel.GetTurnPlayer() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992104.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.NegateAttack()
end