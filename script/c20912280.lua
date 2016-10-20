--The Sacred Sword's Pedestal
function c20912280.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912280,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetLabel(1)
	e2:SetCountLimit(1,20912280)
	e2:SetCondition(c20912280.effcon)
	e2:SetTarget(c20912280.target5)
	e2:SetOperation(c20912280.operation5)
	c:RegisterEffect(e2)
	--discard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912280,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetLabel(3)
	e3:SetCountLimit(1,20912280)
	e3:SetCondition(c20912280.effcon)
	e3:SetTarget(c20912280.target1)
	e3:SetOperation(c20912280.operation1)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20912280,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetLabel(6)
	e4:SetCountLimit(1,20912280)
	e4:SetCondition(c20912280.effcon)
	e4:SetTarget(c20912280.target2)
	e4:SetOperation(c20912280.operation2)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20912280,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetLabel(9)
	e5:SetCountLimit(1,20912280)
	e5:SetCondition(c20912280.effcon)
	e5:SetTarget(c20912280.target3)
	e5:SetOperation(c20912280.operation3)
	c:RegisterEffect(e5)
	-- draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20912280,4))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1,20912280)
	e6:SetCondition(c20912280.condition4)
	e6:SetTarget(c20912280.target4)
	e6:SetOperation(c20912280.operation4)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(20912280,5))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCountLimit(1,20912280)
	e7:SetCondition(c20912280.condition5)
	e7:SetTarget(c20912280.target6)
	e7:SetOperation(c20912280.operation6)
	c:RegisterEffect(e7)
end
function c20912280.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912280.effcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912280.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c20912280.filter1(c)
	return c:IsSetCard(0xd0a2) and c:IsAbleToGrave()
end
function c20912280.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912280.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c20912280.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20912280.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c20912280.filter2(c,e,tp)
	return  c:IsSetCard(0xd0a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912280.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20912280.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c20912280.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp)
end
function c20912280.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20912280.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tg=Duel.GetMatchingGroup(c20912280.eqfilter,tp,LOCATION_HAND,0,nil,tc,tp)
	if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(20912280,6)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=tg:Select(tp,1,1,nil)
		Duel.Equip(tp,sg:GetFirst(),tc,true)
	end
end
function c20912280.thfilter(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c20912280.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20912280.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912280.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20912280.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c20912280.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c20912280.condition4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912280.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==12
end
function c20912280.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20912280.operation4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c20912280.filter5(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912280.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912280.filter5,tp,LOCATION_MZONE,0,1,nil) end
end
function c20912280.operation5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912280.filter5,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c20912280.condition5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912280.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==15
end
function c20912280.thfilter2(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c20912280.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912280.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20912280.operation6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20912280.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
