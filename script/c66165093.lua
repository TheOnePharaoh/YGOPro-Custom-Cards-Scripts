--
function c66165093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66165093.target)
	e1:SetOperation(c66165093.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66165093,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c66165093.negcon)
	e2:SetCost(c66165093.negcost)
	e2:SetTarget(c66165093.negtg)
	e2:SetOperation(c66165093.negop)
	c:RegisterEffect(e2)
end
function c66165093.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c66165093.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xea010) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c66165093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c66165093.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>1
			and Duel.IsExistingMatchingCard(c66165093.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66165093.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66165093.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 and tg1:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c66165093.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetOperation(c66165093.thop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
		end
	end
end
function c66165093.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c66165093.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c66165093.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66165093.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c66165093.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c66165093.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66165093.negfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66165093.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66165093.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) and tc:IsType(TYPE_EFFECT) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
end