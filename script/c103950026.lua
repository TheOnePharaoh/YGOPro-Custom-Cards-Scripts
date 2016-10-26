--Mist Wyvern
function c103950026.initial_effect(c)

	--Negate Attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950026,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c103950026.condition)
	e1:SetTarget(c103950026.target)
	e1:SetOperation(c103950026.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end

--Negate Attack condition
function c103950026.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and
			(Duel.GetAttackTarget() == e:GetHandler() or Duel.GetAttacker() == e:GetHandler()) and
			e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end

--Negate Attack target
function c103950026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end

--Negate Attack operation
function c103950026.operation(e,tp,eg,ep,ev,re,r,rp)

	local c = e:GetHandler()

	if not c:IsRelateToEffect(e) or not c:IsPosition(POS_FACEUP_ATTACK) then return end
	
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
	Duel.NegateAttack()
	
	local chain = Duel.GetCurrentChain()
	if chain <= 1 then return end
	
	Duel.BreakEffect()
	
	for i=1,(chain-1) do
		Duel.NegateActivation(i)
	end
end