--Seafarer Deckhand Alvida
function c66666689.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666689,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
--	e3:SetCost(c66666689.cost)
	e3:SetCountLimit(1,66666689)
	e3:SetTarget(c66666689.sptg)
	e3:SetOperation(c66666689.spop)
	c:RegisterEffect(e3)
end


function c66666689.dfilter(c,s)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c66666689.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e:GetHandler()) end
	local dg=Duel.GetMatchingGroup(c66666689.dfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	dg=Duel.SelectMatchingCard(tp,c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e:GetHandler())
	Duel.Destroy(dg,REASON_EFFECT)
end

function c66666689.spfilter(c,e,tp)
	return c:IsSetCard(0x669) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66666689.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66666689.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c66666689.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c66666689.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66666689.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local g=Duel.SelectTarget(tp,c66666689.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end