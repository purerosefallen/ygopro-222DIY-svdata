--アゾリウス・クルーストーン
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992308.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992308+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9992308.activate)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--Indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c)
		return not c:IsCode(9992308) and Dazz.IsAzorius(c)
	end)
	e2:SetValue(function(e,re,r,rp)
		if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
			return 1
		else return 0 end
	end)
	c:RegisterEffect(e2)
end
c9992308.Dazz_name_Azorius=true
function c9992308.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(function(c) return not c:IsCode(9992308) and Dazz.IsAzorius(c)
		and c:IsType(TYPE_TRAP) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9992308,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end