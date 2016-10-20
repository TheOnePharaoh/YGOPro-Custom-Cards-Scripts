--The Legendary Emerald Golem
function c66165083.initial_effect(c)
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
	e2:SetValue(c66165083.tlimit)
	c:RegisterEffect(e2)
	--summon with 2 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165083,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetCondition(c66165083.ttcon)
	e3:SetOperation(c66165083.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66165083,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c66165083.atkcon)
	e5:SetOperation(c66165083.atkop)
	c:RegisterEffect(e5)
	--summon cannot be negated
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(66165083,3))
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCondition(c66165083.negcon)
	e7:SetOperation(c66165083.negop)
	c:RegisterEffect(e7)
	--release limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UNRELEASABLE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
end
function c66165083.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165083.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		at:RegisterEffect(e1)
	end
end
function c66165083.tlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165083.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=2 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
end
function c66165083.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c66165083.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165083.negfilter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c66165083.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c66165083.negfilter,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c66165083.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c66165083.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end