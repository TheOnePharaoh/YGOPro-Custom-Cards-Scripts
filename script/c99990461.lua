--SAO - Silica ALO
function c99990461.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,9999))
  c:EnableReviveLimit()
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990461.dmgcon)
  e1:SetTarget(c99990461.dmgtg)
  e1:SetOperation(c99990461.dmgop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990461,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99990461.sptg)
  e2:SetOperation(c99990461.spop)
  c:RegisterEffect(e2)
  --ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990461.atkcon)
  e3:SetOperation(c99990461.atkop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990461.atkcon2)
  e4:SetOperation(c99990461.atkop)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_BATTLE_DESTROYED)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99990461.atkcon3)
  e5:SetOperation(c99990461.atkop)
  c:RegisterEffect(e5)  
end
function c99990461.dmgcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99990461.dmgfilter(c)
  return c:IsFacedown()
end
function c99990461.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99990461.dmgfilter,tp,0,LOCATION_SZONE,1,nil) end
  local dmg=Duel.GetMatchingGroupCount(c99990461.dmgfilter,e:GetHandler():GetControler(),0,LOCATION_SZONE,nil)*500
  Duel.SetTargetPlayer(1-tp)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
end
function c99990461.dmgop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dmg=Duel.GetMatchingGroupCount(c99990461.dmgfilter,e:GetHandler():GetControler(),0,LOCATION_SZONE,nil)*500
  Duel.Damage(p,dmg,REASON_EFFECT)
end
function c99990461.spfilter(c,e,tp)
  return c:IsCode(99990200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99990461.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99990461.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99990461.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99990461.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99990461.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99990461.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  return tc:IsReason(REASON_BATTLE) and bc:IsRelateToBattle() and bc:IsControler(tp) and bc:IsSetCard(9999)
end
function c99990461.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif tc:IsType(TYPE_MONSTER) and bc:IsControler(tp) and bc:IsSetCard(9999) and tc:IsReason(REASON_BATTLE) and bc:IsReason(REASON_BATTLE) then return true end
end
function c99990461.atkcon3(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif bc:IsType(TYPE_MONSTER) and tc:IsControler(tp) and tc:IsSetCard(9999) and bc:IsReason(REASON_BATTLE) and tc:IsReason(REASON_BATTLE) then return true end
end
function c99990461.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(200)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end