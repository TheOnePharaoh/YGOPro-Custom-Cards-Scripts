--Mystic Fauna Hummingbird
function c77777854.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
  --return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777854,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77777854.retcon)
	e1:SetTarget(c77777854.rettg)
	e1:SetOperation(c77777854.retop)
	c:RegisterEffect(e1)
  --atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27143874,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(c77777854.rettg)
	e2:SetOperation(c77777854.retop)
	c:RegisterEffect(e2)
  --atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c77777854.atkval)
	c:RegisterEffect(e3)
end

function c77777854.atkfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x40a)
end
function c77777854.atkval(e,c)
	if c77777854.atkfilter(c) then
		return Duel.GetMatchingGroupCount(c77777854.atkfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
	else return 0 end	
end

function c77777854.ssfilter1(c,e,tp)
	return c:IsSetCard(0x40a) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777854.ssfilter2(c,e,tp)
	return c:IsSetCard(0x40a) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777854.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end
function c77777854.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c77777854.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
  if Duel.IsExistingMatchingCard(c77777854.ssfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
    and Duel.IsExistingMatchingCard(c77777854.ssfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
    local g=Duel.SelectMatchingCard(tp,c77777854.ssfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local g2=Duel.SelectMatchingCard(tp,c77777854.ssfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    g:Merge(g2)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end