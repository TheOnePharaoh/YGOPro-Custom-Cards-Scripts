--Overglowing Bonquet
function c59821082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,59821082+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c59821082.condition)
	e1:SetCost(c59821082.cost)
	e1:SetTarget(c59821082.target)
	e1:SetOperation(c59821082.activate)
	c:RegisterEffect(e1)
end
function c59821082.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated())
end
function c59821082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c59821082.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER)
end
function c59821082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821082.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c59821082.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c59821082.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c59821082.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c59821082.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(59821082,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c59821082.descon)
	e2:SetOperation(c59821082.desop)
	Duel.RegisterEffect(e2,tp)
end
function c59821082.desfilter(c,fid)
	return c:GetFlagEffectLabel(59821082)==fid
end
function c59821082.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c59821082.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c59821082.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c59821082.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end
