--Hawkeye Gough
--lua script by SGJin
function c12310742.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310742,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12310742.atkcon)
	e1:SetTarget(c12310742.atktg)
	e1:SetOperation(c12310742.atkop)
	c:RegisterEffect(e1)
end
function c12310742.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsControler(tp) and tc:IsPosition(POS_FACEUP_ATTACK)
end
function c12310742.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c12310742.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local c=e:GetHandler()
	local G_arrow=e:GetHandler():GetLevel()*100
	local preatk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-G_arrow)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
end
