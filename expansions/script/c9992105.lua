--Jace, Vryn's Prodigy
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9992105.initial_effect(c)
	Dazz.DFCFrontsideCommonEffect(c)
	c:EnableReviveLimit()
	--Activate Limit
	local ex=Effect.CreateEffect(c)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_SPSUMMON_SUCCESS)
	ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9992105,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabelObject(e1)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCondition(function(e,tp)
			return Duel.GetTurnPlayer()==tp
		end)
		e2:SetOperation(function(e)
			e:GetLabelObject():Reset()
			e:Reset()
		end)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end)
	c:RegisterEffect(ex)
	--Transform
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x1e0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or Duel.ChangePosition(c,POS_FACEUP_DEFENSE)==0 then return false end
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local hg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
			if hg:GetCount()~=0 then
				if hg:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
					hg=hg:Select(tp,1,1,nil)
				end
				Duel.SendtoGrave(hg,REASON_DISCARD+REASON_EFFECT)
			end
		end
		if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=5 and Dazz.DFCTransformable(c,tp) then
			local token=Dazz.DFCTransformExecute(c,true)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end)
	c:RegisterEffect(e1)
end
c9992105.Dazz_name_Azorius=true