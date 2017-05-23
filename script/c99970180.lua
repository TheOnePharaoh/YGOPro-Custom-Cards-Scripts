--DAL - Metatron-Angel of Extinction
function c99970180.initial_effect(c)
  --Return To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970180,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970180+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970180.target)
  e1:SetOperation(c99970180.operation)
  c:RegisterEffect(e1)
  --Banish From Grave
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970180,1))
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99970180.bancost)
  e2:SetTarget(c99970180.bantg)
  e2:SetOperation(c99970180.banop)
  c:RegisterEffect(e2)
end
function c99970180.filter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
  and Duel.IsExistingMatchingCard(c99970180.filter2,tp,0,LOCATION_MZONE,1,c,c:GetAttack())
end
function c99970180.filter2(c,atk)
  return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c99970180.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970180.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970180.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99970180.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970180.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    local g=Duel.GetMatchingGroup(c99970180.filter2,tp,0,LOCATION_MZONE,tc,tc:GetAttack())
    Duel.SendtoHand(g,nil,REASON_EFFECT)
  end
end
function c99970180.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99970180.banfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970180.banfilter2(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99970180.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970180.banfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970180.banfilter1,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingTarget(c99970180.banfilter2,tp,0,LOCATION_GRAVE,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99970180.banfilter1,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99970180.banfilter2,tp,0,LOCATION_GRAVE,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c99970180.banop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end