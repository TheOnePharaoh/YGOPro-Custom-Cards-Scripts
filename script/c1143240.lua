--Over Point, ANTI-MATTER Break
function c1143240.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143240,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,1143240)
	e1:SetCondition(c1143240.condition)
	e1:SetCost(c1143240.cost)
	e1:SetTarget(c1143240.target)
	e1:SetOperation(c1143240.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143240,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,1143240)
	e4:SetCondition(c1143240.negcon)
	e4:SetCost(c1143240.negcost)
	e4:SetTarget(c1143240.negtg)
	e4:SetOperation(c1143240.negop)
	c:RegisterEffect(e4)
	if not c1143240.global_check then
		c1143240.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143240))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143240.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1143240.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDestructable()
end
function c1143240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143240.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1143240.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c1143240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c1143240.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c1143240.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c1143240.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c1143240.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1143240.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143240.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if Duel.IsExistingMatchingCard(c1143240.confilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
