--DAL - The Spirit Summer
function c99970520.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Recover
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetCondition(c99970520.reccon)
  e2:SetOperation(c99970520.recop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
  --Shuffle/Draw
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970520,0))
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCategory(CATEGORY_DRAW)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_SZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(c99970520.tdtg)
  e4:SetOperation(c99970520.tdop)
  c:RegisterEffect(e4)
  --Special Summon
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970520,1))
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e5:SetCode(EVENT_DESTROYED)
  e5:SetTarget(c99970520.sptg)
  e5:SetOperation(c99970520.spop)
  c:RegisterEffect(e5)
end
function c99970520.recfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c99970520.reccon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99970520.recfilter,1,nil,tp) and rp==tp
end
function c99970520.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Recover(tp,300,REASON_EFFECT)
end
function c99970520.tdfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99970520.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingTarget(c99970520.tdfilter,tp,LOCATION_HAND,0,1,nil)
  and Duel.IsPlayerCanDraw(tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99970520.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99970520.tdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
  Duel.ShuffleDeck(tp)
  Duel.Draw(tp,1,REASON_EFFECT)
  end
end
function c99970520.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970520.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970520.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970520.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end