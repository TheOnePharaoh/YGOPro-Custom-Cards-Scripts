--DAL - Virus
function c99970960.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99970960.spcon)
  e1:SetOperation(c99970960.spop)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetTarget(c99970960.thtg)
  e2:SetOperation(c99970960.thop)
  c:RegisterEffect(e2)
  --Damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99970960.damcon)
  e3:SetTarget(c99970960.damtg)
  e3:SetOperation(c99970960.damop)
  c:RegisterEffect(e3)
  --Immune Trap
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99970960.efilter)
  c:RegisterEffect(e4)
  --ATK Down
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970960,0))
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetCondition(c99970960.atkcon)
  e5:SetTarget(c99970960.atktg)
  e5:SetOperation(c99970960.atkop)
  c:RegisterEffect(e5)
end
function c99970960.spfilter(c)
  return c:IsCode(99970940)
end
function c99970960.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
  and Duel.CheckReleaseGroup(c:GetControler(),c99970960.spfilter,1,nil)
end
function c99970960.spop(e,tp,eg,ep,ev,re,r,rp,c)
  local g=Duel.SelectReleaseGroup(c:GetControler(),c99970960.spfilter,1,1,nil)
  Duel.Release(g,REASON_COST)
end
function c99970960.thfilter(c)
  return c:IsSetCard(9997)  and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c99970960.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970960.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970960.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970960.thfilter,tp,LOCATION_DECK,0,1,2,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99970960.damcon(e,tp,eg,ep,ev,re,r,rp)
  return tp==Duel.GetTurnPlayer()
end
function c99970960.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
  Duel.SetTargetPlayer(1-tp)
  local dmg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
  Duel.SetTargetParam(dmg)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dmg)
end
function c99970960.damop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dmg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
  Duel.Damage(p,dmg,REASON_EFFECT)
end
function c99970960.efilter(e,te)
  return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99970960.atkfilter(c)
  return c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970960.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c99970960.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970960,1))
  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99970960.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local tc=Duel.GetFirstTarget()
  Duel.ConfirmDecktop(tp,5)
  local g=Duel.GetDecktopGroup(tp,5)
  local ct=g:FilterCount(c99970960.atkfilter,nil)
  Duel.ShuffleDeck(tp)
  if ct>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-ct*500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
end