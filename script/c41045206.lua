--Vocaloid Rin Kagamine
function c41045206.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41045206,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,41045206)
	e2:SetCost(c41045206.spcost)
	e2:SetTarget(c41045206.sptg)
	e2:SetOperation(c41045206.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c41045206.effcon)
	e3:SetOperation(c41045206.effop)
	c:RegisterEffect(e3)
end
function c41045206.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c41045206.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c41045206.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c41045206.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41045206.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c41045206.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c41045206.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c41045206.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c41045206.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c41045206.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c41045206.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c41045206.limittg)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c41045206.countval)
	e:GetHandler():RegisterEffect(e2)
end
function c41045206.limittg(e,c,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return t1>=2
end
function c41045206.countval(e,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if t1>=2 then return 0 else return 2-t1 end
end
