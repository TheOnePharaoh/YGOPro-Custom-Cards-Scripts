--Necromantic Spectral Reinforcements
function c77777748.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c77777748.ctcon)
	e2:SetOperation(c77777748.ctop)
	c:RegisterEffect(e2)
	--ToDeck/Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777748,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c77777748.target)
	e4:SetOperation(c77777748.operation)
	c:RegisterEffect(e4)
end

function c77777748.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1c8)and not re:GetHandler():IsCode(77777748)
end
function c77777748.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1666+COUNTER_NEED_ENABLE,1)
end

function c77777748.filter2(c)
	return c:IsSetCard(0x1c8) and c:IsAbleToDeck()-- and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c77777748.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsCanRemoveCounter(tp,0x1666,2,REASON_COST)
		and Duel.IsExistingMatchingCard(c77777748.filter2,tp,LOCATION_REMOVED,0,1,nil)
	local b2=e:GetHandler():IsCanRemoveCounter(tp,0x1666,25,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(77777748,2),aux.Stringid(77777748,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(77777748,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(77777748,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK)
		e:GetHandler():RemoveCounter(tp,0x1666,2,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:GetHandler():RemoveCounter(tp,0x1666,25,REASON_COST)
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c77777748.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c77777748.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

