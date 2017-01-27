--草飞球
function c13254071.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,13254071)
	e1:SetTarget(c13254071.target)
	e1:SetOperation(c13254071.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23254071)
	e3:SetTarget(c13254071.target2)
	e3:SetOperation(c13254071.operation2)
	c:RegisterEffect(e3)
	
end
function c13254071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.IsPlayerCanDraw(tp,1) end
end
function c13254071.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.IsPlayerCanDraw(tp,1)) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if (tc:IsRace(RACE_PLANT) and tc:IsLevelBelow(1)) or (tc:IsSetCard(0x356) and tc:IsType(TYPE_MONSTER)) then
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(13254071,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end
function c13254071.filter(c)
	return (c:IsRace(RACE_PLANT) and c:IsLevelBelow(1)) or (c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER))
end
function c13254071.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254071.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c13254071.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254071,1))
	local g=Duel.SelectMatchingCard(tp,c13254071.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
