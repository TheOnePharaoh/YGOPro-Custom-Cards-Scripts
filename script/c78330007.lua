--AB Healer
function c78330007.initial_effect(c)
	--summon without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330007,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c78330007.ntcon)
	c:RegisterEffect(e1)
	--LP up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330007,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c78330007.condition)
	e2:SetTarget(c78330007.target)
	e2:SetOperation(c78330007.operation)
	c:RegisterEffect(e2)
end
function c78330007.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xac9812)
end
function c78330007.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78330007.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c78330007.filter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c78330007.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78330007.filter,1,nil)
end
function c78330007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local ct=eg:FilterCount(c78330007.filter,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ct*400)
end
function c78330007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
