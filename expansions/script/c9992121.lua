--アゾリウス・ジャスティシャー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992121.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Dazz.IsAzorius),1)
	--Kick Out
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9992121)
	e1:SetCondition(c9992121.con)
	e1:SetTarget(c9992121.tg)
	e1:SetOperation(c9992121.op)
	c:RegisterEffect(e1)
end
c9992121.Dazz_name_Azorius=true
function c9992121.con(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return false end
	local c=e:GetHandler()
	return eg:IsContains(c) or eg:IsExists(c9992121.confilter,1,nil,tp)
end
function c9992121.confilter(c,tp)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and c:GetSummonPlayer()==tp and Dazz.IsAzorius(c)
end
function c9992121.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9992121.limit(g:GetFirst(),g:GetNext()))
end
function c9992121.limit(c1,c2)
	return function (e,lp,tp)
		return e:GetHandler()~=c1 and e:GetHandler()~=c2
	end
end
function c9992121.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end