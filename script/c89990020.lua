--Ohomarax
function c89990020.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c89990020.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c89990020.condition)
	e2:SetTarget(c89990020.target)
	e2:SetOperation(c89990020.operation)
	c:RegisterEffect(e2)
end
function c89990020.indcon(e)
	return Duel.IsEnvironment(89990018)
end
function c89990020.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c89990020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c89990020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
