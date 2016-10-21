--MSMM - Return Of Miracles
function c99950400.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99950400.drcon)
  e1:SetTarget(c99950400.drtg)
  e1:SetOperation(c99950400.drop)
  c:RegisterEffect(e1)
end
function c99950400.drfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(9995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950400.drcon(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsExistingMatchingCard(c99950400.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99950400.drfilter2(c)
  return c:IsFaceup() and c:IsSetCard(9995) and bit.band(c:GetType(),0x81)==0x81 and  c:GetLevel()==5 and c:IsAbleToDeck()
end
function c99950400.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950400.drfilter2,tp,LOCATION_REMOVED,0,1,nil) end
  local g=Duel.GetMatchingGroup(c99950400.drfilter2,tp,LOCATION_REMOVED,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c99950400.drop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99950400.drfilter2,tp,LOCATION_REMOVED,0,nil)
  local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
  Duel.ShuffleDeck(tp)
  if ct>5 then
  Duel.Draw(tp,3,REASON_EFFECT)
  else 
  Duel.Draw(tp,2,REASON_EFFECT)
  end
end