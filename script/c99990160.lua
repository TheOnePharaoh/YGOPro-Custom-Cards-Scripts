--SAO - Lisbeth
function c99990160.initial_effect(c)
  --Destroy + Search
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99990160.destg)
  e1:SetOperation(c99990160.desop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990160.atkcon)
  e3:SetOperation(c99990160.atkop)
  c:RegisterEffect(e3)
end
function c99990160.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99990160.thfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c99990160.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c99990160.desfilter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(c99990160.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99990160.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99990160.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(99990160,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99990160.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
  end
end
function c99990160.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990160.atkop(e,tp,eg,ep,ev,re,r,rp)
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