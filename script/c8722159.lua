--Radiant Kryos
function c8722159.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,8722151),aux.NonTuner(Card.IsRace,RACE_DRAGON),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--destroy and damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8722159,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c8722159.descon)
	e2:SetCost(c8722159.descost)
	e2:SetTarget(c8722159.destg)
	e2:SetOperation(c8722159.desop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(8722159,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c8722159.condition)
	e3:SetTarget(c8722159.target)
	e3:SetOperation(c8722159.operation)
	c:RegisterEffect(e3)
end
function c8722159.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c8722159.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e1,tp)
end
function c8722159.dfilter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c8722159.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8722159.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c8722159.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c8722159.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8722159.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local tc=dg:GetFirst()
	local dam=0
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		dam=dam+atk
		tc=dg:GetNext()
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end
function c8722159.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
		and c:GetPreviousControler()==tp and rp~=tp
end
function c8722159.filter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_MONSTER)
end
function c8722159.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c8722159.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c8722159.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c8722159.filter,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
