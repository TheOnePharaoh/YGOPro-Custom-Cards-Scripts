--SAO - Yui
function c99990080.initial_effect(c)
  --Special summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990080,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99990080.spcon)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCondition(c99990080.drcon)
  e2:SetOperation(c99990080.drop)
  c:RegisterEffect(e2)
end
function c99990080.spfilter(c)
  return c:IsFaceup() and (c:IsCode(99990000) or c:IsCode(99990020) or c:IsCode(99990100) 
  or c:IsCode(99990120) or c:IsCode(99990140) or c:IsCode(99990360) or c:IsCode(99990380))
end
function c99990080.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99990080.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99990080.drcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0x999)
end
function c99990080.drop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Draw(tp,1,REASON_EFFECT)
  if c:IsLocation(LOCATION_GRAVE) then
  Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
  end
end