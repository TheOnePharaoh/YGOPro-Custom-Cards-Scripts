--SAO - Bits Of Sorrow
function c99990660.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c99990660.condition)
	e1:SetTarget(c99990660.target)
	e1:SetOperation(c99990660.operation)
	c:RegisterEffect(e1)
end
function c99990660.filter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:IsSetCard(9999)
end
function c99990660.filter2(c)
	return c:IsFaceup() and c:IsSetCard(9999) and c:IsType(TYPE_MONSTER)
end
function c99990660.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c99990660.filter1,1,nil,tp)
end
function c99990660.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c99990660.filter2,tp,LOCATION_MZONE,0,1,nil) end
	local val=eg:Filter(c99990660.filter1,nil,tp):GetFirst():GetBaseAttack()
	e:SetLabel(val)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99990660,0))
	Duel.SelectTarget(tp,c99990660.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990660.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local val=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(val/2)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	tc:RegisterEffect(e2)
	end
end