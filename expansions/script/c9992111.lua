--アゾリウス・ゲートキーパー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992111.initial_effect(c)
	--Special Summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,9992111)
	e1:SetCondition(c9992111.spcon)
	e1:SetOperation(c9992111.spop)
	c:RegisterEffect(e1)
	--Exile
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--Strict
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9992111.condition)
	e3:SetOperation(c9992111.operation)
	c:RegisterEffect(e3)
end
c9992111.Dazz_name_Azorius=true
function c9992111.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9992111.spconfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.CheckReleaseGroup(tp,Dazz.IsAzorius,1,nil)
end
function c9992111.spconfilter(c)
	return c:IsFaceup() and Dazz.IsAzorius(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9992111.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Dazz.IsAzorius,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9992111.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg and eg:FilterCount(function(c,tp) return c:GetOwner()==1-tp end,nil,tp)~=0
end
function c9992111.operation(e,tp,eg,ep,ev,re,r,rp)
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_BATTLE_START)
	local lab=Duel.GetTurnCount()
	if Duel.GetTurnPlayer()~=tp then lab=lab+1 end
	ge1:SetLabel(lab)
	ge1:SetLabelObject(e:GetHandler())
	ge1:SetCondition(function(e)
		return Duel.GetTurnCount()-e:GetLabel()==1
	end)
	ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local se1=Effect.CreateEffect(e:GetLabelObject())
		se1:SetType(EFFECT_TYPE_FIELD)
		se1:SetCode(EFFECT_CANNOT_ATTACK)
		se1:SetTargetRange(0,LOCATION_MZONE)
		se1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(se1,tp)
		e:Reset()
	end)
	ge1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(ge1,tp)
end