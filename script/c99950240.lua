--MSMM - Wish's Pride
function c99950240.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c99950240.condition)
	e1:SetCost(c99950240.cost)
	e1:SetOperation(c99950240.activate)
	c:RegisterEffect(e1)
end
function c99950240.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950240.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or tc:IsFacedown() or at:IsFacedown() then return false end
	if tc:IsControler(1-tp) then tc=at end
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(9995)
end
function c99950240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,1000)/100)
	local t={}
	for i=1,m do
	t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	local v=ac
	e:SetLabel(v)
end
function c99950240.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
    local sg=Duel.GetMatchingGroup(c99950240.filter1,tp,LOCATION_MZONE,0,nil)
    local v=e:GetLabel()
	local tc2=sg:GetFirst()
	while tc2 do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(v)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc2:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc2:RegisterEffect(e2)
	tc2=sg:GetNext()
	end
	end
end