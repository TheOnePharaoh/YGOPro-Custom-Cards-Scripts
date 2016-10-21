--BRS - Chain Armament
function c99960320.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99960320.target)
  e1:SetOperation(c99960320.activate)
  c:RegisterEffect(e1)
end
function c99960320.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER)
end
function c99960320.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960320.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960320.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960320,0))
  Duel.SelectTarget(tp,c99960320.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960320.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99960320.value)
  e1:SetReset(RESET_EVENT+0x1620000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetTarget(c99960320.damtg)
  e2:SetOperation(c99960320.damop)
  e2:SetReset(RESET_EVENT+0x1620000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  end
end
function c99960320.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end
function c99960320.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tc=e:GetHandler():GetBattleTarget()
  if tc:IsType(TYPE_XYZ) then
  local rk=tc:GetRank()
  dmg=rk*200
  elseif not tc:IsType(TYPE_XYZ) then
  local lvl=tc:GetLevel()
  dmg=lvl*200
    end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(dmg)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
end
function c99960320.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end