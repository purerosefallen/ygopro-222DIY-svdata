--Sawawa-NyaNya and Wa
local m=37564211
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)	
senya.sww(c,1,false,false,false)
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(senya.swwblex)
	e1:SetCost(senya.swwrmcost(1))
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	local gc=g:RandomSelect(tp,1):GetFirst()
	Duel.ConfirmCards(tp,gc)
	if gc:IsType(TYPE_XYZ) and gc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then
	   local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(gc,mg)
		end
		gc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(gc,Group.FromCards(tc))
		Duel.SpecialSummon(gc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		gc:CompleteProcedure()
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
