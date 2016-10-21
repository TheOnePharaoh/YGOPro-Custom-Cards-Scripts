--BRS - Black ★ Rock Shooter Despair
function c99960160.initial_effect(c)
  c:SetUniqueOnField(1,0,99960160)
  c:EnableReviveLimit()
  --Fusion Material
  aux.AddFusionProcCode2(c,99960000,99960160,false,false)
  c:EnableReviveLimit()
  --Spsummon Condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99960160.splimit)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_EXTRA)
  e2:SetCondition(c99960160.fuscon)
  e2:SetOperation(c99960160.fusop)
  c:RegisterEffect(e2)
  --Special Summon 1 BRS
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960160,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960160.spcost)
  e3:SetTarget(c99960160.sptg)
  e3:SetOperation(c99960160.spop)
  c:RegisterEffect(e3)
  --Destroy+Damage+ATK Gain
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960160,1))
  e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1)
  e4:SetTarget(c99960160.destg)
  e4:SetOperation(c99960160.desop)
  c:RegisterEffect(e4)
  --Piercing
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e5)
  --Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e6:SetCode(EVENT_DESTROYED)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e6:SetTarget(c99960160.sumtg)
  e6:SetOperation(c99960160.sumop)
  c:RegisterEffect(e6)
  --ATK Up
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE)
  e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e7:SetRange(LOCATION_MZONE)
  e7:SetCode(EFFECT_UPDATE_ATTACK)
  e7:SetValue(c99960160.value)
  c:RegisterEffect(e7)
end
function c99960160.splimit(e,se,sp,st)
  return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c99960160.fusfilter(c,code)
  return c:IsAbleToDeckOrExtraAsCost() and c:GetCode()==code
end
function c99960160.fuscon(e,c)
  if c==nil then return true end 
  local tp=c:GetControler()
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<-1 then return false end
  local g1=Duel.GetMatchingGroup(c99960160.fusfilter,tp,LOCATION_ONFIELD,0,nil,99960000)
  local g2=Duel.GetMatchingGroup(c99960160.fusfilter,tp,LOCATION_ONFIELD,0,nil,99960100)
  if g1:GetCount()==0 or g2:GetCount()==0 then return false end
  if ft>0 then return true end
  local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
  local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
  if ft==-1 then return f1>0 and f2>0
  else return f1>0 or f2>0 end
end
function c99960160.fusop(e,tp,eg,ep,ev,re,r,rp,c)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local g1=Duel.GetMatchingGroup(c99960160.fusfilter,tp,LOCATION_ONFIELD,0,nil,99960000)
  local g2=Duel.GetMatchingGroup(c99960160.fusfilter,tp,LOCATION_ONFIELD,0,nil,99960100)
  g1:Merge(g2)
  local g=Group.CreateGroup()
  local tc=nil
  for i=1,2 do
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  if ft<=0 then
  tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
  else
  tc=g1:Select(tp,1,1,nil):GetFirst()
  end
  g:AddCard(tc)
  g1:Remove(Card.IsCode,nil,tc:GetCode())
  ft=ft+1
  end
  local cg=g:Filter(Card.IsFacedown,nil)
  if cg:GetCount()>0 then
  Duel.ConfirmCards(1-tp,cg)
  end
  Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99960160.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960160.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.GetLP(tp)>=250 and Duel.IsExistingMatchingCard(c99960160.fildfilter,tp,LOCATION_ONFIELD,0,1,nil))
  or (Duel.GetLP(tp)>=500 and not Duel.IsExistingMatchingCard(c99960160.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
  if Duel.IsExistingMatchingCard(c99960160.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
  Duel.PayLPCost(tp,250)
  elseif not Duel.IsExistingMatchingCard(c99960160.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  Duel.PayLPCost(tp,500)
  end
end
function c99960160.spfilter(c,e,tp)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and c:IsCanBeSpecialSummoned(e,9996,tp,false,false)
end
function c99960160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960160.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960160.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960160.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,9996,tp,tp,false,false,POS_FACEUP)
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
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  if tc:IsType(TYPE_XYZ) then
  local rk=tc:GetRank()
  dmg=rk*300
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc:GetRank()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  end
  elseif not tc:IsType(TYPE_XYZ) then
  local lvl=tc:GetLevel()
  dmg=lvl*300
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc:GetLevel()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  end
  end
  end
end
function c99960160.sumfilter(c,e,tp)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99960160.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c99960160.sumfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99960160.sumfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99960160.sumfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99960160.sumop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SpecialSummon(tc,9996,tp,tp,true,false,POS_FACEUP)
  end
end
function c99960160.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end