--ANTI-MATTERVERSE, The Gate to Wierd Worlds
function c1143235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dig
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143235,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1,1143235)
	e2:SetTarget(c1143235.drtg)
	e2:SetOperation(c1143235.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143235,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,1143235)
	e3:SetCondition(c1143235.spcon)
	e3:SetTarget(c1143235.sptg)
	e3:SetOperation(c1143235.spop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143235,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,1143235)
	e4:SetTarget(c1143235.thtg)
	e4:SetOperation(c1143235.thop)
	c:RegisterEffect(e4)
	if not c1143235.global_check then
		c1143235.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143235))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143235.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsAbleToDeck()
end
function c1143235.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1143235.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c1143235.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1143235.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143235.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c1143235.confilter(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==tp and c:IsSetCard(0xaf75)
end
function c1143235.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1143235.confilter,1,nil,tp)
end
function c1143235.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143235.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143235.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c1143235.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1143235.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1143235.tgfilter(c,tp)
	return c:IsSetCard(0xaf75) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c1143235.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c1143235.thfilter(c,code)
	return c:IsSetCard(0xaf75) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(code) and c:IsAbleToHand()
end
function c1143235.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143235.tgfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1143235.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1143235.tgfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) or tc:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1143235.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
