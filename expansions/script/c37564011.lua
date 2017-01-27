--元素掌握者·Ayane
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c37564011.initial_effect(c)
	--xyz summon
	senya.rxyz1(c,4,nil,2,63)
	--不会成为攻击效果对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37564011.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c37564011.con)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
		--吸收素材
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564011,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37560011)
	e3:SetTarget(c37564011.target)
	e3:SetOperation(c37564011.operation)
	c:RegisterEffect(e3)
	--特招
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37564011,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,37564011)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c37564011.thcon)
	e4:SetOperation(c37564011.operation2)
	c:RegisterEffect(e4)
end
function c37564011.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:GetOriginalRank()==4
end
function c37564011.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c37564011.cfilter2,1,nil)
end
function c37564011.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()==4
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c37564011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c37564011.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c37564011.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c37564011.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler(),tp)
end
function c37564011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c37564011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c37564011.filter7,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c37564011.filter7(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c37564011.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=e:GetHandler():GetOverlayGroup()
	local sg=g1:Filter(c37564011.filter7,nil,e,tp)
	if ft==0 or sg==0  then return end
	local mg=sg:Select(tp,ft,ft,nil)
	local fid=e:GetHandler():GetFieldID()
	local tc=mg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(37564011,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		  e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		  e2:SetValue(1)
		  e2:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e2,true)
			tc:CompleteProcedure()
		tc=mg:GetNext()
	end
	Duel.SpecialSummonComplete()
	mg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(mg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c37564011.retop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(mg)
	e2:SetOperation(c37564011.desop)
	e:GetHandler():RegisterEffect(e2,true)
end
function c37564011.retfilter(c,fid)
	return c:GetFlagEffectLabel(37564011)==fid
end
function c37564011.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tg=g:Filter(c37564011.retfilter,nil,e:GetLabel())
	local tc=tg:GetFirst()
	if c:IsFaceup() then
		while tc do
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		tc=tg:GetNext()
		end
	end
end
function c37564011.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tg=g:Filter(c37564011.retfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end