--彼方の驍騎
function c9990301.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Guard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(function(e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	--目标敌阵，全军突击！
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c9990301.disablecondition)
	e3:SetOperation(c9990301.disableoperation)
	c:RegisterEffect(e3)
end
function c9990301.disablecondition(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return Duel.IsPlayerCanDiscardDeck(tp,1) and bc
		and bc:GetControler()~=e:GetHandler():GetControler()
end
function c9990301.disableoperation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9990301,0)) then return end
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	if Duel.GetOperatedGroup():FilterCount(function(c)
		return c:IsLocation(LOCATION_GRAVE) and not c:IsType(TYPE_TRAP)
	end,nil)<=0 then return end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.HintSelection(Group.FromCards(bc))
	local ex=Effect.CreateEffect(bc)
	ex:SetDescription(aux.Stringid(9990301,1))
	ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_BATTLED)
	ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end)
	ex:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	bc:RegisterEffect(ex,true)
end