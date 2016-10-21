--MSMM - Akemi Homura
function c99950041.initial_effect(c)
	c:EnableReviveLimit()
	--Spell Zone
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c99950041.sztg)
	e1:SetOperation(c99950041.szop)
	c:RegisterEffect(e1)
	--Pay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99950041.paycon)
	e2:SetOperation(c99950041.payop)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c99950041.value)
	c:RegisterEffect(e3)
	--Mill
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99950041,2))
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c99950041.millcon)
	e4:SetOperation(c99950041.millop)
	c:RegisterEffect(e4)
	--To Hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99950041,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c99950041.thcost)
	e5:SetTarget(c99950041.thtg)
	e5:SetOperation(c99950041.thop)
	c:RegisterEffect(e5)
	--Cannot Special Summon
    local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c99950041.splimit)
	c:RegisterEffect(e6)
	--Banish
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c99950041.bancon)
	e7:SetTarget(c99950041.bantg)
	e7:SetOperation(c99950041.banop)
	c:RegisterEffect(e7)
end
function c99950041.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950041.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	return Duel.SelectYesNo(tp,aux.Stringid(99950041,0))
end
function c99950041.szop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--Spell
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	--Counter
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c99950041.ctcon)
	e2:SetTarget(c99950041.cttg)
	e2:SetOperation(c99950041.ctop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950041.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950041.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99950041.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99950041.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950041.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950041,4))
	local g=Duel.SelectTarget(tp,c99950041.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x9995,1)
end
function c99950041.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	tc:AddCounter(0x9995,1)
	if tc:GetFlagEffect(99950041)~=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(c99950041.reptg)
	e1:SetOperation(c99950041.repop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(99950041,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c99950041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetCounter(0x9995)>0 end
	return true
end
function c99950041.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x9995,1,REASON_EFFECT)
end
function c99950041.paycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99950041.payop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(99950041,1)) then
	Duel.PayLPCost(tp,300)
	else
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c99950041.filter2(c,e,tp)
    return c:IsType(TYPE_MONSTER)
end
function c99950041.millcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 
end
function c99950041.millop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.ConfirmDecktop(1-tp,3)
    local g=Duel.GetDecktopGroup(1-tp,3):Filter(c99950041.filter2,nil,e,tp)
	if g:GetCount()>0  then
	local tc=g:GetFirst()
	while tc do
	Duel.SendtoGrave(tc,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
end
end
	Duel.ShuffleDeck(1-tp)
end
function c99950041.filter3(c)
	return c:GetCode()==99950000 and c:IsAbleToHand()
end
function c99950041.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c99950041.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950041.thop(e,tp,eg,ep,ev,re,r,rp,chk)
   	local tg=Duel.GetFirstMatchingCard(c99950041.filter3,tp,LOCATION_DECK,0,nil)
	if tg then
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	end
end
function c99950041.filter4(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950041.bancon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT)
end
function c99950041.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950041.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950041.filter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99950041.filter4,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950041.banop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c99950041.filter5(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950041.value(e,c)
	return Duel.GetMatchingGroupCount(c99950041.filter5,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end