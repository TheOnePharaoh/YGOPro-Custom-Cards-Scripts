--DAL - White Licorice - Origami
function c99970260.initial_effect(c)
  --xyz summon
  aux.AddXyzProcedure(c,c99970260.mfilter,3,3,c99970260.ovfilter,aux.Stringid(99970260,1),3,c99970260.xyzop)
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
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetDescription(aux.Stringid(99970260,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99970260.descost)
  e2:SetTarget(c99970260.destg)
  e2:SetOperation(c99970260.desop)
  c:RegisterEffect(e2)
  --Damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetCondition(c99970260.damcon)
  e3:SetTarget(c99970260.damtg)
  e3:SetOperation(c99970260.damop)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e4)
  local e5=e3:Clone()
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e5)
end
function c99970260.mfilter(c)
  return c:IsSetCard(9997)
end
function c99970260.ovfilter(c)
  return c:IsFaceup() and c:IsCode(99970220)
end
function c99970260.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,99970260)==0 end
end
function c99970260.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970260.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970260.filter1,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c99970260.filter2(c)
  return c:IsFaceup() and c:IsDestructable() and c:IsAttackBelow(2000)
end
function c99970260.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970260.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970260.filter2(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970260.filter2,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970260.filter2,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970260.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and c99970260.filter2(tc) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end
function c99970260.filter3(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970260.damcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99970260.filter3,1,nil)
end
function c99970260.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(500)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99970260.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end