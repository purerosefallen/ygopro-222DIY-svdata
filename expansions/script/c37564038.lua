--幽玄之乱
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
os=require('os')
function c37564038.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,63)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564038,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,37564038)
	e2:SetCost(senya.rmovcost(2))
	e2:SetTarget(c37564038.tdtg)
	e2:SetOperation(c37564038.tdop)
	c:RegisterEffect(e2)
end
c37564038.list={["Mon"]=LOCATION_HAND,["Tue"]=LOCATION_MZONE,["Wed"]=LOCATION_SZONE,["Thu"]=LOCATION_GRAVE,["Fri"]=LOCATION_REMOVED,["Sat"]=LOCATION_EXTRA,["Sun"]=LOCATION_DECK}
function c37564038.filter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c37564038.dtchk(tp)
	local dt=os.date("%a")
	local ar=c37564038.list[dt]
	return ar and Duel.IsExistingMatchingCard(c37564038.filter,tp,0,ar,1,nil)
end
function c37564038.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c37564038.dtchk(tp) end
end
function c37564038.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dt=os.date("%a")
	local ar=c37564038.list[dt]
	local g=Group.CreateGroup()
	if not (ar and c37564038.dtchk(tp) and c:IsRelateToEffect(e)) then return end
	if bit.band(ar,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)~=0 then
		local g1=Duel.GetMatchingGroup(c37564038.filter,tp,0,ar,nil)
		if g1:GetCount()>0 then
			if ar==LOCATION_HAND then
				g=g1:RandomSelect(tp,1)
			else
				Duel.ConfirmCards(tp,g1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				g=g1:Select(tp,1,1,nil)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		g=Duel.SelectMatchingCard(tp,c37564038.filter,tp,0,ar,1,1,nil)
	end
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if tc:IsFaceup() and tc:IsType(TYPE_SPELL+TYPE_TRAP) and ar==LOCATION_SZONE then
			tc:CancelToGrave()
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end