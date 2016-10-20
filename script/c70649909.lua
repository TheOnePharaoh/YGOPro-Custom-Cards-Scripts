--ADE Larc
function c70649909.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649909,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c70649909.spcon)
	e1:SetTarget(c70649909.sptg)
	e1:SetOperation(c70649909.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649909,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c70649909.destg)
	e2:SetOperation(c70649909.desop)
	c:RegisterEffect(e2)
end
function c70649909.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c70649909.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70649909.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c70649909.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70649909.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c70649909.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,g2:GetCount(),0,0)
end
function c70649909.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if g1:GetFirst():IsRelateToEffect(e) and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		local hg=g2:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
	end
end