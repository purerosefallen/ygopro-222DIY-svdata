--夜鸦·诱捕者I
function c10115002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3331),5,2)
	c:EnableReviveLimit()
	--fucking self&oppo
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10115002,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10115002)
	e1:SetCost(c10115002.cost)
	e1:SetTarget(c10115002.target)
	e1:SetOperation(c10115002.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10115002,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10115002)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c10115002.spcon)
	e2:SetCost(c10115002.spcost)
	e2:SetTarget(c10115002.sptg)
	e2:SetOperation(c10115002.spop)
	c:RegisterEffect(e2)	 
	--fuck then condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10115002.spop2)
	c:RegisterEffect(e3)	
end

function c10115002.spop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10115102,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end

function c10115002.fkfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToChangeControler()
end

function c10115002.fkfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and c:IsAbleToHand()
end

function c10115002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local gc1=Duel.GetMatchingGroupCount(c10115002.fkfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local gc2=Duel.GetMatchingGroupCount(c10115002.fkfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if chk==0 then return gc1>0 or gc2>0  end
	if gc1==0 and gc2>0 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_SZONE)
	end
end

function c10115002.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c10115002.fkfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local g2=Duel.GetMatchingGroup(c10115002.fkfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10115002,2))
	local g=g1:Select(tp,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   local tc=g:GetFirst()
	   if tc:IsLocation(LOCATION_MZONE) then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then Duel.SendtoGrave(tc,REASON_EFFECT) return end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10115002.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(300)
		tc:RegisterEffect(e2)
	   else
		 Duel.SendtoHand(g,tp,REASON_EFFECT)
	   end
	end
end

function c10115002.eqlimit(e,c)
	return e:GetOwner()==c
end

function c10115002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c10115002.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10115102)==0 
end

function c10115002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end

function c10115002.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10115002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10115002.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

function c10115002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10115002.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end