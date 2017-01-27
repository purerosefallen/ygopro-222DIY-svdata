--元素创造者·Senya
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c37564022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4,nil,nil,63)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c37564022.atkcon)
	e1:SetOperation(c37564022.atkop)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564022,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c37564022.rettg)
	e3:SetOperation(c37564022.retop)
	c:RegisterEffect(e3)
end
function c37564022.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c37564022.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetOverlayGroup():IsExists(c37564022.ovfilter,1,nil)
end
function c37564022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37564022,1))
		local sg=c:GetOverlayGroup():FilterSelect(tp,c37564022.ovfilter,1,1,nil)
		local tc=sg:GetFirst()
		senya.copy(e,nil,tc,false)
end
function c37564022.filter(c,e,tp)
	return c:GetRank()==4 and c:IsSetCard(0x770) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37564022.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c37564022.filter2(c)
	return c:IsSetCard(0x770) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c37564022.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37564022.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then 
		local g2=Duel.GetMatchingGroup(c37564022.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(37564022,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37564022,2))
				local sg2=g2:Select(tp,1,1,nil)
				Duel.Overlay(g:GetFirst(),sg2)
			end
		end
	end
end