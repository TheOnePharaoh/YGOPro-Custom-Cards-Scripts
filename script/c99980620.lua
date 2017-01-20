--HN - Rank-Up-Magic CPU Memory
function c99980620.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99980620.target)
  e1:SetOperation(c99980620.activate)
  c:RegisterEffect(e1)
  end
function c99980620.filter1(c,e,tp)
  local rk=c:GetRank()
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and rk==4
  and Duel.IsExistingMatchingCard(c99980620.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c99980620.filter2(c,e,tp,mc,rk)
	if c.rum_limit_code and not mc:IsCode(c.rum_limit_code) then return false end
  return c:GetRank()==rk and c:IsSetCard(0x998) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99980620.filter3(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980620.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99980620.filter1(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingTarget(c99980620.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980620.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99980620.activate(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980620.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
  local sc=g:GetFirst()
  if sc then
  local mg=tc:GetOverlayGroup()
  if mg:GetCount()~=0 then
  Duel.Overlay(sc,mg)
  end
  sc:SetMaterial(Group.FromCards(tc))
  Duel.Overlay(sc,Group.FromCards(tc))
  Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
  if Duel.IsExistingTarget(c99980620.filter3,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980620,0)) then 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local mg2=Duel.SelectTarget(tp,c99980620.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if mg2:GetCount()==0 then return end
  local sc2=mg2:GetFirst()
  if sc2 then
  Duel.Overlay(sc,mg2)
  end
  end
  sc:CompleteProcedure()
  end
end