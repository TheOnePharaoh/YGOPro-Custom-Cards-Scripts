--Power Tool Dragon/Assault Mode
function c24108326.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2403771,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c24108326.thtg)
	e2:SetOperation(c24108326.thop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c24108326.desreptg)
	e3:SetOperation(c24108326.desrepop)
	c:RegisterEffect(e3)
		--damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24108326,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c24108326.rdcon)
	e4:SetOperation(c24108326.rdop)
	c:RegisterEffect(e4)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2403771,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c24108326.spcon)
	e5:SetTarget(c24108326.sptg)
	e5:SetOperation(c24108326.spop)
	c:RegisterEffect(e5)
end
function c24108326.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c24108326.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24108326.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c24108326.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24108326.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c24108326.repfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c24108326.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c24108326.repfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(2403771,1)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c24108326.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c24108326.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
function c24108326.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetEquipCount()>0
end
function c24108326.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c24108326.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c24108326.spfilter(c,e,tp)
	return c:IsCode(2403771) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24108326.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24108326.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c24108326.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24108326.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24108326.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
