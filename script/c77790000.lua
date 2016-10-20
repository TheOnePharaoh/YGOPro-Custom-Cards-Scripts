--Aria The One
function c77790000.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--ritual summon
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c77790000.splimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77790000.cost)
	e1:SetCondition(c77790000.con)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c77790000.distg)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77790000,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c77790000.condition)
	e3:SetTarget(c77790000.target)
	e3:SetOperation(c77790000.operation)
	c:RegisterEffect(e3)
	--negate 2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetTarget(c77790000.distg)
	c:RegisterEffect(e5)
	--damage reduce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetOperation(c77790000.rdop)
	c:RegisterEffect(e6)
end
function c77790000.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c77790000.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=5
end
function c77790000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c77790000.distg(e,c)
	return c~=e:GetHandler()
end
function c77790000.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c77790000.remfilter(c)
	return (c:IsCode(33396948) or c:IsCode(95308449) or c:IsCode(8062132)or c:IsCode(10000040) or c:IsCode(13893596) or c:IsCode(94212438) 
		or c:IsCode(28566710) or c:IsCode(48995978) or c:IsCode(6165656) or c:IsCode(81171949) or c:IsCode(42776960) or c:IsCode(53334641) 
		or c:IsCode(501000000) or c:IsCode(501000001) or c:IsCode(501000002) or c:IsCode(501000003) or c:IsCode(501000004) or c:IsCode(501000005) 
		or c:IsCode(501000006) or c:IsCode(501000007) or c:IsCode(501000008) or c:IsCode(501000009) or c:IsCode(501000010) or c:IsCode(501000011) 
		or c:IsCode(501000012) or c:IsCode(501000013) or c:IsCode(501000014) or c:IsCode(501000015) or c:IsCode(501000016) or c:IsCode(501000017) 
		or c:IsCode(501000018) or c:IsCode(501000019) or c:IsCode(200000002) or c:IsCode(511000186) or c:IsCode(511000296) or c:IsCode(511000793) 
		or c:IsCode(123214)) and c:IsAbleToRemove() 
end
function c77790000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77790000.remfilter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77790000.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77790000.remfilter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c77790000.rdop(e,tp,eg,ep,ev,re,r,rp)
	local INF=Duel.GetLP(1-tp)
	if e:GetHandler():GetAttack()>INF then
		Duel.ChangeBattleDamage(1-tp,INF)
	end
end
