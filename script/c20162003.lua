--Strong Lizardfolk - Shaman
function c20162003.initial_effect(c)
	c:SetUniqueOnField(1,0,20162003)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),aux.NonTuner(Card.IsSetCard,0xab90),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20162003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,20162003+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c20162003.cost)
	e1:SetTarget(c20162003.sptg)
	e1:SetOperation(c20162003.spop)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20162003,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,20162003+EFFECT_COUNT_CODE_OATH)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c20162003.cost)
	e2:SetTarget(c20162003.tdtg)
	e2:SetOperation(c20162003.tdop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20162003,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20162003+EFFECT_COUNT_CODE_OATH)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c20162003.cost)
	e3:SetTarget(c20162003.drtg)
	e3:SetOperation(c20162003.drop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e4)
end
function c20162003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20162003.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92) and not c:IsCode(20162003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20162003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20162003.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c20162003.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20162003.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20162003.filter2(c)
	return c:IsAbleToDeck()
end
function c20162003.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c20162003.filter2(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20162003.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c20162003.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c20162003.filter3(c)
	return c:IsSetCard(0xab90) and c:IsAbleToDeck() and not c:IsPublic()
end
function c20162003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c20162003.filter3,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c20162003.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c20162003.filter3,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end
