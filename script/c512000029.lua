--未来への思い
function c512000029.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000029.target)
	e1:SetOperation(c512000029.operation)
	c:RegisterEffect(e1)
end
function c512000029.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c512000029.rfilter(c,lv)
	return c:GetLevel()==lv
end
function c512000029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c512000029.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and g:GetClassCount(Card.GetLevel)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(c512000029.rfilter,nil,g1:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,1,1,nil)
	g:Remove(c512000029.rfilter,nil,g2:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c512000029.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=3 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c512000029.checkop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c512000029.lpop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function c512000029.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function c512000029.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,4000,REASON_EFFECT)
end
