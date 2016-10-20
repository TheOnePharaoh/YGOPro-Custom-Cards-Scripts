--Evil HERO Raging Storm
function c888000005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),true)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000005,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c888000005.atkcon)
	e2:SetCost(c888000005.atkcost)
	e2:SetOperation(c888000005.atkop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c888000005.splimit)
	c:RegisterEffect(e3)
end
c888000005.dark_calling=true
function c888000005.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8)
end
function c888000005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c888000005.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function c888000005.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c888000005.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def/2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
