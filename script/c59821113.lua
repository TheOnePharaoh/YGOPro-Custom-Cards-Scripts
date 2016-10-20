--Urgent Scale Setting
function c59821113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c59821113.condition)
	e1:SetTarget(c59821113.target)
	e1:SetOperation(c59821113.activate)
	c:RegisterEffect(e1)
end
function c59821113.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not tc1:IsSetCard(0xa1a2) or not tc2:IsSetCard(0xa1a2) then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==2 and scl2==5
end
function c59821113.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c59821113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59821113.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c59821113.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821113.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end