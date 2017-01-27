--神天竜－ロード
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991210.initial_effect(c)
	Dazz.GodraMainCommonEffect(c,true)
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991210,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991210)
	e1:SetCost(c9991210.cost)
	e1:SetTarget(c9991210.fstarget)
	e1:SetOperation(c9991210.fsoperation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9991210,1))
	e2:SetTarget(c9991210.sptg)
	e2:SetOperation(c9991210.spop)
	c:RegisterEffect(e2)
end
c9991210.Dazz_name_Godra=true
function c9991210.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	local desc=e:GetDescription()
	Duel.Hint(HINT_OPSELECTED,1-tp,desc)
	e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+0x1fe0000+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,desc)
end
function c9991210.spfilter(c,e,tp)
	return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9991210.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991210.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c9991210.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991210.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.HintSelection(g)
		end
	end
end
function c9991210.filter1(c,e)
	return c9991210.filter1Sub(c) and not c:IsImmuneToEffect(e)
end
function c9991210.filter1Sub(c)
	return c:IsCanBeFusionMaterial() and c:IsRace(RACE_WYRM)
		and ((not c:IsLocation(LOCATION_GRAVE) and c:IsAbleToGrave()) or c:IsAbleToRemove())
end
function c9991210.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsRace(RACE_WYRM)
end
function c9991210.fstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c9991210.filter1Sub,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local res=Duel.IsExistingMatchingCard(c9991210.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9991210.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9991210.fsoperation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c9991210.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c9991210.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9991210.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local rmg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Sub(rmg)
			Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end