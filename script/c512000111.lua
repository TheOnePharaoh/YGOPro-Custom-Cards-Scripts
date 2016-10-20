--Xyz Colosseum
function c512000111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c512000111.noatkcon)
	e2:SetTarget(c512000111.notatk)
	c:RegisterEffect(e2)	
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c512000111.noatkcon)
	e3:SetValue(200)
	e3:SetTarget(c512000111.atk)
	c:RegisterEffect(e3)
	--self cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c512000111.nocon)
	c:RegisterEffect(e4)
end
function c512000111.nofilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c512000111.noatkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c512000111.nofilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c512000111.nofilter,tp,0,LOCATION_MZONE,1,nil)
end
function c512000111.notatk(e,c)
	return not c:IsType(TYPE_XYZ)
end
function c512000111.atk(e,c)
	return c:IsType(TYPE_XYZ)
end
function c512000111.nocon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c512000111.nofilter,tp,LOCATION_MZONE,0,1,nil)
end
