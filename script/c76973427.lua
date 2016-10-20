--Vocalist Dark Circuit
function c76973427.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c76973427.encfilter)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76973427,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c76973427.discon)
	e4:SetCost(c76973427.discost)
	e4:SetTarget(c76973427.distg)
	e4:SetOperation(c76973427.disop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(76973427,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c76973427.drcon)
	e5:SetTarget(c76973427.drtg)
	e5:SetOperation(c76973427.drop)
	c:RegisterEffect(e5)
end
function c76973427.encfilter(e,c)
	return c:IsCode(76973411) or c:IsCode(76973412) or c:IsCode(76973415) or c:IsCode(76973416) or c:IsCode(76973418) or c:IsCode(76973419) or c:IsCode(76973420) or c:IsCode(76973421)
end
function c76973427.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c76973427.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c76973427.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c76973427.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c76973427.drawfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c76973427.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c76973427.drawfilter,1,nil)
end
function c76973427.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c76973427.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end