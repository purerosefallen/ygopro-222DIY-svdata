--智飞球
function c13254041.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(c13254041.sfilter))
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254041,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,13254041)
	e2:SetTarget(c13254041.tktg)
	e2:SetOperation(c13254041.tkop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c13254041.reptg)
	e3:SetValue(c13254041.repval)
	e3:SetOperation(c13254041.repop)
	c:RegisterEffect(e3)
end
function c13254041.sfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254041.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,13254083,0x356,0x4011,300,200,1,RACE_FAIRY,ATTRIBUTE_EARTH) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c13254041.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,13254083,0x356,0x4011,300,200,1,RACE_FAIRY,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,13254083)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		--cannot release
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e11,true)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e12,true)
		token:RegisterFlagEffect(13254041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1,fid)
		local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e13:SetCode(EVENT_PHASE+PHASE_END)
		e13:SetCountLimit(1)
		e13:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e13:SetLabel(fid)
		e13:SetLabelObject(token)
		e13:SetCondition(c13254041.descon)
		e13:SetOperation(c13254041.desop)
		Duel.RegisterEffect(e13,tp)
	end
end
function c13254041.descon(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetLabelObject()
	if Duel.GetTurnPlayer()==tp then return false end
	if token:GetFlagEffectLabel(13254041)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c13254041.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c13254041.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsLevelBelow(1)
end
function c13254041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c13254041.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(13254041,1))
end
function c13254041.repval(e,c)
	return c13254041.repfilter(c,e:GetHandlerPlayer())
end
function c13254041.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
