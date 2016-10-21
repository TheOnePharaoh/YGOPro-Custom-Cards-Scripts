--Close to You - Song of Obedience and Broken Heart
function c11251891.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11251891,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,11251891)
	e1:SetCondition(c11251891.condition)
	e1:SetTarget(c11251891.target)
	e1:SetOperation(c11251891.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetCountLimit(1,11251891)
	e2:SetCondition(c11251891.condition)
	e2:SetTarget(c11251891.target)
	e2:SetOperation(c11251891.activate)
	c:RegisterEffect(e2)
end
function c11251891.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c11251891.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11251891.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-p,tc)
	if tc:IsType(TYPE_SPELL) and tc:IsSetCard(0x0dac405) or tc:IsSetCard(0x0dac406) and not tc:IsType(TYPE_QUICKPLAY) and Duel.SelectYesNo(tp,aux.Stringid(11251891,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_QUICKPLAY)
		e1:SetReset(RESET_EVENT+0x0fe0000)
		tc:RegisterEffect(e1)
		local te=tc:GetActivateEffect()
		if te then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(te:GetCode())
			e2:SetRange(LOCATION_SZONE+LOCATION_HAND)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCondition(c11251891.accon)
			if te:GetCost() then
				e2:SetCost(te:GetCost())
			end
			e2:SetReset(RESET_EVENT+0x0fe0000)
			e2:SetTarget(c11251891.actg)
			e2:SetOperation(c11251891.acop)
			tc:RegisterEffect(e2)
		end
	end
	Duel.ShuffleHand(tp)
end
function c11251891.accon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	local condition=te:GetCondition()
	return (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) 
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c11251891.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local con=false
	if Duel.GetTurnPlayer()~=c:GetControler() then
		con=not c:IsStatus(STATUS_SET_TURN) and c:IsFacedown()
	else
		if Duel.GetCurrentChain()>0 or not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then
			if c:IsLocation(LOCATION_HAND) then
				con=(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
			elseif c:IsLocation(LOCATION_SZONE) then
				con=not c:IsStatus(STATUS_SET_TURN) and c:IsFacedown()
			end
		end
	end
	local te=c:GetActivateEffect()
	local target=te:GetTarget()
	local tpe=c:GetType()
	if chk==0 then return con and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if bit.band(tpe,TYPE_FIELD)~=0 then
		local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if of and Duel.Destroy(of,REASON_RULE)==0 and Duel.SendtoGrave(of,REASON_RULE)==0 then Duel.SendtoGrave(c,REASON_RULE) end
	end
	if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	c:CreateEffectRelation(te)
	if target then target(te,tp,eg,ep,ev,re,r,rp,1) end			
end
function c11251891.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	local op=te:GetOperation()
	local tpe=c:GetType()
	if op then
		c:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			c:CancelToGrave(false)
		end
		c:ReleaseEffectRelation(te)
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
	end
end
