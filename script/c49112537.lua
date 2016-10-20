--HYSTERIA - Song of Anger
function c49112537.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49112537,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c49112537.damcon)
	e2:SetTarget(c49112537.damtg)
	e2:SetOperation(c49112537.damop)
	c:RegisterEffect(e2)
end
function c49112537.check(c,tp)
	return c and c:IsControler(tp) and c:IsSetCard(0x0dac402)
end
function c49112537.damcon(e,tp,eg,ep,ev,re,r,rp)
	return c49112537.check(Duel.GetAttacker(),tp) or c49112537.check(Duel.GetAttackTarget(),tp)
end
function c49112537.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c49112537.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
