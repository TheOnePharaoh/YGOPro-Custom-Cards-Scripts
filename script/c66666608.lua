--Aetherial Exchange
function c66666608.initial_effect(c)
	--Light Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66666608)
	e1:SetDescription(aux.Stringid(66666608,0))
	e1:SetCost(c66666608.lhtcost)
	e1:SetTarget(c66666608.lhttarget)
	e1:SetOperation(c66666608.lhtactivate)
	c:RegisterEffect(e1)
	--Dark Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,66666608)
	e2:SetDescription(aux.Stringid(66666608,1))
	e2:SetCost(c66666608.dkcost)
	e2:SetTarget(c66666608.dktarget)
	e2:SetOperation(c66666608.dkactivate)
	c:RegisterEffect(e2)
end

function c66666608.lhtcostfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x144)
end

function c66666608.lhtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c66666608.lhtcostfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c66666608.lhtcostfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c66666608.lhtfilter(c,e,tp)
	return c:IsSetCard(0x144) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c66666608.lhttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingMatchingCard(c66666608.lhtfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66666608.lhtactivate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66666608.lhtfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	 	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end


function c66666608.dkcostfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x144)
end

function c66666608.dkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c66666608.dkcostfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c66666608.dkcostfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c66666608.dkfilter(c,e,tp)
	return c:IsSetCard(0x144) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c66666608.dktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingMatchingCard(c66666608.dkfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66666608.dkactivate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66666608.dkfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end