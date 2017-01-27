--3L·紧闭的恋之瞳
local m=37564826
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.setreg(c,m,37564800)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(cm.lfuscon)
	e1:SetOperation(cm.lfusop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
cm.custom_ctlm_3L=2
function cm.lfuscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=senya.lfusfilter
	local f2=cm.fusf
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		local fs=(chkf==PLAYER_NONE or aux.FConditionCheckF(gc,chkf))
		return (f1(gc) and mg:IsExists(senya.lchkffilter,1,gc,f2,chkf,fs)) or (f2(gc) and mg:IsExists(senya.lchkffilter,1,gc,f1,chkf,fs))
	end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end
end
function cm.lfusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=senya.lfusfilter
	local f2=cm.fusf
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		local fs=(chkf==PLAYER_NONE or aux.FConditionCheckF(gc,chkf))
		local sg=Group.CreateGroup()
		if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:FilterSelect(tp,senya.lchkffilter,1,1,nil,nil,chkf,fs)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=f1(tc1)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
	if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function cm.fusf(c)
	return c:IsHasEffect(37564800) and senya.tpf(c,TYPE_FUSION) and not c:IsHasEffect(6205579)
end