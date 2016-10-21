--HN - The CPU Xmas
function c99980540.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99980540.drtg)
  e1:SetOperation(c99980540.drop)
  c:RegisterEffect(e1)
end
function c99980540.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x9998) and c:IsType(TYPE_MONSTER)
end
function c99980540.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99980540.drfilter(chkc,e,tp) end
  if chk==0 then return Duel.IsExistingTarget(c99980540.drfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c99980540.drop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Draw(tp,1,REASON_EFFECT)
  Duel.Draw(1-tp,1,REASON_EFFECT)
end