--神天竜－ダースト
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991211.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c,9991211,ATTRIBUTE_EARTH)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991211,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9991211.discon)
	e1:SetTarget(c9991211.distg)
	e1:SetOperation(c9991211.disop)
	c:RegisterEffect(e1)
end
c9991211.Dazz_name_Godra=true
function c9991211.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and bit.band(loc,0x0c)~=0 and np~=tp
end
function c9991211.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991211.check_box[tp][1] end
	c9991211.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991211.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end