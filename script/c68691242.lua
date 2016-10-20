--The Vocalist's First Creation
function c68691242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c68691242.condition)
	e1:SetCost(c68691242.cost)
	e1:SetTarget(c68691242.target)
	e1:SetOperation(c68691242.activate)
	c:RegisterEffect(e1)
end
function c68691242.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1
end
function c68691242.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end
function c68691242.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68691242.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c68691242.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK)
end
function c68691242.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
	local g=Duel.GetMatchingGroup(c68691242.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local tc=sg1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(68691242,RESET_EVENT+0x1fe0000,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=sg1:GetNext()
		end
		sg1:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg1)
		e3:SetCondition(c68691242.descon)
		e3:SetOperation(c68691242.desop)
		Duel.RegisterEffect(e3,tp)
		Duel.SpecialSummonComplete()
	end
end
function c68691242.desfilter(c,fid)
	return c:GetFlagEffectLabel(68691242)==fid
end
function c68691242.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c68691242.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c68691242.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c68691242.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
