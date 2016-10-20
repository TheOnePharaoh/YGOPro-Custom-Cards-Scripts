--Dark Android Rampart
function c99200185.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99200185.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99200185.sprcon)
	e2:SetOperation(c99200185.sprop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200185.immfilter)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99200185,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c99200185.adcon)
	e4:SetCost(c99200185.adcost)
	e4:SetOperation(c99200185.adop)
	c:RegisterEffect(e4)
	--to defense
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c99200185.poscon)
	e5:SetOperation(c99200185.posop)
	c:RegisterEffect(e5)
end
function c99200185.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99200185.spfilter1(c,tp)
	return c:IsSetCard(0xda3790) and Duel.IsExistingMatchingCard(c99200185.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c99200185.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200185.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c99200185.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c99200185.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200185,0))
	local g1=Duel.SelectMatchingCard(tp,c99200185.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200185,1))
	local g2=Duel.SelectMatchingCard(tp,c99200185.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c99200185.immfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99200185.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and e:GetHandler():IsAttackPos() and bc:IsFaceup() and bc:IsType(TYPE_MONSTER)
end
function c99200185.costfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c99200185.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99200185.costfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99200185.costfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c99200185.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SWAP_ATTACK_FINAL)
		e1:SetValue(c:GetBaseDefense())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SWAP_DEFENSE_FINAL)
		e2:SetValue(c:GetBaseAttack())
		c:RegisterEffect(e2)
	end
end
function c99200185.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c99200185.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
