--νガンダム
function c9990324.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c9990324.SynCondition(nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--Fin Funnel
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0xd1dc)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(6)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCondition(c9990324.ffcon)
	e1:SetTarget(c9990324.fftg)
	e1:SetOperation(c9990324.ffop)
	c:RegisterEffect(e1)
end
function c9990324.SynCondition(f1,f2,minct,maxc)
	return	function(e,c,smat,mg)
				if c==nil then return true end
				if Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)<3 then return false end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				local ct=-ft
				local minc=minct
				if minc<ct then minc=ct end
				if maxc<minc then return false end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function c9990324.ffcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetCurrentPhase(),0x1fc)~=0
end
function c9990324.fftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:GetFlagEffect(1)==0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	c:RegisterFlagEffect(1,RESET_CHAIN,0,1)
	local lab=c:GetFlagEffectLabel(9990324)
	if not lab then lab=0 else c:ResetFlagEffect(9990324) end
	lab=lab+1
	c:RegisterFlagEffect(9990324,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,lab,aux.Stringid(9990324,lab))
end
function c9990324.ffop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9990324,0))
	local sg=sg:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	if tc:IsImmuneToEffect(e) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	if tc:GetDefense()==0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end