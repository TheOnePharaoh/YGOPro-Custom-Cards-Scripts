--Black Art's Underlings
function c77628942.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628942,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,77628942)
	e2:SetCondition(c77628942.condition)
	e2:SetCost(c77628942.cost)
	e2:SetTarget(c77628942.target)
	e2:SetOperation(c77628942.operation)
	c:RegisterEffect(e2)
	--perform fusion summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628942,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,77628942)
	e3:SetCondition(c77628942.fscon)
	e3:SetCost(c77628942.fscost)
	e3:SetTarget(c77628942.fstg)
	e3:SetOperation(c77628942.fsop)
	c:RegisterEffect(e3)
end
function c77628942.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xba003)
end
function c77628942.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0
		and not Duel.IsExistingMatchingCard(c77628942.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77628942.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77628942.tgfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c77628942.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628942.tgfilter,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,tp,LOCATION_DECK)
end
function c77628942.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628942.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,4,4,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c77628942.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628942.fscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628942.grafilter,tp,LOCATION_GRAVE,0,4,nil)
end
function c77628942.fscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c77628942.filter0(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c77628942.filter1(c,e)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c77628942.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xba003) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m)
end
function c77628942.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c77628942.filter0,tp,LOCATION_REMOVED,0,nil)
		return Duel.IsExistingMatchingCard(c77628942.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77628942.fsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c77628942.filter1,tp,LOCATION_REMOVED,0,nil,e)
	local sg=Duel.GetMatchingGroup(c77628942.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		tc:SetMaterial(mat)
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
		tc:CompleteProcedure()
	end
end
