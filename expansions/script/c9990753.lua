--ＲＵＭ－イリミティッド・プロトス・フォース
function c9990753.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c9990753.cost)
	e1:SetTarget(c9990753.target)
	e1:SetOperation(c9990753.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9990753+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c9990753.cost2)
	e2:SetTarget(c9990753.target2)
	e2:SetOperation(c9990753.operation2)
	c:RegisterEffect(e2)
end
function c9990753.costfilter(c,md)
	if not c:IsAbleToRemoveAsCost() then return false end
	if md==1 then return c:IsType(TYPE_XYZ) else return c:IsSetCard(0x95) end
end
function c9990753.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990753.costfilter,tp,LOCATION_GRAVE,0,1,nil,1)
		and Duel.IsExistingMatchingCard(c9990753.costfilter,tp,LOCATION_GRAVE,0,1,nil,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c9990753.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9990753.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,2)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c9990753.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990753.costfilter,tp,LOCATION_GRAVE,0,1,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9990753.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,1)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9990753.filter1(c,e,tp)
	return c:GetRank()>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(c9990753.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetRank(),c:GetRace(),c:GetCode(),e,tp)
end
function c9990753.filter2(c,rk,rc,code,e,tp)
	if c:IsCode(6165656) and code~=48995978 then return false end
	return (c:GetRank()==rk+1 or c:GetRank()==rk+2) and c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9990753.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990753.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c9990753.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9990753.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990753.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() local c=e:GetHandler()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e)
		or not Duel.IsExistingMatchingCard(c9990753.filter2,tp,LOCATION_EXTRA,0,1,nil,tc:GetRank(),tc:GetRace(),tc:GetCode(),e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c9990753.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),tc:GetRace(),tc:GetCode(),e,tp):GetFirst()
	local mg=tc:GetOverlayGroup() if mg:GetCount()~=0 then Duel.Overlay(sc,mg) end
	sc:SetMaterial(Group.FromCards(tc)) Duel.Overlay(sc,Group.FromCards(tc))
	Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	sc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	sc:CompleteProcedure()
end
function c9990753.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9990753.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,c) end
end
