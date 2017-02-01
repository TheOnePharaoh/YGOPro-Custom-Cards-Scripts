--Searing Destruction
function c42599690.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c42599690.cost)
	e1:SetTarget(c42599690.target)
	e1:SetOperation(c42599690.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,42599690)
	e2:SetCondition(c42599690.thcon)
	e2:SetTarget(c42599690.thtg)
	e2:SetOperation(c42599690.thop)
	c:RegisterEffect(e2)
end
function c42599690.costfilter(c)
	return c:IsFaceup() and c:IsCode(42599677) or c:IsType(TYPE_DUAL) and c:IsAbleToHandAsCost()
end
function c42599690.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42599690.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local rt=Duel.GetTargetCount(c42599690.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local cg=Duel.SelectMatchingCard(tp,c42599690.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	Duel.SendtoHand(cg,nil,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c42599690.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c42599690.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c42599690.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c42599690.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local eg=Duel.SelectTarget(tp,c42599690.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,e:GetHandler())	
	local dam=eg:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)*400
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam)
end
function c42599690.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Destroy(rg,REASON_EFFECT)
		local dam=rg:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)*400
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		Duel.Damage(tp,dam,REASON_EFFECT)
	end
end
function c42599690.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PYRO)
end
function c42599690.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c42599690.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c42599690.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xfc10) or c:IsCode(42599677)) and c:IsAbleToHand()
end
function c42599690.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42599690.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c42599690.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c42599690.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
