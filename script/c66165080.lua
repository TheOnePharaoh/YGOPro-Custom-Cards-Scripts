--The Legendary Blazing Golem
function c66165080.initial_effect(c)
	--destroy&damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165080,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c66165080.condition)
	e1:SetTarget(c66165080.target)
	e1:SetOperation(c66165080.operation)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66165080,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,66165080)
	e2:SetCondition(c66165080.damcon)
	e2:SetOperation(c66165080.damop)
	c:RegisterEffect(e2)
end
function c66165080.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165080.desfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c66165080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c66165080.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*400)
	end
end
function c66165080.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66165080.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*400,REASON_EFFECT)
	end
end
function c66165080.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165080.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1175,REASON_EFFECT)
end