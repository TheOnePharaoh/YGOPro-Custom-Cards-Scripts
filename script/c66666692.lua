--Seafarer Lookout Barbarossa
function c66666692.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetDescription(aux.Stringid(66666692,0))
	e2:SetCountLimit(1,66666692)
--	e2:SetCost(c66666692.cost)
	e2:SetTarget(c66666692.sptg)
	e2:SetOperation(c66666692.spop)
	c:RegisterEffect(e2)
end

function c66666692.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c66666692.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666692.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c66666692.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end

function c66666692.filter2(c)
	return c:IsAbleToChangeControler()and c:GetSequence()<5
end

function c66666692.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c66666692.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c66666692.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c66666692.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
	and Duel.IsExistingTarget(c66666692.filter2,tp,0,LOCATION_SZONE,1,c)then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c66666692.filter2,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
	end
end