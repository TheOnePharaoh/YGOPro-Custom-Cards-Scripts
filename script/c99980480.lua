--HN - Arfoire
function c99980480.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980480,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99980480.spcon)
  c:RegisterEffect(e1)
  --Lvl 4 Xyz
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_XYZ_LEVEL)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetValue(4)
  c:RegisterEffect(e2)
end
function c99980480.spfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980480.spcon(e,c)
  if c==nil then return true end
  if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
  local g=Duel.GetMatchingGroup(c99980480.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
  local ct=g:GetClassCount(Card.GetCode)
  return ct>3
end	