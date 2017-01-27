--神天竜－ツナミ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991213.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c,9991213,ATTRIBUTE_WATER)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991213,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9991213.recon)
	e1:SetTarget(c9991213.retg)
	e1:SetOperation(c9991213.reop)
	c:RegisterEffect(e1)
end
c9991213.Dazz_name_Godra=true
function c9991213.rfilter(c,code)
	return c:IsAbleToRemove() and c:IsCode(code)
end
function c9991213.recon(e,tp,eg,ep,ev,re,r,rp)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and bit.band(loc,0x12)~=0 and np~=tp
end
function c9991213.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991213.check_box[tp][1] end
	c9991213.check_box[tp][1]=true
	e:SetLabel(re:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rg=Duel.GetMatchingGroup(c9991213.rfilter,tp,0,LOCATION_GRAVE,nil,e:GetLabel())
	if rg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991213.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rg=Duel.GetMatchingGroup(c9991213.rfilter,tp,0,LOCATION_HAND+LOCATION_GRAVE,nil,e:GetLabel())
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
end