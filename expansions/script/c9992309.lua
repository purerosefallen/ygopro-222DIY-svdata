--アゾリウス・アバンドン
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992309.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992309+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		return true
	end)
	e1:SetTarget(c9992309.target)
	e1:SetOperation(c9992309.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
c9992309.Dazz_name_Azorius=true
function c9992309.tgfilter(c)
	if not c:IsOnField() then return false end
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsAbleToHand()
	else
		return c:IsDestructable()
	end
end
function c9992309.shfilter(c)
	return c:IsFacedown() and Dazz.IsAzorius(c)
end
function c9992309.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9992309.tgfilter(chkc) end
	if chk==0 and e:GetLabel()~=1 then return false else e:SetLabel(0) end
	local v1,v2=
		Duel.GetTargetCount(c9992309.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()),
		Duel.GetMatchingGroupCount(c9992309.shfilter,tp,LOCATION_HAND,0,e:GetHandler())
	local maxc=math.min(v1,v2,2)
	if chk==0 then return maxc>0 end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,526)
	local shg=Duel.SelectMatchingCard(tp,c9992309.shfilter,tp,LOCATION_HAND,0,1,maxc,e:GetHandler())
	Duel.ConfirmCards(1-tp,shg)
	Duel.ShuffleHand(tp)
	local count=shg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c9992309.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,count,count,e:GetHandler())
	local hg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	tg:Sub(hg)
	local category=0
	if hg:GetCount()~=0 then
		category=category+CATEGORY_TOHAND
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,hg:GetCount(),0,0)
	end
	if tg:GetCount()~=0 then
		category=category+CATEGORY_DESTROY
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
	end
	e:SetCategory(category)
end
function c9992309.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	local hg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	tg:Sub(hg)
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.Destroy(tg,REASON_EFFECT)
end