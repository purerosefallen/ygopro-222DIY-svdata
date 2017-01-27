--Lahm Loving
local m=37564513
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.nntr(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(senya.multi_choice_target(m,cm.tg1,cm.tg2))
	e1:SetOperation(senya.multi_choice_operation(cm.op1,cm.op2))
	c:RegisterEffect(e1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler()) and senya.nncon(false)(e,tp,eg,ep,ev,re,r,rp) end
	local pr1,pr2=e:GetProperty()
	e:SetProperty(bit.bor(pr1,EFFECT_FLAG_CARD_TARGET),pr2)
	e:SetCategory(CATEGORY_DESTROY)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and senya.nncon(true)(e,tp,eg,ep,ev,re,r,rp) and Duel.IsPlayerCanDraw(tp,1) end
	local pr1,pr2=e:GetProperty()
	e:SetProperty(pr1-bit.band(pr1,EFFECT_FLAG_CARD_TARGET),pr2)
	e:SetCategory(CATEGORY_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
