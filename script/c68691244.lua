--Darkness Tuning
function c68691244.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c68691244.target)
	e1:SetOperation(c68691244.operation)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68691244,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e2:SetCountLimit(1,68691244)
	e2:SetCost(c68691244.cost)
	e2:SetTarget(c68691244.sctg)
	e2:SetOperation(c68691244.scop)
	c:RegisterEffect(e2)
end
function c68691244.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x0dac405) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c68691244.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c68691244.spfilter(c,e,tp,code)
	return c:IsSetCard(0x0dac405) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68691244.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c68691244.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c68691244.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c68691244.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c68691244.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c68691244.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c68691244.splimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1,true)
	end
end
function c68691244.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x0dac402)
end
function c68691244.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c68691244.scfilter(c)
	return c:IsSetCard(0x0dac402) and c:IsSynchroSummonable(nil)
end
function c68691244.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c68691244.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c68691244.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c68691244.scfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end