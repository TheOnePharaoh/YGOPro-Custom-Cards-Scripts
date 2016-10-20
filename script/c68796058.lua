--INNONENCE - Song of Ressurection
function c68796058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68796058,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c68796058.target)
	e2:SetOperation(c68796058.operation)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c68796058.descon)
	e3:SetOperation(c68796058.desop)
	c:RegisterEffect(e3)
end
function c68796058.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402) and c:GetLevel()<=7 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68796058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c68796058.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c68796058.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c68796058.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c68796058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	end
end
function c68796058.dfilter(c,sg)
	return sg:IsContains(c)
end
function c68796058.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()==0 then return false end
	return c:GetCardTarget():IsExists(c68796058.dfilter,1,nil,eg)
end
function c68796058.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
