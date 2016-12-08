--OTNN - Attribute Boost
function c99930080.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99930080.rktg)
  e1:SetOperation(c99930080.rkop)
  c:RegisterEffect(e1)
end
function c99930080.rkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ)
end
function c99930080.atkfilter(c)
  return c:IsRace(RACE_WARRIOR) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99930080.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99930080.rkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99930080.rkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99930080.rkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99930080.rkop(e,tp,eg,ep,ev,re,r,rp)    
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CHANGE_RANK_FINAL)
  e1:SetValue(tc:GetRank()*2)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  if Duel.IsExistingTarget(c99930080.atkfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99930080,0)) then 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local mg2=Duel.SelectTarget(tp,c99930080.atkfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
  if mg2:GetCount()==0 then return end
  local sc2=mg2:GetFirst()
  if sc2 and Duel.Overlay(tc,mg2)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(sc2:GetAttack()/2)
  tc:RegisterEffect(e1)
  end
  end
  end
end
