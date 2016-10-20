--Rise Of The Fallen Dragon
function c999915.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999915+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c999915.condition)
	e1:SetTarget(c999915.target)
	e1:SetOperation(c999915.activate)
	c:RegisterEffect(e1)
end
function c999915.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c999915.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999915.cfilter,1,nil,tp)
end
function c999915.filter(c,e,tp)
	return c:IsSetCard(0x1045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999915.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999915.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 
		and Duel.IsExistingTarget(c999915.filter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999915.filter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,3,0,0)
end
function c999915.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
	local tc=tg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		tc=tg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
