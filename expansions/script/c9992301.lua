--アゾリウス・オーソリティー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992301.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9992301+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c9992301.target)
	e1:SetOperation(c9992301.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
c9992301.Dazz_name_Azorius=true
function c9992301.filter1(c)
	return Dazz.IsAzorius(c) and c:IsFaceup()
end
function c9992301.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9992301.filter1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c9992301.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9992301.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local sel=0
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0 then
		sel=Duel.SelectOption(tp,aux.Stringid(9992301,0),aux.Stringid(9992301,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(9992301,1))+1
	end
	e:GetHandler():RegisterFlagEffect(9992301,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9992301,sel))
	e:SetLabel(sel)
end
function c9992301.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local sel=e:GetLabel()
	if sel==0 then
		local val=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*500
		if val==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	else
		--negate on this chain
		local lab=0
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if c9992301.checkfunc(tc,tp,tgp,i,te) then
				lab=lab+(2^i)
			end
		end
		if lab~=0 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_CHAIN_SOLVING)
			ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
				if not (Duel.IsChainDisablable(ev)
					and bit.band(e:GetLabel(),2^ev)~=0) then return end
				Duel.NegateEffect(ev)
			end)
			ge1:SetReset(RESET_CHAIN)
			ge1:SetLabel(lab)
			Duel.RegisterEffect(ge1,tp)
		end
		--negate after this chain
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9992301,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if not c9992301.checkfunc(e:GetHandler(),tp,ep,ev,re) then return end
			local g1=Effect.GlobalEffect()
			g1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			g1:SetCode(EVENT_CHAIN_SOLVING)
			g1:SetReset(RESET_CHAIN)
			g1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local val=e:GetLabel()
				if ev==val then
					Duel.NegateEffect(val)
				end
			end)
			g1:SetLabel(Duel.GetCurrentChain())
			Duel.RegisterEffect(g1,tp)
		end)
		tc:RegisterEffect(e1)
	end
end
function c9992301.checkfunc(c,tp,ep,ev,re)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ep~=tp and re:IsHasType(0x7f0) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and tg and tg:IsContains(c)
end