----D.S. Sea Dorado
function c29001790.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FISH),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29001790,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c29001790.spcon)
	e1:SetTarget(c29001790.sptg)
	e1:SetOperation(c29001790.spop)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetTarget(c29001790.atlimit)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c29001790.spcon)
	c:RegisterEffect(e3)
end
function c29001790.atlimit(e,c)
	return c:IsFaceup() and c~=e:GetHandler() and c:IsRace(RACE_FISH)
end
function c29001790.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c29001790.spcon(e)
	return Duel.IsExistingMatchingCard(c29001790.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c29001790.filter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29001790.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c29001790.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c29001790.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c29001790.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29001790.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
