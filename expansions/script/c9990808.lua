--思考の電光
function c9990808.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9990808.target)
	e1:SetOperation(c9990808.activate)
	c:RegisterEffect(e1)
end
function c9990808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9990808.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)==0 or not Duel.IsPlayerCanDraw(tp,1)
		or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.BreakEffect()
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9990808,0))
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 then
		sel=Duel.SelectOption(tp,aux.Stringid(9990808,1),aux.Stringid(9990808,2))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(9990808,1))
	end
	if sel==0 then
		c9990808.operation1(e,tp)
		Duel.BreakEffect()
		c9990808.operation2(e,tp)
	else
		c9990808.operation2(e,tp)
		Duel.BreakEffect()
		c9990808.operation1(e,tp)
	end
end
function c9990808.operation1(e,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==5 then
		Duel.SortDecktop(tp,tp,5)
		return
	end
	local g1=Duel.GetDecktopGroup(tp,5)
	Duel.ConfirmCards(tp,g1)
	if Duel.SelectYesNo(tp,aux.Stringid(9990808,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9990808,4))
		local g2=g1:Select(tp,1,5,nil)
		g1:Sub(g2)
		while g2:GetCount()~=0 do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9990808,5))
			local g=g2:Select(tp,1,1,nil)
			Duel.MoveSequence(g:GetFirst(),1)
			g2:Sub(g)
		end
	end
	local val=g1:GetCount()
	if val<2 then return end
	Duel.SortDecktop(tp,tp,val)
end
function c9990808.operation2(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local c=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
	if bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 then
		Duel.Damage(1-tp,c:GetLevel()*200,REASON_EFFECT)
	end
end