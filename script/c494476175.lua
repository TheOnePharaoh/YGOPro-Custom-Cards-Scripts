function c494476175.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.nfbdncon)
	e1:SetTarget(c494476175.splimit)
	c:RegisterEffect(e1)
	--Increase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46035545,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c494476175.atkcost)
	e2:SetTarget(c494476175.atktg)
	e2:SetOperation(c494476175.atkop)
	c:RegisterEffect(e2)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(46035545,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,46035545)
	e6:SetCondition(c494476175.thcon)
	e6:SetTarget(c494476175.thtg)
	e6:SetOperation(c494476175.thop)
	c:RegisterEffect(e6)
end

function c494476175.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x600) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c494476175.atkcfil(c)
  return c:IsSetCard(0x500) or c:IsSetCard(0x601) and c:IsDiscardable()
end
function c494476175.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c494476175.atkcfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c494476175.atkcfil,1,1,REASON_COST+REASON_DISCARD)
end
function c494476175.atkfil(c)
  return c:IsFaceup() and c:IsSetCard(0x600) and c:IsLevelBelow(8)
end
function c494476175.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c494476175.atkfil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c494476175.atkfil,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c494476175.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c494476175.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
  end
end

function c494476175.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c494476175.thfil1(c)
  return c:IsFaceup() and c:IsSetCard(0x600) and c:IsAbleToHand()
end
function c494476175.thfil2(c)
  return c:IsFaceup() and c:IsSetCard(0x600) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c494476175.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c46035545.thfil1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c494476175.thfil1,tp,LOCATION_MZONE,0,1,nil) 
	and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
	and Duel.IsExistingMatchingCard(c494476175.thfil2,tp,LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c494476175.thfil1,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c494476175.thop(e,tp,eg,ep,ev,re,r,rp)
  local ct=0
  if Duel.CheckLocation(tp,LOCATION_SZONE,6) then ct=ct+1 end
  if Duel.CheckLocation(tp,LOCATION_SZONE,7) then ct=ct+1 end
  if ct==0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c494476175.thfil2,tp,LOCATION_EXTRA,0,1,ct,nil)
	local pc=g:GetFirst()
	while pc do
	  Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  pc=g:GetNext()
	end
  end
end