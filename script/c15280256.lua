--Malfunctionating Cyber Dragon
function c15280256.initial_effect(c)
	--lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15280256,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c15280256.cost)
	e1:SetOperation(c15280256.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15280256,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,15280256)
	e2:SetTarget(c15280256.thtg)
	e2:SetOperation(c15280256.thop)
	c:RegisterEffect(e2)
	--name change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(70095154)
	c:RegisterEffect(e3)
end

function c15280256.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost()
end
function c15280256.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15280256.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c15280256.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c15280256.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end

function c15280256.thfilter(c)
	return c:IsSetCard(0x93) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c15280256.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15280256.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c15280256.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c15280256.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end