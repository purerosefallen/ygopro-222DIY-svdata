--神天竜－ゴールド
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991206.initial_effect(c)
	Dazz.GodraMainCommonEffect(c)
	Dazz.AddTurnCheckBox(9991206)
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9991206.fstarget)
	e1:SetOperation(c9991206.fsoperation)
	c:RegisterEffect(e1)
	--Recycle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c9991206.tdtg)
	e2:SetOperation(c9991206.tdop)
	c:RegisterEffect(e2)
end
c9991206.Dazz_name_Godra=true
function c9991206.tdfilter(c)
	return c:IsFaceup() and Dazz.IsGodra(c) and c:IsAbleToDeck()
end
function c9991206.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not c9991206.check_box[tp][2]
		and e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c9991206.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	c9991206.check_box[tp][2]=true
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9991206.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c9991206.tdfilter,tp,LOCATION_REMOVED,0,2,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9991206.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.HintSelection(g)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	if Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
		Duel.ShuffleDeck(tp)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c9991206.filter1(c,e)
	return c9991206.filter1Sub(c) and not c:IsImmuneToEffect(e)
end
function c9991206.filter1Sub(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsRace(RACE_WYRM)
end
function c9991206.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf) and Dazz.IsGodra(c)
end
function c9991206.fstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if c9991206.check_box[tp][1] then return false end
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c9991206.filter1Sub,tp,0x36,0,nil)
		local res=Duel.IsExistingMatchingCard(c9991206.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9991206.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	c9991206.check_box[tp][1]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9991206.fsoperation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c9991206.filter1,tp,0x36,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c9991206.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c24094653.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local cn1=mat1:Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(Card.IsFacedown,nil)
			local cn2=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND)
			local gr=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
			local gr2=mat1:Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(Card.IsFaceup,nil)
			gr:Merge(gr2)
			if gr:GetCount()~=0 then Duel.HintSelection(gr) end
			if cn1:GetCount()~=0 then Duel.ConfirmCards(tp,cn1) Duel.ConfirmCards(1-tp,cn1) end
			if cn2:GetCount()~=0 then Duel.ConfirmCards(1-tp,cn2) end
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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