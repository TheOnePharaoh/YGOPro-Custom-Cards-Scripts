--Sword Art Champion Tyrande the Vanquisher
function c20912289.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912289,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,20912289)
	e1:SetCondition(c20912289.nacon)
	e1:SetCost(c20912289.nacost)
	e1:SetTarget(c20912289.natg)
	e1:SetOperation(c20912289.naop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912289,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c20912289.negcon)
	e2:SetCost(c20912289.negcost)
	e2:SetTarget(c20912289.negtg)
	e2:SetOperation(c20912289.negop)
	c:RegisterEffect(e2)
end
function c20912289.nacon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsRace(RACE_WARRIOR)
end
function c20912289.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c20912289.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsOnField() end
	local dam=Duel.GetAttacker():GetAttack()/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c20912289.naop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.NegateAttack() then
		Duel.Damage(1-tp,a:GetAttack()/2,REASON_EFFECT)
	end
end
function c20912289.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c20912289.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c20912289.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c20912289.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20912289.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c20912289.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
