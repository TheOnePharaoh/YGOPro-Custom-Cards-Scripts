--Vampiric Sense
function c13212303.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c13212303.condition)
	e1:SetCost(c13212303.cost)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13212303,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c13212303.reccon)
	e2:SetTarget(c13212303.rectg)
	e2:SetOperation(c13212303.recop)
	c:RegisterEffect(e2)
	--self destruct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c13212303.descon)
	c:RegisterEffect(e3)
end
function c13212303.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c13212303.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13212303.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c13212303.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406) and not c:IsCode(13212303) and c:IsAbleToGraveAsCost()
end
function c13212303.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13212303.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13212303.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13212303.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsRace(RACE_MACHINE)
end
function c13212303.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c13212303.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c13212303.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c13212303.descon(e)
	return not Duel.IsExistingMatchingCard(c13212303.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end