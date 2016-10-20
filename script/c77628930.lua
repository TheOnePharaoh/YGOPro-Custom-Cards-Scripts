--Imperial Slaves of the Black Art
function c77628930.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xba003),aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c77628930.splimit)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628930,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,77628930)
	e3:SetCondition(c77628930.condition)
	e3:SetTarget(c77628930.target1)
	e3:SetOperation(c77628930.operation1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77628930,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,77628930)
	e4:SetCondition(c77628930.condition)
	e4:SetTarget(c77628930.target2)
	e4:SetOperation(c77628930.operation2)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77628930,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,77628930)
	e5:SetCondition(c77628930.condition)
	e5:SetTarget(c77628930.target3)
	e5:SetOperation(c77628930.operation3)
	c:RegisterEffect(e5)
end
function c77628930.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628930.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628930.tdfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xba003)
end
function c77628930.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77628930.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c77628930.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77628930.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c77628930.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsDestructable()
end
function c77628930.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628930.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c77628930.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77628930.operation2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77628930.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c77628930.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628930.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77628930.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77628930.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77628930.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
