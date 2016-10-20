--Vocaloid Xinhua
function c78360180.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c78360180.hspcon)
	e1:SetOperation(c78360180.hspop)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78360180,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,78360180)
	e2:SetOperation(c78360180.lvop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78360180,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,78360180)
	e3:SetCost(c78360180.cost)
	e3:SetTarget(c78360180.target)
	e3:SetOperation(c78360180.operation)
	c:RegisterEffect(e3)
end
function c78360180.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(3)
		c:RegisterEffect(e1)
	end
end
function c78360180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c78360180.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and c:GetCode()~=78360180 and c:IsAbleToHand()
end
function c78360180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78360180.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78360180.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78360180.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c78360180.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c78360180.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c78360180.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c78360180.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78360180.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
