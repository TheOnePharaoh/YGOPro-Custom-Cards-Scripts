--Sword Art Style - Defensive Stance
function c20912269.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c20912269.condition)
	e1:SetCost(c20912269.cost)
	e1:SetTarget(c20912269.target)
	e1:SetOperation(c20912269.activate)
	c:RegisterEffect(e1)
end
function c20912269.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_XYZ)
end
function c20912269.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c20912269.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return tp~=Duel.GetTurnPlayer()
end
function c20912269.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c20912269.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c20912269.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
