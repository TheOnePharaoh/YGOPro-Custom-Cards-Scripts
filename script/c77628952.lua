--Dark Necromancer of the Black Art
function c77628952.initial_effect(c)
	c:SetSPSummonOnce(77628952)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628952,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77628952.spcon)
	e2:SetTarget(c77628952.sptg)
	e2:SetOperation(c77628952.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628952,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c77628952.target)
	e3:SetOperation(c77628952.operation)
	c:RegisterEffect(e3)
	--def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77628952.defval)
	c:RegisterEffect(e4)
end
function c77628952.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba003) and c:IsType(TYPE_FUSION)
end
function c77628952.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628952.spfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c77628952.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77628952.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77628952.filter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and not c:IsCode(77628952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628952.limfil(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628952.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77628952.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77628952.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77628952.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if Duel.IsExistingMatchingCard(c77628952.limfil,tp,LOCATION_GRAVE,0,3,nil) then
		Duel.SetChainLimit(c77628952.chlimit)
	end
end
function c77628952.chlimit(e,ep,tp)
	return tp==ep
end
function c77628952.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77628952.deffilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628952.defval(e,c)
	return Duel.GetMatchingGroupCount(c77628952.deffilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
