--Clash of the Heroes
function c44559810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c44559810.condition)
	e1:SetCost(c44559810.cost)
	e1:SetTarget(c44559810.target)
	e1:SetOperation(c44559810.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(44559810,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,44559810)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c44559810.spcost)
	e2:SetTarget(c44559810.sptarget)
	e2:SetOperation(c44559810.spoperation)
	c:RegisterEffect(e2)
end
function c44559810.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2017)
end
function c44559810.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
	and Duel.IsExistingMatchingCard(c44559810.confilter,tp,LOCATION_ONFIELD,0,2,e:GetHandler()) and Duel.IsChainNegatable(ev)
end
function c44559810.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:IsAbleToDeckAsCost()
end
function c44559810.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559810.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44559810.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c44559810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c44559810.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c44559810.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c44559810.spefilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44559810.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44559810.spefilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c44559810.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44559810.spefilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end