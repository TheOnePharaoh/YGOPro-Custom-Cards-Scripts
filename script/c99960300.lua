--The Tiny Bird The Colors
function c99960300.initial_effect(c)
  c:SetUniqueOnField(1,0,99960300)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --To Grave
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960300,0))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99960300.tgtg)
  e2:SetOperation(c99960300.tgop)
  c:RegisterEffect(e2)
  --Indestruct
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3:SetRange(LOCATION_SZONE)
  e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
  e3:SetTarget(c99960300.infilter)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  --Cost Change
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_LPCOST_CHANGE)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetRange(LOCATION_SZONE)
  e4:SetTargetRange(1,0)
  e4:SetValue(c99960300.costchange)
  c:RegisterEffect(e4)
end
function c99960300.tgfilter(c)
  return c:IsFaceup() and (c:IsCode(99960180) or c:IsCode(99960200) or c:IsCode(99960220) or c:IsCode(99960240) or c:IsCode(99960260))
end
function c99960300.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c99960300.tgfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960300.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960300,1))
  local g=Duel.SelectTarget(tp,c99960300.tgfilter,tp,LOCATION_REMOVED,0,1,5,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c99960300.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
  if sg:GetCount()>0 then
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
  end
end
function c99960300.infilter(e,c)
  return c:IsCode(99960280)
end
function c99960300.costchange(e,re,rp,val)
  if re and re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x996) then
  return val/2
  else
  return val
  end
end