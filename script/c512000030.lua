--Nightmare Shuffle
function c512000030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c512000030.target)
	e1:SetOperation(c512000030.operation)
	c:RegisterEffect(e1)
	--swap
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(33911264,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c512000030.swcon)
	e2:SetOperation(c512000030.swop)
	c:RegisterEffect(e2)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c512000030.distg)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c512000030.accost)
	e4:SetTarget(c512000030.actg)
	e4:SetOperation(c512000030.acop)
	c:RegisterEffect(e4)
end
function c512000030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then
		ft=ft-1
	end
	if chkc then return true end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(nil,tp,LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local tc=sg:RandomSelect(tp,1):GetFirst()
	if tc:IsCanBeEffectTarget(e) then
		Duel.SetTargetCard(tc)
	end
end
function c512000030.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		if tc:IsSSetable() then
			Duel.SSet(tp,tc)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MONSTER_SSET)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
		end
		if tc:IsLocation(LOCATION_SZONE) then
			c:SetCardTarget(tc)
		end
	end
end
function c512000030.swcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c512000030.swop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetFirstCardTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or not tg then return end
	if Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,tg)
		local tc=sg:RandomSelect(tp,1):GetFirst()
		if tc:IsSSetable() then
			Duel.SSet(tp,tc)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MONSTER_SSET)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
		end
		if tc:IsLocation(LOCATION_SZONE) then
			c:SetCardTarget(tc)
		end
	end
end
function c512000030.distg(e,c)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and c==tc
end
function c512000030.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetFirstCardTarget()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and tc and tc:IsFacedown() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.SetTargetCard(tc)
end
function c512000030.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if te:GetCode()==EVENT_FREE_CHAIN then
		return (not condition or condition(te,c:GetControler(),eg,ep,ev,re,r,rp)) 
			and (not cost or cost(te,c:GetControler(),eg,ep,ev,re,r,rp,0))
			and (not target or target(te,c:GetControler(),eg,ep,ev,re,r,rp,0))
	elseif te:GetCode()==EVENT_CHAINING then
		return (not condition or condition(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp)) 
			and (not cost or cost(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp,0))
			and (not target or target(te,c:GetControler(),Group.FromCards(e:GetHandler()),tp,0,e,r,tp,0))
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		return res and (not condition or condition(te,c:GetControler(),teg,tep,tev,tre,tr,trp)) 
			and (not cost or cost(te,c:GetControler(),teg,tep,tev,tre,tr,trp,0))
			and (not target or target(te,c:GetControler(),teg,tep,tev,tre,tr,trp,0))
	end
end
function c512000030.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if chk==0 then return true end
	Duel.SetTargetCard(tc)
end
function c512000030.acop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFaceup() then return end
	Duel.ChangePosition(tc,POS_FACEUP)
	if c512000030.filter(tc,e,tp,eg,ep,ev,re,r,rp) then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		Duel.ClearTargetCard()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if te:GetCode()==EVENT_FREE_CHAIN then
			if co then co(te,tc:GetControler(),eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tc:GetControler(),eg,ep,ev,re,r,rp,1) end
		elseif te:GetCode()==EVENT_CHAINING then
			if co then co(te,tc:GetControler(),Group.FromCards(c),tp,0,e,r,tp,1) end
			if tg then tg(te,tc:GetControler(),Group.FromCards(c),tp,0,e,r,tp,1) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if co then co(te,tc:GetControler(),teg,tep,tev,tre,tr,trp,1) end
			if tg then tg(te,tc:GetControler(),teg,tep,tev,tre,tr,trp,1) end
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
				while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		tc:SetStatus(STATUS_ACTIVATED,true)
		if te:GetCode()==EVENT_FREE_CHAIN then
			if op then op(te,tc:GetControler(),eg,ep,ev,re,r,rp) end
		elseif te:GetCode()==EVENT_CHAINING then
			if op then op(te,tc:GetControler(),Group.FromCards(c),tp,0,e,r,tp) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if op then op(te,tc:GetControler(),teg,tep,tev,tre,tr,trp) end
		end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
