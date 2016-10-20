--divine ritual
function c11478416.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11478416+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11478416.condition)
	e1:SetCost(c11478416.cost)
	e1:SetTarget(c11478416.target)
	e1:SetOperation(c11478416.activate)
	c:RegisterEffect(e1)
end
function c11478416.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c11478416.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end
function c11478416.filter(c)
	return c:IsSetCard(0xf2002) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11478416.filter2(c)
	return c:IsSetCard(0xf2001) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c11478416.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478416.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11478416.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478416.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g=Duel.GetMatchingGroup(c11478416.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11478416,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
