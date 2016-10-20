--Two Boundaries of the Future
function c99199036.initial_effect(c)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99199036.target)
	e1:SetOperation(c99199036.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c99199036.thcon)
	e2:SetCost(c99199036.thcost)
	e2:SetTarget(c99199036.thtg)
	e2:SetOperation(c99199036.thop)
	c:RegisterEffect(e2)
end
function c99199036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15)
end
function c99199036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199036.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199036.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99199036.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetLabelObject(g)
		e1:SetOperation(c99199036.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetDescription(aux.Stringid(99199036,0))
		e2:SetCode(EVENT_BATTLED)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetLabelObject(e1)
		e2:SetOperation(c99199036.regop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c99199036.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetCount()>0 then
		local sg=g:Filter(Card.IsRelateToBattle,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		g:Clear()
	end
end
function c99199036.regop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and not bc:IsStatus(STATUS_BATTLE_DESTROYED) then
		local g=e:GetLabelObject():GetLabelObject()
		g:AddCard(bc)
	end
end
function c99199036.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c99199036.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c99199036.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end
function c99199036.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15) and c:IsAbleToHand()
end
function c99199036.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99199036)==0 end
	Duel.RegisterFlagEffect(tp,99199036,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199036.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99199036.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99199036,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99199036,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
