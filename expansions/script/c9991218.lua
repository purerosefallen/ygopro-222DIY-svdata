--神天竜－ルンナー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991218.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c)
	Dazz.AddTurnCheckBox(9991218)
	--Xyz
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Exile Card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11d8)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9991218.condition1)
	e1:SetCost(c9991218.rmvcost)
	e1:SetTarget(c9991218.rmvtg)
	e1:SetOperation(c9991218.rmvop)
	c:RegisterEffect(e1)
	--Grave Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x11d8)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9991218.condition2)
	e2:SetTarget(c9991218.gxtg)
	e2:SetOperation(c9991218.gxop)
	c:RegisterEffect(e2)
end
c9991218.Dazz_name_Godra=true
function c9991218.matfilter(c,xc)
	return c:GetLevel()==8 and Dazz.IsGodra(c) and c:IsCanBeXyzMaterial(xc) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991218.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or bit.band(Duel.GetCurrentPhase(),0xf8)~=0
end
function c9991218.rmvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9991218.rmvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991218.check_box[tp][1]
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	c9991218.check_box[tp][1]=true
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c9991218.rmvop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9991218.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and (Duel.GetTurnPlayer()==tp or bit.band(Duel.GetCurrentPhase(),0xf8)~=0)
end
function c9991218.gxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c9991218.check_box[tp][2]
		and Duel.IsExistingMatchingCard(c9991218.matfilter,tp,LOCATION_GRAVE,0,2,nil,c)
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	c9991218.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local xg=Duel.GetMatchingGroup(c9991218.matfilter,tp,LOCATION_GRAVE,0,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,xg,2,0,0)
end
function c9991218.gxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=Duel.GetMatchingGroup(c9991218.matfilter,tp,LOCATION_GRAVE,0,nil,c)
	if not c:IsRelateToEffect(e) or xg:GetCount()<2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	xg=xg:Select(tp,2,2,nil)
	Duel.SpecialSummonStep(c,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
	c:SetMaterial(xg)
	Duel.Overlay(c,xg)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991218,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
end