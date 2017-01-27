--量子网络·意志之力
function c76541007.initial_effect(c)
	c:SetSPSummonOnce(76541007)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--rank up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c76541007.condition)
	e2:SetCost(c76541007.cost)
	e2:SetTarget(c76541007.target)
	e2:SetOperation(c76541007.operation)
	c:RegisterEffect(e2)
	local xg=Group.CreateGroup()
	xg:KeepAlive()
	e2:SetLabelObject(xg)
end
function c76541007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c76541007.tgfilter1(c,e,tp,xyzcard)
	return c:IsFaceup() and c:IsSetCard(0x9d0) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and c:IsCanBeXyzMaterial(xyzcard)
end
function c76541007.tgfilter2(c)
	return c:IsSetCard(0x9d0) and c:IsAbleToRemove()
end
function c76541007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,76541007)==0 end
	Duel.RegisterFlagEffect(tp,76541007,RESET_CHAIN,0,1)
end
function c76541007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
		and Duel.IsExistingTarget(c76541007.tgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
		and Duel.IsExistingTarget(c76541007.tgfilter2,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local xg=Duel.SelectTarget(tp,c76541007.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(xg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectTarget(tp,c76541007.tgfilter2,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,4,0,0)
end
function c76541007.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g1=g1:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsAbleToRemove,nil)
	if g1:GetCount()<=0 then
		return
	else
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) then return end
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
		Duel.Overlay(c,mg)
	end
	c:SetMaterial(Group.FromCards(tc))
	Duel.Overlay(c,Group.FromCards(tc))
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
	c:CompleteProcedure()
	Duel.BreakEffect()
	Duel.Hint(HINT_CARD,0,76541007)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end