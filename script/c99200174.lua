--Dark Android Berserker
function c99200174.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e2:SetValue(c99200174.encorefilter)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200174.efilter)
	c:RegisterEffect(e3)
	--atkplus
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99200174,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,99200174)
	e4:SetOperation(c99200174.atkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c99200174.encorefilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_TRAP)
end
function c99200174.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200174.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200174.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99200174.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
