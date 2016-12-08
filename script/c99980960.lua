--HN - UD Neptune
function c99980960.initial_effect(c)
  --Neptune Code
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_CHANGE_CODE)
  e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  e1:SetValue(99980000)
  c:RegisterEffect(e1)
  --Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980960,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99980960.spcon)
  c:RegisterEffect(e2)
  --Xyz Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980960,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCountLimit(1,99980960)
  e3:SetTarget(c99980960.xyztg)
  e3:SetOperation(c99980960.xyzop)
  c:RegisterEffect(e3)
  --Get Effect
  if not c99980960.global_check then
  c99980960.global_check=true
  local ge1=Effect.CreateEffect(c)
  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
  ge1:SetOperation(c99980960.checkop)
  Duel.RegisterEffect(ge1,0)
  end
end
function c99980960.spfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980960.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and not Duel.IsExistingMatchingCard(c99980960.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c99980960.xyzfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
  and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980960.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980960.xyzfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c99980960.xyzop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980960.xyzfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
  Duel.Overlay(tc,Group.FromCards(c))
  end
  end
end
function c99980960.checkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
  if tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x998)
  and tc:GetFlagEffect(99980960)==0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99980960.atkcon)
  e1:SetOperation(c99980960.atkop)
  tc:RegisterEffect(e1,true)
  tc:RegisterFlagEffect(99980960,0,0,1)
  end
  tc=eg:GetNext()
  end
end
function c99980960.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99980960)
end
function c99980960.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(500)
  c:RegisterEffect(e1)
end