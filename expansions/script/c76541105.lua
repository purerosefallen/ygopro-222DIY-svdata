--sia%Lto
function c76541105.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541105.condition)
	e1:SetOperation(c76541105.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c76541105.efilter)
	c:RegisterEffect(e2)
	if not c76541105.global_check then
		c76541105.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c76541105.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c76541105.regfilter(c,i)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetSummonPlayer()==i
end
function c76541105.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if Duel.GetFlagEffect(i,76541105)==0 and eg:FilterCount(c76541105.regfilter,nil,i)~=0 then
			Duel.RegisterFlagEffect(i,76541105,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c76541105.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
c76541105.mikagami_kobato=true
c76541105.apply_condition_set={
	function(c,e,tp) return Duel.IsExistingMatchingCard(c76541105.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end,
	function(c,e,tp) return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end,
	function(c,e,tp) return true end,
	function(c,e,tp) return true end,
}
function c76541105.desfilter(c)
	return c:GetSequence()==5
end
function c76541105.setfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsSSetable(true)
end
function c76541105.check_choice(c,e,tp)
	local rt={false,false,false,false}
	for i=1,4 do
		if c76541105.apply_condition_set[i](c,e,tp) then
			rt[i]=true
		end
	end
	return rt
end
function c76541105.valid_choice_count(t)
	local v=0
	for i,value in pairs(t) do
		if value then v=v+1 end
	end
	return v
end
function c76541105.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local valid_choice=c76541105.check_choice(c,e,tp)
	local check_list={false,false,false,false}
	if c76541105.valid_choice_count(valid_choice)<=2 then
		check_list=valid_choice
	else
		for ex=1,2 do
			local tb1={tp}
			local tb2={}
			for i,value in pairs(valid_choice) do
				if value then
					table.insert(tb1,aux.Stringid(76541105,i-1))
					table.insert(tb2,i)
				end
			end
			local choice=tb2[Duel.SelectOption(table.unpack(tb1))+1]
			valid_choice[choice]=false
			check_list[choice]=true
		end
	end
	if check_list[1] then
		local g1=Duel.GetMatchingGroup(c76541105.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		local g2=Duel.GetMatchingGroup(c76541105.setfilter,tp,LOCATION_DECK,0,nil)
		if g1:GetCount()~=0 and Duel.Destroy(g1,REASON_EFFECT)~=0
			and g2:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(76541105,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			g2=g2:Select(tp,1,1,nil)
			local tc=g2:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	if check_list[2] then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0,0xff)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetTarget(c76541105.rmtg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if check_list[3] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(c76541105.aclimit)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SSET)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c76541105.aclimset)
		Duel.RegisterEffect(e2,tp)
	end
	if check_list[4] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(59822133)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetCondition(c76541105.splimitcon)
		e2:SetTarget(c76541105.splimit)
		Duel.RegisterEffect(e2,tp)
	end
end
function c76541105.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c76541105.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local c=re:GetHandler()
	return c:IsLocation(LOCATION_HAND) or c:GetFlagEffect(76541105)>0
end
function c76541105.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(76541105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c76541105.splimitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),76541105)~=0
end
function c76541105.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end