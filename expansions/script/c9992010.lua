--アゾリウス・エーテルメイジ
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992010.initial_effect(c)
	Dazz.AddTurnCheckBox(9992010)
	--Summon Succeed
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9992010.sumtg)
	e1:SetOperation(c9992010.sumop)
	c:RegisterEffect(e1)
	--Special Summon Succeed
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9992010.drtg)
	e2:SetOperation(c9992010.drop)
	c:RegisterEffect(e2)
end
c9992010.Dazz_name_Azorius=true
function c9992010.spfilter(c,e,tp)
	return Dazz.IsAzorius(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9992010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not c9992010.check_box[tp][1]
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c9992010.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	c9992010.check_box[tp][1]=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c9992010.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c9992010.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if not g1:GetFirst():IsRelateToEffect(e) or Duel.SendtoHand(g1,nil,REASON_EFFECT)==0
		or not g1:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then return end
	if g2:GetFirst():IsRelateToEffect(e) then Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP) end
end
function c9992010.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand()
		and chkc~=c and chkc:IsControler(tp) end
	if chk==0 then return not c9992010.check_box[tp][2] and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,c) end
	c9992010.check_box[tp][2]=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9992010.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end