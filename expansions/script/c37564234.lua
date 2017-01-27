--Sawawa-Prism Melody
local m=37564234
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.sww(c,2,true,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37560234)
	e1:SetCondition(senya.swwblex)
	e1:SetCost(senya.swwrmcost(1))
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,37561234)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(senya.delay)
	e2:SetCost(senya.serlcost)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(senya.swwblex)
	e2:SetTarget(cm.target)
	e2:SetOperation(senya.drawop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsControlerCanBeChanged()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_BATTLE,1)
	end
end
function cm.cfilter(c,tp)
	local ty=c:GetSummonType()
	return c:GetSummonPlayer()==1-tp and (bit.band(ty,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(ty,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO or bit.band(ty,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ) and c:GetMaterialCount()>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil,tp)
	local ct=0
	g:ForEach(function(c)
		ct=ct+c:GetMaterialCount()
	end)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end