--Kryos' Damage Filter
function c8722171.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,8722171+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c8722171.condition)
	e1:SetTarget(c8722171.target)
	e1:SetOperation(c8722171.operation)
	c:RegisterEffect(e1)
end
function c8722171.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb1b32)
end
function c8722171.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c8722171.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c8722171.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c8722171.filter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(8722150) and c:IsAbleToHand()
end
function c8722171.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT,true)
	Duel.Damage(1-tp,ev,REASON_EFFECT,true)
	Duel.RDComplete()
	local g=Duel.GetMatchingGroup(c8722171.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(8722171,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
