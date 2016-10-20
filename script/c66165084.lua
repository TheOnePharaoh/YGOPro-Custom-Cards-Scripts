--The Legendary Anima Golem - Ymir
function c66165084.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--tribute limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIBUTE_LIMIT)
	e2:SetValue(c66165084.tlimit)
	c:RegisterEffect(e2)
	--summon with 3 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165084,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetCondition(c66165084.ttcon)
	e3:SetOperation(c66165084.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
	--summon cannot be negated
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
	--banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66165084,1))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCost(c66165084.remcost)
	e6:SetCondition(c66165084.remcon)
	e6:SetTarget(c66165084.remtg)
	e6:SetOperation(c66165084.remop)
	c:RegisterEffect(e6)
	--release limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c66165084.tlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165084.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=3 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
end
function c66165084.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c66165084.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165084.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c66165084.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c66165084.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
