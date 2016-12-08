-- HN - Gust
function c99980740.initial_effect(c)
  --Copy Card
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980740,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetCountLimit(1,99980740)
  e1:SetHintTiming(0,TIMING_END_PHASE)
  e1:SetTarget(c99980740.cptg)
  e1:SetOperation(c99980740.cpop)
  c:RegisterEffect(e1)  
end
function c99980740.fil(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL and c:CheckActivateEffect(true,true,false)~=nil
end
function c99980740.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then
  local te=e:GetLabelObject()
  local tg=te:GetTarget()
  return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
  end
  if chk==0 then return Duel.IsExistingTarget(c99980740.fil,tp,LOCATION_DECK,0,1,nil) end
  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980740.fil,tp,LOCATION_DECK,0,1,1,nil)
  Duel.ConfirmCards(1-tp,g)
  local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
  Duel.ClearTargetCard()
  g:GetFirst():CreateEffectRelation(e)
  local tg=te:GetTarget()
  e:SetCategory(te:GetCategory())
  e:SetProperty(te:GetProperty())
  if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
  te:SetLabelObject(e:GetLabelObject())
  e:SetLabelObject(te)
end
function c99980740.cpop(e,tp,eg,ep,ev,re,r,rp)
  local te=e:GetLabelObject()
  if not te then return end
  if not te:GetHandler():IsRelateToEffect(e) then return end
  e:SetLabelObject(te:GetLabelObject())
  local op=te:GetOperation()
  if op then op(e,tp,eg,ep,ev,re,r,rp) end
  Duel.BreakEffect()
  Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end