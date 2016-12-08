--HN - Nepgear
function c99980061.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980061,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99980061.spcon)
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
function c99980061.spfilter(c)
  return c:IsFaceup() and c:IsCode(99980000)
end
function c99980061.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99980061.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end