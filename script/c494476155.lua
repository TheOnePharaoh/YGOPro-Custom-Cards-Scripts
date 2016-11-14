function c494476155.initial_effect(c)
  --synchro
  aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0600),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
  --gain atk
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetTarget(c494476155.atktg)
  e1:SetValue(c494476155.atkval)
  c:RegisterEffect(e1)
  --atk directly
 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c494476155.tg)
	c:RegisterEffect(e2)
  --spsummon
  local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,494476155)
	e3:SetCondition(c494476155.spcon)
	e3:SetTarget(c494476155.sptg)
	e3:SetOperation(c494476155.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c494476155.tg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c494476155.atktg(e,c)
return c:IsSetCard(0x600)
end
function c494476155.atkfilter(c)
return c:IsFaceup() and c:IsSetCard(0x600)
end
function c494476155.atkval(e,c)
return (Duel.GetMatchingGroupCount(c494476155.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*500)+500
end

function c494476155.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x600) and c:IsControler(tp)
end
function c494476155.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c494476155.cfilter,1,nil,tp)
end
function c494476155.spfilter(c,e,tp)
	return c:IsSetCard(0x600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c494476155.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c494476155.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c494476155.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c494476155.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c494476155.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

