--Looking Glass
function c59821084.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821084,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,59821084)
	e1:SetTarget(c59821084.target1)
	e1:SetOperation(c59821084.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821084,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,59821084)
	e2:SetTarget(c59821084.target2)
	e2:SetOperation(c59821084.activate2)
	c:RegisterEffect(e2)
end
function c59821084.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821084.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c59821084.spfilter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c59821084.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c59821084.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c59821084.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c59821084.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:GetOverlayCount()==0
end
function c59821084.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821084.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821084.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,2,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59821084.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59821084.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
		if g:GetCount()>=2 then
			local og=g:Select(tp,2,2,nil)
			Duel.Overlay(tc,og)
		end
	end
end
