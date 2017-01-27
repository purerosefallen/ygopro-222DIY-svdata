--飞球之天界
function c13254066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,13254066)
	e2:SetTarget(c13254066.target)
	e2:SetOperation(c13254066.activate)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c13254066.reptg)
	e3:SetOperation(c13254066.repop)
	c:RegisterEffect(e3)
	
end
function c13254066.desfilter(c)
	return c:IsDestructable()
end
function c13254066.disfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13254066.thfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c13254066.thfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsAbleToHand()
end
function c13254066.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsAbleToRemoveAsCost()
end
function c13254066.rfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c13254066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254066.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c13254066.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetMatchingGroupCount(c13254066.disfilter,p,LOCATION_HAND,0,nil)<1 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(p,c13254066.disfilter,p,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)~=1 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	local code=tc:GetCode()
	Duel.BreakEffect()
	local g=Group.CreateGroup()
	if code==13254042 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=Duel.SelectMatchingCard(tp,c13254066.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			g=Duel.GetMatchingGroup(c13254066.desfilter,tp,0,LOCATION_MZONE,nil)
			if g:GetCount()>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(13254066,0)) then
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
		end
	elseif code==13254045 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=1 then return end
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif code==13254046 then
		if Duel.IsExistingMatchingCard(c13254066.cfilter,tp,LOCATION_DECK,0,4,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g=Duel.SelectMatchingCard(tp,c13254066.cfilter,tp,LOCATION_DECK,0,4,4,nil)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			sg=Duel.SelectMatchingCard(tp,c13254066.rfilter,tp,0,LOCATION_ONFIELD,2,2,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	elseif code==13254047 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if h1==0 then return end
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		sg=Duel.SelectMatchingCard(tp,c13254066.thfilter2,tp,LOCATION_DECK,0,h1,h1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c13254066.repfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254066.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c13254066.repfilter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(13254066,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c13254066.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c13254066.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
