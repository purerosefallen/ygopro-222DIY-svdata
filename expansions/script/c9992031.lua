--アゾリウス・レザルーター
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992031.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c9992031.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c9992031.condition)
	e2:SetTarget(c9992031.target)
	e2:SetOperation(c9992031.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
c9992031.Dazz_name_Azorius=true
function c9992031.valcheck(e,c)
	if c:GetMaterial():IsExists(Dazz.IsAzorius,1,nil) then e:SetLabel(100) else e:SetLabel(0) end
end
function c9992031.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ADVANCE and e:GetLabelObject():GetLabel()==100
end
function c9992031.filter(c)
	return Dazz.IsAzorius(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9992031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9992031.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9992031.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9992031.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	local lab=Duel.GetTurnCount()
	if Duel.GetTurnPlayer()~=tp then lab=lab+1 end
	e1:SetLabel(lab)
	e1:SetCondition(function(e)
		return Duel.GetTurnCount()-e:GetLabel()==1
	end)
	e1:SetTarget(function(e,c)
		return c:IsLevelBelow(4) or c:IsRankBelow(4)
	end)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end