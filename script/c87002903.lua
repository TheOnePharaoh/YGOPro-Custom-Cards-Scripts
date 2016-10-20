--May-Raias Deep Behemoth
function c87002903.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002903,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87002903.spcon)
	e1:SetCost(c87002903.spcost)
	e1:SetTarget(c87002903.sptg)
	e1:SetOperation(c87002903.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87002903,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,87002903)
	e2:SetCondition(c87002903.sccon)
	e2:SetTarget(c87002903.sctg)
	e2:SetOperation(c87002903.scop)
	c:RegisterEffect(e2)
end
function c87002903.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c87002903.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c87002903.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xe291ca) and not c:IsCode(87002903) and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
end
function c87002903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87002903.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c87002903.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002903.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,200,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
	end
end
function c87002903.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c87002903.scfilter(c)
	return c:IsSetCard(0xe291ca) and c:IsType(TYPE_MONSTER) and not c:IsCode(87002903) and c:IsAbleToHand()
end
function c87002903.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87002903.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87002903.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87002903.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
