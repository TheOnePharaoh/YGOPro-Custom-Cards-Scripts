--The Legendary Wood Golem
function c66165073.initial_effect(c)
	c:SetSPSummonOnce(66165073)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165073,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c66165073.condition)
	e1:SetCost(c66165073.cost)
	e1:SetTarget(c66165073.target)
	e1:SetOperation(c66165073.operation)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(c66165073.sumlimit)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66165073,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,66165073)
	e4:SetCondition(c66165073.descon)
	e4:SetTarget(c66165073.destg)
	e4:SetOperation(c66165073.desop)
	c:RegisterEffect(e4)
end
function c66165073.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c66165073.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66165073.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66165073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c66165073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66165073.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c66165073.sumlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165073.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165073.desfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c66165073.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c66165073.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c66165073.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c66165073.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66165073.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end