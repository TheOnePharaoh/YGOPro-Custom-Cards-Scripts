--SAO - Illusion Incantation
function c99990600.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99990600+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99990600.cost)
	e1:SetTarget(c99990600.target)
	e1:SetOperation(c99990600.activate)
	c:RegisterEffect(e1)
end
function c99990600.filter1(c)
	return c:GetAttack()>0 and c:IsType(TYPE_MONSTER) and c:IsSetCard(9999)
end
function c99990600.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(9999)
end
function c99990600.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99990600.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99990600.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99990600.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99990600.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99990600.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99990600,0))
	Duel.SelectTarget(tp,c99990600.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990600.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local atk=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk/2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
    end
end