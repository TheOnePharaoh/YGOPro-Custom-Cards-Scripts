--The Wierd Gate, ANTI-MATTER Portal
function c1143242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143242,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,1143242)
	e1:SetCost(c1143242.cost)
	e1:SetTarget(c1143242.target)
	e1:SetOperation(c1143242.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143242,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,1143242)
	e2:SetCost(c1143242.thcost)
	e2:SetTarget(c1143242.thtg)
	e2:SetOperation(c1143242.thop)
	c:RegisterEffect(e2)
	if not c1143242.global_check then
		c1143242.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143242))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143242.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsCode(1143242) and c:IsAbleToRemoveAsCost()
end
function c1143242.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143242.cfilter,tp,LOCATION_SZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1143242.cfilter,tp,LOCATION_SZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1143242.spfilter(c,e,tp)
	return c:IsSetCard(0xaf75) and c:GetLevel()==6 and c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143242.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c1143242.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c1143242.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1143242.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and g:GetClassCount(Card.GetCode)>=3 then
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
		local fid=c:GetFieldID()
		local tc=sg1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(1143242,RESET_EVENT+0x1fe0000,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
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
		e3:SetCondition(c1143242.descon)
		e3:SetOperation(c1143242.desop)
		Duel.RegisterEffect(e3,tp)
		Duel.SpecialSummonComplete()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c1143242.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1143242.splimit(e,c)
	return not c:IsSetCard(0xaf75)
end
function c1143242.desfilter(c,fid)
	return c:GetFlagEffectLabel(1143242)==fid
end
function c1143242.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1143242.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1143242.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c1143242.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c1143242.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaf75) and not c:IsCode(1143242) and c:IsDiscardable()
end
function c1143242.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143242.thfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c1143242.thfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c1143242.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c1143242.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
