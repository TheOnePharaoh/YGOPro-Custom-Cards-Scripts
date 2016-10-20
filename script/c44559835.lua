--Soul Steal
function c44559835.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,44559835+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c44559835.condition)
	e1:SetTarget(c44559835.target)
	e1:SetOperation(c44559835.operation)
	c:RegisterEffect(e1)
end
function c44559835.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832)
end
function c44559835.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c44559835.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c44559835.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c44559835.filter(c)
	return c:IsCode(44559804) or c:IsCode(24094653) or c:IsCode(48130397) and c:IsAbleToHand()
end
function c44559835.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c44559835.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(44559835,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
