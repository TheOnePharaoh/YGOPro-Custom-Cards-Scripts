--May-Raias Buckler
function c87002920.initial_effect(c)
	--intercept
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002920,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,87002920+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c87002920.condition)
	e1:SetCost(c87002920.cost)
	e1:SetOperation(c87002920.operation)
	c:RegisterEffect(e1)
end
function c87002920.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttacker():GetAttack()>=2000 and Duel.GetLP(tp)<=2000
end
function c87002920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c87002920.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		Duel.SetLP(tp,100)
	end
end
