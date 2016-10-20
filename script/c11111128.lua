--Vocalist Gravity Barrier
function c11111128.initial_effect(c)
	c:SetUniqueOnField(1,0,11111128)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c11111128.infilter)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetCondition(c11111128.con)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c11111128.aclimit)
	c:RegisterEffect(e3)
end
function c11111128.infilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406)
end
function c11111128.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN or ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c11111128.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
