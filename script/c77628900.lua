--Griffin, Guardian of the Black Art
function c77628900.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628900,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c77628900.condition)
	e2:SetTarget(c77628900.target)
	e2:SetOperation(c77628900.operation)
	c:RegisterEffect(e2)
	--special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628900,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,77628900)
	e3:SetCondition(c77628900.spcon)
	e3:SetCost(c77628900.spcost)
	e3:SetTarget(c77628900.sptg)
	e3:SetOperation(c77628900.spop)
	c:RegisterEffect(e3)
end
function c77628900.filter(c,ec,tp)
	return c~=ec and c:IsSetCard(0xba003) and c:GetCode()~=77628900 and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_BATTLE)
end
function c77628900.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77628900.filter,1,nil,e:GetHandler(),tp)
end
function c77628900.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77628900.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c77628900.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628900.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628900.grafilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c77628900.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77628900.spfilter(c,e,tp)
	return c:IsSetCard(0xba003) and c:GetCode()~=77628900 and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628900.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c77628900.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77628900.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77628900.spfilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77628900.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
