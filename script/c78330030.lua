--Infector of the Arch Beetle
function c78330030.initial_effect(c)
	c:SetUniqueOnField(1,0,78330030)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,78330027),aux.NonTuner(Card.IsRace,RACE_INSECT),1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c78330030.atkval)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330030,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c78330030.drcon)
	e2:SetTarget(c78330030.drtg)
	e2:SetOperation(c78330030.drop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78330030,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c78330030.discon)
	e3:SetCost(c78330030.discost)
	e3:SetTarget(c78330030.distg)
	e3:SetOperation(c78330030.disop)
	c:RegisterEffect(e3)
end
function c78330030.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_REMOVED,0,nil,RACE_INSECT)*200
end
function c78330030.drafilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c78330030.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) and eg:IsExists(c78330030.drafilter,1,nil)
end
function c78330030.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78330030.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c78330030.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c78330030.disfilter(c)
	return c:IsCode(78330001) or c:IsCode(78330002) or c:IsCode(78330003) or c:IsCode(78330004) or c:IsCode(78330005) or c:IsCode(78330006) or c:IsCode(78330007) or c:IsCode(78330008) or c:IsCode(78330009) or c:IsCode(78330010) or c:IsCode(78330011) or c:IsCode(78330012) or c:IsCode(78330013) or c:IsCode(78330014) or c:IsCode(78330019) or c:IsCode(78330020) or c:IsCode(78330021) or c:IsCode(78330022) or c:IsCode(78330023) or c:IsCode(78330025) or c:IsCode(78330026) or c:IsCode(78330027) or c:IsCode(78330028) or c:IsCode(78330029) and not c:IsCode(78330030) and c:IsAbleToRemoveAsCost()
end
function c78330030.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78330030.disfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78330030.disfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c78330030.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c78330030.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end