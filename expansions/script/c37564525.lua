--Kyami Kyami
local m=37564525
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.nnhr(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,37564765,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,true,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	senya.cneg(c,cm.discon,cm.discost,nil,m*16,true,nil)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and c:GetEquipGroup():IsExists(cm.cf,1,nil,re:GetHandler())
end
function cm.cf(c,rc)
	if not c:IsAbleToGraveAsCost() then return false end
	if c:IsCode(37564517) then return true end
	return bit.band(c:GetAttribute(),rc:GetAttribute())~=0 or bit.band(c:GetRace(),rc:GetRace())~=0
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,cm.cf,1,1,nil,re:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and bc:IsAbleToChangeControler()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	if c:IsRelateToBattle() and bc:IsRelateToBattle() then
			if Duel.Equip(tp,bc,c,false) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(function(e,c)
					return e:GetOwner()==c
				end)
				bc:RegisterEffect(e1)
			end
	end
end
function cm.sprfilter1(c,tp,fc)
	return c:IsCode(37564765) and c:IsReleasable() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_MZONE,0,1,c,fc)
end
function cm.sprfilter2(c,fc)
	return c:IsRace(RACE_FAIRY) and c:IsReleasable() and c:IsCanBeFusionMaterial(fc)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end