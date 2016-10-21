--MSMM - Timeless Soul Cage
function c99950300.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99950300.target)
	e1:SetOperation(c99950300.activate)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c99950300.drcon)
	e2:SetTarget(c99950300.drtg)
	e2:SetOperation(c99950300.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c99950300.ctcon2)
	e3:SetOperation(c99950300.ctop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c99950300.descost)
	e7:SetOperation(c99950300.desop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetTarget(c99950300.destg)
	e8:SetOperation(c99950300.desop2)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e9)
end
function c99950300.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function c99950300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c99950300.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950300.filter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c99950300.filter1,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99950300.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()           
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c99950300.filter1(tc)
	and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
     if tc:IsCode(99950020) then
	--Recover
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c99950300.reccon)
	e1:SetTarget(c99950300.rectg)
	e1:SetOperation(c99950300.recop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	elseif tc:IsCode(99950040) then
	--Counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c99950300.ctcon)
	e1:SetTarget(c99950300.cttg)
	e1:SetOperation(c99950300.ctop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
   	elseif tc:IsCode(99950060) then
	--ATK up
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c99950300.autg)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	elseif tc:IsCode(99950080) then
	--Discard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c99950300.discon)
	e1:SetTarget(c99950300.distg)
	e1:SetOperation(c99950300.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	elseif tc:IsCode(99950100) then
	--Battle Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c99950300.bdcon)
	e1:SetTarget(c99950300.bdtg)
	e1:SetOperation(c99950300.bdop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	elseif tc:IsCode(99950120) then
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c99950300.mscon)
	e1:SetTarget(c99950300.mstg)
	e1:SetOperation(c99950300.msop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	elseif tc:IsCode(99950360) then
	--To hand
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c99950300.thbcon)
    e1:SetTarget(c99950300.thbtg)
    e1:SetOperation(c99950300.thbop)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
	end
	end
end
function c99950300.filter4(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetPreviousControler()~=tp
end
function c99950300.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950300.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99950300.filter4,1,nil,tp)
end
function c99950300.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c99950300.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c99950300.filter3(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950300.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99950300.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99950300.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950300.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950300,0))
	local g=Duel.SelectTarget(tp,c99950300.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x9995,1)
end
function c99950300.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	tc:AddCounter(0x9995,1)
	if tc:GetFlagEffect(99950300)~=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(c99950300.reptg)
	e1:SetOperation(c99950300.repop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(99950300,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c99950300.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetCounter(0x9995)>0 end
	return true
end
function c99950300.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x9995,1,REASON_EFFECT)
end
function c99950300.autg(e,c)
	return c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950300.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0
end
function c99950300.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
end
function c99950300.disop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950300,1))
	local sg=g:Select(p,1,1,nil)
	Duel.ConfirmCards(tp,sg)
	local tc=sg:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
	else Duel.ShuffleHand(1-tp) end 
	end
end
function c99950300.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsReason(REASON_BATTLE) and bc:IsRelateToBattle() and bc:IsControler(tp) and bc:IsSetCard(9995)
end
function c99950300.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99950300.bdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c99950300.filter5(c,e,sp)
	return c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950300.mscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c99950300.filter5,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c99950300.mstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c99950300.filter5,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99950300.msop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99950300.filter5,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c99950300.filter6(c)
  return c:IsSetCard(9995) and bit.band(c:GetType(),0x81)==0x81 and c:GetLevel()==5 and c:IsAbleToHand()
end
function c99950300.thbcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c99950300.filter6,tp,LOCATION_REMOVED,0,1,nil,e,tp)
end
function c99950300.thbtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c99950300.filter4(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950300.filter6,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99950300.filter6,tp,LOCATION_REMOVED,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99950300.thbop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99950300.filter7(c,tp)
	return c:IsSetCard(9995)  and c:IsType(TYPE_MONSTER) and c:IsControler(tp) 
end
function c99950300.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99950300.filter7,1,nil,tp)
end
function c99950300.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99950300.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c99950300.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(9995) and c:IsLevelAbove(1)
end
function c99950300.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99950300.ctfilter,1,nil)
end
function c99950300.ctop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetHandlerPlayer(),500,REASON_EFFECT)
end
function c99950300.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	Duel.PayLPCost(tp,300)
end
function c99950300.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c99950300.desfilter(c)
	return c:IsCode(99950300) and c:IsAbleToHand()
end
function c99950300.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99950300.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950300.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99950300.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end