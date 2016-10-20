--D.S. Eel
function c29001787.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29001787,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,29001787)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c29001787.spcon)
	e1:SetTarget(c29001787.sptg)
	e1:SetOperation(c29001787.spop)
	c:RegisterEffect(e1)
end
function c29001787.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsType(TYPE_TUNER)
end
function c29001787.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29001787.spfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c29001787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29001787.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end