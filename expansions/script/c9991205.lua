--神天竜－サイズミック
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991205.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991205)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9991205.thtg)
	e1:SetOperation(c9991205.thop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(0xfe)
	e2:SetCondition(Dazz.GodraMainFuseEffectCondition)
	e2:SetTarget(c9991205.drtg)
	e2:SetOperation(c9991205.drop)
	c:RegisterEffect(e2)
end
c9991205.Dazz_name_Godra=true
function c9991205.thfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991205.check_box[tp][1]
		and Duel.IsExistingMatchingCard(c9991205.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	c9991205.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c9991205.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991205.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
function c9991205.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991205.check_box[tp][2] and Duel.IsPlayerCanDraw(tp,1) end
	c9991205.check_box[tp][2]=true
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9991205.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end