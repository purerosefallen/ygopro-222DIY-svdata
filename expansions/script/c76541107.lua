--\Fyrw/
function c76541107.initial_effect(c)
	--special effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c76541107.condition)
	e1:SetOperation(c76541107.operation)
	c:RegisterEffect(e1)
	--brave bird
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c76541107.bdtg)
	e2:SetOperation(c76541107.bdop)
	c:RegisterEffect(e2)
end
c76541107.mikagami_kobato=true
function c76541107.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetOriginalCode()==76541101
end
function c76541107.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local valid_choice={true,true,true,Duel.GetTurnPlayer()~=tp}
	local check_list={false,false,false,false}
	for ex=1,2 do
		local tb1={tp}
		local tb2={}
		for i,value in pairs(valid_choice) do
			if value then
				table.insert(tb1,aux.Stringid(76541107,i-1))
				table.insert(tb2,i)
			end
		end
		local choice=tb2[Duel.SelectOption(table.unpack(tb1))+1]
		valid_choice[choice]=false
		check_list[choice]=true
	end
	if check_list[1] then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
	if check_list[2] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	if check_list[3] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(76541107,2))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c76541107.immunv)
		e2:SetOwnerPlayer(tp)
		c:RegisterEffect(e2)
	end
	if check_list[4] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e2:SetCountLimit(1)
		e2:SetOperation(c76541107.atop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c76541107.immunv(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function c76541107.posfilter(c)
	return not c:IsPosition(POS_FACEUP_ATTACK)
end
function c76541107.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76541107.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(76541107,4)) then return end
	Duel.Hint(HINT_CARD,0,76541107)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	g=g:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function c76541107.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsDefenseBelow(c:GetAttack()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c76541107.bdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end