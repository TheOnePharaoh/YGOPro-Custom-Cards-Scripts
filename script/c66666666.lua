--Combustion Eruption
function c66666666.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66666666+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c66666666.condition)
	e1:SetTarget(c66666666.target)
	e1:SetOperation(c66666666.activate)
	c:RegisterEffect(e1)
end
function c66666666.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c66666666.spfilter(c,e,tp)
	return c:IsSetCard(0x29b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66666666.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66666666.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66666666.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66666666.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		tc:RegisterFlagEffect(66666666,RESET_EVENT+0x1fe0000,0,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabelObject(tc)
		e3:SetCondition(c66666666.descon)
		e3:SetOperation(c66666666.desop)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.SpecialSummonComplete() then
		local g2=Duel.SelectTarget(tp,c66666666.dekfilter,tp,LOCATION_DECK,0,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,2,0,0)
		local tc2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(tc2,REASON_EFFECT)
	end
end
function c66666666.dekfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDestructable()
end
function c66666666.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(66666666)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c66666666.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
