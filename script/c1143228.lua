--ANTI-MATTER Dark Being, Narhhg
function c1143228.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143228.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c1143228.indval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,1143228)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(c1143228.sptarget)
	e4:SetOperation(c1143228.spoperation)
	c:RegisterEffect(e4)
	--double atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1143228,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,1143228)
	e6:SetCondition(c1143228.thcon)
	e6:SetTarget(c1143228.thtg)
	e6:SetOperation(c1143228.thop)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(1143228,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,1143228)
	e7:SetTarget(c1143228.sptg)
	e7:SetOperation(c1143228.spop)
	c:RegisterEffect(e7)
	if not c1143228.global_check then
		c1143228.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143228))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143228.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143228.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143228.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143228.indval(e,re,rp)
	return re:GetOwner():IsCode(1143228)
end
function c1143228.spfilter(c,e,tp)
	return c:IsSetCard(0xaf75) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143228.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143228.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143228.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1143228.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1143228.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c1143228.thfilter(c)
	return c:IsSetCard(0xaf75) and not c:IsCode(1143228) and c:IsAbleToHand()
end
function c1143228.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143228.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c1143228.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1143228.thfilter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=sg:Select(tp,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function c1143228.spfilter1(c,e,tp)
	return c:IsSetCard(0xaf75) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1143228.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetCode())
end
function c1143228.spfilter2(c,e,tp,code)
	return c:IsSetCard(0xaf75) and c:IsLevelBelow(4) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143228.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143228.spfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_REMOVED)
end
function c1143228.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c1143228.spfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1143228.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
