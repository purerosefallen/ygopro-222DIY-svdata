--神天竜－オンブラ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991207.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991207)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c9991207.thcost)
	e1:SetTarget(c9991207.thtg)
	e1:SetOperation(c9991207.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c9991207.spcost)
	e2:SetTarget(c9991207.sptg)
	e2:SetOperation(c9991207.spop)
	c:RegisterEffect(e2)
end
c9991207.Dazz_name_Godra=true
function c9991207.thfilter(c)
	return Dazz.IsGodra(c) and c:IsType(TYPE_MONSTER) and not c:IsCode(9991207) and c:IsAbleToHand()
end
function c9991207.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9991207.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c9991207.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return not c9991207.check_box[tp][1] and sg:GetCount()~=0 end
	c9991207.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c9991207.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991207.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
function c9991207.spfilter(c,e,tp)
	return Dazz.IsGodra(c) and not c:IsCode(9991207) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9991207.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c9991207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991207.check_box[tp][2] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991207.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	c9991207.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9991207.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991207.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.HintSelection(g)
		end
	end
end