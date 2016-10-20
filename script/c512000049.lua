--ダッシュ・ピルファー
function c512000049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000049.target)
	e1:SetOperation(c512000049.activate)
	c:RegisterEffect(e1)
end
function c512000049.filter(c)
	return c:IsControlerCanBeChanged() and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c512000049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000049.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c512000049.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,c512000049.filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
