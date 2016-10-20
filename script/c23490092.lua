--Paper Plane - A Piece of Eternity
function c23490092.initial_effect(c)
	c:SetUniqueOnField(1,0,23490092)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c23490092.condition)
	e2:SetOperation(c23490092.activate)
	c:RegisterEffect(e2)
	--invulnerable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c23490092.target)
	e3:SetValue(1)
	c:RegisterEffect(e2)
	--invulnerable battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c23490092.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c23490092.mtop)
	c:RegisterEffect(e5)
	--add setcode
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x0dac406)
	c:RegisterEffect(e6)
end
function c23490092.condition(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) or eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp)
end
function c23490092.filter(c)
	return c:IsSetCard(0x0dac406) and c:IsAbleToHand()
end
function c23490092.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c23490092.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(23490092,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c23490092.target(e,c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:GetRank()<=4
end
function c23490092.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(23490092,1)) then
		Duel.PayLPCost(tp,300)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
