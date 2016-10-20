--Undefined - Song of Doubted Heart
function c78696361.initial_effect(c)
	c:SetUniqueOnField(1,0,c78696361)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c78696361.condition)
	e1:SetHintTiming(0,0x1c0)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78696361,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c78696361.negcon)
	e3:SetCost(c78696361.negcost)
	e3:SetTarget(c78696361.negtg)
	e3:SetOperation(c78696361.negop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c78696361.descon)
	e4:SetOperation(c78696361.desop)
	c:RegisterEffect(e4)
end
function c78696361.filter(c)
	return c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c78696361.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78696361.filter,tp,LOCATION_MZONE,0,2,nil)
end
function c78696361.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP)
end
function c78696361.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c78696361.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c78696361.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then return	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c78696361.dfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_SYNCHRO)
end
function c78696361.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78696361.dfilter,1,nil,tp)
end
function c78696361.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
