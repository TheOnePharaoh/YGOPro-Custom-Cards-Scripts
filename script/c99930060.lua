--OTNN - Tail Red - Riser Chain
function c99930060.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCondition(c99930060.xyzcon)
  e1:SetOperation(c99930060.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Immune
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetCondition(c99930060.indcon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --Rank Increase
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c99930060.rankcon)
  e3:SetOperation(c99930060.rankop)
  c:RegisterEffect(e3)
  --Rank Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetOperation(c99930060.rkop)
  c:RegisterEffect(e4)
  --Attack Twice
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_EXTRA_ATTACK)
  e5:SetValue(1)
  c:RegisterEffect(e5)
  --ATK Up
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_ATKCHANGE)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e6:SetCode(EVENT_ATTACK_ANNOUNCE)
  e6:SetOperation(c99930060.atkop)
  c:RegisterEffect(e6)
  --Attach Monster
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_BATTLE_DESTROYING)
  e7:SetCondition(c99930060.attachcon)
  e7:SetTarget(c99930060.attachtg)
  e7:SetOperation(c99930060.attachop)
  c:RegisterEffect(e7)
  --ATK Gain
  local e8=Effect.CreateEffect(c)
  e8:SetCategory(CATEGORY_ATKCHANGE)
  e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e8:SetCode(EVENT_SPSUMMON_SUCCESS)
  e8:SetRange(LOCATION_MZONE)
  e8:SetCountLimit(2)
  e8:SetCost(c99930060.agcost)
  e8:SetTarget(c99930060.agtg)
  e8:SetOperation(c99930060.agop)
  c:RegisterEffect(e8)
  --Destroy + Damage
  local e9=Effect.CreateEffect(c)
  e9:SetDescription(aux.Stringid(99930060,0))
  e9:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e9:SetType(EFFECT_TYPE_IGNITION)
  e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e9:SetCountLimit(1)
  e9:SetRange(LOCATION_MZONE)
  e9:SetTarget(c99930060.destg)
  e9:SetOperation(c99930060.desop)
  c:RegisterEffect(e9)
end
function c99930060.ovfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) 
  and c:GetOverlayCount()>=5 and not c:IsCode(99930060)
end
function c99930060.xyzcon(e,c,og,min,max)
  local c=e:GetHandler() 
  if c==nil then return true end
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99930060.ovfilter,c) then
  return true
  end
end
function c99930060.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local c=e:GetHandler() 
  local tp=c:GetControler()
  altmg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if altmg:IsExists(aux.XyzAlterFilter,1,nil,c99930060.ovfilter,c) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=altmg:FilterSelect(tp,aux.XyzAlterFilter,1,1,nil,c99930060.ovfilter,c)
  local g2=g:GetFirst():GetOverlayGroup()
  if g2:GetCount()~=0 then
  Duel.Overlay(c,g2)
  end
  c:SetMaterial(g)
  Duel.Overlay(c,g)
  end
end
function c99930060.indfilter(c)
  return c:IsSetCard(0x993) and c:IsType(TYPE_XYZ)
end
function c99930060.indcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():Filter(c99930060.indfilter,nil)
end
function c99930060.rankcon(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetOverlayCount()
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and ct>0
end
function c99930060.rankop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
  local ct=c:GetOverlayCount()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(ct)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
end
function c99930060.rkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
function c99930060.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(c:GetRank()*100)
  c:RegisterEffect(e1)
end
function c99930060.attachcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if not c:IsRelateToBattle() or c:IsFacedown() then return false end
  e:SetLabelObject(tc)
  return tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not  tc:IsType(TYPE_TOKEN)
end
function c99930060.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tc=e:GetLabelObject()
  Duel.SetTargetCard(tc)
end
function c99930060.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,tc)
  end
end
function c99930060.agfilter(c,e,tp)
  return c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function c99930060.agcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99930060.agtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99930060.agfilter,1,nil,nil,tp) end
  local g=eg:Filter(c99930060.agfilter,nil,nil,tp)
  Duel.SetTargetCard(eg)
end
function c99930060.agop(e,tp,eg,ep,ev,re,r,rp)
  local g=eg:Filter(c99930060.agfilter,nil,e,tp)
  local sum=0
  local tc=g:GetFirst()
  while tc do
  sum=sum+tc:GetBaseAttack()/2
  tc=g:GetNext()
  end
  if sum>0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(sum)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
end
function c99930060.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  local atk=g:GetFirst():GetAttack()
  if atk<0 then atk=0 end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c99930060.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
  local atk=tc:GetAttack()
  if atk<0 then atk=0 end
  if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.Damage(1-tp,atk,REASON_EFFECT)~=0 then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  end
  end
end