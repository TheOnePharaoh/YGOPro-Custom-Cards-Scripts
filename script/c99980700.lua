--HN - Dimension Zero
function c99980700.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCondition(c99980700.dmgcon)
  e2:SetTarget(c99980700.dmgtg)
  e2:SetOperation(c99980700.dmgop)
  c:RegisterEffect(e2)
  --Draw
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980700,0))
  e3:SetCategory(CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99980700.drcon)
  e3:SetTarget(c99980700.drtg)
  e3:SetOperation(c99980700.drop)
  c:RegisterEffect(e3)
end
function c99980700.dmgcon(e,tp,eg,ep,ev,re,r,rp)
  local dmg=0
  local tc=eg:GetFirst()
  while tc do
  if tc:IsSetCard(0x998) and tc:IsPreviousPosition(POS_FACEUP) and tc:IsPreviousLocation(LOCATION_MZONE) then
  local tdmg=tc:GetAttack()/2
  dmg=dmg+tdmg
  end
  tc=eg:GetNext()
  end
  if dmg>0 then e:SetLabel(dmg) end
  return dmg>0
end
function c99980700.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local dmg=e:GetLabel()
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dmg)
end
function c99980700.dmgop(e,tp,eg,ep,ev,re,r,rp)
  local dmg=e:GetLabel()
  Duel.Damage(tp,dmg,REASON_EFFECT,true)
  Duel.Damage(1-tp,dmg,REASON_EFFECT,true)
  Duel.RDComplete()
end 
function c99980700.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980700.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99980700.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99980700.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980700.drop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetDecktopGroup(tp,1)
  local tc=g:GetFirst()
  Duel.Draw(tp,1,REASON_EFFECT)
  if tc then
  Duel.ConfirmCards(1-tp,tc)
  if tc:IsSetCard(0x998) and tc:IsType(TYPE_MONSTER) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99980700,1))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99980700.spcon)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  elseif tc:IsSetCard(0x998) and tc:GetType()==TYPE_SPELL+TYPE_CONTINUOUS then
  if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
  Duel.Damage(tp,300,REASON_EFFECT)
  end
  end
  Duel.ShuffleHand(tp)
  end
end
function c99980700.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
end