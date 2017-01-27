--Subterranean Rose
local m=37564054
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function cm.sfilter(c)
	return c:IsFaceup() and c:IsCanBeXyzMaterial()
end
function cm.filter(c,tg,tp)
	return Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_EXTRA,0,1,nil,tg,tc)
end
function cm.xfilter(c,tg,tc)
	return tg:IsExists(cm.mfilter,1,nil,c,tc)
end
function cm.mfilter(c,xyzc,exc)
	return c:IsCanBeXyzMaterial(xyzc) and exc:IsCanBeXyzMaterial(xyzc) and xyzc:IsXyzSummonable(Group.FromCards(c,exc),2,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tg=Duel.GetMatchingGroup(cm.sfilter,p,LOCATION_MZONE,0,nil)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		if g:IsExists(cm.filter,1,nil,tg,p) and Duel.SelectYesNo(p,37564007*16) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_XMATERIAL)
			local g1=g:FilterSelect(p,cm.filter,1,1,nil,tg,p)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local xyzc=Duel.SelectMatchingCard(p,cm.xfilter,p,LOCATION_EXTRA,0,1,1,nil,tg,g1:GetFirst()):GetFirst()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_XMATERIAL)
			local g2=tg:FilterSelect(p,cm.mfilter,1,1,nil,xyzc,g1:GetFirst())
			g1:Merge(g2)
			Duel.XyzSummon(p,xyzc,g1,2,2)
		end
	end
end