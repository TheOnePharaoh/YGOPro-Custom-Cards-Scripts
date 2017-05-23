--DAL - White Licorice - Origami
function c99970260.initial_effect(c)
  --xyz summon
  aux.AddXyzProcedure(c,c99970260.mfilter,3,3,c99970260.ovfilter,aux.Stringid(99970260,0))
  c:EnableReviveLimit()
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99970260.atkval)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970260,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99970260.descost)
  e2:SetTarget(c99970260.destg1)
  e2:SetOperation(c99970260.desop1)
  c:RegisterEffect(e2)
  --Destroy DAL
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970260,2))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_MZONE)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCondition(c99970260.descon)
  e3:SetTarget(c99970260.destg2)
  e3:SetOperation(c99970260.desop2)
  c:RegisterEffect(e3)
end
function c99970260.mfilter(c)
  return c:IsSetCard(0x997)
end
function c99970260.ovfilter(c)
  return c:IsFaceup() and c:IsCode(99970220)
end
function c99970260.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970260.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970260.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c99970260.desfilter1(c)
  return c:IsFaceup() and c:IsDestructable() and c:IsAttackBelow(2000)
end
function c99970260.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970260.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970260.desfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970260.desfilter1,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970260.desfilter1,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970260.desop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end
function c99970260.descon(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return not e:GetHandler():IsStatus(STATUS_CHAINING)
  and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c99970260.desfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970260.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970260.desfilter2(chkc) end
  if chk==0 then return c:GetFlagEffect(99970260)==0 and
  Duel.IsExistingTarget(c99970260.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  c:RegisterFlagEffect(99970260,RESET_CHAIN,0,1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970260.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99970260.desop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.Destroy(tc,REASON_EFFECT)>0 then
  Duel.Damage(1-tp,500,REASON_EFFECT)
  end
  end
end