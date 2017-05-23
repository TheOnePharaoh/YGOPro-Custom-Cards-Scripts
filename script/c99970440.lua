--DAL - Rasiel - Tome of Revelation
function c99970440.initial_effect(c)
  --Copy Effect
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970440,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970440+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970440.target)
  e1:SetOperation(c99970440.operation)
  c:RegisterEffect(e1)
end
function c99970440.filter1(c)
  return c:IsSetCard(0x997) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToRemove()
  and not c:IsCode(99970440) and c:CheckActivateEffect(false,true,false)~=nil
end
function c99970440.filter2(c)
  return c:IsSetCard(0x997) and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c99970440.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
  if chk==0 then return g:GetCount()>0 end
end
function c99970440.operation(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
  if g:GetCount()==0 then return end
  local tc=g:RandomSelect(tp,1):GetFirst()
  Duel.ConfirmCards(tp,tc)
  local ct1=nil
  local ct=nil
  if tc:IsType(TYPE_PENDULUM) then ct1=TYPE_PENDULUM end
  if tc:IsType(TYPE_FUSION) then ct=TYPE_FUSION end
  if tc:IsType(TYPE_SYNCHRO) then ct=TYPE_SYNCHRO end
  if tc:IsType(TYPE_XYZ) then ct=TYPE_XYZ end
  if ct1 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetLabel(ct1)
    e1:SetTargetRange(0,1)
    e1:SetTarget(c99970440.sumlimit)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
  end
  if ct then
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetLabel(ct)
    e2:SetTargetRange(0,1)
    e2:SetTarget(c99970440.sumlimit)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,tp)
  end
  Duel.BreakEffect()
  if Duel.IsExistingMatchingCard(c99970440.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970440,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c99970440.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    local bantg=g:GetFirst()
    if not bantg or Duel.Remove(bantg,POS_FACEUP,REASON_EFFECT)==0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetCondition(c99970440.tdcon)
    e1:SetOperation(c99970440.tdop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    bantg:RegisterEffect(e1)
    g:GetFirst():CreateEffectRelation(e)
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    local te=e:GetLabelObject()
    if not te then return end
    if not te:GetHandler():IsRelateToEffect(e) then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
    if Duel.IsExistingMatchingCard(c99970440.filter2,tp,LOCATION_DECK,0,1,nil) 
    and Duel.SelectYesNo(tp,aux.Stringid(99970440,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970440.filter2),tp,LOCATION_DECK,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
  end
end
function c99970440.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:IsType(e:GetLabel())
end
function c99970440.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970440.tdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end