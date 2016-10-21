--BRS - Black ★ Rock Shooter - Stella
function c99960120.initial_effect(c)
  c:SetUniqueOnField(1,0,99960120)
  c:EnableReviveLimit()
  --Xyz Summon 1000 LP
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCondition(c99960120.xyzcon1)
  e1:SetOperation(c99960120.xyzop1)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Xyz Summon 500 LP
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetRange(LOCATION_EXTRA)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetCondition(c99960120.xyzcon2)
  e2:SetOperation(c99960120.xyzop2)
  e2:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e2)
  --Attach
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99960120.matcon)
  e3:SetTarget(c99960120.mattg)
  e3:SetOperation(c99960120.matop)
  c:RegisterEffect(e3)
  --Special Summon 1 BRS
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960120,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99960120.spcost)
  e4:SetTarget(c99960120.sptg)
  e4:SetOperation(c99960120.spop)
  c:RegisterEffect(e4)
  --Destroy+Damage
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e5:SetDescription(aux.Stringid(99960120,1))
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetCountLimit(1)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCost(c99960120.descost)
  e5:SetTarget(c99960120.destg)
  e5:SetOperation(c99960120.desop)
  c:RegisterEffect(e5)
  --ATK up
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_UPDATE_ATTACK)
  e6:SetValue(c99960120.value1)
  c:RegisterEffect(e6)
  --ATK up
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE)
  e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e7:SetRange(LOCATION_MZONE)
  e7:SetCode(EFFECT_UPDATE_ATTACK)
  e7:SetValue(c99960120.value2)
  c:RegisterEffect(e7)
end
function c99960120.ovfilter(c)
  return c:IsFaceup() and c:IsCode(99960000)
end
function c99960120.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960120.xyzcon1(e,c,og,min,max)
  local c=e:GetHandler()   
  if c==nil then return true end
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99960120.ovfilter,c) 
  and Duel.GetLP(tp)>=1000 and not Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  return true end
end
function c99960120.xyzop1(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local c=e:GetHandler()   
  Duel.PayLPCost(tp,1000)
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99960120.ovfilter,c) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=altmg:FilterSelect(tp,aux.XyzAlterFilter,1,1,nil,c99960120.ovfilter,c)
  local g2=g:GetFirst():GetOverlayGroup()
  if g2:GetCount()~=0 then
  Duel.Overlay(c,g2)
  end
  c:SetMaterial(g)
  Duel.Overlay(c,g)
  end
end
function c99960120.xyzcon2(e,c,og,min,max)
  local c=e:GetHandler()   
  if c==nil then return true end
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99960120.ovfilter,c) 
  and Duel.GetLP(tp)>=500 and Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  return true end
end
function c99960120.xyzop2(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local c=e:GetHandler()   
  Duel.PayLPCost(tp,500)
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99960120.ovfilter,c) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=altmg:FilterSelect(tp,aux.XyzAlterFilter,1,1,nil,c99960120.ovfilter,c)
  local g2=g:GetFirst():GetOverlayGroup()
  if g2:GetCount()~=0 then
  Duel.Overlay(c,g2)
  end
  c:SetMaterial(g)
  Duel.Overlay(c,g)
  end
end
function c99960120.matcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
end
function c99960120.matfilter(c)
  return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960120.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960120.matfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960120.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960120,2))
  local g=Duel.SelectTarget(tp,c99960120.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
  end
function c99960120.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  local og=c:GetOverlayGroup()
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960120.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.GetLP(tp)>=250 and Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil))
  or (Duel.GetLP(tp)>=500 and not Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
  if Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
  Duel.PayLPCost(tp,250)
  elseif not Duel.IsExistingMatchingCard(c99960120.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  Duel.PayLPCost(tp,500)
  end
end
function c99960120.spfilter(c,e,tp)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and c:IsCanBeSpecialSummoned(e,9996,tp,false,false)
end
function c99960120.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960120.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960120.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960120.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,9996,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960120.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960120.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960120.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  local atk=tc:GetBaseAttack()
  if atk<0 then atk=0 end
  Duel.Damage(1-tp,atk,REASON_EFFECT)
  end
  end
end
function c99960120.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x9996)
end
function c99960120.value1(e,c)
  return Duel.GetMatchingGroupCount(c99960120.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*100
end
function c99960120.value2(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end