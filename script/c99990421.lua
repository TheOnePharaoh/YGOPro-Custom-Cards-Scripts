--SAO - Sinon GGO
function c99990421.initial_effect(c)
  --Xyz summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --Destroy 1 Spell/Trap
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990421.descon)
  e1:SetTarget(c99990421.destg)
  e1:SetOperation(c99990421.desop)
  c:RegisterEffect(e1)
  --Discard
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990421,0))
  e2:SetCategory(CATEGORY_HANDES)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99990421.discost)
  e2:SetCondition(c99990421.discon)
  e2:SetTarget(c99990421.distg)
  e2:SetOperation(c99990421.disop)
  c:RegisterEffect(e2)
  --Direct attack
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DIRECT_ATTACK)
  c:RegisterEffect(e3)
  --ATK/DEF
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990421.atkcon)
  e4:SetOperation(c99990421.atkop)
  c:RegisterEffect(e4)
end
function c99990421.descon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
end
function c99990421.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99990421.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c99990421.desfilter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(c99990421.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99990421.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99990421.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end
function c99990421.discon(e)
  return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0
end
function c99990421.discost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99990421.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99990421.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_HAND,1,1,nil)
  if g:GetCount()~=0 then
  Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
  Duel.ShuffleHand(1-tp)
  local tc=g:GetFirst()
  if not tc:IsType(TYPE_MONSTER) then
  Duel.Draw(tp,1,REASON_EFFECT)
  end
  end
end
function c99990421.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
  e:SetLabel(des:GetRank()) 
  else
  e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x999) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c99990421.atkop(e,tp,eg,ep,ev,re,r,rp)
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