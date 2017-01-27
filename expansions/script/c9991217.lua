--神天竜王－ナイヒリティー
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991217.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c)
	--Fusion
	aux.AddFusionProcFunRep(c,Dazz.GodraExtraFusionFilter,3,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Fusion Success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9991217.condition)
	e2:SetOperation(c9991217.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetLabelObject(e2)
	e3:SetValue(c9991217.checkval)
	c:RegisterEffect(e3)
	--To Deck
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ex1:SetTargetRange(0xff,0xff)
	ex1:SetValue(LOCATION_DECKBOT)
	ex1:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer()
	end)
	c:RegisterEffect(ex1)
	local ex2=ex1:Clone()
	ex2:SetCode(EFFECT_CANNOT_TO_GRAVE)
	ex2:SetTargetRange(0,LOCATION_DECK+LOCATION_EXTRA)
	ex2:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer() and (c:IsLocation(LOCATION_DECK)
			or (c:IsLocation(LOCATION_EXTRA) and bit.band(c:GetOriginalType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)~=0))
	end)
	c:RegisterEffect(ex2)
end
c9991217.Dazz_name_Godra=true
function c9991217.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and e:GetLabel()==100
end
function c9991217.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetMatchingGroupCount(function(c)
		return c:IsFaceup() and c:IsRace(RACE_WYRM)
	end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*300
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--activation lock
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9991217.checkval(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=0 then
		e:GetLabelObject():SetLabel(100)
	else
		e:GetLabelObject():SetLabel(0)
	end
end