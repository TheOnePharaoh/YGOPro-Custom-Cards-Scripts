--God's Relic Tome of Resurrection
function c55438824.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,55438823)
	--Reversal
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,55438824)
	e1:SetCost(c55438824.revcost)
	e1:SetOperation(c55438824.revop)
	c:RegisterEffect(e1)
end
function c55438824.remfilter(c,e,tp)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438824.revcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c55438824.remfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55438824.remfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438824.revop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c55438824.condition)
	e1:SetValue(c55438824.reverse)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c55438824.reverse(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)>0
end
function c55438824.condition(e)
  local tp=e:GetHandlerPlayer()
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  return (a and a:IsControler(tp) and a:IsSetCard(0xd70)) or (d and d:IsControler(tp) and d:IsSetCard(0xd70))
end