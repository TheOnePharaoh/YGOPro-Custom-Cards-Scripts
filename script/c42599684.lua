--Searing Magic
function c42599684.initial_effect(c)
	c:SetUniqueOnField(1,0,42599684)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c42599684.atktg)
	e2:SetValue(c42599684.atkval)
	c:RegisterEffect(e2)
	--damage filter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c42599684.damval)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(42599684,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c42599684.target)
	e4:SetOperation(c42599684.operation)
	c:RegisterEffect(e4)
end
function c42599684.atktg(e,c)
	return c:IsRace(RACE_PYRO)
end
function c42599684.cfilter(c)
	return c:IsCode(42599677)
end
function c42599684.atkval(e,c)
	return Duel.GetMatchingGroupCount(c42599684.cfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
function c42599684.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
function c42599684.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0xfc10) or c:IsCode(42599677)) and not c:IsCode(42599684) and c:IsAbleToHand()
end
function c42599684.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42599684.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c42599684.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c42599684.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
end
