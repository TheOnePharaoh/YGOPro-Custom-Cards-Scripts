--Destiny Activator
function c512000095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c512000095.activate)
	c:RegisterEffect(e1)
end
function c512000095.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.DiscardDeck(tp,1,REASON_EFFECT)
	if ct>0 then
		local tcs=Duel.GetOperatedGroup():GetFirst()
		if tcs:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_DRAW)
			e1:SetRange(LOCATION_SZONE)
			e1:SetOperation(c512000095.op1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
			c:RegisterEffect(e1)
		elseif tcs:IsType(TYPE_SPELL) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_DRAW)
			e1:SetRange(LOCATION_SZONE)
			e1:SetOperation(c512000095.op2)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_DRAW)
			e1:SetRange(LOCATION_SZONE)
			e1:SetOperation(c512000095.op3)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
			c:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetLabel(3)
		e2:SetCountLimit(1)
		e2:SetOperation(c512000095.tgop)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
		c:RegisterEffect(e2)
	end
end
function c512000095.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	Duel.ShuffleHand(ep)
	local tc=hg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() then
			if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
				Duel.BreakEffect()
				local p=e:GetHandler():GetControler()
				Duel.SetLP(1-p,Duel.GetLP(1-p)/2,REASON_EFFECT)
			end
		end
		tc=hg:GetNext()
	end
end
function c512000095.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	Duel.ShuffleHand(ep)
	local tc=hg:GetFirst()
	while tc do
		if tc:IsType(TYPE_SPELL) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() then
			if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
				Duel.BreakEffect()
				local p=e:GetHandler():GetControler()
				Duel.SetLP(1-p,Duel.GetLP(1-p)/2,REASON_EFFECT)
			end
		end
		tc=hg:GetNext()
	end
end
function c512000095.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	Duel.ShuffleHand(ep)
	local tc=hg:GetFirst()
	while tc do
		if tc:IsType(TYPE_TRAP) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() then
			if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
				Duel.BreakEffect()
				local p=e:GetHandler():GetControler()
				Duel.SetLP(1-p,Duel.GetLP(1-p)/2,REASON_EFFECT)
			end
		end
		tc=hg:GetNext()
	end
end
function c512000095.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local ct=e:GetLabel()
	ct=ct-1
	e:SetLabel(ct)
	if ct==0 then
		if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)>0 then
			local p=e:GetHandler():GetControler()
			Duel.SetLP(p,Duel.GetLP(p)/2,REASON_EFFECT)
		end
	end
end
