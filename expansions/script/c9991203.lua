--神天竜－ウェーブ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991203.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991203)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c9991203.spcost)
	e1:SetTarget(c9991203.sptg)
	e1:SetOperation(c9991203.spop)
	c:RegisterEffect(e1)
	--Recycle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(0xfe)
	e2:SetCondition(Dazz.GodraMainFuseEffectCondition)
	e2:SetTarget(c9991203.thtg)
	e2:SetOperation(c9991203.thop)
	c:RegisterEffect(e2)
end
c9991203.Dazz_name_Godra=true
function c9991203.spfilter(c,e,tp)
	return Dazz.IsGodra(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9991203.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9991203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991203.check_box[tp][1] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991203.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	c9991203.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9991203.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991203.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
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
function c9991203.thfilter(c)
	if c:IsLocation(LOCATION_REMOVED) then
		if c:IsFacedown() then return false end
	end
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(9991203)
end
function c9991203.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991203.check_box[tp][2]
		and Duel.GetMatchingGroupCount(c9991203.thfilter,tp,0x30,0x30,nil)~=0 end
	c9991203.check_box[tp][2]=true
	local sg=Duel.GetMatchingGroup(c9991203.thfilter,tp,0x30,0x30,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c9991203.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991203.thfilter,tp,0x30,0x30,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end