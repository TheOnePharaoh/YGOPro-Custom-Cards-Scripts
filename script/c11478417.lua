--Awakens the Divine Aura
function c11478417.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11478417.target)
	e1:SetOperation(c11478417.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478417,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11478417)
	e2:SetCost(c11478417.thcost)
	e2:SetTarget(c11478417.thtg)
	e2:SetOperation(c11478417.thop)
	c:RegisterEffect(e2)
end
function c11478417.filter(c,e,tp,m)
	if not c:IsSetCard(0xf2002) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumGreater(Card.GetRitualLevel,10,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumGreater(Card.GetRitualLevel,10,c)
	end
	return result
end
function c11478417.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2000) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c11478417.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c11478417.mfilter,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c11478417.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11478417.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c11478417.mfilter,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11478417.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg1)
	local tc=g:GetFirst()
	if tc then
		mg1:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11478417.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11478417.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsAbleToHand()
end
function c11478417.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c11478417.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11478417.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11478417.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11478417.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end