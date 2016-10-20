--Rescuer from the Grave
function c512000101.initial_effect(c)
    --negate attack and end battle phase
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(c512000101.con)
    e1:SetCost(c512000101.cost)
    e1:SetOperation(c512000101.op)
    c:RegisterEffect(e1)
end
function c512000101.con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c512000101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
    	if Duel.GetFlagEffect(tp,512000101)<3 then
    		return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,5,nil)
    	else
    		return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,4,e:GetHandler())
    	end
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    if Duel.GetFlagEffect(tp,512000101)<3 then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,5,5,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,4,4,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.RegisterFlagEffect(tp,512000101,0,0,0)
end
function c512000101.op(e,tp,eg,ep,ev,re,r,rp)
    local sk=Duel.GetTurnPlayer()
    Duel.BreakEffect()
	Duel.SkipPhase(sk,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
