
function c344000060.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(344000060,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,344000060)
	e2:SetCondition(c344000060.damcon)
	e2:SetCost(c344000060.damcost)
	e2:SetTarget(c344000060.damtg)
	e2:SetOperation(c344000060.damop)
	c:RegisterEffect(e2)
end
function c344000060.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c344000060.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c344000060.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c344000060.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x444a)
end
function c344000060.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c344000060.filter2,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c344000060.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c344000060.filter2,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
