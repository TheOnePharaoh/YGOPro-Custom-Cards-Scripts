--May-Raias Plague
function c87002904.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002904,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,87002904)
	e1:SetTarget(c87002904.target)
	e1:SetOperation(c87002904.operation)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetCondition(c87002904.sccon)
	e2:SetValue(2100)
	c:RegisterEffect(e2)
end
function c87002904.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe291ca)
end
function c87002904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c87002904.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c87002904.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c87002904.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
function c87002904.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end