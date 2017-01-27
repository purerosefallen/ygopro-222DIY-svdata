--银草飞球
function c13254087.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,13254087)
	e1:SetTarget(c13254087.target)
	e1:SetOperation(c13254087.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23254087)
	e3:SetTarget(c13254087.target2)
	e3:SetOperation(c13254087.operation2)
	c:RegisterEffect(e3)
	
end
function c13254087.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13254087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13254087.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c13254087.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13254087.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13254087.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)==1 and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(13254087,0)) then
			Duel.ConfirmDecktop(tp,1)
			local g=Duel.GetDecktopGroup(tp,1)
			local tc=g:GetFirst()
			if (tc:IsRace(RACE_PLANT) and tc:IsLevelBelow(1)) or (tc:IsSetCard(0x356) and tc:IsType(TYPE_MONSTER))	then
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				Duel.MoveSequence(tc,1)
			end
		end
	end
end
function c13254087.filter(c)
	return (c:IsRace(RACE_PLANT) and c:IsLevelBelow(1)) or (tc:IsSetCard(0x356) and tc:IsType(TYPE_MONSTER))
end
function c13254087.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254087.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c13254087.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13254087,1))
	local g=Duel.SelectMatchingCard(tp,c13254087.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
