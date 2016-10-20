--Familiar Re-Call
function c20912309.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20912309.condition)
	e1:SetTarget(c20912309.target)
	e1:SetOperation(c20912309.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912309,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(2,20912309)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c20912309.descost)
	e2:SetTarget(c20912309.destg)
	e2:SetOperation(c20912309.desop)
	c:RegisterEffect(e2)
end
function c20912309.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsRace(RACE_WARRIOR)
end
function c20912309.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20912309.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20912309.desfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP) and c:IsDestructable()
end
function c20912309.spfilter(c,e,tp)
	return c:IsSetCard(0xd0a3) and c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912309.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc~=e:GetHandler() and c20912309.desfilter1(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_SZONE
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(c20912309.desfilter1,tp,loc,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(c20912309.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20912309.desfilter1,tp,e:GetLabel(),0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20912309.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c20912309.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c20912309.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20912309.desfilter2(c)
	return c:IsDestructable()
end
function c20912309.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c20912309.desfilter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c20912309.desfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20912309.desfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c20912309.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end