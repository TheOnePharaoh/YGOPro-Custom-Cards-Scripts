--Ressurection of the Saints
function c32887086.initial_effect(c)
	c:SetUniqueOnField(1,0,32887086)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32887086,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c32887086.spcon)
	e2:SetTarget(c32887086.sptg)
	e2:SetOperation(c32887086.spop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(c32887086.descon)
	e4:SetTarget(c32887086.destg)
	e4:SetOperation(c32887086.desop)
	c:RegisterEffect(e4)
	--xyz effect
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c32887086.sccon)
	e5:SetTarget(c32887086.sctg)
	e5:SetOperation(c32887086.scop)
	c:RegisterEffect(e5)
end
function c32887086.confilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x1e20) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c32887086.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32887086.confilter,1,nil,tp)
end
function c32887086.spfilter1(c,e,tp)
	return c:GetLevel()==8 and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1e20) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c32887086.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c32887086.spfilter2(c,e,tp,code)
	return c:GetLevel()==8 and c:IsType(TYPE_SYNCHRO) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32887086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32887086.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c32887086.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c32887086.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c32887086.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32887086.sdfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD) and c:IsLocation(LOCATION_REMOVED) and c:IsControler(tp)
end
function c32887086.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32887086.sdfilter,1,nil,tp)
end
function c32887086.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c32887086.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c32887086.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c32887086.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c32887086.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsXyzSummonable(mg)
end
function c32887086.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c32887086.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c32887086.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32887086.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32887086.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c32887086.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,5)
	end
end
