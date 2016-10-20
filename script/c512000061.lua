--スピード・フォース
function c512000061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c512000061.activate)
	c:RegisterEffect(e1)
end
function c512000061.activate(e,tp,eg,ep,ev,re,r,rp)
	--indestructable
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(c512000061.indval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c512000061.indval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetOwner()~=e:GetOwner()
end
