--DAL - Date Alive
function c99970640.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970640,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99970640.spcost)
  e2:SetTarget(c99970640.sptg)
  e2:SetOperation(c99970640.spop)
  c:RegisterEffect(e2)
  --Recover
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_RECOVER)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCondition(c99970640.reccon)
  e3:SetTarget(c99970640.rectg)
  e3:SetOperation(c99970640.recop)
  c:RegisterEffect(e3)
end 
function c99970640.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99970640.spfilter(c,e,tp)
  return c:IsSetCard(9997) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970640.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970640.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970640.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970640.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99970640.reccon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99970640.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970640.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970640.recfilter,tp,LOCATION_MZONE,0,1,nil) end
  local rec=Duel.GetMatchingGroupCount(c99970640.recfilter,tp,LOCATION_MZONE,0,nil)*500
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(rec)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c99970640.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local rec=Duel.GetMatchingGroupCount(c99970640.recfilter,tp,LOCATION_MZONE,0,nil)*500
  Duel.Recover(p,rec,REASON_EFFECT)
end