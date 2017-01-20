--Tranquil Trail Through the Glade
function c77777885.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --SS
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_BOTH_SIDE)
	e6:SetRange(LOCATION_SZONE)
  e6:SetCountLimit(1,77777885)
	e6:SetCode(EVENT_TO_GRAVE)
  e6:SetCondition(c77777885.condition)
	e6:SetTarget(c77777885.target)
	e6:SetOperation(c77777885.operation)
	c:RegisterEffect(e6)
end

function c77777885.condition(e,tp,eg,ep,ev,re,r,rp)
  --Makes sure that an xyz monster was destroyed, else return false
  local g=eg
  --Loops through g, trying to find if the card is an xyz monster
  local tc=g:GetFirst()
  while tc do
    if tc:IsSetCard(0x40c) and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsType(TYPE_MONSTER)then return true end
    tc=g:GetNext()
  end
	return false
end
function c77777885.filter(c,e,tp)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_MONSTER)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777885.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77777885.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777885.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777885.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end