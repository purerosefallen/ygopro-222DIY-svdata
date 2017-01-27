--幻影龍魂（ワイラム・フュージョン）
function c9990705.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990705+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9990705.cost)
	e1:SetTarget(c9990705.target)
	e1:SetOperation(c9990705.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9990705,ACTIVITY_SPSUMMON,c9990705.counterfilter)
end
function c9990705.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c9990705.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9990705,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
		return c:IsLocation(LOCATION_EXTRA) and bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
	end)
	Duel.RegisterEffect(e1,tp)
end
function c9990705.filter1(c,e)
	return c9990705.filter1Sub(c) and not c:IsImmuneToEffect(e)
end
function c9990705.filter1Sub(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsRace(RACE_WYRM)
end
function c9990705.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9990705.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c9990705.filter1Sub,tp,0x16,0,nil)
		local res=Duel.IsExistingMatchingCard(c9990705.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9990705.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990705.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c9990705.filter1,tp,0x16,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c9990705.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil local sg2=nil local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then local fgroup=ce:GetTarget() mg2=fgroup(ce,e,tp) local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9990705.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf) end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone() if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil) local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			if bit.band(Duel.GetCurrentPhase(),0xf8)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(9990705,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation() fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end