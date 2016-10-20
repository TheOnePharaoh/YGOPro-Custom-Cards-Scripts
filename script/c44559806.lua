--Long Wang, Chaotic Dragon of the Sky Nirvana
function c44559806.initial_effect(c)
	c:SetUniqueOnField(1,0,44559806)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,44559800,44559801,44559802,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Halve LP
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c44559806.hvop)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559806,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCountLimit(1,44559806)
	e4:SetCondition(c44559806.atcon)
	e4:SetOperation(c44559806.atop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559806,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c44559806.negcon)
	e5:SetTarget(c44559806.negtg)
	e5:SetOperation(c44559806.negop)
	c:RegisterEffect(e5)
end
function c44559806.hvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function c44559806.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(44559806)==0
		and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c44559806.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c44559806.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(44559806) and Duel.IsChainNegatable(ev)
end
function c44559806.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c44559806.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end