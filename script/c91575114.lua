--Jekyll & Hyde - Song of Insatiable Hunger and Inner Lust
function c91575114.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c91575114.condition)
	e1:SetTarget(c91575114.target)
	e1:SetOperation(c91575114.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1,91575114)
	e2:SetCondition(c91575114.spcon)
	e2:SetCost(c91575114.spcost)
	e2:SetTarget(c91575114.sptg)
	e2:SetOperation(c91575114.spop)
	c:RegisterEffect(e2)
end
function c91575114.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c91575114.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and c:IsAbleToHand()
end
function c91575114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c91575114.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91575114.filter,tp,LOCATION_DECK,0,1,nil) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c91575114.filter,tp,LOCATION_DECK,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c91575114.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c91575114.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c91575114.spfilter(c,e,tp,dam)
	return c:IsAttackBelow(dam) and c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91575114.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c91575114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c91575114.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ev) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c91575114.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c91575114.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
