--百慕 最初的乐谱·灯里
local m=37564424
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.setreg(c,m,37564573)
	aux.AddXyzProcedure(c,senya.bmchkfilter,3,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
	end)
	e2:SetProperty(0x14000)
	e2:SetCost(senya.bmrmcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetLabel(0)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetLabel(1)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)	
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(37560424,RESET_EVENT+0x1fe0000,0,1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((eg and eg:IsContains(e:GetHandler())) or e:GetLabel()==1) and e:GetHandler():GetFlagEffect(37560424)>0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Draw(tp,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+   EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(cm.atkop)
		c:RegisterEffect(e1)
	end 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	e:Reset()
end