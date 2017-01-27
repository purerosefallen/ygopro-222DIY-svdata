--sir#n(A)it<kgh>
function c76541106.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541106.condition)
	e1:SetOperation(c76541106.operation)
	c:RegisterEffect(e1)
	--battle start
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c76541106.batcon)
	e2:SetOperation(c76541106.batop)
	c:RegisterEffect(e2)
end
c76541106.mikagami_kobato=true
c76541106.apply_condition_set={
	function(c,e,tp) return Duel.IsPlayerCanDraw(tp,1) end,
	function(c,e,tp) return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end,
	function(c,e,tp) return true end,
	function(c,e,tp) return true end,
}
function c76541106.check_choice(c,e,tp)
	local rt={false,false,false,false}
	for i=1,4 do
		if c76541106.apply_condition_set[i](c,e,tp) then
			rt[i]=true
		end
	end
	return rt
end
function c76541106.valid_choice_count(t)
	local v=0
	for i,value in pairs(t) do
		if value then v=v+1 end
	end
	return v
end
function c76541106.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541106.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local valid_choice=c76541106.check_choice(c,e,tp)
	local check_list={false,false,false,false}
	if c76541106.valid_choice_count(valid_choice)<=2 then
		check_list=valid_choice
	else
		for ex=1,2 do
			local tb1={tp}
			local tb2={}
			for i,value in pairs(valid_choice) do
				if value then
					table.insert(tb1,aux.Stringid(76541106,i-1))
					table.insert(tb2,i)
				end
			end
			local choice=tb2[Duel.SelectOption(table.unpack(tb1))+1]
			valid_choice[choice]=false
			check_list[choice]=true
		end
	end
	if check_list[1] then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if check_list[2] then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if check_list[3] then
		Duel.Hint(HINT_SELECTMSG,tp,564)
		local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(c76541106.splimit)
		Duel.RegisterEffect(e1,tp)
	end
	if check_list[4] then
		if Duel.GetFlagEffect(tp,76541106)==0 then
			Duel.RegisterFlagEffect(tp,76541106,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(c76541106.discon)
			e1:SetOperation(c76541106.disop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c76541106.splimit(e,c,tp,sumtp,sumpos)
	return c:IsCode(e:GetLabel())
end
function c76541106.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c76541106.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(76541106,4)) then return end
	Duel.Hint(HINT_CARD,0,76541106)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(re:GetHandler(),REASON_EFFECT)
	end
	e:Reset()
end
function c76541106.batcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:IsPreviousLocation(LOCATION_DECK)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c76541106.batop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(3400)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(3200)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ATTACK_ALL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end