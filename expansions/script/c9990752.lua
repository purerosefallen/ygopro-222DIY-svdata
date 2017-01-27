--ＲＵＭ－プロトス・フォース
function c9990752.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c9990752.cost)
	e1:SetTarget(c9990752.target)
	e1:SetOperation(c9990752.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9990752+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c9990752.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c9990752.target2)
	e2:SetOperation(c9990752.operation2)
	c:RegisterEffect(e2)
end
function c9990752.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	local sg=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,nil,tp,1,REASON_COST)
	if sg:GetCount()~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,532)
		sg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	end
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9990752.filter1(c,e,tp)
	return c:GetRank()>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(c9990752.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetRank(),c:GetRace(),c:GetCode(),e,tp,c)
end
function c9990752.filter2(c,rk,rc,code,e,tp,mc)
	if c:IsCode(6165656) and code~=48995978 then return false end
	if not mc:IsCanBeXyzMaterial(c,true) then return false end
	return c:GetRank()==rk+1 and c:IsRace(rc) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9990752.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990752.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c9990752.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9990752.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990752.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() local c=e:GetHandler()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not c:IsRelateToEffect(e)
		or not Duel.IsExistingMatchingCard(c9990752.filter2,tp,LOCATION_EXTRA,0,1,nil,tc:GetRank(),tc:GetRace(),tc:GetCode(),e,tp,tc) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c9990752.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),tc:GetRace(),tc:GetCode(),e,tp,tc):GetFirst()
	local mg=tc:GetOverlayGroup() if mg:GetCount()~=0 then Duel.Overlay(sc,mg) end
	sc:SetMaterial(Group.FromCards(tc)) Duel.Overlay(sc,Group.FromCards(tc))
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) sc:CompleteProcedure()
end
function c9990752.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9990752.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,c) end
end