--夜鸦·TGR-Ⅰ
function c10114007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10114007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10114007)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c10114007.spcon)
	e1:SetCost(c10114007.spcost)
	e1:SetTarget(c10114007.sptg)
	e1:SetOperation(c10114007.spop)
	c:RegisterEffect(e1) 
	-- atkdef
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetCondition(c10114007.adcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--fuck then condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10114007.spop2)
	c:RegisterEffect(e4)	  
end

function c10114007.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x3331) then
	   c:RegisterFlagEffect(10114007,RESET_EVENT+0x1ff0000,0,1)
	end
	c:RegisterFlagEffect(10114107,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
end

function c10114007.adcon(e)
	return e:GetHandler():GetFlagEffect(10114007)>0
end

function c10114007.spcon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(10114107)==0  
end

function c10114007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10114007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10114007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and c:IsAbleToDeckAsCost()
	end
	if c:GetFlagEffect(10114007)>0 then e:SetLabel(1) end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10114007.filter(c,e,tp)
	local rc=e:GetHandler()
	return (c:IsLevelBelow(6) or ((e:GetLabel()==1 or rc:GetFlagEffect(10114007)>0) and c:GetLevel()==7)) and c:IsSetCard(0x3331) and not c:IsCode(10114007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10114007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10114007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end