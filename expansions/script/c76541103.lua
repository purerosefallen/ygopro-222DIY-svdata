--NUM!euo>rgn
function c76541103.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541103.condition)
	e1:SetOperation(c76541103.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c76541103.efilter)
	c:RegisterEffect(e2)
end
c76541103.mikagami_kobato=true
c76541103.apply_condition_set={
	function(c,e,tp) return true end,
	function(c,e,tp) return true end,
	function(c,e,tp) return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end,
	function(c,e,tp) return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end,
}
function c76541103.check_choice(c,e,tp)
	local rt={false,false,false,false}
	for i=1,4 do
		if c76541103.apply_condition_set[i](c,e,tp) then
			rt[i]=true
		end
	end
	return rt
end
function c76541103.valid_choice_count(t)
	local v=0
	for i,value in pairs(t) do
		if value then v=v+1 end
	end
	return v
end
function c76541103.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541103.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local valid_choice=c76541103.check_choice(c,e,tp)
	local check_list={false,false,false,false}
	if c76541103.valid_choice_count(valid_choice)<=2 then
		check_list=valid_choice
	else
		for ex=1,2 do
			local tb1={tp}
			local tb2={}
			for i,value in pairs(valid_choice) do
				if value then
					table.insert(tb1,aux.Stringid(76541103,i-1))
					table.insert(tb2,i)
				end
			end
			local choice=tb2[Duel.SelectOption(table.unpack(tb1))+1]
			valid_choice[choice]=false
			check_list[choice]=true
		end
	end
	if check_list[1] then
		Duel.Recover(tp,2100,REASON_EFFECT)
	end
	if check_list[2] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(2100)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	if check_list[3] then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76541103,6))
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.HintSelection(g)
		local rc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(76541103,4))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fa0000)
		rc:RegisterEffect(e1)
	end
	if check_list[4] then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76541103,7))
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local rc=g:GetFirst()
		if rc:IsImmuneToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(76541103,5))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_SET_DEFENSE)
		rc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		rc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		rc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		rc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetCountLimit(1)
		e6:SetOperation(c76541103.rmop)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e6)
	end
end
function c76541103.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c76541103.efilter(e,te)
	local rc=te:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsPosition(POS_FACEUP_ATTACK)
end