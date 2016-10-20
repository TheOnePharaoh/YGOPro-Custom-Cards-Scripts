--リアクター・ポッド
function c512000056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000056.target)
	e1:SetOperation(c512000056.activate)
	c:RegisterEffect(e1)
end
function c512000056.filter(c)
	return c:IsAttackBelow(1000) and c:IsFaceup()
end
function c512000056.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c512000056.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c512000056.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c512000056.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c512000056.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
