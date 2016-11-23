--Action Card - Conjured Blades
function c20912322.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c20912322.condition)
	e1:SetTarget(c20912322.target)
	e1:SetOperation(c20912322.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c20912322.handcon)
	c:RegisterEffect(e2)
end
function c20912322.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c20912322.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c20912322.limfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c20912322.chlimit(e,ep,tp)
	return tp==ep
end
function c20912322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	if Duel.IsExistingMatchingCard(c20912322.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c20912322.chlimit)
	end
end
function c20912322.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
