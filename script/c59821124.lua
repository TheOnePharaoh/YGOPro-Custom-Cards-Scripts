--The Idol's Last Glare
function c59821124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c59821124.target)
	e1:SetOperation(c59821124.activate)
	c:RegisterEffect(e1)
	--search&destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1,59821124)
	e2:SetCondition(c59821124.thcon)
	e2:SetCost(c59821124.thcost)
	e2:SetTarget(c59821124.thtg)
	e2:SetOperation(c59821124.thop)
	c:RegisterEffect(e2)
end
function c59821124.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsDestructable()
end
function c59821124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c59821124.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c59821124.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c59821124.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c59821124.thcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsType(TYPE_PENDULUM)
end
function c59821124.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821124.thfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c59821124.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c59821124.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821124.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetAttackTarget():IsDestructable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c59821124.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local d=Duel.GetAttackTarget()
	d:RegisterFlagEffect(59821124,RESET_EVENT+0x3fe0000,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c59821124.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local d=Duel.GetAttackTarget()
		if d:GetFlagEffect(59821124)~=0 then
			Duel.Destroy(d,REASON_EFFECT)
		end
	end
end
