--D.S. Serpent
function c29001781.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29001781)
	e1:SetCondition(c29001781.spcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29001781,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c29001781.condition)
	e2:SetTarget(c29001781.target)
	e2:SetOperation(c29001781.operation)
	c:RegisterEffect(e2)
end
function c29001781.spefilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and not c:IsCode(29001781)
end
function c29001781.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29001781.spefilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29001781.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29001781.filter(c,e,tp)
	return c:IsDefenseBelow(800) and c:IsAttribute(ATTRIBUTE_WATER) and c:GetCode()~=29001781
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29001781.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29001781.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29001781.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29001781.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
