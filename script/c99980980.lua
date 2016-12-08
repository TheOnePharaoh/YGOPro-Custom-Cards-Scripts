--HN - MAGES.
function c99980980.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Destroy Replace
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetTarget(c99980980.reptg)
  e1:SetValue(c99980980.repval)
  e1:SetOperation(c99980980.repop)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980980.damcon)
  e2:SetTarget(c99980980.damtg)
  e2:SetOperation(c99980980.damop)
  c:RegisterEffect(e2)
  --Immune Spell/Trap
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980980.imfilter)
  c:RegisterEffect(e3)
  --Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980980,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1,99980980)
  e4:SetCondition(c99980980.spcon)
  e4:SetTarget(c99980980.sptg)
  e4:SetOperation(c99980980.spop)
  c:RegisterEffect(e4)
  if not c99980980.global_check then
  c99980980.global_check=true
  local ge1=Effect.CreateEffect(c)
  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  ge1:SetCode(EVENT_SUMMON_SUCCESS)
  ge1:SetLabel(99980980)
  ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  ge1:SetOperation(aux.sumreg)
  Duel.RegisterEffect(ge1,0)
  local ge2=ge1:Clone()
  ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
  ge2:SetLabel(99980980)
  Duel.RegisterEffect(ge2,0)
  end
end
function c99980980.repfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
    and c:IsSetCard(0x998) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
end
function c99980980.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99980980.repfilter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
  return Duel.SelectYesNo(tp,aux.Stringid(99980980,1))
end
function c99980980.repval(e,c)
  return c99980980.repfilter(c,e:GetHandlerPlayer())
end
function c99980980.repop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c99980980.damfilter1(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x998) 
end
function c99980980.damcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980980.damfilter1,1,nil,tp)
end
function c99980980.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(300)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c99980980.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function c99980980.imfilter(e,te)
  return te:IsActiveType(TYPE_TRAP+TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99980980.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetFlagEffect(99980980)>0
end
function c99980980.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980980.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_DECK+LOCATION_GRAVE and c99980980.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99980980.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980980.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c99980980.damfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x998)
end
function c99980980.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local sg=Duel.GetMatchingGroup(c99980980.damfilter2,tp,LOCATION_MZONE,0,nil)
  local dam=sg:GetCount()*300
  Duel.Damage(1-tp,dam,REASON_EFFECT)
  end
end