--Pendulum Compression
function c112000010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c112000010.target)
	e2:SetOperation(c112000010.operation)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c112000010.dcondition)
	e3:SetTarget(c112000010.dtarget)
	e3:SetOperation(c112000010.doperation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c112000010.mtop)
	c:RegisterEffect(e5)
end
function c112000010.filter(c,e,sp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c112000010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112000010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c112000010.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112000010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112000010.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetSummonPlayer()==tp
end
function c112000010.dcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c112000010.cfilter,1,nil,tp)
end
function c112000010.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	local g=eg:Filter(c112000010.cfilter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c112000010.dfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsRelateToEffect(e) and c:GetSummonPlayer()==tp
end
function c112000010.doperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c112000010.dfilter,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c112000010.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>700 and Duel.SelectYesNo(tp,aux.Stringid(112000010,0)) then
		Duel.PayLPCost(tp,700)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
