--MSMM - Witch Overcoming
function c99950220.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c99950220.condition)
	e1:SetTarget(c99950220.target)
	e1:SetOperation(c99950220.activate)
	c:RegisterEffect(e1)
end
function c99950220.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsLevelAbove(1)
end
function c99950220.filter2(c)
	return c:IsFaceup() and (c:IsLevelAbove(5) or c:IsRankAbove(5))
end
function c99950220.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() 
end
function c99950220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99950220.filter1,tp,LOCATION_MZONE,0,1,nil) and 
    Duel.IsExistingMatchingCard(c99950220.filter2,tp,0,LOCATION_MZONE,1,nil) end
end
function c99950220.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c99950220.filter1,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(c99950220.filter1,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	local atk=sg2:GetCount()*300
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	tc=sg:GetNext()
	end
end