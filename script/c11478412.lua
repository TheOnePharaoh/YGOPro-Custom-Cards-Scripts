--Wisdom God of the Bound Creator
function c11478412.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11478412.splimit)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c11478412.atklimtg)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478412,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c11478412.negcon)
	e3:SetCost(c11478412.negcost)
	e3:SetTarget(c11478412.negtg)
	e3:SetOperation(c11478412.negop)
	c:RegisterEffect(e3)
end
function c11478412.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c11478412.atklimtg(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackBelow(4500) and not c:IsCode(11478412)
end
function c11478412.negfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c11478412.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11478412.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c11478412.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11478412.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11478412.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
