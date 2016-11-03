--Predator Overgrowth
function c59023916.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1353770,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c59023916.condition)
	e2:SetTarget(c59023916.target)
	e2:SetOperation(c59023916.operation)
	c:RegisterEffect(e2)
end
function c59023916.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsSetCard(0x10f3) and c:GetPreviousLevelOnField()>0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and c:GetReasonPlayer()~=tp
end
function c59023916.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c59023916.cfilter,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetPreviousLevelOnField())
	return tc
end
function c59023916.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x10f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<lv
end
function c59023916.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59023916.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c59023916.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59023916.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
