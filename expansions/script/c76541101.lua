--神镜小鸠
function c76541101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c76541101.acttg)
	e1:SetOperation(c76541101.actop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(76541101,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c76541101.sptarget)
	e2:SetOperation(c76541101.spoperation)
	c:RegisterEffect(e2)
	--to deck
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(76541101,1))
	e3:SetTarget(c76541101.tdtarget)
	e3:SetOperation(c76541101.tdoperation)
	c:RegisterEffect(e3)
	--to hand
	local e4=e2:Clone()
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(76541101,2))
	e4:SetHintTiming(0,0)
	e4:SetTarget(c76541101.thtarget)
	e4:SetOperation(c76541101.thoperation)
	c:RegisterEffect(e4)
	if not c76541101.check_box then
		c76541101.check_box={}
		c76541101.check_box[0]={}
		c76541101.check_box[1]={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c76541101.check_box[0]={}
			c76541101.check_box[1]={}
		end)
		Duel.RegisterEffect(ge1,0)
	end
end
function c76541101.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local v={
		true,
		c76541101.sptarget(e,tp,eg,ep,ev,re,r,rp,0),
		c76541101.tdtarget(e,tp,eg,ep,ev,re,r,rp,0),
	}
	local selt={tp,aux.Stringid(76541101,3)}
	local keyt={1}
	for i=2,3 do
		if v[i] then
			table.insert(selt,aux.Stringid(76541101,i-2))
			table.insert(keyt,i)
		end
	end
	local sel=keyt[Duel.SelectOption(table.unpack(selt))+1]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(0)
		e:SetDescription(0)
		return
	end
	if sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetDescription(aux.Stringid(76541101,0))
		c76541101.sptarget(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if sel==3 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetDescription(aux.Stringid(76541101,1))
		c76541101.tdtarget(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c76541101.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==2 then c76541101.spoperation(e,tp,eg,ep,ev,re,r,rp) end
	if sel==3 then c76541101.tdoperation(e,tp,eg,ep,ev,re,r,rp) end
end
function c76541101.base_cost(e,tp,chk,flag)
	if chk==0 then return e:GetHandler():GetFlagEffect(1)==0 and not c76541101.check_box[tp][flag] end
	c76541101.check_box[tp][flag]=true
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+0x1fe0000+RESET_CHAIN+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,e:GetDescription())
end
function c76541101.base_filter(c)
	return c.mikagami_kobato
end
function c76541101.spfilter(c,e,tp)
	return c.mikagami_kobato and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76541101.spcfilter(c)
	return c:IsAbleToGraveAsCost() and (c.mikagami_kobato or c:IsSetCard(0x9d0))
end
function c76541101.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local loc=LOCATION_HAND+LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then loc=LOCATION_MZONE end
	local c=e:GetHandler()
	if chk==0 then
		return c76541101.base_cost(e,tp,chk,1)
			and Duel.IsExistingMatchingCard(c76541101.spcfilter,tp,loc,0,1,nil)
			and Duel.IsExistingMatchingCard(c76541101.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	c76541101.base_cost(e,tp,chk,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76541101.spcfilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76541101.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if dg:GetCount()==0 then return end
	local sg=dg:Filter(c76541101.base_filter,nil)
	if sg:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dg:GetCount())
		Duel.ShuffleDeck(tp)
		return
	end
	if sg:GetCount()<3 then
		Duel.ConfirmDecktop(tp,dg:GetCount())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,1,1,nil)
	else
		local sg2=Group.CreateGroup()
		local rvc=0
		for i=1,3 do
			local tg=sg:GetMaxGroup(Card.GetSequence)
			sg2:Merge(tg)
			sg:Sub(tg)
			rvc=dg:GetCount()-tg:GetFirst():GetSequence()
		end
		Duel.ConfirmDecktop(tp,rvc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg2:Select(tp,1,1,nil)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(sg,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
end
function c76541101.tdfilter(c)
	return c.mikagami_kobato and c:IsAbleToDeck()
end
function c76541101.tdtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c76541101.base_cost(e,tp,chk,2)
		and Duel.IsExistingMatchingCard(c76541101.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	c76541101.base_cost(e,tp,chk,2)
end
function c76541101.tdoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c76541101.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g=g:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	local draw=false
	if g:GetFirst():IsLocation(LOCATION_MZONE) then draw=true end
	if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)==0 then return end
	if draw then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c76541101.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c76541101.base_cost(e,tp,chk,3)
		and e:GetHandler():IsAbleToHand() end
	c76541101.base_cost(e,tp,chk,3)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c76541101.thoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end