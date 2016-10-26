--Spring of Wyrm Souls
function c77777844.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777844.target)
	e1:SetOperation(c77777844.operation)
	c:RegisterEffect(e1)
end
function c77777844.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777844.filter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	local rec=Duel.GetMatchingGroupCount(c77777844.filter,tp,LOCATION_MZONE,0,nil)*1000
	local rec2=Duel.GetMatchingGroupCount(c77777844.filter,tp,LOCATION_EXTRA,0,nil)*500
	rec=rec+rec2
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c77777844.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM)
end
function c77777844.operation(e,tp,eg,ep,ev,re,r,rp)
	local rec=Duel.GetMatchingGroupCount(c77777844.filter,tp,LOCATION_MZONE,0,nil)*1000
	local rec2=Duel.GetMatchingGroupCount(c77777844.filter,tp,LOCATION_EXTRA,0,nil)*500
	rec=rec+rec2
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
