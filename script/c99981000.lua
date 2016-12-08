--HN - CyberConnect2
function c99981000.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Draw
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99981000.drcon)
  e1:SetTarget(c99981000.drtg)
  e1:SetOperation(c99981000.drop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCondition(c99981000.spcon)
  e2:SetTarget(c99981000.sptg)
  e2:SetOperation(c99981000.spop)
  c:RegisterEffect(e2)
  --Discard
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_HANDES)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCondition(c99981000.discon)
  e3:SetTarget(c99981000.distg)
  e3:SetOperation(c99981000.disop)
  c:RegisterEffect(e3)
  --To Hand
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99981000,0))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1)
  e4:SetTarget(c99981000.thtg)
  e4:SetOperation(c99981000.thop)
  c:RegisterEffect(e4)
  --Lvl 4 Xyz
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_XYZ_LEVEL)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetValue(4)
  c:RegisterEffect(e5)
end
function c99981000.drfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99981000.drcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99981000.drfilter1,1,nil,tp)
end
function c99981000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99981000.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function c99981000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c99981000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99981000.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
  return false end
end
function c99981000.discon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0
end
function c99981000.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99981000.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
  local sg=g:RandomSelect(1-tp,1)
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  end
end
function c99981000.thfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and not c:IsCode(99981000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99981000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_HAND and c99981000.thfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99981000.thfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99981000.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99981000.thfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
  end
  end
end