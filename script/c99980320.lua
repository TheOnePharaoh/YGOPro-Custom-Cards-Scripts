--HN - Green Heart
function c99980320.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980320.thcon)
  e1:SetTarget(c99980320.thtg)
  e1:SetOperation(c99980320.thop)
  c:RegisterEffect(e1)
  --Multi Attack & Damage
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980320,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCost(c99980320.atkcost)
  e2:SetTarget(c99980320.atktg)
  e2:SetOperation(c99980320.atkop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980320.atkval)
  c:RegisterEffect(e3)
  --Lvl 5 Xyz
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_XYZ_LEVEL)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(5)
  c:RegisterEffect(e4)
  --HN Xyz
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
  e5:SetValue(c99980320.xyzlimit)
  c:RegisterEffect(e5)
end
function c99980320.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980320.thfilter(c)
  return c:IsCode(99980300) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980320.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980320.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980320.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980320.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980320.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980320.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980320.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c99980320.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
  --Multi Attack
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EXTRA_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e2:SetCondition(c99980320.damcon)
  e2:SetTarget(c99980320.damtg)
  e2:SetOperation(c99980320.damop)
  c:RegisterEffect(e2)
  end
end
function c99980320.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c99980320.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(500)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99980320.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function c99980320.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980300)*500
end
function c99980320.xyzlimit(e,c)
  if not c then return false end
  return not c:IsSetCard(0x998)
end