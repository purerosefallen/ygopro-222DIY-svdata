--アゾリウス・ギルド・メイジ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992131.initial_effect(c)
	--Xyz
	c:EnableReviveLimit()
	Dazz.AddXyzProcedureDoubleStandarded(c,3,Dazz.IsAzorius,1,1)
	--Back to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c9992131.target)
	e1:SetOperation(c9992131.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9992131.cost2)
	e2:SetCondition(c9992131.condition2)
	e2:SetTarget(c9992131.target2)
	e2:SetOperation(c9992131.operation2)
	c:RegisterEffect(e2)
end
c9992131.Dazz_name_Azorius=true
function c9992131.filter1(c)
	return c:IsAbleToHand() and c:IsFaceup()
end
function c9992131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c9992131.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9992131.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9992131.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9992131.limit(g:GetFirst()))
end
function c9992131.limit(c)
	return function (e,lp,tp)
		return e:GetHandler()~=c
	end
end
function c9992131.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9992131.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9992131.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c9992131.confilter,1,nil)
end
function c9992131.confilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and Dazz.IsAzorius(c,Card.GetPreviousCodeOnField)
end
function c9992131.filter(c,e,tp)
	return Dazz.IsAzorius(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9992131.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9992131.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9992131.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9992131.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end