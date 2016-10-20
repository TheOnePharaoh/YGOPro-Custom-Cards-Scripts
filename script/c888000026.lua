--Ultimate Life Drainer
function c888000026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c888000026.con)
	c:RegisterEffect(e1)
	--Drain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)	
	e2:SetOperation(c888000026.operation)
	c:RegisterEffect(e2)
end
function c888000026.cfilter(c)
	return c:IsCode(8124921) or c:IsCode(44519536) or c:IsCode(70903634) or c:IsCode(7902349) or c:IsCode(33396948)
end
function c888000026.con(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_ONFIELD)
	local con1=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)<=1 and ct2>ct1
	local lp1=Duel.GetLP(e:GetHandler():GetControler())
	local lp2=Duel.GetLP(1-e:GetHandler():GetControler())
	local con2=(lp1*4)<=lp2
	local con3=Duel.IsExistingMatchingCard(c888000026.cfilter,tp,0,LOCATION_HAND,4,nil)
	return con1 or con2 or con3
end
function c888000026.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-e:GetHandler():GetControler())
	Duel.SetLP(1-e:GetHandler():GetControler(),lp-50)
end
