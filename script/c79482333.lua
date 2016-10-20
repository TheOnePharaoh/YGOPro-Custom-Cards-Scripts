--Vocalist Private Room
function c79482333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79482333.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c79482333.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79482333.target)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79482333.target)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79482333,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c79482333.thcon)
	e5:SetTarget(c79482333.thtg)
	e5:SetOperation(c79482333.thop)
	c:RegisterEffect(e5)
end
function c79482333.target(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c79482333.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79482333.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c79482333.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79482333.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79482333.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79482333.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
