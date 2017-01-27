Dazz={}

function Dazz.AddTurnCheckBox(code)
	local m=_G["c"..code]
	if not m.check_box then
		m.check_box={}
		Dazz.EnableTurnCheckBox(function()
			m.check_box[0]={}
			m.check_box[1]={}
		end)
	end
end
function Dazz.EnableTurnCheckBox(f)
	if not Dazz.CheckBoxInitializer then
		Dazz.CheckBoxInitializer={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for i,func in pairs(Dazz.CheckBoxInitializer) do
				func()
			end
		end)
		Duel.RegisterEffect(ge1,0)
	end
	if f then
		f()
		table.insert(Dazz.CheckBoxInitializer,f)
	end
end

function Dazz.EnableMiracleCheck()
	if not Dazz.MiracleCheckBox then
		Dazz.MiracleCheckBox={}
		Dazz.EnableTurnCheckBox(function()
			Dazz.MiracleCheckBox[0]=false
			Dazz.MiracleCheckBox[1]=false
		end)
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_DRAW)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			eg:ForEach(function(tc)
				local cp=tc:GetControler()
				Dazz.MiracleCheckBox[cp]=true
			end)
		end)
		Duel.RegisterEffect(ex,0)
	end
end
function Dazz.IsMiracleEncountered(tp) --Used in condition
	return not Dazz.MiracleCheckBox[tp]
end

function Dazz.PreExile(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local t={EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_REMOVE,EFFECT_CANNOT_TO_GRAVE}
	for i,code in pairs(t) do
		local ex=e1:Clone()
		ex:SetCode(code)
		c:RegisterEffect(ex,true)
	end
	Duel.SendtoGrave(c:GetOverlayGroup(),REASON_RULE)
end
function Dazz.ExileCard(c)
	Dazz.PreExile(c)
	Duel.SendtoDeck(c,nil,-1,REASON_RULE)
	c:ResetEffect(0xfff0000,RESET_EVENT)
end
--[[function Dazz.ExileGroup(g)
	local c=g:GetFirst()
	while c do
		Dazz.PreExile(c)
		c=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,-1,REASON_RULE)
	local c=g:GetFirst()
	while c do
		c:ResetEffect(0xfff0000,RESET_EVENT)
		c=g:GetNext()
	end
end]]

--Double-faced Card
function Dazz.DFCFrontsideCommonEffect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	Dazz.EnableDFCGlobalCheck(c)
	local code=c:GetOriginalCode()
	local m=_G["c"..code]
	if not m.Dazz_DFC_Paramater then
		m.Dazz_DFC_Paramater={0,code+1}
	end
end
function Dazz.DFCBacksideCommonEffect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	Dazz.EnableDFCGlobalCheck(c)
	local code=c:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	local m=_G["c"..code]
	if not m.Dazz_DFC_Paramater then
		m.Dazz_DFC_Paramater={1,code-1}
	end
end
function Dazz.EnableDFCGlobalCheck(c)
	if not Dazz.DFCPairing then
		--create and keep couples of frontsides and backsides
		Dazz.DFCPairing={}
		Dazz.DFCStackSet=Group.CreateGroup()
		Dazz.DFCStackSet:KeepAlive()
		Dazz.DFCBackside=Group.CreateGroup()
		Dazz.DFCBackside:KeepAlive()
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(Dazz.DFCGlobalCheckOperation)
		Duel.RegisterEffect(e1,0)
	end
	Dazz.DFCStackSet:AddCard(c)
end
function Dazz.DFCGlobalCheckOperation(e,tp,eg,ep,ev,re,r,rp)
	--create and keep couples of frontsides and backsides
	if Dazz.DFCStackSet:GetCount()~=0 then
		local tc=Dazz.DFCStackSet:GetFirst()
		while tc do
			local token=Dazz.DFCPairing[tc]
			if not token then
				token=Duel.CreateToken(tc:GetOwner(),tc.Dazz_DFC_Paramater[2])
				Dazz.DFCPairing[tc]=token
				Dazz.DFCPairing[token]=tc
				if tc.Dazz_DFC_Paramater[1]==0 then
					Dazz.DFCBackside:AddCard(token)
				else
					Dazz.DFCBackside:AddCard(tc)
				end
			end
			tc=Dazz.DFCStackSet:GetNext()
		end
		Dazz.DFCStackSet:Clear()
	end
	--transform backsides that should be filped back
	local g=Dazz.DFCBackside:Filter(function(c)
		return c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
			or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())
			or (c:IsLocation(LOCATION_EXTRA) and c:IsFacedown())
	end,nil)
	if g:GetCount()~=0 then
		local sfd,sfh={[0]=false,[1]=false},{[0]=false,[1]=false}
		local tc=g:GetFirst()
		while tc do
			local loc=tc:GetLocation()
			local fu=tc:IsFaceup()
			local controller=tc:GetControler()
			local token=Dazz.DFCTransformExecute(tc)
			if loc==LOCATION_DECK then
				Duel.SendtoDeck(token,controller,2,REASON_RULE)
				sfd[controller]=true
			elseif loc==LOCATION_HAND then
				Duel.SendtoHand(token,controller,REASON_RULE)
				sfh[controller]=true
			elseif loc==LOCATION_GRAVE then
				Duel.SendtoGrave(token,REASON_RULE)
			elseif loc==LOCATION_REMOVED then
				Duel.Remove(token,POS_FACEUP,REASON_RULE)
			elseif loc==LOCATION_EXTRA then
				Duel.SendtoDeck(token,controller,0,REASON_RULE)
			end
			tc=g:GetNext()
		end
		for i=0,1 do
			if sfd[i] then Duel.ShuffleDeck(i) end
			if sfh[i] then Duel.ShuffleHand(i) end
		end
	end
end
--[[This function tells you whether "sp_player" can special summon the transform target.
	If "sp_player" is nill or transform target isn't a monster, tells whether it's a double-faced. 
	"..." provides extra paramaters for Duel.IsPlayerCanSpecialSummonMonster.]]
function Dazz.DFCTransformable(c,sp_player,...)
	local param=c.Dazz_DFC_Paramater
	if not param then return false end
	if not sp_player then return true end
	local token=Dazz.DFCPairing[c]
	if not token:IsType(TYPE_MONSTER) then return true end
	return Duel.IsPlayerCanSpecialSummonMonster(sp_player,token:GetOriginalCode(),0,
		token:GetOriginalType(),token:GetTextAttack(),token:GetTextDefense(),
		math.max(token:GetOriginalLevel(),token:GetOriginalRank()),token:GetOriginalRace(),
		token:GetOriginalAttribute(),...)
end
--[[This function executes double-faced card "c" transforming.]]
function Dazz.DFCTransformExecute(c)
	if not c.Dazz_DFC_Paramater then return end
	Dazz.ExileCard(c)
	local token=Dazz.DFCPairing[c]
	return token
end

--Xyz Procedure, "minc-maxc" monsters fit "func"
function Dazz.AddXyzProcedureLevelFree(c,func,minc,maxc)
	local maxc=maxc or minc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Dazz.XyzProcedureLevelFreeCondition(func,minc,maxc))
	e1:SetOperation(Dazz.XyzProcedureLevelFreeOperation(func,minc,maxc))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Dazz.XyzProcedureLevelFreeFilter(c,xyzcard,func)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard) and (not func or func(c,xyzcard))
end
function Dazz.XyzProcedureLevelFreeCondition(func,minc,maxc)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc,maxc=minc,maxc
		if og then
			if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
		return og:IsExists(Dazz.XyzProcedureLevelFreeFilter,minc,nil,c,func)
			else
		local count=og:GetCount()
		return count>=minc and count<=maxc
			and og:FilterCount(Dazz.XyzProcedureLevelFreeFilter,nil,c,func)==count
			end
		end
		return Duel.IsExistingMatchingCard(Dazz.XyzProcedureLevelFreeFilter,tp,LOCATION_MZONE,0,minc,nil,c,func)
	end
end
function Dazz.XyzProcedureLevelFreeOperation(func,minc,maxc)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local mg=og or Duel.GetMatchingGroup(Dazz.XyzProcedureLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,func)
		if not og or min then
			local minc,maxc=minc,maxc
			if min then minc,maxc=math.max(minc,min),math.min(maxc,max) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg:Select(tp,minc,maxc,nil)
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
end

--Xyz Procedure, "minc1" level "lv" monsters fit "func" + "minc2-maxc2" level "lv" monsters
function Dazz.AddXyzProcedureDoubleStandarded(c,lv,func,minc1,minc2,maxc2)
	local maxc2=maxc2 or minc2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Dazz.XyzProcedureDoubleStandardedCondition(func,lv,minc1,minc2,maxc2))
	e1:SetOperation(Dazz.XyzProcedureDoubleStandardedOperation(func,lv,minc1,minc2,maxc2))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Dazz.XyzProcedureDoubleStandardedFilter1(c,xyzcard,lv)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard) and c:IsXyzLevel(xyzcard,lv)
end
function Dazz.XyzProcedureDoubleStandardedCondition(func,lv,minc1,minc2,maxc2)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc,maxc=minc1+minc2,minc1+maxc2
		local mg=nil
		if og then
			if min then
				if min>minc then minc=min end
				if max<maxc then maxc=max end
				if minc>maxc then return false end
			else
				local count=og:GetCount()
				return count>=minc and count<=maxc
					and og:FilterCount(Dazz.XyzProcedureDoubleStandardedFilter1,nil,c,lv)==count
					and og:IsExists(func,minc1,nil,c)
			end
			mg=og:Filter(Dazz.XyzProcedureDoubleStandardedFilter1,nil,c,lv)
		else
			mg=Duel.GetMatchingGroup(Dazz.XyzProcedureDoubleStandardedFilter1,c:GetControler(),LOCATION_MZONE,0,nil,c,lv)
		end
		return mg:GetCount()>=minc and mg:IsExists(func,minc1,nil,c)
	end
end
function Dazz.XyzProcedureDoubleStandardedOperation(func,lv,minc1,minc2,maxc2)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local mg=og or Duel.GetMatchingGroup(Dazz.XyzProcedureDoubleStandardedFilter1,tp,LOCATION_MZONE,0,nil,c,lv)
		local minc,maxc=minc1+minc2,minc1+maxc2
		if not og or min then
			if min then mg=og:Filter(Dazz.XyzProcedureDoubleStandardedFilter1,nil,c,lv) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg1=mg:FilterSelect(tp,func,minc1,minc1,nil,c)
			mg:Sub(mg1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=mg:Select(tp,minc2,maxc2,nil)
			mg:Merge(mg1)
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
end

--Godra Module
function Dazz.GodraMainCommonEffect(c,nolimit)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(Dazz.GodraMainProcCondition)
	e1:SetOperation(Dazz.GodraMainProcOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	if nolimit then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	e3:SetCondition(Dazz.GodraMainXyzLimitCondition)
	c:RegisterEffect(e3)
end
function Dazz.GodraMainProcCondition(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Dazz.GodraMainGraveCostFilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function Dazz.GodraMainProcOperation(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Dazz.GodraMainGraveCostFilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function Dazz.GodraMainXyzLimitCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function Dazz.GodraMainGraveCostFilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function Dazz.GodraMainFuseEffectCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Dazz.GodraMainFuseEffectConditionFilter,1,nil,e:GetHandler())
end
function Dazz.GodraMainFuseEffectConditionFilter(c,mc)
	local mg=c:GetMaterial()
	return mg and mg:IsContains(mc) and Dazz.IsGodra(c) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function Dazz.GodraExtraCommonEffect(c,code,fusattr)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		local lmcode=9991200
		if c:IsType(TYPE_SYNCHRO) then lmcode=lmcode+1 end
		if c:IsType(TYPE_XYZ) then lmcode=lmcode+2 end
		c:SetSPSummonOnce(lmcode)
		c:EnableReviveLimit()
		if fusattr then
			aux.AddFusionProcFun2(c,Dazz.GodraExtraFusionFilter,aux.FilterBoolFunction(Card.IsAttribute,fusattr),true)
		end
	end
	if not code then return end
	Dazz.AddTurnCheckBox(code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,code)
	e1:SetCondition(Dazz.GodraExtraReviveCondition)
	e1:SetTarget(Dazz.GodraExtraReviveTarget)
	e1:SetOperation(Dazz.GodraExtraReviveOperation)
	c:RegisterEffect(e1)
end
function Dazz.GodraExtraFusionFilter(c)
	return Dazz.IsGodra(c,Card.GetFusionCode)
end
function Dazz.GodraExtraReviveFilter(c,e,tp)
	return Dazz.IsGodra(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function Dazz.GodraExtraReviveConditionFilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function Dazz.GodraExtraReviveCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Dazz.GodraExtraReviveConditionFilter,1,e:GetHandler(),tp)
end
function Dazz.GodraExtraReviveTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Dazz.GodraExtraReviveFilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function Dazz.GodraExtraReviveOperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Dazz.GodraExtraReviveFilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
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
	
--Simulated Setcodes
function Dazz.SimulatedSetCodeCore(c,f,v,str,...)
	local f=f
	if type(f)~="function" then f=Card.GetCode end
	local t={f(c)}
	for i,code in pairs(t) do
		if Dazz.IsCodeBeSimulatedSetCard(code,v,str,...) then return true end
	end
	return false
end
function Dazz.IsCodeBeSimulatedSetCard(code,v,str,...)
	for i,code2 in ipairs{...} do
		if code==code2 then return true end
	end
	local m=_G["c"..code]
	local val=false
	if m then
		val=m["Dazz_name_"..str]
	else
		_G["c"..code]={}
		if not (pcall(function() dofile("expansions/script/c"..code..".lua") end)
			or pcall(function() dofile("script/c"..code..".lua") end)) then
			_G["c"..code]=nil
			return false
		else
			val=_G["c"..code]["Dazz_name_"..str]
			_G["c"..code]=nil
		end
	end
	return val and (not v or val==v)
end
function Dazz.IsGodra(c,f,v)
	return Dazz.SimulatedSetCodeCore(c,f,v,"Godra")
end
function Dazz.IsAzorius(c,f,v)
	return Dazz.SimulatedSetCodeCore(c,f,v,"Azorius")
end