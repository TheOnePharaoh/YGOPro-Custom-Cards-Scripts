--SAO - Illfang The Kobold Lord
function c99990240.initial_effect(c)
  c:EnableReviveLimit()
  --Cannot be Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e1)
  --Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990240,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99990240.spcon)
  e2:SetOperation(c99990240.spop)
  c:RegisterEffect(e2)
  --Special Summon 1 Token
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990240,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99990240.tktg)
  e3:SetOperation(c99990240.tkop)
  c:RegisterEffect(e3)
  --ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99990240.value)
  c:RegisterEffect(e4)
  --Cannot Be Battle Target
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  e5:SetCondition(c99990240.atkcon)
  e5:SetValue(aux.imval1)
  c:RegisterEffect(e5)
end
function c99990240.spfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990240.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990240.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c99990240.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990240.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99990240.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990260,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99990240.tkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990260,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then
  local token=Duel.CreateToken(tp,99990260)
  Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99990240.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_ONFIELD,0,nil,99990260)*200
end
function c99990240.cafilter(c)
  return c:IsFaceup() and c:IsCode(99990260)
end
function c99990240.atkcon(e)
  return Duel.IsExistingMatchingCard(c99990240.cafilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end