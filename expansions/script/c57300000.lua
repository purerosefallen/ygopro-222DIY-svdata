miyuki=miyuki or {}
miyuki.setchk=miyuki.setchk or {}
function miyuki.setreg(c,cd,setcd)   
	if not miyuki.setchk[cd] then
		miyuki.setchk[cd]=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ex:SetCode(setcd)
		ex:SetTargetRange(0xff,0xff)
		ex:SetTarget(aux.TargetBoolFunction(Card.IsCode,cd))
		Duel.RegisterEffect(ex,0)
	end
end
function miyuki.sgreg(c,setcd)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(setcd)
	c:RegisterEffect(e1)
end
function miyuki.rxyz1(c,rk,f)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(miyuki.xyzcon1(rk,f))
	e1:SetOperation(miyuki.xyzop1(rk,f))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function miyuki.mfilter(c,xyzc,rk,f)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc) and (not rk or c:GetRank()==rk) and (not f or f(c))
end
function miyuki.xyzfilter1(c,g,ct)
	return g:IsExists(miyuki.xyzfilter2,ct,c,c:GetRank())
end
function miyuki.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function miyuki.xyzcon1(rk,f)
return function(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(miyuki.mfilter,nil,c,rk,f)
	else
		mg=Duel.GetMatchingGroup(miyuki.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f)
	end
	return maxc>=2 and mg:IsExists(miyuki.xyzfilter1,1,nil,mg,ct)
end
end
function miyuki.xyzop1(rk,f)
return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(miyuki.mfilter,nil,c,rk,f)
		else
			mg=Duel.GetMatchingGroup(miyuki.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=2
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,miyuki.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,miyuki.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
end

function miyuki.rxyz2(c,rk,f,ct)
	if not ct then ct=2 end
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(miyuki.xyzcon2(rk,f,ct))
	e1:SetOperation(miyuki.xyzop2(rk,f,ct))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--reborn for mokou
function miyuki.xyzcon2(rk,f,ct)
return function(e,c,og)
	local lct=ct-1
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(miyuki.mfilter,nil,c,rk,f)
	else
		mg=Duel.GetMatchingGroup(miyuki.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f)
	end
	local lm=0-ct
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>lm
		and mg:IsExists(miyuki.xyzfilter1,lct,nil,mg,lct)
end
end
function miyuki.xyzop2(rk,f,ct)
return function(e,tp,eg,ep,ev,re,r,rp,c,og)
	local lct=ct-1
	local g=nil
	local sg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=Duel.GetMatchingGroup(miyuki.mfilter,tp,LOCATION_MZONE,0,nil,c,rk,f)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,miyuki.xyzfilter1,1,1,nil,mg,lct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,miyuki.xyzfilter2,lct,lct,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
		local tc=g:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=g:GetNext()
		end
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
end
function miyuki.serlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function miyuki.neg(c,lmct,lmcd,cost,excon,exop,loc,force)
	local e3=Effect.CreateEffect(c)
	loc=loc or LOCATION_MZONE
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	if force then
		e3:SetType(EFFECT_TYPE_QUICK_F)
	else
		e3:SetType(EFFECT_TYPE_QUICK_O)
	end
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(lmct,lmcd)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(loc)
	e3:SetCondition(miyuki.negcon(excon))
	if cost then e3:SetCost(cost) end
	e3:SetTarget(miyuki.negtg)
	e3:SetOperation(miyuki.negop(exop))
	c:RegisterEffect(e3)
end
function miyuki.negcon(excon)
return function(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
end
end
function miyuki.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function miyuki.negop(exop)
return function(e,tp,eg,ep,ev,re,r,rp)
	local chk=Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if chk and exop then
		exop(e,tp,eg,ep,ev,re,r,rp)
	end
end
end
function miyuki.negtrap(c,lmct,lmcd,cost,excon,exop)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(lmct,lmcd)
	e1:SetCondition(miyuki.negcon(excon))
	if cost then e1:SetCost(cost) end
	e1:SetTarget(miyuki.negtg)
	e1:SetOperation(miyuki.negop(exop))
	c:RegisterEffect(e1)
end
function miyuki.ens(c,cd)
	miyuki.setreg(c,cd,57310000)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e1)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57300000,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(miyuki.enssumcon)
	e4:SetTarget(miyuki.enssumtg)
	e4:SetOperation(miyuki.enssumop)
	c:RegisterEffect(e4)
end
function miyuki.enssumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function miyuki.enssumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function miyuki.enssumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end
function miyuki.ensfilter(c,cd)
	return c:IsHasEffect(57310000) and not c:IsCode(cd)
end
function miyuki.ensop(cd)
return function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(miyuki.ensfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,cd) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(57300000,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,miyuki.ensfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cd)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		end
	end
end
end