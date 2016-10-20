--Vocaloid Competition Arena
function c96866605.initial_effect(c)
	c:EnableCounterPermit(0x104)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c96866605.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e3:SetValue(c96866605.atkval)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(96866605,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,96866605)
	e4:SetCost(c96866605.cost2)
	e4:SetTarget(c96866605.tg2)
	e4:SetOperation(c96866605.op2)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c96866605.desreptg)
	e5:SetOperation(c96866605.desrepop)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c96866605.splimit)
	c:RegisterEffect(e6)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(96866605,1))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetOperation(c96866605.wop)
	c:RegisterEffect(e7)
end
function c96866605.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c96866605.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c96866605.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x104,1)
	end
end
function c96866605.atkval(e,c)
	return e:GetHandler():GetCounter(0x104)*100
end
function c96866605.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x104,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x104,2,REASON_COST)
end
function c96866605.filter2(c)
	return c:IsType(TYPE_CONTINUOUS)and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c96866605.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c96866605.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c96866605.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96866605.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c96866605.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x104)>=3 end
	return true
end
function c96866605.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x104,3,REASON_EFFECT)
end
function c96866605.splimit(e,c)
	return c:IsRace(0xffffff-RACE_MACHINE)
	end
function c96866605.wop(e,tp,eg,ep,ev,re,r,rp)
	if c:GetCounter(0x104)>=10 then
		Duel.Win(tp,0x52)
	end
end