--Rainbow Snake Eingana
function c512000108.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000638,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c512000108.condition)
	e1:SetTarget(c512000108.target)
	e1:SetOperation(c512000108.operation)
	c:RegisterEffect(e1)
end
function c512000108.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsReason(REASON_RETURN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c512000108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)
end
function c512000108.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
