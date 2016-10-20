--Colossal Warrior - MG
function c78219327.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c78219327.splimcon)
	e1:SetTarget(c78219327.splimit)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c78219327.descon)
	c:RegisterEffect(e2)
	--atk to 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c78219327.atkcon)
	e3:SetTarget(c78219327.atktg)
	e3:SetValue(-9999)
	c:RegisterEffect(e3)
	--place card
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78219327,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c78219327.sgtg)
	e4:SetOperation(c78219327.sgop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78219327,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,78219327)
	e5:SetCost(c78219327.cost)
	e5:SetTarget(c78219327.target)
	e5:SetOperation(c78219327.operation)
	c:RegisterEffect(e5)
end
function c78219327.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c78219327.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x7ad30) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c78219327.descon(e)
	return not Duel.IsEnvironment(78219322)
end
function c78219327.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c78219327.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c78219327.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c78219327.filter(c)
	return c:IsSetCard(0x7ad30) and c:IsType(TYPE_MONSTER) and not c:IsCode(78219327) and c:IsAbleToHand()
end
function c78219327.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219327.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78219327.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78219327.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c78219327.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219327.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219327.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219327.sgop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219327.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,78219327,e,0,tp,0,0)
	end
end
