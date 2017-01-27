--アゾリウス・セニット
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992203.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992203+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Ignition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9992203.target)
	e2:SetOperation(c9992203.operation)
	c:RegisterEffect(e2)
end
c9992203.Dazz_name_Azorius=true
function c9992203.filter(c,typ)
	if not Dazz.IsAzorius(c) or c:IsFacedown() then return false end
	if typ==nil then
		return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	else
		return c:IsType(typ)
	end
end
function c9992203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992203.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9992203.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c9992203.filter,tp,LOCATION_MZONE,0,1,nil,TYPE_RITUAL) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c9992203.filter,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c9992203.filter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9992203,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if Duel.IsExistingMatchingCard(c9992203.filter,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9992203,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		end
	end
end