--Mystic Fauna Unicorn
function c77777852.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777852,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77777852.tdcon)
	e1:SetTarget(c77777852.tdtg)
	e1:SetOperation(c77777852.tdop)
	c:RegisterEffect(e1)
  --direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end

function c77777852.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77777852.filter(c)
	return c:IsSetCard(0x40a) and not c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c77777852.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777852.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c77777852.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777852.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777852.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,g:GetCount(),nil)
	if g2:GetCount()>0 then
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
end


