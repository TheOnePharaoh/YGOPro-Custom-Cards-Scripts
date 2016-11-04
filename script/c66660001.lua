--Twisted Dragonsbane - Eternal Carnage
--Coded by Chadook
function c66660001.initial_effect(c)
--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c66660001.rlevel)
	c:RegisterEffect(e1)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,66660001)
	e2:SetCost(c66660001.thcost)
	e2:SetTarget(c66660001.thtg)
	e2:SetOperation(c66660001.thop)
	c:RegisterEffect(e2)
end
function c66660001.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c66660001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66660001.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c66660001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66660001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66660001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end