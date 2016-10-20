--Spiritual Zone
function c112000012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --Destroy S/T DM
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(112000012,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c112000012.DMcondition)
    e2:SetCost(c112000012.DMcost)
    e2:SetTarget(c112000012.DMtarget)
    e2:SetOperation(c112000012.DMactivate)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    c:RegisterEffect(e2)
    --DestroyALL Neos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112000012,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c112000012.NEOScost)
	e3:SetCondition(c112000012.NEOScondition)
	e3:SetTarget(c112000012.NEOStarget)
	e3:SetOperation(c112000012.NEOSactivate)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e3)
	--Negate trap Stardust
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112000012,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c112000012.STARcondition)
	e4:SetTarget(c112000012.STARtarget)
	e4:SetOperation(c112000012.STARactivate)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e4)
	--No destroy UTOPIA
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(112000012,3))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c112000012.UTOcondition)
	e5:SetCost(c112000012.UTOcost)
	e5:SetTarget(c112000012.UTOtarget)
	e5:SetOperation(c112000012.UTOactivate)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e5)
	--Addtohand ODDEYES
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(112000012,4))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c112000012.ODDcondition)
	e6:SetTarget(c112000012.ODDtarget)
	e6:SetOperation(c112000012.ODDactivate)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e6)
end
c112000012.dark_magician_list=true
function c112000012.DMcfilter(c)
    return c:IsFaceup() and c:IsCode(46986414)
end
function c112000012.DMcondition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c112000012.DMcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c112000012.DMfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c112000012.DMcostfilter(c)
	return c:GetAttack()==2500 and c:IsFaceup()
end
function c112000012.DMcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c112000012.DMcostfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c112000012.DMcostfilter,1,1,nil)
    Duel.Release(sg,REASON_COST)
end
function c112000012.DMtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c112000012.DMfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c112000012.DMfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c112000012.DMactivate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c112000012.DMfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
function c112000012.NEOScost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c112000012.NEOScofilter(c)
    return c:IsFaceup() and c:IsCode(89943723)
end
function c112000012.NEOScondition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c112000012.NEOScofilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c112000012.NEOSfilter(c)
	return c:IsFaceup() and c:GetAttack()==2500 and c:IsAbleToDeck()
end
function c112000012.NEOStarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c112000012.NEOSfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112000012.NEOSfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c112000012.NEOSfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	dg:RemoveCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c112000012.NEOSactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c112000012.NEOSfilter(tc)
		and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c112000012.STARcofilter(c)
    return c:IsFaceup() and c:IsCode(44508094)
end
function c112000012.STARcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112000012.STARcofilter,tp,LOCATION_ONFIELD,0,1,nil) and re:IsActiveType(TYPE_TRAP) 
	and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c112000012.STARtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c112000012.STARactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c112000012.UTOcofilter(c)
    return c:IsFaceup() and c:IsCode(84013237)
end
function c112000012.UTOcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112000012.UTOcofilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c112000012.UTOcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c112000012.UTOtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112000012.UTOfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c112000012.UTOfilter(c)
	return c:IsFaceup() and c:GetAttack()==2500
end
function c112000012.UTOactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c112000012.UTOfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c112000012.ODDcofilter(c)
    return c:IsFaceup() and c:IsCode(16178681)
end
function c112000012.ODDcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112000012.ODDcofilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c112000012.ODDfilter(c)
	return c:IsAttackBelow(2500) and c:IsAbleToHand()
end
function c112000012.ODDtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112000012.ODDfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112000012.ODDactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112000012.ODDfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

