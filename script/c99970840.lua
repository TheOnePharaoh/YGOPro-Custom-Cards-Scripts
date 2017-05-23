--DAL - Pendragon - Ellen
function c99970840.initial_effect(c)
  --xyz summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,3)
  c:EnableReviveLimit()
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99970840.atkval)
  c:RegisterEffect(e1)
  --Immune
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970840,0))
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99970840.cost)
  e2:SetTarget(c99970840.target)
  e2:SetOperation(c99970840.operation)
  c:RegisterEffect(e2)
  --Atk Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EVENT_CHAINING)
  e3:SetRange(LOCATION_MZONE)
  e3:SetOperation(aux.chainreg)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970840,1))
  e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e4:SetCode(EVENT_CHAIN_SOLVING)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetOperation(c99970840.atkop)
  c:RegisterEffect(e4)
end
function c99970840.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970840.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970840.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c99970840.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970840.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970840.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970840.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970840.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99970840.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970840.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetValue(c99970840.efilter)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end
function c99970840.efilter(e,re)
  return e:GetHandler()~=re:GetOwner()
end
function c99970840.atkop(e,tp,eg,ep,ev,re,r,rp)
  if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x997) and re:GetHandler():IsLevelAbove(5) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
end