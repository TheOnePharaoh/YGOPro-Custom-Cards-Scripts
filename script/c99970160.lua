--DAL - Itsuka Shido
function c99970160.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970160,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99970160.sumcon)
  c:RegisterEffect(e1)
  --Increase ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970160,1))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99970160.atktg)
  e2:SetOperation(c99970160.atkop)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970160,2))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCondition(c99970160.spcon)
  e3:SetTarget(c99970160.sptg)
  e3:SetOperation(c99970160.spop)
  c:RegisterEffect(e3)
end
function c99970160.sumfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and not c:IsCode(99970160)
end
function c99970160.sumcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99970160.sumfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99970160.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5) 
end
function c99970160.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99970160.atkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970160.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970160.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970160.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local atk=tc:GetAttack()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() and atk>0 then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
function c99970160.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
  and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c99970160.spfilter(c,e,tp)
return c:IsSetCard(0x997) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970160.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970160.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970160.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end