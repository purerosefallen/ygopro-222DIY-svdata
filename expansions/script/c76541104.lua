--KRKZN-iiia
function c76541104.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541104.condition)
	e1:SetOperation(c76541104.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
c76541104.mikagami_kobato=true
c76541104.apply_condition_set={
	function(c,e,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end,
	function(c,e,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end,
	function(c,e,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end,
	function(c,e,tp) return true end,
}
function c76541104.check_choice(c,e,tp)
	local rt={false,false,false,false}
	for i=1,4 do
		if c76541104.apply_condition_set[i](c,e,tp) then
			rt[i]=true
		end
	end
	return rt
end
function c76541104.valid_choice_count(t)
	local v=0
	for i,value in pairs(t) do
		if value then v=v+1 end
	end
	return v
end
function c76541104.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541104.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local valid_choice=c76541104.check_choice(c,e,tp)
	local check_list={false,false,false,false}
	if c76541104.valid_choice_count(valid_choice)<=2 then
		check_list=valid_choice
	else
		for ex=1,2 do
			local tb1={tp}
			local tb2={}
			for i,value in pairs(valid_choice) do
				if value then
					table.insert(tb1,aux.Stringid(76541104,i-1))
					table.insert(tb2,i)
				end
			end
			local choice=tb2[Duel.SelectOption(table.unpack(tb1))+1]
			valid_choice[choice]=false
			check_list[choice]=true
		end
	end
	local eg=Group.CreateGroup()
	if check_list[1] then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,1,1,nil)
		Duel.ConfirmCards(tp,g)
		eg:Merge(g)
	end
	if check_list[2] then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		eg:Merge(g)
	end
	if check_list[3] then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_EXTRA,1,1,nil)
		Duel.ConfirmCards(tp,g)
		eg:Merge(g)
	end
	if check_list[4] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SendtoGrave(eg,REASON_RULE)
end