--量子网络·命定终局
function c76541003.initial_effect(c)
	c:SetSPSummonOnce(76541003)
	--remove check
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(c76541003.rmcheck)
	c:RegisterEffect(e1)
	--self remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c76541003.rmtarget)
	e2:SetOperation(c76541003.rmoperation)
	c:RegisterEffect(e2)
	--self special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetTarget(c76541003.sptarget)
	e2:SetOperation(c76541003.spoperation)
	c:RegisterEffect(e2)
	--recycle
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c76541003.target)
	e4:SetOperation(c76541003.operation)
	c:RegisterEffect(e4)
end
function c76541003.rmcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetReasonEffect():GetOwner():IsSetCard(0x9d0) then
		c:RegisterFlagEffect(76541000,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c76541003.rmtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c76541003.rmoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c76541003.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(76541000)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76541003.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c76541003.thfilter(c)
	return c:IsSetCard(0x9d0) and c:IsAbleToHand()
end
function c76541003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c76541003.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c76541003.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76541003.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	g=g:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end