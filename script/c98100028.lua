--Aspirin - Song of Smeared Reality and Disappointment
function c98100028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c98100028.regcon)
	e1:SetOperation(c98100028.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c98100028.condition)
	e2:SetCost(c98100028.cost)
	e2:SetTarget(c98100028.target)
	e2:SetOperation(c98100028.activate)
	c:RegisterEffect(e2)
end
function c98100028.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,98100028)==0 and Duel.GetCurrentPhase()==PHASE_DRAW
		and c:IsReason(REASON_DRAW) and c:IsReason(REASON_RULE)
end
function c98100028.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(98100028,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(98100028,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1,0,1)
	end
end
function c98100028.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c98100028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98100028)~=0 end
end
function c98100028.rmfilter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c98100028.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel())
end
function c98100028.rmfilter2(c,lv)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove() and c:GetOriginalLevel()==lv
end
function c98100028.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c98100028.rmfilter2,tp,LOCATION_HAND,0,1,nil,c:GetLevel()-lv)
end
function c98100028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98100028.rmfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98100028.rmfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c98100028.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98100028.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98100028.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalLevel())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c98100028.rmfilter2,tp,LOCATION_HAND,0,1,1,nil,g:GetFirst():GetLevel()-tc:GetOriginalLevel())
		rg:AddCard(tc)
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end