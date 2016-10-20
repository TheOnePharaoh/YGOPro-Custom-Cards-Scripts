--Lyla, High Priest of the Creator
function c11478402.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c11478402.regop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478402,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11478402)
	e2:SetCondition(c11478402.con)
	e2:SetOperation(c11478402.atkop)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478402,1))
	e3:SetCategory(CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11478402)
	e3:SetCondition(c11478402.con)
	e3:SetOperation(c11478402.defop)
	c:RegisterEffect(e3)
end
function c11478402.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,11478402)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf2000))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,11478402,RESET_PHASE+PHASE_END,0,1)
end
function c11478402.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c11478402.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2002) and c:IsType(TYPE_RITUAL)
end
function c11478402.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c11478402.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c11478402.defop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c11478402.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
