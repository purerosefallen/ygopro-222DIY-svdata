--钢牙 狂绿猛毒风
function c10125004.initial_effect(c)
	--cannotdisbalesummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c10125004.scost)
	e3:SetOperation(c10125004.scop)
	c:RegisterEffect(e3)	
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	--c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	--c:RegisterEffect(e5)
	--act limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetValue(c10125004.aclimit)
	c:RegisterEffect(e6)
	--summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10125004,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c10125004.smcon)
	e7:SetTarget(c10125004.smtg)
	e7:SetOperation(c10125004.smop)
	c:RegisterEffect(e7)
	--equip
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10125004,1))
	e8:SetCategory(CATEGORY_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetTarget(c10125004.sumtg)
	e8:SetOperation(c10125004.sumop)
	c:RegisterEffect(e8)
	Duel.AddCustomActivityCounter(10125004,ACTIVITY_SPSUMMON,c10125004.counterfilter)  
	Duel.AddCustomActivityCounter(10125104,ACTIVITY_SUMMON,c10125004.counterfilter)  
end
function c10125004.scost(e,c,tp)
	return Duel.GetCustomActivityCount(10125004,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(10125104,tp,ACTIVITY_SUMMON)==0
end
function c10125004.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10125004.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c10125004.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x9334)
end
function c10125004.counterfilter(c)
	return c:IsSetCard(0x9334)
end
function c10125004.sumfilter(c)
	return c:IsSetCard(0x9334) and not c:IsCode(10125004) and c:IsSummonable(true,nil)
end
function c10125004.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10125004.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10125004.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10125004.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c10125004.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10125004.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c10125004.smcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c10125004.aclimit(e,re,tp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
