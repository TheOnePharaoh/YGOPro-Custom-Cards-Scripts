--B.M.I. Red Core Starter
function c76973425.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c76973425.target)
	e1:SetOperation(c76973425.activate)
	c:RegisterEffect(e1)
end
function c76973425.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c76973425.thfilter(c)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c76973425.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c76973425.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c76973425.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c76973425.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c76973425.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	if Duel.IsExistingMatchingCard(c76973425.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c76973425.chlimit)
	end
end
function c76973425.limfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x301)
end
function c76973425.chlimit(e,ep,tp)
	return tp==ep
end
function c76973425.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c76973425.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
