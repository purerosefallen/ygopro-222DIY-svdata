--ストライクフリーダムガンダム
function c9990323.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Koroshitakunai
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE_CALCULATING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(c9990323.killop)
	c:RegisterEffect(e1)
	--Attack All
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--No Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
end
function c9990323.killop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9990323.rplctg)
	e1:SetOperation(c9990323.rplcop)
	bc:RegisterEffect(e1)
end
function c9990323.rplctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and c:IsReason(REASON_BATTLE) end
	return true
end
function c9990323.rplcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--effect disabled
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e2)
	--atk def 0
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	Duel.AdjustInstantly(c)
	--destroyed when BP end
	if c:GetFlagEffect(9990323)~=0 then e:Reset() return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(9990323,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9990323,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCountLimit(1)
	e5:SetLabel(fid)
	e5:SetLabelObject(c)
	e5:SetCondition(c9990323.boomcon)
	e5:SetOperation(c9990323.boomop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	e:Reset()
end
function c9990323.boomcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(9990323)==e:GetLabel()
end
function c9990323.boomop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.SendtoGrave(c,REASON_RULE+REASON_DESTROY)
end