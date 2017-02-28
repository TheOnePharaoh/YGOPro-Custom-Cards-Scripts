--BRS - The Little Bird Of Colors
function c99960280.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99960280.acccond)
  c:RegisterEffect(e1)
  --ATK Up
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_FZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x996))
  e2:SetValue(500)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
  --Destroy Replace
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(EFFECT_DESTROY_REPLACE+CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EFFECT_DESTROY_REPLACE)
  e4:SetRange(LOCATION_FZONE)
  e4:SetTarget(c99960280.reptg)
  e4:SetValue(c99960280.repval)
  c:RegisterEffect(e4)
  --To Deck
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER+CATEGORY_DAMAGE)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e5:SetCode(EVENT_TO_GRAVE)
  e5:SetCondition(c99960280.tdcon)
  e5:SetTarget(c99960280.tdtg)
  e5:SetOperation(c99960280.tdop)
  c:RegisterEffect(e5)
end
function c99960280.filter1(c,code)
  return c:IsCode(code)
end
function c99960280.acccond(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960180)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960200)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960220)
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960240) 
  and Duel.IsExistingMatchingCard(c99960280.filter1,tp,LOCATION_GRAVE,0,1,nil,99960260) 
end
function c99960280.repcfilter(c)
  return (c:IsCode(99960180) or c:IsCode(99960200) or c:IsCode(99960220) or c:IsCode(99960240) or c:IsCode(99960260)) 
  and c:IsAbleToRemoveAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960280.repfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
  and c:IsSetCard(0x996) and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
end
function c99960280.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99960280.repfilter,1,nil,tp) end
  if Duel.IsExistingMatchingCard(c99960280.repcfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99960280,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99960280.repcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  return true
  else return false end
end
function c99960280.repval(e,c)
  return c99960280.repfilter(c,e:GetHandlerPlayer())
end
function c99960280.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99960280.tdfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99960280.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960280.tdfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960280.tdfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960280.tdfilter,tp,LOCATION_MZONE,0,1,99,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c99960280.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
  local dam=0
  local tc=g:GetFirst()
  while tc do
  dam=dam + tc:GetBaseAttack()/2
  tc=g:GetNext()
  end
  if ct>0 then
  Duel.Recover(tp,ct*500,REASON_EFFECT)
  Duel.Damage(1-tp,dam,REASON_EFFECT)
  end
end