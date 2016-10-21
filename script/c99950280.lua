--MSMM - Madness Regrets
function c99950280.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(99950280)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c99950280.eqcon)
	e1:SetTarget(c99950280.target)
	e1:SetOperation(c99950280.operation)
	c:RegisterEffect(e1)
end
function c99950280.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsFaceup() and tc:IsSetCard(9995) and tc:IsControler(tp)
end
function c99950280.filter1(c)
	return c:IsDestructable()
end
function c99950280.filter2(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsLevelAbove(1)
end
function c99950280.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950280.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950280.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99950280.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99950280.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
	end
	if Duel.IsExistingTarget(c99950280.filter2,tp,LOCATION_SZONE,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950280,0))
	local g=Duel.SelectTarget(tp,c99950280.filter2,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)~=0 then
    Duel.Damage(tp,Duel.GetMatchingGroupCount(c99950280.filter2,c:GetControler(),LOCATION_SZONE,0,nil)*100,REASON_EFFECT)
	end
	end
end