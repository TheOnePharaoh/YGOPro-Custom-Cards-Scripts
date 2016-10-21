--BRS - The Little Bird Of Colors
function c99960280.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99960280.accost)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960280,0))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCost(c99960280.cost)
  e2:SetTarget(c99960280.drtg)
  e2:SetOperation(c99960280.drop)
  c:RegisterEffect(e2)
  --Recover
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960280,1))
  e3:SetCategory(CATEGORY_RECOVER)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCost(c99960280.cost)
  e3:SetTarget(c99960280.rectg)
  e3:SetOperation(c99960280.recop)
  c:RegisterEffect(e3)
  --To Hand
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960280,2))
  e4:SetCategory(CATEGORY_TOHAND)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_SZONE)
  e4:SetCost(c99960280.cost)
  e4:SetTarget(c99960280.tdtg)
  e4:SetOperation(c99960280.tdop)
  c:RegisterEffect(e4)
  --To Hand 
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99960280,3))
  e5:SetCategory(CATEGORY_TOHAND)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetCountLimit(1)
  e5:SetRange(LOCATION_SZONE)
  e5:SetCost(c99960280.cost)
  e5:SetTarget(c99960280.thtg)
  e5:SetOperation(c99960280.thop)
  c:RegisterEffect(e5)
  --To Hand Monster
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99960280,4))
  e6:SetCategory(CATEGORY_DAMAGE)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetCountLimit(1)
  e6:SetRange(LOCATION_SZONE)
  e6:SetCost(c99960280.cost)
  e6:SetTarget(c99960280.mthtg)
  e6:SetOperation(c99960280.mthop)
  c:RegisterEffect(e6)
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_FIELD)
  e7:SetCode(EFFECT_UPDATE_ATTACK)
  e7:SetRange(LOCATION_SZONE)
  e7:SetTargetRange(LOCATION_MZONE,0)
  e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9996))
  e7:SetValue(500)
  c:RegisterEffect(e7)
end
function c99960280.filter1(c,code)
  return c:IsCode(code)
end
function c99960280.accost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960180)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960200)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960220)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960240) 
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960260) 
  end
end
function c99960280.filter2(c)
  return (c:IsCode(99960180) or c:IsCode(99960200) or c:IsCode(99960220) or c:IsCode(99960240) or c:IsCode(99960260)) and c:IsAbleToRemoveAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960280.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960280.filter2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99960280.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99960280.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99960280.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function c99960280.filter3(c)
  return c:IsFaceup() and c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER)
end
function c99960280.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960280.filter3,tp,LOCATION_MZONE,0,1,nil) end
  local sg=Duel.GetMatchingGroup(c99960280.filter3,tp,LOCATION_MZONE,0,nil)
  local val=sg:GetCount()*500
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c99960280.recop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c99960280.filter3,tp,LOCATION_MZONE,0,nil)
  local val=sg:GetCount()*500
  Duel.Recover(tp,val,REASON_EFFECT)
end
function c99960280.filter4(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960280.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960280.filter4(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960280.filter4,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=Duel.SelectTarget(tp,c99960280.filter4,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end 
function c99960280.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99960280.filter5(c)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960280.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960280.filter5(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960280.filter5,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=Duel.SelectTarget(tp,c99960280.filter5,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end 
function c99960280.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99960280.filter6(c,e,tp)
  return c:GetLevel()==4 and c:IsAbleToHand()
end
function c99960280.mthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c99960280.filter6(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960280.filter6,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=Duel.SelectTarget(tp,c99960280.filter6,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end 
function c99960280.mthop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end