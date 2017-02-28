--BRS - Black Rock Shooter Despair
function c99960160.initial_effect(c)
  c:EnableReviveLimit()
  --Fusion Material
  aux.AddFusionProcCode2(c,99960000,99960100,false,false)
  --Spsummon Condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99960160.splimit)
  c:RegisterEffect(e1)
  --Special Summon Rule
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_EXTRA)
  e2:SetValue(1)
  e2:SetCondition(c99960160.sumcon)
  e2:SetOperation(c99960160.sumop)
  c:RegisterEffect(e2)
  --Damage
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c99960160.damcon)
  e3:SetTarget(c99960160.damtg)
  e3:SetOperation(c99960160.damop)
  c:RegisterEffect(e3)
  --Special Summon 1 BRS
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960160,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99960160.spcost)
  e4:SetTarget(c99960160.sptg)
  e4:SetOperation(c99960160.spop)
  c:RegisterEffect(e4)
  --Destroy + Damage + ATK
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99960160,1))
  e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetCountLimit(1)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTarget(c99960160.destg)
  e5:SetOperation(c99960160.desop)
  c:RegisterEffect(e5)
  --Pierceing
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e6)
  --Special summon
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e7:SetCode(EVENT_DESTROYED)
  e7:SetTarget(c99960160.sptg2)
  e7:SetOperation(c99960160.spop2)
  c:RegisterEffect(e7)
   --ATK Up
  local e8=Effect.CreateEffect(c)
  e8:SetType(EFFECT_TYPE_SINGLE)
  e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e8:SetRange(LOCATION_MZONE)
  e8:SetCode(EFFECT_UPDATE_ATTACK)
  e8:SetValue(c99960160.value)
  c:RegisterEffect(e8)
end
function c99960160.splimit(e,se,sp,st)
  return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c99960160.tdfilter(c)
  return c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c99960160.tdfilter1(c,mg,ft)
  local mg2=mg:Clone()
  mg2:RemoveCard(c)
  local ct=ft
  if c:IsLocation(LOCATION_MZONE) then ct=ct+1 end
  return c:IsFusionCode(99960000) and mg2:IsExists(c99960160.tdfilter2,1,nil,ct)
end
function c99960160.tdfilter2(c,ft)
  local ct=ft
  if c:IsLocation(LOCATION_MZONE) then ct=ct+1 end
  return c:IsFusionCode(99960100) and ct>0
end
function c99960160.sumcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<-1 then return false end
  local mg=Duel.GetMatchingGroup(c99960160.tdfilter,tp,LOCATION_ONFIELD,0,nil)
  return mg:IsExists(c99960160.tdfilter1,1,nil,mg,ft)
end
function c99960160.sumop(e,tp,eg,ep,ev,re,r,rp,c)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local mg=Duel.GetMatchingGroup(c99960160.tdfilter,tp,LOCATION_ONFIELD,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g1=mg:FilterSelect(tp,c99960160.tdfilter1,1,1,nil,mg,ft)
  local tc1=g1:GetFirst()
  mg:RemoveCard(tc1)
  if tc1:IsLocation(LOCATION_MZONE) then ft=ft+1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=mg:FilterSelect(tp,c99960160.tdfilter2,1,1,nil,ft)
  local tc2=g2:GetFirst()
  if tc2:IsLocation(LOCATION_MZONE) then ft=ft+1 end
  mg:RemoveCard(tc2)
  g1:Merge(g2)
  Duel.SendtoHand(g1,nil,REASON_COST)
end
function c99960160.damcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99960160.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local dam=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
  if chk==0 then return dam>0 end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(dam)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99960160.damop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dam=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
  Duel.Damage(p,dam,REASON_EFFECT)
end
function c99960160.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960160.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetRank()==4
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960160.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960160.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960160.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960160.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960160.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local dmg=0
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
  if tc:IsType(TYPE_XYZ) then dmg=tc:GetRank() else dmg=tc:GetLevel() end
  if Duel.Damage(1-tp,dmg*300,REASON_EFFECT)~=0 then
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(dmg*300)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  end
  end
end
function c99960160.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960160.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c99960160.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960160.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960160.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end