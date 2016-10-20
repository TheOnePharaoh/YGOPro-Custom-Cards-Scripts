--Lizardfolk - Assault Squad
function c20161988.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20161988,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c20161988.indescost)
	e1:SetOperation(c20161988.indesop)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c20161988.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20161988.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c20161988.etarget)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c20161988.etarget)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c20161988.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end

