--Predator's Chains
function c96100574.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cannot be used as material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c96100574.sertg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	--Unaffected by Opponent Card Effects
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c96100574.uncon)
	e7:SetValue(c96100574.unval)
	c:RegisterEffect(e7)
		--maintain
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c96100574.mtcon)
	e8:SetOperation(c96100574.mtop)
	c:RegisterEffect(e8)
end
function c96100574.sertg(e,c)
	return c:GetCounter(0x1041)>0
end
function c96100574.filter(c)
	return c:GetCounter(0x1041)>0
end
function c96100574.uncon(e,c)
	if Duel.IsExistingMatchingCard(c96100574.filter,tp,0,LOCATION_MZONE,1,nil) then return true else return false end
end
function c96100574.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c96100574.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c96100574.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>800 and Duel.SelectYesNo(tp,aux.Stringid(95100827,0)) then
		Duel.PayLPCost(tp,800)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end