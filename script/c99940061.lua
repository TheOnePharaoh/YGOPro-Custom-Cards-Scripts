--NGNL - Jibril
function c99940061.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    --Scale change
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(99940061,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetOperation(c99940061.scop)
    c:RegisterEffect(e2)
    --Cannot Target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c99940061.tgtg)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --Mill
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(99940061,5))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c99940061.milltg)
    e4:SetOperation(c99940061.millop)
    c:RegisterEffect(e4)
    --Shuffle
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_DRAW)
    e5:SetCondition(c99940061.sfcon)
    e5:SetTarget(c99940061.sftg)
    e5:SetOperation(c99940061.sfop)
    c:RegisterEffect(e5)
  --ATK Up
  local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_DRAW)
    e6:SetOperation(c99940061.atkop)
    c:RegisterEffect(e6)
end
function c99940061.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(2)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c99940061.tgtg(e,c)
  return c:IsSetCard(9994) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99940061.filter1(c)
  return c:IsDiscardable(REASON_EFFECT)
end
function c99940061.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99940061.millop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
  if Duel.DiscardHand(tp,c99940061.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99940061,4))
  local ac=Duel.SelectOption(tp,aux.Stringid(99940061,1),aux.Stringid(99940061,2),aux.Stringid(99940061,3))
  local ty=TYPE_MONSTER
  if ac==1 then ty=TYPE_SPELL
  elseif ac==2 then ty=TYPE_TRAP end
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
  Duel.ConfirmCards(tp,g)
  local ct=g:FilterCount(Card.IsType,nil,ty)
  Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
  Duel.ShuffleHand(1-tp)
  end
  end
end
function c99940061.sfcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940061.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99940061.sfop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
  local tc=g:GetFirst()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
  end
  end
end99940061
function c99940061.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()   
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(200)
  e1:SetReset(RESET_EVENT+0xff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end