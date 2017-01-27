--アゾリウス・ヴァンガード
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992012.initial_effect(c)
	Dazz.AddTurnCheckBox(9992012)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9992012.spcon)
	e1:SetOperation(c9992012.spop)
	c:RegisterEffect(e1)
	--Airman
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c9992012.target)
	e2:SetOperation(c9992012.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Disable Effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c9992012.disop)
	c:RegisterEffect(e4)
end
c9992012.Dazz_name_Azorius=true
function c9992012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c9992012.check_box[tp][1]
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9992012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	c9992012.check_box[tp][1]=true
end
function c9992012.filter(c)
	return Dazz.IsAzorius(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9992012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9992012.check_box[tp][2]
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c9992012.filter,tp,LOCATION_DECK,0,1,nil) end
	c9992012.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9992012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9992012.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
	end
end
function c9992012.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local c=e:GetHandler()
	if not (re:IsHasType(0x7f0) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return end
	local g1=Effect.GlobalEffect()
	g1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	g1:SetCode(EVENT_CHAIN_SOLVING)
	g1:SetReset(RESET_CHAIN)
	g1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local val=e:GetLabel()
		if ev==val then
			Duel.NegateEffect(val)
		end
	end)
	g1:SetLabel(Duel.GetCurrentChain())
	Duel.RegisterEffect(g1,tp)
end