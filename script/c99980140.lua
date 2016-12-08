--HN - Lastation
function c99980140.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980140.dmgcon)
  e2:SetTarget(c99980140.dmgtg)
  e2:SetOperation(c99980140.dmgop)
  c:RegisterEffect(e2)
  --To Hand
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCondition(c99980140.thcon)
  e3:SetTarget(c99980140.thtg)
  e3:SetOperation(c99980140.thop)
  c:RegisterEffect(e3)
end
function c99980140.dmgfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99980140.dmgcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980140.dmgfilter1,1,nil,tp)
end
function c99980140.dmgfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980140.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980140.dmgfilter2,tp,LOCATION_MZONE,0,1,nil) end
  Duel.SetTargetPlayer(1-tp)
  local sg=Duel.GetMatchingGroup(c99980140.dmgfilter2,tp,LOCATION_MZONE,0,nil)
  local dam=sg:GetCount()*300
  Duel.SetTargetParam(dam)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99980140.dmgop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local sg=Duel.GetMatchingGroup(c99980140.dmgfilter2,tp,LOCATION_MZONE,0,nil)
  local dam=sg:GetCount()*300
  Duel.Damage(p,dam,REASON_EFFECT)
end
function c99980140.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980140.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980140.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980140.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980140.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end