--AB Fortress
function c78330015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c78330015.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c78330015.tg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c78330015.rmtarget)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78330015,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c78330015.thcost)
	e5:SetTarget(c78330015.thtg)
	e5:SetOperation(c78330015.thop)
	c:RegisterEffect(e5)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78330015,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c78330015.spcon)
	e5:SetTarget(c78330015.sptg)
	e5:SetOperation(c78330015.spop)
	c:RegisterEffect(e5)
end
function c78330015.tg(e,c)
	return c:IsRace(RACE_INSECT)
end
function c78330015.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c78330015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c78330015.filter(c)
	return c:IsSetCard(0xac9812) and c:IsAbleToHand()
end
function c78330015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78330015.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78330015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78330015.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c78330015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c78330015.spfilter(c,e,tp)
	return c:IsSetCard(0xac9812) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c78330015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78330015.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c78330015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c78330015.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end