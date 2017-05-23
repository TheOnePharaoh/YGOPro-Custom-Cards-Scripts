--HN - Gust
function c99980740.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980740,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99980740)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCost(c99980740.thcost)
  e1:SetTarget(c99980740.thtg)
  e1:SetOperation(c99980740.thop)
  c:RegisterEffect(e1)
end
function c99980740.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99980740.fil(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL and c:CheckActivateEffect(true,true,false)~=nil
end
function c99980740.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then
  local te=e:GetLabelObject()
  local tg=te:GetTarget()
  return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
  end
  if chk==0 then return Duel.IsExistingTarget(c99980740.fil,tp,LOCATION_DECK,0,1,nil) end
end
function c99980740.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c99980740.fil,tp,LOCATION_DECK,0,1,1,nil,tp)
  Duel.ConfirmCards(1-tp,g)
  Duel.ShuffleDeck(tp)
  local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
  Duel.ClearTargetCard()
  g:GetFirst():CreateEffectRelation(e)
  local tg=te:GetTarget()
  e:SetCategory(te:GetCategory())
  e:SetProperty(te:GetProperty())
  if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
  te:SetLabelObject(e:GetLabelObject())
  if not te then return end
  if not te:GetHandler():IsRelateToEffect(e) then return end
  e:SetLabelObject(te:GetLabelObject())
  local op=te:GetOperation()
  if op then op(e,tp,eg,ep,ev,re,r,rp) end
end