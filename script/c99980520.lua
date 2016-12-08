--HN - A CPU Valentine
function c99980520.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SUMMON+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980520+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980520.target)
  e1:SetOperation(c99980520.activate)
  c:RegisterEffect(e1)
end
function c99980520.filter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end
function c99980520.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980520.filter,tp,LOCATION_DECK,0,1,nil) end
  local ct=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE,0,nil,99980520)
  local rec=300*ct
  Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000-rec)
end
function c99980520.activate(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980520.filter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc and Duel.Summon(tp,tc,true,nil)~=0 then
  local ct=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE,0,nil,99980520)
  local rec=300*ct
  Duel.Recover(1-tp,1000-rec,REASON_EFFECT)
  end
end