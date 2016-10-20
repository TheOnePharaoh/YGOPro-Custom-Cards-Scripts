--Vocaloid Awakening
function c33945054.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33945054+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c33945054.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c33945054.tg1)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTarget(c33945054.tg2)
	e3:SetValue(-100)
	c:RegisterEffect(e3)
	--def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetTarget(c33945054.tg1)
	e4:SetValue(100)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTarget(c33945054.tg2)
	e5:SetValue(-100)
	c:RegisterEffect(e5)
end
function c33945054.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c33945054.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33945054.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33945054,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c33945054.tg1(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c33945054.tg2(e,c)
	return not c:IsRace(RACE_MACHINE)
end
