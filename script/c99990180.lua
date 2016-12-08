--SAO - Silica - SAO
function c99990180.initial_effect(c)
  --Lock Spell/Trap
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99990180.lcktg)
  e1:SetOperation(c99990180.lckop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --Special Summon Pina
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990180,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99990180.sptg)
  e3:SetOperation(c99990180.spop)
  c:RegisterEffect(e3)
  --ATK/DEF Gain
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLED)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990180.atkcon)
  e4:SetOperation(c99990180.atkop)
  c:RegisterEffect(e4)
end
function c99990180.lcktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsFacedown() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
  Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
  if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
  Duel.SetChainLimit(c99990180.limit(g:GetFirst()))
  end
end
function c99990180.limit(c)
  return  function (e,lp,tp)
  return e:GetHandler()~=c
  end
end
function c99990180.lckop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_TRIGGER)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end
function c99990180.spfilter(c,e,tp)
  return c:IsCode(99990200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990180.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK+LOCATION_HAND) and c99990180.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99990180.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99990180.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99990180.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99990180.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a,d=d,a end
  if d:IsType(TYPE_XYZ) then
  e:SetLabel(d:GetRank()) 
  else
  e:SetLabel(d:GetLevel())
  end
  return a:IsControler(tp) and a:IsSetCard(0x999) and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99990180.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end