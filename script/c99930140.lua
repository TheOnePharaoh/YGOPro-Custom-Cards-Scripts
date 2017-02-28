--OTNN - Twoearle
function c99930140.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930140,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99930140.spcon)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCountLimit(1,99930140)
  e2:SetTarget(c99930140.thtg)
  e2:SetOperation(c99930140.thop)
  c:RegisterEffect(e2)
  --Xyz Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99930140,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99930140.sptg)
  e3:SetOperation(c99930140.spop)
  c:RegisterEffect(e3)
  --Get Effect
  if not c99930140.global_check then
  c99930140.global_check=true
  local ge1=Effect.CreateEffect(c)
  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
  ge1:SetOperation(c99930140.checkop)
  Duel.RegisterEffect(ge1,0)
  end
end
function c99930140.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
function c99930140.thfilter(c)
  return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99930140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99930140.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99930140.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99930140.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99930140.spfilter(c,e,tp,rk)
  return c:IsSetCard(0x993) and e:GetHandler():IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99930140.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99930140.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99930140.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
  local sc=g:GetFirst()
  if sc then
  local mg=c:GetOverlayGroup()
  if mg:GetCount()~=0 then
  Duel.Overlay(sc,mg)
  end
  sc:SetMaterial(Group.FromCards(c))
  Duel.Overlay(sc,Group.FromCards(c))
  Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
  sc:CompleteProcedure()
  end
end
function c99930140.checkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
  if tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x993)
  and tc:GetFlagEffect(99930140)==0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(99930140,1))
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c99930140.rankcon)
  e1:SetValue(c99930140.rankval)
  tc:RegisterEffect(e1,true)
  tc:RegisterFlagEffect(99930140,0,0,1)
  end
  tc=eg:GetNext()
  end
end
function c99930140.rankcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99930140)
end
function c99930140.rankval(e,c)
  return Duel.GetFieldGroupCount(0,LOCATION_MZONE,LOCATION_MZONE)*1
end