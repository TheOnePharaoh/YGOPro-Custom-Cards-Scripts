--DAL - Vanargandr - Mana
function c99970800.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,3)
  c:EnableReviveLimit()
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99970800.atkval)
  c:RegisterEffect(e1)
  --ATK UP/Second ATK
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetDescription(aux.Stringid(99970800,0))
  e2:SetProperty(EFFECT_FLAG2_XMDETACH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99970800.atkcost)
  e2:SetTarget(c99970800.atktg)
  e2:SetOperation(c99970800.atkop)
  c:RegisterEffect(e2)
  --Piercing
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e3)
end
function c99970800.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970800.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970800.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c99970800.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970800.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970800.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_EXTRA_ATTACK)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetValue(1)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e2)
  end
end