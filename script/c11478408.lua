--Rebirth God of the Bound Creator
function c11478408.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11478408.splimit)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478408,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11478408.negcon)
	e2:SetCost(c11478408.negcost)
	e2:SetTarget(c11478408.negtg)
	e2:SetOperation(c11478408.negop)
	c:RegisterEffect(e2)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478408,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c11478408.sumtg)
	e3:SetOperation(c11478408.sumop)
	c:RegisterEffect(e3)
	--atkup grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetDescription(aux.Stringid(11478408,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c11478408.atkcon)
	e4:SetCost(c11478408.atkcost)
	e4:SetOperation(c11478408.atkop)
	c:RegisterEffect(e4)
end
function c11478408.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c11478408.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c11478408.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11478408.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11478408.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(11478408,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c11478408.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(11478408)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11478408.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function c11478408.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_DEVINE) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_DEVINE) and d:IsRelateToBattle())
end
function c11478408.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11478408.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1650)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	a:RegisterEffect(e2)
end