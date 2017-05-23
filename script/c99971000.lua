--DAL - Sister
function c99971000.initial_effect(c)
  --ATK/DEF + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99971000,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99971000.atkcon)
  e1:SetTarget(c99971000.atktg)
  e1:SetOperation(c99971000.atkop)
  c:RegisterEffect(e1)
  --Recover
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99971000,2))
  e2:SetCategory(CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,99971000)
  e2:SetCondition(c99971000.reccon)
  e2:SetTarget(c99971000.rectg)
  e2:SetOperation(c99971000.recop)
  c:RegisterEffect(e2)
end
function c99971000.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99971000.countfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER)
end
function c99971000.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99971000.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99971000.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 
  and Duel.IsExistingMatchingCard(c99971000.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99971000.atkop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
  Duel.ConfirmDecktop(1-tp,5)
  local ct=Duel.GetDecktopGroup(1-tp,5):Filter(c99971000.countfilter,nil,e,tp)
  Duel.ShuffleDeck(1-tp)
  local g=Duel.GetMatchingGroup(c99971000.atkfilter,tp,LOCATION_MZONE,0,nil)
  if ct:GetCount()>0 and g:GetCount()>0 then
  local sc=g:GetFirst()
  while sc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  e1:SetValue(ct:GetCount()*100)
  sc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  sc:RegisterEffect(e2)
  sc=g:GetNext()
  end
  if Duel.IsExistingMatchingCard(c99971000.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99971000,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99971000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
  end
end
function c99971000.reccon(e)
  local tp=e:GetHandlerPlayer()
  return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>0
end
function c99971000.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tp=e:GetHandlerPlayer()
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
end
function c99971000.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end