--Decolate Dragon
function c34858510.initial_effect(c)
	c:SetUniqueOnField(1,0,34858510)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--Prevent Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c34858510.target)
	e2:SetOperation(c34858510.operation)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34858510,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c34858510.rmcon)
	e3:SetCost(c34858510.rmcost)
	e3:SetTarget(c34858510.rmtg)
	e3:SetOperation(c34858510.rmop)
	c:RegisterEffect(e3)
end
function c34858510.target(e,c)
	local c=e:GetHandler()
	return c:IsRace(RACE_DRAGON) or c:IsType(TYPE_PENDULUM)
end
function c34858510.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if tp then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetTarget(c34858510.tg)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetRange(LOCATION_PZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c34858510.tg)
		e2:SetValue(1)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
end
function c34858510.tg(e,c)
	return c:IsRace(RACE_DRAGON) or c:IsType(TYPE_PENDULUM)
end
function c34858510.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c34858510.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsAbleToRemove() end
Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CANNOT_BP)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetRange(LOCATION_REMOVED)
	  e1:SetTargetRange(1,0)
	  e1:SetReset(RESET_PHASE+PHASE_END)
	  Duel.RegisterEffect(e1,tp)
end
function c34858510.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsRace(RACE_DRAGON) and c:IsFaceup())
	or (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c34858510.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_EXTRA) and c34858510.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c34858510.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g=Duel.SelectTarget(tp,c34858510.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c34858510.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end