--OTNN - Tail Blue
function c99930020.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCondition(c99930020.xyzcon)
  e1:SetOperation(c99930020.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Rank Up
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetOperation(c99930020.rkop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_ATTACK_ANNOUNCE)
  e3:SetOperation(c99930020.atkop)
  c:RegisterEffect(e3)
  --Attach Monster
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYING)
  e4:SetCondition(c99930020.attachcon)
  e4:SetTarget(c99930020.attachtg)
  e4:SetOperation(c99930020.attachop)
  c:RegisterEffect(e4)
  --Disable Special Spsummon
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DAMAGE)
  e5:SetType(EFFECT_TYPE_QUICK_O)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_SPSUMMON)
  e5:SetCountLimit(1)
  e5:SetCondition(c99930020.dsscon)
  e5:SetCost(c99930020.dsscost)
  e5:SetTarget(c99930020.dsstg)
  e5:SetOperation(c99930020.dssop)
  c:RegisterEffect(e5)
  --Triple Pierceing 
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e6)
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e7:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e7:SetCondition(c99930020.pircon)
  e7:SetOperation(c99930020.pirop)
  c:RegisterEffect(e7)
end
function c99930020.matfilter(c,xyzc)
  return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(1) and c:IsCanBeXyzMaterial(xyzc) 
end
function c99930020.xyzfilter1(c,g,ct)
  return g:IsExists(c99930020.xyzfilter2,ct,c,c:GetLevel())
end
function c99930020.xyzfilter2(c,lv)
  return c:GetLevel()==lv
end
function c99930020.xyzcon(e,c,og,min,max)
  if c==nil then return true end
  local tp=c:GetControler()
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local minc=2
  local maxc=64
  if min then
  minc=math.max(minc,min)
  maxc=max
  end
  local ct=math.max(minc-1,-ft)
  local mg=nil
  if og then
  mg=og:Filter(c99930020.matfilter,nil,c)
  else
  mg=Duel.GetMatchingGroup(c99930020.matfilter,tp,LOCATION_MZONE,0,nil,c)
  end
  return maxc>=2 and mg:IsExists(c99930020.xyzfilter1,1,nil,mg,ct)
end
function c99930020.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local g=nil
  if og and not min then
  g=og
  else
  local mg=nil
  if og then
  mg=og:Filter(c99930020.matfilter,nil,c)
  else
  mg=Duel.GetMatchingGroup(c99930020.matfilter,tp,LOCATION_MZONE,0,nil,c)
  end
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local minc=2
  local maxc=64
  if min then
  minc=math.max(minc,min)
  maxc=max
  end
  local ct=math.max(minc-1,-ft)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  g=mg:FilterSelect(tp,c99930020.xyzfilter1,1,1,nil,mg,ct)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g2=mg:FilterSelect(tp,c99930020.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetLevel())
  g:Merge(g2)
  end
  local sg=Group.CreateGroup()
  local tc=g:GetFirst()
  while tc do
  sg:Merge(tc:GetOverlayGroup())
  tc=g:GetNext()
  end
  Duel.SendtoGrave(sg,REASON_RULE)
  c:SetMaterial(g)
  Duel.Overlay(c,g)
end
function c99930020.rkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
function c99930020.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(c:GetRank()*100)
  c:RegisterEffect(e1)
end
function c99930020.attachcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if not c:IsRelateToBattle() or c:IsFacedown() then return false end
  e:SetLabelObject(tc)
  return tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not  tc:IsType(TYPE_TOKEN)
end
function c99930020.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tc=e:GetLabelObject()
  Duel.SetTargetCard(tc)
end
function c99930020.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,tc)
  end
end
function c99930020.dsscon(e,tp,eg,ep,ev,re,r,rp)
  return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0
end
function c99930020.dsscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99930020.dsstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
end
function c99930020.dssop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=eg:GetFirst()
  if Duel.NegateSummon(eg)~=0 then
  Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
  end
end
function c99930020.pircon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c99930020.pirop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev*3)
end