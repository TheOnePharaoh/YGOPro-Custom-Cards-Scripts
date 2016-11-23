--The Idol's Graceful Burial
function c59821139.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c59821139.target)
	e1:SetOperation(c59821139.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821139,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821139)
	e2:SetCondition(c59821139.spcon)
	e2:SetCost(c59821139.spcost)
	e2:SetTarget(c59821139.sptg)
	e2:SetOperation(c59821139.spop)
	c:RegisterEffect(e2)
end
function c59821139.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2)
end
function c59821139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821139.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c59821139.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c59821139.tgfilter,tp,LOCATION_DECK,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c59821139.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c59821139.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821139.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821139.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59821139.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c59821139.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821139.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c59821139.descon)
		e1:SetOperation(c59821139.desop)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(59821139,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c59821139.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c59821139.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(59821139)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c59821139.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c59821139.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
