--起爆化
function c512000054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000054.target)
	e1:SetOperation(c512000054.activate)
	c:RegisterEffect(e1)
end
function c512000054.filter(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function c512000054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c512000054.filter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c512000054.filter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c512000054.filter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c512000054.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.BreakEffect()
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
