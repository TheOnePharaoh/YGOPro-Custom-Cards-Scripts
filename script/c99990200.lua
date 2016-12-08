--SAO - Pina
function c99990200.initial_effect(c)
  --Equip 
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
  e1:SetTarget(c99990200.eqtg)
  e1:SetOperation(c99990200.eqop)
  c:RegisterEffect(e1)
  --Destroy Replace
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
  e2:SetValue(c99990200.repval)
  c:RegisterEffect(e2)
end
function c99990200.eqfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990200.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99990200.eqfilter(chkc) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingTarget(c99990200.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  Duel.SelectTarget(tp,c99990200.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c99990200.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
  Duel.SendtoGrave(c,REASON_EFFECT)
  return
  end
  Duel.Equip(tp,c,tc,true)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(c99990200.eqlimit)
  e1:SetLabelObject(tc)
  c:RegisterEffect(e1)
  --ATK Gain
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(500)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1,99990200)
  e3:SetTarget(c99990200.sptg)
  e3:SetOperation(c99990200.spop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e3)
end
function c99990200.eqlimit(e,c)
  return c==e:GetLabelObject()
end
function c99990200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99990200.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
  Duel.SendtoGrave(c,REASON_RULE)
  end
end
function c99990200.repval(e,re,r,rp)
  return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end