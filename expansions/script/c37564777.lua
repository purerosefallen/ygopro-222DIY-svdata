prim=prim or {}
function prim.se(c,at)
	local cd=c:GetCode()
	local cd1=cd*2
	local cd2=cd*3
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564777,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,cd)
	e1:SetCost(prim.sesscost(at))
	e1:SetTarget(prim.sesstg)
	e1:SetOperation(prim.sessop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(37564777,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,cd1)
	e2:SetCost(prim.sethcost(at))
	e2:SetTarget(prim.sethtg)
	e2:SetOperation(prim.sethop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,cd2)
	e3:SetCost(prim.secost(at))
	e3:SetOperation(prim.seop(at))
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78651105,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(prim.ntcon)
	e4:SetOperation(prim.ntop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e4:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
end
function prim.sessfilter(c,at)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x777) or c:IsAttribute(at))
end
function prim.sesscost(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sessfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),at) end
	local g=Duel.SelectMatchingCard(tp,prim.sessfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),at)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
end
function prim.sesstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function prim.sessop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end
function prim.sethfilter(c,at)
	return (c:IsSetCard(0x777) or c:IsAttribute(at)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function prim.sethcost(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sethfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),at) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,prim.sethfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),at)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
end
function prim.sethtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function prim.sethop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function prim.sefilter2(c)
	return c:IsSetCard(0x777) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function prim.sefilter3(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function prim.sefilter4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function prim.sefilter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function prim.sefilter(c,at,e,tp)
	if not (c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)) then return false end
	if c:IsSetCard(0x777) and Duel.IsExistingMatchingCard(prim.sefilter2,tp,LOCATION_DECK,0,1,nil) then return true end
	if c:IsAttribute(at) then
		if at==ATTRIBUTE_WIND and Duel.IsExistingMatchingCard(prim.sefilter3,tp,LOCATION_DECK,0,1,nil) then
			return true
		elseif at==ATTRIBUTE_FIRE and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			return true
		elseif at==ATTRIBUTE_EARTH and Duel.IsExistingMatchingCard(prim.sefilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			return true
		elseif at==ATTRIBUTE_WATER and Duel.IsExistingMatchingCard(prim.sefilter5,tp,LOCATION_DECK,0,1,nil,e,tp) then
			return true
		else
			return false
		end
	else 
		return false
	end
end
function prim.secost(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sefilter,tp,LOCATION_HAND,0,1,e:GetHandler(),at,e,tp) end
	Duel.DiscardHand(tp,prim.sefilter,1,1,REASON_COST,e:GetHandler(),at,e,tp)
	e:SetLabelObject(Duel.GetOperatedGroup():GetFirst())
end
end
function prim.seop(at)
return function(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	local at1=dc:GetAttribute()
	if dc and dc:IsSetCard(0x777) and Duel.IsExistingMatchingCard(prim.sefilter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
	if at~=at1 then return end
	if at1==ATTRIBUTE_WIND and Duel.IsExistingMatchingCard(prim.sefilter3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if at1==ATTRIBUTE_FIRE and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if at1==ATTRIBUTE_EARTH and Duel.IsExistingMatchingCard(prim.sefilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if at1==ATTRIBUTE_WATER and Duel.IsExistingMatchingCard(prim.sefilter5,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter5,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
end

function prim.ntfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function prim.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local ct=0
	if lv>4 and lv<7 then ct=1 end
	if lv>=7 then ct=2 end
	return minc==0 and ct>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsPlayerAffectedByEffect(tp,66677708) and Duel.IsExistingMatchingCard(prim.ntfilter,tp,LOCATION_REMOVED,0,ct,nil) and Duel.GetFlagEffect(tp,66677750)==0
end
function prim.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local lv=c:GetLevel()
	local ct=0
	if lv>4 and lv<7 then ct=1 end
	if lv>=7 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,prim.ntfilter,tp,LOCATION_REMOVED,0,ct,ct,nil)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,66677750,RESET_PHASE+PHASE_END,0,1)
end