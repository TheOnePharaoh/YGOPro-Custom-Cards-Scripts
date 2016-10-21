--MSMM - Rain Of Vain
function c99950200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c99950200.condition)
	e1:SetOperation(c99950200.operation)
	c:RegisterEffect(e1)
end
function c99950200.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsLevelAbove(1)
end
function c99950200.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP) and tc:IsSetCard(9995) and tp~=Duel.GetTurnPlayer()
end
function c99950200.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)	
	local tc=g:GetFirst()
	while tc and Duel.IsExistingMatchingCard(c99950200.filter1,tp,LOCATION_SZONE,0,1,nil) do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-Duel.GetMatchingGroupCount(c99950200.filter1,c:GetControler(),LOCATION_SZONE,0,nil)*300)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
