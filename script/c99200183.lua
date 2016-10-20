--Dark Android Artillery
function c99200183.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99200183.condition)
	e1:SetTarget(c99200183.target)
	e1:SetOperation(c99200183.activate)
	c:RegisterEffect(e1)
end
function c99200183.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsSetCard(0xda3790)
end
function c99200183.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99200183.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99200183.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetChainLimit(c99200183.chainlimit)
end
function c99200183.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:IsActiveType(TYPE_TRAP)
end
function c99200183.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
