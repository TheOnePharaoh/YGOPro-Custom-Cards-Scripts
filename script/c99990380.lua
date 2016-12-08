--SAO - Kirito - GGO
function c99990380.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990380.thcon)
  e1:SetTarget(c99990380.thtg)
  e1:SetOperation(c99990380.thop)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetDescription(aux.Stringid(99990380,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99990380.descost)
  e2:SetTarget(c99990380.destg)
  e2:SetOperation(c99990380.desop)
  c:RegisterEffect(e2)
  --Second Attack
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLED)
  e3:SetCondition(c99990380.atcon1)
  e3:SetOperation(c99990380.atop1)
  c:RegisterEffect(e3)
  --ATK/DEF Gain
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLED)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990380.atkcon2)
  e4:SetOperation(c99990380.atkop2)
  c:RegisterEffect(e4)
end
function c99990380.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99990380.thfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99990380.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990380.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99990380.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c99990380.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 then
  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g1)
  end
end
function c99990380.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99990380.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99990380.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990380.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c99990380.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
  and Duel.SelectYesNo(tp,aux.Stringid(99990380,1)) then 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990380.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end
function c99990380.atcon1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(99990380)==0
  and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c99990380.atop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChainAttack()
end
function c99990380.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a,d=d,a end
  if d:IsType(TYPE_XYZ) then
  e:SetLabel(d:GetRank()) 
  else
  e:SetLabel(d:GetLevel())
  end
  return a:IsControler(tp) and a:IsSetCard(0x999) and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99990380.atkop2(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end