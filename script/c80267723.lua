--Vocaloid Kid Backup Singer
function c80267723.initial_effect(c)
	c:EnableReviveLimit()
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(80267723,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,80267723)
	e2:SetCondition(c80267723.condition1)
	e2:SetCost(c80267723.cost1)
	e2:SetOperation(c80267723.operation1)
	c:RegisterEffect(e2)
	--atkup grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(80267723,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,80267723)
	e3:SetCondition(c80267723.condition2)
	e3:SetCost(c80267723.cost2)
	e3:SetOperation(c80267723.operation2)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80267723,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c80267723.spcon)
	e4:SetTarget(c80267723.sptg)
	e4:SetOperation(c80267723.spop)
	c:RegisterEffect(e4)
	--spson
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(aux.FALSE)
	c:RegisterEffect(e5)
end
function c80267723.condition1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (d~=nil and a:GetControler()==tp and a:IsRace(RACE_MACHINE) and a:IsRelateToBattle())
		or (d~=nil and d:GetControler()==tp and d:IsFaceup() and d:IsRace(RACE_MACHINE) and d:IsRelateToBattle())
end
function c80267723.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c80267723.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(2100)
	a:RegisterEffect(e1)
end
function c80267723.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsRace(RACE_MACHINE) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsRace(RACE_MACHINE) and d:IsRelateToBattle())
end
function c80267723.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80267723.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(2100)
	a:RegisterEffect(e1)
end
function c80267723.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsType(TYPE_SYNCHRO) and c:GetCode()~=80267723
end
function c80267723.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80267723.cfilter,1,nil,tp)
end
function c80267723.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80267723.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)~=0 then
		c:CompleteProcedure()
	end
end