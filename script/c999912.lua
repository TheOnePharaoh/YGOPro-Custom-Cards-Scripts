--Red Dragon Blast
function c999912.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c999912.damtg)
	e1:SetOperation(c999912.damop)
	c:RegisterEffect(e1)
end
function c999912.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1045)
end
function c999912.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999912.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
	local ct=Duel.GetMatchingGroupCount(c999912.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c999912.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c999912.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*800,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
