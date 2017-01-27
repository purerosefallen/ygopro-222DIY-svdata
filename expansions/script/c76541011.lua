--量子网络·埃莉萨
function c76541011.initial_effect(c)
	c:SetSPSummonOnce(76541011)
	--remove check
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(c76541011.rmcheck)
	c:RegisterEffect(e1)
	--self remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76541011,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c76541011.rmtarget)
	e2:SetOperation(c76541011.rmoperation)
	c:RegisterEffect(e2)
	--self special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetTarget(c76541011.sptarget)
	e3:SetOperation(c76541011.spoperation)
	c:RegisterEffect(e3)
	--xyz summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetValue(SUMMON_TYPE_XYZ)
	e4:SetCondition(c76541011.xyzcon)
	e4:SetOperation(c76541011.xyzop)
	c:RegisterEffect(e4)
end
function c76541011.rmcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetReasonEffect():GetOwner():IsSetCard(0x9d0) then
		c:RegisterFlagEffect(76541000,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c76541011.rmtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c76541011.rmoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c76541011.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(76541000)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x9d0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76541011.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetDecktopGroup(1-tp,3)
		local tc=g:GetFirst()
		if g:GetCount()~=3 or not (tc:IsAbleToGrave() and tc:IsAbleToRemove()) then return end
		local sel=0
		if tc:IsAbleToGrave() and tc:IsAbleToRemove() then
			sel=Duel.SelectOption(tp,aux.Stringid(76541011,1),aux.Stringid(76541011,2))
		elseif not tc:IsAbleToGrave() then
			sel=1
		end
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(c76541011.lmvalue)
		if sel==0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(g,REASON_EFFECT)
			e1:SetLabel(LOCATION_GRAVE)
		else
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			e1:SetLabel(LOCATION_REMOVED)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c76541011.lmvalue(e,re,tp)
	local ec=re:GetHandler()
	return ec:GetControler()~=e:GetHandlerPlayer() and ec:IsLocation(e:GetLabel())
end
function c76541011.xyzfilter(c,xyzcard)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard) and c:IsXyzLevel(xyzcard,4) and c:IsSetCard(0x9d0)
end
function c76541011.xyzfilter_kobato(c,xyzcard)
	return c76541011.xyzfilter(c,xyzcard) and c:IsHasEffect(76541004)
end
function c76541011.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if og then
		if min then
			if min>2 or max<2 then return false end
			if og:IsExists(c76541011.xyzfilter,2,nil,c) then return true end
			if min==1 and og:IsExists(c76541011.xyzfilter_kobato,1,nil,c) then return true end
			return false
		else
			local count=og:GetCount()
			if count==1 then
				return c76541011.xyzfilter_kobato(og:GetFirst(),c)
			elseif count==2 then
				return og:FilterCount(c76541011.xyzfilter,nil,c)==2
			end
			return false
		end
	end
	local tg=Duel.GetMatchingGroup(c76541011.xyzfilter,c:GetControler(),LOCATION_MZONE,0,nil,c)
	return tg:GetCount()>=2 or tg:IsExists(c76541011.xyzfilter_kobato,1,nil,c)
end
function c76541011.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=og or Duel.GetMatchingGroup(c76541011.xyzfilter,tp,LOCATION_MZONE,0,nil,c)
	if not og or min then
		local mg1=mg:Filter(c76541011.xyzfilter,nil,c)
		local mg2=mg:Filter(c76541011.xyzfilter_kobato,nil,c)
		if (not min or min<2) and (mg1:GetCount()==1 or mg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76541011,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg2:Select(tp,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg1:Select(tp,2,2,nil)
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
