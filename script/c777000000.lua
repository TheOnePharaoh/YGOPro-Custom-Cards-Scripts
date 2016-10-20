--Ｓｐ炎舞－「天璣」
function c777000000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77700000+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c777000000.cost)
	e1:SetOperation(c777000000.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEASTWARRIOR))
	e2:SetValue(100)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c777000000.mtop)
	c:RegisterEffect(e3)
end
function c777000000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc:IsCanRemoveCounter(tp,0x91,4,REASON_COST) end	 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	tc:RemoveCounter(tp,0x91,4,REASON_COST)	
end
function c777000000.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToHand()
end
function c777000000.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c777000000.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(777000000,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c777000000.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local td=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if td:GetCounter(0x91)<4 then
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
