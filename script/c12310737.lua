--Great Grey Wolf Sif
--lua script by SGJin
function c12310737.initial_effect(c)
	-- Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	-- Can't Change Control (Loyalty to controller)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	-- Cannot Banish (Loyalty to controller)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	-- Double Attack (if Artorias is in Graveyard)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c12310737.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	-- Drops Humanity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310737,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310737.thcon)
	e4:SetTarget(c12310737.thtg)
	e4:SetOperation(c12310737.thop)
	c:RegisterEffect(e4)
end
function c12310737.con(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,12310718)
end
function c12310737.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,12310718)
end
function c12310737.filter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310737.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310737.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310737.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310737.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
