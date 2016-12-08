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
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980540.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980540.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99980540.drfilter(chkc,e,tp) end
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c99980540.drfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980540.drop(e,tp,eg,ep,ev,re,r,rp)
  local g1=Duel.GetDecktopGroup(tp,1)
  local tc1=g1:GetFirst()
  Duel.Draw(tp,1,REASON_EFFECT)
  if tc1 then
  Duel.ConfirmCards(1-tp,tc1)
  if tc1:IsSetCard(0x998) and tc1:IsType(TYPE_MONSTER) and Duel.IsExistingTarget(c99980540.atkfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
  and Duel.SelectYesNo(tp,aux.Stringid(99980540,0)) then
  local g2=Duel.SelectTarget(tp,c99980540.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  local tc2=g2:GetFirst()
  if tc2:IsFacedown() or not tc2:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(tc1:GetAttack()/2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  end
  end
end