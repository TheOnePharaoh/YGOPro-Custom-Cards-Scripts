--The Day After That Tragedy 
function c99200176.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c99200176.cost)
	e1:SetTarget(c99200176.target)
	e1:SetOperation(c99200176.activate)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99200176,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99200176)
	e2:SetCondition(c99200176.fuscon)
	e2:SetCost(c99200176.fuscost)
	e2:SetOperation(c99200176.fusop)
	c:RegisterEffect(e2)
end
function c99200176.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c99200176.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99200176.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99200176.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99200176.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99200176.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c99200176.fusfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c99200176.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
		and not Duel.IsExistingMatchingCard(c99200176.fusfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99200176.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99200176.fusop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c99200176.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c99200176.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
end
