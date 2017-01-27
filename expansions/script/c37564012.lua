--元素毁灭者·Aya Ayane
function c37564012.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c37564012.sprcon)
	e2:SetOperation(c37564012.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564012,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37564012+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c37564012.descost)
	e3:SetTarget(c37564012.destg)
	e3:SetOperation(c37564012.desop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(37564012,ACTIVITY_CHAIN,aux.FALSE)
end
function c37564012.sprfilter1(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function c37564012.spcfilter(c)
	return c:IsSetCard(0x771) and not c:IsPublic()
end
function c37564012.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(c37564012.sprfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) and Duel.IsExistingMatchingCard(c37564012.spcfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c37564012.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37564012.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c37564012.sprfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,3,99,nil)
	Duel.Hint(HINT_CARD,0,37564012)
	Duel.ConfirmCards(1-tp,g)
	Duel.Release(g1,REASON_COST)
	Duel.ShuffleHand(tp)	
end
function c37564012.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(37564012,tp,ACTIVITY_CHAIN)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
		return se~=e:GetLabelObject()
	end)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(aux.TRUE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c37564012.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION)
end
function c37564012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c37564012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c37564012.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c37564012.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c37564012.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
