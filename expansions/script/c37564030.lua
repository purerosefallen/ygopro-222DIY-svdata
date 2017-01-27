--Unconscious Dark
function c37564030.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,4,c37564030.ovfilter,aux.Stringid(37564030,0))
	c:EnableReviveLimit()
--ctxm
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e9:SetValue(1)
	c:RegisterEffect(e9)
--tp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564030,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c37564030.destg)
	e1:SetOperation(c37564030.desop)
	--c:RegisterEffect(e1)
--lm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c37564030.aclimit)
	e2:SetCondition(c37564030.actcon)
	--c:RegisterEffect(e2)
--de
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564030,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c37564030.atkcon)
	e3:SetCost(c37564030.atkcost)
	e3:SetOperation(c37564030.atkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(c37564030.exat)
	c:RegisterEffect(e4)
end
function c37564030.exat(e,c)
	return c:GetFlagEffect(375640302)
end
function c37564030.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x770) and c:IsType(TYPE_XYZ)
end
function c37564030.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c37564030.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
end
function c37564030.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c37564030.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c37564030.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c37564030.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(37564030)==0 end
	--c:RemoveOverlayCard(tp,2,2,REASON_COST)
	c:RegisterFlagEffect(37564030,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c37564030.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ct=Duel.Draw(tp,1,REASON_EFFECT)
		if ct==0 then return end 
		local dr=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dr)
	if not (dr:IsSetCard(0x770) and dr:IsType(TYPE_MONSTER)) then return Duel.ShuffleHand(tp) end
	Duel.Hint(HINT_CARD,0,dr:GetOriginalCode())
	if dr:IsAttribute(ATTRIBUTE_LIGHT) then
		c:RegisterFlagEffect(375640302,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	if dr:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,bc) then
		if Duel.SelectYesNo(tp,aux.Stringid(37564030,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,bc)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	if dr:IsAttribute(ATTRIBUTE_WATER) then
		Duel.Recover(tp,2500,REASON_EFFECT)
	end
	if dr:IsAttribute(ATTRIBUTE_FIRE) then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
	if dr:IsAttribute(ATTRIBUTE_WIND) then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if dr:IsAttribute(ATTRIBUTE_EARTH) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c37564030.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		if Duel.SelectYesNo(tp,aux.Stringid(37564030,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c37564030.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
			   -- tc:RegisterFlagEffect(375640301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				--local e1=Effect.CreateEffect(c)
				--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				--e1:SetCode(EVENT_PHASE+PHASE_END)
				--e1:SetCountLimit(1)
				--e1:SetLabelObject(tc)
				--e1:SetCondition(c37564030.retcon)
				--e1:SetOperation(c37564030.retop)
				--e1:SetReset(RESET_PHASE+PHASE_END)
				--Duel.RegisterEffect(e1,tp)   
			end
		end
	end
	local val=dr:GetTextAttack()+dr:GetTextDefense()
		if val>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(val)
			c:RegisterEffect(e1)
		end
		Duel.ShuffleHand(tp)
	end
end
function c37564030.spfilter(c,e,tp)
	return c:IsSetCard(0x770) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c37564030.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(375640301)>0
end
function c37564030.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end