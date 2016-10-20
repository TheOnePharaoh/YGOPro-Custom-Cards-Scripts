--Qilin, Thunder King of the Sky Nirvana
function c44559824.initial_effect(c)
	c:SetUniqueOnField(1,0,44559824)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559824.tgvalue)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c44559824.descon)
	e4:SetTarget(c44559824.destg)
	e4:SetOperation(c44559824.desop)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c44559824.aclimit)
	e5:SetCondition(c44559824.actcon)
	c:RegisterEffect(e5)
	--sp restrict
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559824,0))
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCondition(c44559824.condition)
	e6:SetOperation(c44559824.operation)
	c:RegisterEffect(e6)
end
function c44559824.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559824.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559824.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c44559824.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559824.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c44559824.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c44559824.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c44559824.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c44559824.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c44559824.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c44559824.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c44559824.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c44559824.sumcon)
	e1:SetTarget(c44559824.sumlimit)
	e1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c44559824.sumcon(e)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c44559824.sumlimit(e,c)
	return c:IsType(TYPE_EFFECT)
end