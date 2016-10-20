--Hydrush Cycle
function c83070011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,83070011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c83070011.condition)
	e1:SetTarget(c83070011.target)
	e1:SetOperation(c83070011.activate)
	c:RegisterEffect(e1)
end
function c83070011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c83070011.filter1(c,e,tp)
	return c:IsSetCard(0x837) and c:IsCanBeSpecialSummoned(e,8307,tp,false,false)
end
function c83070011.filter2(c)
	return c:IsSetCard(0x837) and c:IsAbleToDeck()
end
function c83070011.filter3(c)
	return c:IsSetCard(0x837) and c:IsAbleToHand()
end
function c83070011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local con1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c83070011.filter1,tp,LOCATION_HAND,0,1,nil,e,tp)
	local con2=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c83070011.filter2,tp,LOCATION_GRAVE,0,1,nil)
	local con3=Duel.IsExistingMatchingCard(c83070011.filter3,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return con1 or con2 or con3 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(83070011,3))
	if con1 and con2 and con3 then
		op=Duel.SelectOption(tp,aux.Stringid(83070011,0),aux.Stringid(83070011,1),aux.Stringid(83070011,2))
	elseif con1 and con2 then
		op=Duel.SelectOption(tp,aux.Stringid(83070011,0),aux.Stringid(83070011,1))
	elseif con1 and con3 then
		op=Duel.SelectOption(tp,aux.Stringid(83070011,0),aux.Stringid(83070011,2))
		if op==1 then
			op=2
		end
	elseif con2 and con3 then
		op=Duel.SelectOption(tp,aux.Stringid(83070011,1),aux.Stringid(83070011,2))
		op=op+1
	elseif con1 then
		Duel.SelectOption(tp,aux.Stringid(83070011,0))
		op=0
	elseif con2 then
		Duel.SelectOption(tp,aux.Stringid(83070011,1))
		op=1
	else
		Duel.SelectOption(tp,aux.Stringid(83070011,2))
		op=2
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif op==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c83070011.filter2,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c83070011.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c83070011.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c83070011.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,8307,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==1 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if tg:IsExists(c83070011.tgfilter,1,nil,e) then return end
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c83070011.filter3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
