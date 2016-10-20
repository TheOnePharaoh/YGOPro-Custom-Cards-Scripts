--Future Gear Detonation
function c99199023.initial_effect(c)
	c:SetUniqueOnField(1,0,99199023)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99199023)
	e1:SetCost(c99199023.lpcost)
	e1:SetTarget(c99199023.target1)
	e1:SetOperation(c99199023.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199023,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99199023)
	e2:SetTarget(c99199023.target2)
	e2:SetOperation(c99199023.operation)
	c:RegisterEffect(e2)
end
function c99199023.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c99199023.secfilter(c,code)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and not c:IsCode(code) and c:IsAbleToHand()
end
function c99199023.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff15) and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c99199023.secfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c99199023.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199023.filter,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199023.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199023.filter,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199023.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99199023.filter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c99199023.secfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end