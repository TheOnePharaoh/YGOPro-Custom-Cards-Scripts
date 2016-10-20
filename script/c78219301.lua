--Colossal Warrior - Keeper
function c78219301.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c78219301.repcon)
	e1:SetOperation(c78219301.repop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c78219301.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219301,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c78219301.thcon)
	e3:SetTarget(c78219301.thtg)
	e3:SetOperation(c78219301.thop)
	c:RegisterEffect(e3)
end
function c78219301.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219301.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219301,e,0,tp,0,0)
end
function c78219301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function c78219301.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7ad30) and c:IsAbleToHand()
end
function c78219301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219301.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78219301.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78219301.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c78219301.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c78219301.discon)
	e1:SetOperation(c78219301.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c78219301.tfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c78219301.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(78219301)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c78219301.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c78219301.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(78219301,1)) then
		e:GetHandler():RegisterFlagEffect(78219301,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end