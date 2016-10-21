--DAL - Camael
function c99970420.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99970420.damtg)
  e1:SetOperation(c99970420.damop)
  c:RegisterEffect(e1)
end
function c99970420.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970420.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970420.filter1,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.GetMatchingGroupCount(c99970420.filter1,tp,LOCATION_MZONE,0,nil)==1 then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970420.damop(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  if v==1 then 
  Duel.Damage(1-tp,600+ct*600,REASON_EFFECT)
  else 
  Duel.Damage(1-tp,300+ct*300,REASON_EFFECT)
  end
end