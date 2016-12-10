--Dal - Sister
function c99971000.initial_effect(c)
  --Spsummon Condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99971000.splimit)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetCondition(c99971000.atkcon)
  e2:SetOperation(c99971000.atkop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e4)
  --Recover
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99971000,0))
  e5:SetCategory(CATEGORY_RECOVER)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetCondition(c99971000.reccon)
  e5:SetTarget(c99971000.rectg)
  e5:SetOperation(c99971000.recop)
  c:RegisterEffect(e5)
end
function c99971000.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99971000.atkfilter1(c)
  return c:IsType(TYPE_MONSTER)
end
function c99971000.atkfilter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99971000.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5
end
function c99971000.atkop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ConfirmDecktop(1-tp,5)
  local g1=Duel.GetDecktopGroup(1-tp,5):Filter(c99971000.atkfilter1,nil,e,tp)
  if g1:GetCount()>0  and Duel.IsExistingMatchingCard(c99971000.atkfilter2,tp,LOCATION_MZONE,0,1,nil) then
  local g2=Duel.GetMatchingGroup(c99971000.atkfilter2,tp,LOCATION_MZONE,0,nil)
  local tc=g2:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(g1:GetCount()*100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  tc=g2:GetNext()
  end
  end
end
function c99971000.reccon(e)
  local tp=e:GetHandlerPlayer()
  return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>0
end
function c99971000.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tp=e:GetHandlerPlayer()
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
end
function c99971000.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d/2,REASON_EFFECT)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e:GetHandler():RegisterEffect(e1)
end