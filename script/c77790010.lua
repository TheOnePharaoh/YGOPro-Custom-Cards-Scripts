--Ouroboros the Infinity, 5th Arian Guardian 
function c77790010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7779010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c77790010.spcon)
	e1:SetCost(c77790010.spcost)
	e1:SetTarget(c77790010.sptg)
	e1:SetOperation(c77790010.spop)
	c:RegisterEffect(e1)
end
function c77790010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c77790010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE  and e:GetHandler():IsReason(REASON_DESTROY)
end
function c77790010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77790010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
