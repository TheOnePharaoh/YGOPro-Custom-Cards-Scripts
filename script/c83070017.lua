--Hydrush Sun
function c83070017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070017,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c83070017.op)
	c:RegisterEffect(e2)
	--increase atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83070017,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c83070017.cost)
	e3:SetTarget(c83070017.target)
	e3:SetOperation(c83070017.operation)
	c:RegisterEffect(e3)
	--return to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(83070017,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,83070017)
	e4:SetCondition(c83070017.retcon)
	e4:SetTarget(c83070017.rettg)
	e4:SetOperation(c83070017.retop)
	c:RegisterEffect(e4)
end
function c83070017.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
end
function c83070017.ctfilter(c)
	return c:GetCounter(0x1837)>0
end
function c83070017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83070017.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c83070017.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		local sct=tc:GetCounter(0x1837)
		tc:RemoveCounter(tp,0x1837,sct,0)
		sum=sum+sct
		tc=g:GetNext()
	end
	e:SetLabel(sum)
end
function c83070017.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c83070017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c83070017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83070017.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c83070017.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c83070017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(e:GetLabel()*100)
		tc:RegisterEffect(e1)
	end
end
function c83070017.retcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c83070017.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c83070017.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
		Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
	end
end
