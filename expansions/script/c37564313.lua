--哈特曼的妖怪少女 -SDVX Remix-
local m=37564313
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.setreg(c,m,37564876)
	senya.rxyz1(c,nil,nil,3,3)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.skipop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16+1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1)
	e1:SetCost(senya.desccost(senya.rmovcost(1)))
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local opt=Duel.SelectOption(tp,1057,1056,1063,1073,1074)
	if opt==0 then ct=TYPE_RITUAL end
	if opt==1 then ct=TYPE_FUSION end
	if opt==2 then ct=TYPE_SYNCHRO end
	if opt==3 then ct=TYPE_XYZ end
	if opt==4 then ct=TYPE_PENDULUM end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(tp,hg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local sg=hg:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	Duel.HintSelection(sg)
	if sc:IsType(TYPE_MONSTER) then
		local val1=math.max(c:GetBaseAttack(),0)+math.max(sc:GetBaseAttack(),0)
		local val2=math.max(c:GetBaseAttack(),0)+math.max(sc:GetBaseDefense(),0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(val1)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(val2)
		c:RegisterEffect(e2)
		c:CopyEffect(sc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	elseif sc:GetActivateEffect() then
		local l=sc:GetFlagEffectLabel(m)
		if l then
			sc:SetFlagEffectLabel(m,l+1)
		else
			sc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(37564765,6))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetHintTiming(0x3c0)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return not Duel.CheckEvent(EVENT_CHAINING)
		end)
		e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			e:SetLabel(1)
			local l=sc:GetFlagEffectLabel(m)
			if chk==0 then return l and l>0 end
			if l==1 then
				sc:ResetFlagEffect(m)
			else
				sc:SetFlagEffectLabel(l-1)
			end
			Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		end)
		e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				if e:GetLabel()==0 then return false end
				e:SetLabel(0)
				return cm.scopyf1(sc)
			end
			e:SetLabel(0)
			local te,ceg,cep,cev,cre,cr,crp=sc:CheckActivateEffect(true,true,true)
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
		end)
		e2:SetOperation(senya.scopyop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(37564765,6))
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_CHAINING)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		if ctlm then e3:SetCountLimit(ctlm,ctlmid) end
		e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			e:SetLabel(1)
			local l=sc:GetFlagEffectLabel(m)
			if chk==0 then return l and l>0 end
			if l==1 then
				sc:ResetFlagEffect(m)
			else
				sc:SetFlagEffectLabel(l-1)
			end
			Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		end)
		e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				if e:GetLabel()==0 then return false end
				e:SetLabel(0)
				return cm.scopyf2(sc,e,tp,eg,ep,ev,re,r,rp)
			end
			e:SetLabel(0)
			local te,ceg,cep,cev,cre,cr,crp
			local fchain=cm.scopyf1(sc)
			if fchain then
				te,ceg,cep,cev,cre,cr,crp=sc:CheckActivateEffect(true,true,true)
			else
				te=sc:GetActivateEffect()
			end
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then
				if fchain then
					tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
				else
					tg(e,tp,eg,ep,ev,re,r,rp,1)
				end
			end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
		end)
		e3:SetOperation(senya.scopyop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
	Duel.ShuffleHand(1-tp)
end
function cm.scopyf1(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.scopyf2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:CheckActivateEffect(true,true,false) then return true end
	local te=c:GetActivateEffect()
	if te:GetCode()~=EVENT_CHAINING then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	return true
end
function cm.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local tc=e:GetLabelObject()
	local l=tc:GetFlagEffectLabel(m)
	if chk==0 then return l and l>0 end
	if l==1 then
		tc:ResetFlagEffect(m)
	else
		tc:SetFlagEffectLabel(l-1)
	end
end