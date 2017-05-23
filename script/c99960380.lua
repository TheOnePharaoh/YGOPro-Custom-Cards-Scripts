--BRS - Black ★ Rock Shooter - Stella
function c99960380.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon 
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetCondition(c99960380.xyzcon)
  e1:SetTarget(c99960380.xyztg)
  e1:SetOperation(c99960380.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Attach
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(c99960380.attachtg)
  e2:SetOperation(c99960380.attachop)
  c:RegisterEffect(e2)
  --Special Summon 1 BRS
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960380,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960380.spcost)
  e3:SetTarget(c99960380.sptg)
  e3:SetOperation(c99960380.spop)
  c:RegisterEffect(e3)
  --Destroy + Damage
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960380,1))
  e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99960380.descost)
  e4:SetTarget(c99960380.destg)
  e4:SetOperation(c99960380.desop)
  c:RegisterEffect(e4)
  --ATK up
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EFFECT_UPDATE_ATTACK)
  e5:SetValue(c99960380.value)
  c:RegisterEffect(e5)
end
function c99960380.ovfilter(c,tp,xyzc)
  return c:IsFaceup() and c:IsCode(99960000) and c:IsCanBeXyzMaterial(xyzc)
end
function c99960380.xyzcon(e,c,og,min,max)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if mg:IsExists(c99960380.ovfilter,1,nil,tp,c) and Duel.CheckLPCost(c:GetControler(),1000) then
  return true
  end
end
function c99960380.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  local g=nil
  if mg:IsExists(c99960380.ovfilter,1,nil,tp,c) then
  Duel.PayLPCost(tp,1000)
  e:SetLabel(1)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  g=mg:FilterSelect(tp,c99960380.ovfilter,1,1,nil,tp,c)
  end
  if g then
  g:KeepAlive()
  e:SetLabelObject(g)
  return true
  else return false end
end
function c99960380.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  if og and not min then
  c:SetMaterial(og)
  Duel.Overlay(c,og)
  else
  local mg=e:GetLabelObject()
  if e:GetLabel()==1 then
  local mg2=mg:GetFirst():GetOverlayGroup()
  if mg2:GetCount()~=0 then
  Duel.Overlay(c,mg2)
  end
  end
  c:SetMaterial(mg)
  Duel.Overlay(c,mg)
  mg:DeleteGroup()
  end
end
function c99960380.attachfilter(c)
  return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960380.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99960380.attachfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960380.attachfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  Duel.SelectTarget(tp,c99960380.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99960380.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960380.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960380.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetRank()==4
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960380.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960380.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960380.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960380.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960380.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960380.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
  local dmg=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  if dmg>0 then
  Duel.Damage(1-tp,dmg*200,REASON_EFFECT)
  end
  end
end
function c99960380.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end