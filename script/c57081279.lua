--Vocaloid Codename VY1
function c57081279.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL+TYPE_DUAL+TYPE_MONSTER)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_TYPE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c57081279.tpval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(57081279,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(c57081279.target)
	e4:SetOperation(c57081279.operation)
	c:RegisterEffect(e4)
end
function c57081279.tpval(e,c)
	if c:IsFaceup() and not c:IsDualState() then return TYPE_NORMAL+TYPE_DUAL+TYPE_MONSTER
	else return TYPE_EFFECT+TYPE_DUAL+TYPE_MONSTER+TYPE_TUNER end
end
function c57081279.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c57081279.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57081279.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c57081279.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57081279.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
