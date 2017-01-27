--メイルストローム・ドラゴン
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9990408.initial_effect(c)
	--Xyz
	c:EnableReviveLimit()
	Dazz.AddXyzProcedureLevelFree(c,c9990408.xyzfilter,3)
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9990408)
	e1:SetCost(c9990408.cost)
	e1:SetTarget(c9990408.target)
	e1:SetOperation(c9990408.operation)
	c:RegisterEffect(e1)
	--Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9990408.rplctg)
	c:RegisterEffect(e2)
end
function c9990408.xyzfilter(c,xyzcard)
	if not c:IsRace(RACE_GRAGON) then return false end
	if c:IsXyzLevel(xyzcard,9) or c:IsXyzLevel(xyzcard,10) then return true end
	return c:GetRank()>=9 and c:GetRank()<=10
end
function c9990408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,3,REASON_COST) end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c9990408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c9990408.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(c,mg)
			end
			if bit.band(tc:GetOriginalType(),TYPE_TOKEN)==TYPE_TOKEN then
				Duel.SendtoGrave(tc,REASON_RULE)
			else
				Duel.Overlay(c,Group.FromCards(tc))
				tc:RegisterFlagEffect(9990408,RESET_CHAIN,0,1)
				tc:CancelToGrave()
			end
		end
		tc=g:GetNext()
	end
	--Not Really Perfect For Negate Effect
	local ge=Effect.CreateEffect(e:GetHandler())
	ge:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge:SetCode(EVENT_CHAIN_ACTIVATING)
	ge:SetOperation(c9990408.disop)
	ge:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(ge,tp)
end
function c9990408.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainNegatable(ev) and re:GetHandler():GetFlagEffect(9990408)~=0 then Duel.NegateActivation(ev) end
end
function c9990408.rplctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end