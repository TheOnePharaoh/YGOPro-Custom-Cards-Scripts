--Shen Long's Mark
function c44559831.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c44559831.target)
	e1:SetOperation(c44559831.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44559831,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,44559831)
	e2:SetCost(c44559831.shufcost)
	e2:SetTarget(c44559831.shuftg)
	e2:SetOperation(c44559831.shufop)
	c:RegisterEffect(e2)
end
function c44559831.filter1(c)
	return c:IsCode(24094653) or c:IsCode(48130397) and c:IsAbleToHand()
end
function c44559831.filter2(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c44559831.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c44559831.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c44559831.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c44559831.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c44559831.filter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c44559831.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c44559831.shufcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c44559831.filter(c)
	return c:IsCode(24094653) or c:IsCode(48130397) and c:IsSSetable(true)
end
function c44559831.spefilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44559831.shuftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c44559831.spefilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c44559831.spefilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c44559831.spefilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c44559831.shufop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c44559831.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end