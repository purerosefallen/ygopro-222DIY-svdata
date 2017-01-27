--神天竜－ストーム
if not Dazz and not pcall(function() require("expansions/script/c9990000") end) then pcall(function() require("script/c9990000") end) end
function c9991212.initial_effect(c)
	Dazz.GodraExtraCommonEffect(c,9991212,ATTRIBUTE_LIGHT)
	--Traping Monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991212,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9991212.tmtg)
	e1:SetOperation(c9991212.tmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
c9991212.Dazz_name_Godra=true
function c9991212.tmfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsAbleToHand()
end
function c9991212.tmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c9991212.check_box[tp][1] and eg:IsExists(c9991212.tmfilter1,1,nil,tp) end
	c9991212.check_box[tp][1]=true
	local g=eg:Filter(c9991212.tmfilter1,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991212.tmfilter2(c,e,tp)
	return c9991212.tmfilter1(c,tp) and c:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e)
end
function c9991212.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9991212.tmfilter2,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end