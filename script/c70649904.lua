--ADE Garuda
function c70649904.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649904,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c70649904.destg)
	e1:SetOperation(c70649904.desop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c70649904.atkcon)
	c:RegisterEffect(e2)
	--destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649904,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c70649904.descon2)
	e3:SetTarget(c70649904.destg2)
	e3:SetOperation(c70649904.desop2)
	c:RegisterEffect(e3)
end
function c70649904.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c70649904.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70649904.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c70649904.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70649904.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c70649904.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c70649904.filter2(c)
	return c:IsSetCard(0xd0a214) and not c:IsCode(70649904) and c:IsFaceup()
end
function c70649904.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c70649904.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c70649904.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649904.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70649904.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c70649904.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70649904.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c70649904.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end