--Forest of the Mystic Fauna
function c77777859.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c77777859.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40a))
	e3:SetValue(1)
	c:RegisterEffect(e3)
  --Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777859,2))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c77777859.desreptg)
	e4:SetOperation(c77777859.desrepop)
	c:RegisterEffect(e4)
  --xyz summon search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777859,1))
	e5:SetCountLimit(1)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
  e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCondition(c77777859.con)
	e5:SetTarget(c77777859.tg)
	e5:SetOperation(c77777859.op)
	c:RegisterEffect(e5)
  --SS
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_BOTH_SIDE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_TO_GRAVE)
  e6:SetCondition(c77777859.condition)
	e6:SetTarget(c77777859.target)
	e6:SetOperation(c77777859.operation)
	c:RegisterEffect(e6)
end

function c77777859.repfilter(c)
	return  c:IsType(TYPE_MONSTER) and c:IsSetCard(0x40a)and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c77777859.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c77777859.repfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(77777859,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c77777859.repfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_LEAVE_CONFIRMED,true)
		return true
	else return false end
end
function c77777859.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_LEAVE_CONFIRMED,false)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end

function c77777859.efilter(e,c)
	return c:IsSetCard(0x40a)
end

function c77777859.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77777859.filter2(c)
	return c:IsCode(31677606) and c:IsAbleToHand()
end
function c77777859.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777859.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777859.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777859.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



function c77777859.condition(e,tp,eg,ep,ev,re,r,rp)
  --Makes sure that an xyz monster was destroyed, else return false
  local g=eg
  --Loops through g, trying to find if the card is an xyz monster
  local tc=g:GetFirst()
  while tc do
    if tc:IsType(TYPE_XYZ) then return true end
    tc=g:GetNext()
  end
	return false
end
function c77777859.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777859.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77777859.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77777859.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777859.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end