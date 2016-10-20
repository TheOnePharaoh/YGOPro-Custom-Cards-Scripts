--DE Assault
function c70649915.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c70649915.target)
	e1:SetOperation(c70649915.activate)
	c:RegisterEffect(e1)
end
function c70649915.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a214) and c:IsDestructable()
end
function c70649915.sfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c70649915.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70649915.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70649915.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c70649915.sfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c70649915.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c70649915.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c70649915.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
