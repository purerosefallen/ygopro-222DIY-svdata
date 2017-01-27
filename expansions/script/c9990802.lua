--断崖の避難所
function c9990802.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9990802.recovtg)
	e1:SetOperation(c9990802.recovop)
	c:RegisterEffect(e1)
	--Recover 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9990802,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp
			and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_ONFIELD,0,3,nil)
	end)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetFlagEffect(9990802)==0 end
		c:RegisterFlagEffect(9990802,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	end)
	e2:SetTarget(c9990802.recovtg)
	e2:SetOperation(c9990802.recovop)
	c:RegisterEffect(e2)
	--Remove Card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9990802,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(function(e,tp)
		return Duel.GetLP(tp)>=11000
	end)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsAbleToGraveAsCost() and Duel.CheckLPCost(tp,3000)
			and c:GetFlagEffect(9990802)==0 end
		Duel.PayLPCost(tp,3000)
		Duel.SendtoGrave(c,REASON_COST)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e3)
end
function c9990802.recovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c9990802.recovop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Recover(tp,1000,REASON_EFFECT)
end