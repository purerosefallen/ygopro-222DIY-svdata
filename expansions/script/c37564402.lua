--百慕 魔法的应援·妮娜
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c37564402.initial_effect(c)
	senya.bm(c,c37564402.target,c37564402.operation,false,CATEGORY_RECOVER+CATEGORY_DAMAGE)
end
function c37564402.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c37564402.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end