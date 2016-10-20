--Bellerophon the Cosmic Monarch
function c32147691.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32147691,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c32147691.condition)
	e1:SetTarget(c32147691.destg)
	e1:SetOperation(c32147691.desop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c32147691.condition)
	e2:SetOperation(c32147691.regop)
	c:RegisterEffect(e2)
end
function c32147691.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c32147691.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c32147691.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c32147691.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c32147691.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32147691.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c32147691.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,32147691)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c32147691.sumtg))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,32147691,RESET_PHASE+PHASE_END,0,1)
end
function c32147691.sumtg(c)
	return c:IsCode(32147691) or c:IsCode(32147690) or c:IsCode(9748752) or c:IsCode(26205777) or c:IsCode(57666212) or c:IsCode(60229110) or c:IsCode(73125233) or c:IsCode(85718645) or c:IsCode(51945556)
end
