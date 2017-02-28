--BRS Rank-Up-Magic
function c99960660.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99960660.target)
  e1:SetOperation(c99960660.activate)
  c:RegisterEffect(e1)
  --Return
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960660.thcon)
  e2:SetCost(c99960660.thcost)
  e2:SetTarget(c99960660.thtg)
  e2:SetOperation(c99960660.thop)
  c:RegisterEffect(e2)
end
function c99960660.filter1(c,e,tp)
  local rk=c:GetRank()
  return rk==4 and c:IsFaceup() and c:IsSetCard(0x996)
  and Duel.IsExistingMatchingCard(c99960660.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c,rk+1)
end
function c99960660.filter2(c,e,tp,mc,rk)
  return c:GetRank()==rk and c:IsSetCard(0x996) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960660.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99960660.filter1(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingTarget(c99960660.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960660.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c99960660.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960660.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
  local sc=g:GetFirst()
  if sc then
  local mg=tc:GetOverlayGroup()
  if mg:GetCount()~=0 then
  Duel.Overlay(sc,mg)
  end
  sc:SetMaterial(Group.FromCards(tc))
  Duel.Overlay(sc,Group.FromCards(tc))
  Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
  --Cannot Be Target
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e1,true)
  --Indest Battle
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e2,true)
  --ATK
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCondition(c99960660.atkcon1)
  e3:SetTarget(c99960660.atktg)
  e3:SetOperation(c99960660.atkop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e3,true)
  --ATK
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99960660.atkcon2)
  e4:SetTarget(c99960660.atktg)
  e4:SetOperation(c99960660.atkop)
  e4:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e4,true)
  if not sc:IsType(TYPE_EFFECT) then
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_ADD_TYPE)
  e5:SetValue(TYPE_EFFECT)
  e5:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e5,true)
  end
  sc:CompleteProcedure()
  end
end
function c99960660.atkcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsRelateToBattle()
end
function c99960660.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(500)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99960660.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Damage(p,d,REASON_EFFECT)~=0 
  and c:IsRelateToEffect(e) and c:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  Duel.SetLP(tp,Duel.GetLP(tp)-500)
  end
end
function c99960660.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
end
function c99960660.thcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960660.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99960660.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end  
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99960660.thop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
  Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
  end
end