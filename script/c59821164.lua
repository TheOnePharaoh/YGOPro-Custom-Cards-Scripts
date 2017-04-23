--Aetherian's Red Apple
function c59821164.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821164,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,59821164)
	e1:SetOperation(c59821164.activate)
	c:RegisterEffect(e1)
	--restrict
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,59821164)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c59821164.rescost)
	e2:SetTarget(c59821164.restg)
	e2:SetOperation(c59821164.resop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c59821164.handcon)
	c:RegisterEffect(e3)
end
function c59821164.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c59821164.activate(e,tp,eg,ep,ev,re,r,rp)
	--ATK Up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(500)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa1a2))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	--piercing
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa1a2))
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	--disable
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e3:SetTarget(c59821164.distarget)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	--disable effect
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetOperation(c59821164.disoperation)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	--disable trap monster
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e5:SetTarget(c59821164.distarget)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
end
function c59821164.distarget(e,c)
	return c:IsType(TYPE_TRAP)
end
function c59821164.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
function c59821164.rescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821164.restg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c59821164.chainlm)
end
function c59821164.chainlm(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:IsActiveType(TYPE_TRAP)
end
function c59821164.resop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c59821164.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c59821164.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end