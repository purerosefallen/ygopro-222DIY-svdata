--量子网络·心之所欲
function c76541005.initial_effect(c)
	c:SetSPSummonOnce(76541005)
	--remove check
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(c76541005.rmcheck)
	c:RegisterEffect(e1)
	--self remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76541005,6))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c76541005.multicost)
	e2:SetTarget(c76541005.rmtarget)
	e2:SetOperation(c76541005.rmoperation)
	c:RegisterEffect(e2)
	--self special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetTarget(c76541005.sptarget)
	e3:SetOperation(c76541005.spoperation)
	c:RegisterEffect(e3)
	--xyz summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetValue(SUMMON_TYPE_XYZ)
	e4:SetCondition(c76541005.xyzcon)
	e4:SetOperation(c76541005.xyzop)
	c:RegisterEffect(e4)
	--multiple
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c76541005.sumsuc)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(76541005,7))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(TIMING_END_PHASE)
	e6:SetCost(c76541005.multicost)
	e6:SetTarget(c76541005.multitarget)
	e6:SetOperation(c76541005.multioperation)
	c:RegisterEffect(e6)
end
function c76541005.rmcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetReasonEffect():GetOwner():IsSetCard(0x9d0) then
		c:RegisterFlagEffect(76541000,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c76541005.rmtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c76541005.rmoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c76541005.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(76541000)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x9d0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76541005.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76541005,2))
			local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0x9d0)
			Duel.Overlay(c,sg)
		end
	end
end
function c76541005.xyzfilter(c,xyzcard)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard) and c:IsXyzLevel(xyzcard,4)
end
function c76541005.xyzfilter_kobato(c,xyzcard)
	return c76541005.xyzfilter(c,xyzcard) and c:IsHasEffect(76541004)
end
function c76541005.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if og then
		if min then
			if min>3 or max<3 then return false end
			if og:IsExists(c76541005.xyzfilter,3,nil,c) then return true end
			if min==2 then
				local tg=og:Filter(c76541005.xyzfilter,nil,c)
				if tg:GetCount()>=2 and tg:IsExists(c76541005.xyzfilter_kobato,1,nil,c) then return true end
			end
			return false
		else
			local count=og:GetCount()
			if count==2 then
				return og:FilterCount(c76541005.xyzfilter,nil,c)==2 and og:IsExists(c76541005.xyzfilter_kobato,1,nil,c)
			elseif count==3 then
				return og:FilterCount(c76541005.xyzfilter,nil,c)==3
			end
			return false
		end
	end
	local tg=Duel.GetMatchingGroup(c76541005.xyzfilter,c:GetControler(),LOCATION_MZONE,0,nil,c)
	if tg:GetCount()<2 then return false end
	return tg:GetCount()>=3 or tg:IsExists(c76541005.xyzfilter_kobato,1,nil,c)
end
function c76541005.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=og or Duel.GetMatchingGroup(c76541005.xyzfilter,tp,LOCATION_MZONE,0,nil,c)
	if not og or min then
		local mg1=mg:Filter(c76541005.xyzfilter,nil,c)
		local mg2=mg:Filter(c76541005.xyzfilter_kobato,nil,c)
		if (not min or min<3) and (mg1:GetCount()==2 or mg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76541005,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tg=mg2:Select(tp,1,1,nil)
			mg1:Sub(tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg1:Select(tp,1,1,nil)
			mg:Merge(tg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg1:Select(tp,3,3,nil)
		end
	end
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
function c76541005.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(76541005,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(76541005,1))
end
function c76541005.multicost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(1)==0 end
	c:RegisterFlagEffect(1,RESET_CHAIN,0,1)
end
function c76541005.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c76541005.multitarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsPlayerCanDraw(tp,1)
		or Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(c76541005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil))
		and c:GetOverlayGroup():FilterCount(Card.IsAbleToRemove,nil)>0 and c:GetFlagEffect(76541005)>0 end
end
function c76541005.multioperation(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	if og:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		og=og:Select(tp,1,1,nil)
	end
	Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
	local v={
		Duel.IsPlayerCanDraw(tp,1),
		Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil),
		Duel.IsExistingMatchingCard(c76541005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	}
	if not v[1] and not v[2] and not v[3] then return end
	Duel.BreakEffect()
	local selt={tp}
	local keyt={}
	for i=1,3 do
		if v[i] then
			table.insert(selt,aux.Stringid(76541005,i+2))
			table.insert(keyt,i)
		end
	end
	local sel=keyt[Duel.SelectOption(table.unpack(selt))+1]
	if sel==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(hg)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local hg=Duel.SelectMatchingCard(tp,c76541005.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(hg)
		Duel.Destroy(hg,REASON_EFFECT)
	end
end