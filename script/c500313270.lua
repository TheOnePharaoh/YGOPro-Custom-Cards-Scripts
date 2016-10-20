--Doomed Mail Box
function c500313270.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500313270,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(c500313270.operation)
	c:RegisterEffect(e1)
end
function c500313270.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(500313270,1))
		e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c500313270.descon)
		e1:SetCost(c500313270.descost)
		e1:SetTarget(c500313270.destg)
		e1:SetOperation(c500313270.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		c:RegisterEffect(e1)
	end
end
function c500313270.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c500313270.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c500313270.desfilter(c)
	return c:GetCounter(0x1079)~=0 and c:IsDestructable()
end
function c500313270.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c500313270.desfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c500313270.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500313270.desfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
