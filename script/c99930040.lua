--OTNN - Tail Yellow
function c99930040.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCondition(c99930040.xyzcon)
  e1:SetOperation(c99930040.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Rank Up
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetOperation(c99930040.rkop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_ATTACK_ANNOUNCE)
  e3:SetOperation(c99930040.atkop)
  c:RegisterEffect(e3)
  --Attach Monster
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYING)
  e4:SetCondition(c99930040.attachcon)
  e4:SetTarget(c99930040.attachtg)
  e4:SetOperation(c99930040.attachop)
  c:RegisterEffect(e4)
  --Destroy Replace
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(EFFECT_DESTROY_REPLACE+CATEGORY_DAMAGE)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e5:SetCode(EFFECT_DESTROY_REPLACE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99930040.reptg)
  e5:SetValue(c99930040.repval)
  e5:SetOperation(c99930040.repop)
  c:RegisterEffect(e5)
  --Damage
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_DAMAGE)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e6:SetCode(EVENT_ATTACK_ANNOUNCE)
  e6:SetCondition(c99930040.dmgcon)
  e6:SetTarget(c99930040.dmgtg)
  e6:SetOperation(c99930040.dmgop)
  c:RegisterEffect(e6)
end
function c99930040.matfilter(c,xyzc)
  return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(1) and c:IsCanBeXyzMaterial(xyzc) 
end
function c99930040.xyzfilter1(c,g,ct)
  return g:IsExists(c99930040.xyzfilter2,ct,c,c:GetLevel())
end
function c99930040.xyzfilter2(c,lv)
  return c:GetLevel()==lv
end
function c99930040.xyzcon(e,c,og,min,max)
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
  mg=og:Filter(c99930040.matfilter,nil,c)
  else
  mg=Duel.GetMatchingGroup(c99930040.matfilter,tp,LOCATION_MZONE,0,nil,c)
  end
  return maxc>=2 and mg:IsExists(c99930040.xyzfilter1,1,nil,mg,ct)
end
function c99930040.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local g=nil
  if og and not min then
  g=og
  else
  local mg=nil
  if og then
  mg=og:Filter(c99930040.matfilter,nil,c)
  else
  mg=Duel.GetMatchingGroup(c99930040.matfilter,tp,LOCATION_MZONE,0,nil,c)
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
  g=mg:FilterSelect(tp,c99930040.xyzfilter1,1,1,nil,mg,ct)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g2=mg:FilterSelect(tp,c99930040.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetLevel())
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
function c99930040.rkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
function c99930040.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(c:GetRank()*100)
  c:RegisterEffect(e1)
end
function c99930040.attachcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if not c:IsRelateToBattle() or c:IsFacedown() then return false end
  e:SetLabelObject(tc)
  return tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not  tc:IsType(TYPE_TOKEN)
end
function c99930040.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tc=e:GetLabelObject()
  Duel.SetTargetCard(tc)
end
function c99930040.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,tc)
  end
end
function c99930040.repfilter1(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
  and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c99930040.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99930040.repfilter1,1,nil,tp) end
  if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(99930040,0)) then
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
  return true
  else return false end
end
function c99930040.repval(e,c)
  return c99930040.repfilter1(c,e:GetHandlerPlayer())
end
function c99930040.repfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ)
end
function c99930040.repop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsExistingMatchingCard(c99930040.repfilter2,tp,LOCATION_MZONE,0,1,nil)  then
  local g=Duel.GetMatchingGroup(c99930040.repfilter2,tp,LOCATION_MZONE,0,nil)
  local sum=0
  local tc=g:GetFirst()
  while tc do
  sum=sum+tc:GetRank()
  tc=g:GetNext()
  end
  if sum>0 then
  Duel.Damage(1-tp,sum*100,REASON_EFFECT)
  end
  else return end
end
function c99930040.dmgcon(e,c)
  local c=e:GetHandler()  
  if c==nil then return true end
  return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)~=0
end
function c99930040.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  Duel.SetTargetPlayer(1-tp)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c99930040.dmgop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  Duel.Damage(p,ct*500,REASON_EFFECT)
end