--邪符『不祥之兆』
local m=37564836
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.lfusm(c,cm.mfilter,2,63)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end)
	e0:SetOperation(cm.skipop)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(function(e,c)
		local g=c:GetMaterial()
		local t={}
		g:ForEach(function(tc)
			local et=senya.lgetcd(tc)
			for i,v in pairs(et) do
				table.insert(t,v)
			end
		end)
		e:GetLabelObject():SetLabel(senya.order_table_new(t))
	end)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.discon)
	e3:SetCost(senya.desccost(senya.lsermeffcost(1)))
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.mfilter(c)
	return senya.lgetct(c)>0 and not c:IsHasEffect(6205579)
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tm=e:GetLabel()
	if not tm then return end
	local t=senya.order_table[tm]
	for i,code in pairs(t) do
		senya.lgeff(c,code)
	end
end
function cm.atkval(e,c)
	return senya.lgetct(c)*1000
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end