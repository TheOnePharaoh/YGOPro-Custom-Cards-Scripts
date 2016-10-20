--Hall of the Black Artists
function c77628924.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e2)
	--spsmmon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628924,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,77628924)
	e3:SetCost(c77628924.spcost)
	e3:SetTarget(c77628924.sptg)
	e3:SetOperation(c77628924.spop)
	c:RegisterEffect(e3)
	--effect indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetCondition(c77628924.edcon)
	c:RegisterEffect(e4)
end
function c77628924.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsDiscardable()
end
function c77628924.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628924.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c77628924.disfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c77628924.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628924.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c77628924.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77628924.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77628924.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77628924.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_ZOMBIE)
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(77628924,RESET_EVENT+0x1fe0000,0,0)
		c:RegisterFlagEffect(77628924,RESET_EVENT+0x1020000,0,0)
	end
end
function c77628924.edfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628924.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c77628924.edfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=6
end