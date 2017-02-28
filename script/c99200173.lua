--Dark Android Beast Tamer
function c99200173.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c99200173.ctcon)
	e2:SetOperation(c99200173.ctop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99200173,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,99200173)
	e3:SetTarget(c99200173.target)
	e3:SetOperation(c99200173.operation)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c99200173.efilter)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99200173,3))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,99200173)
	e5:SetTarget(c99200173.drtg)
	e5:SetOperation(c99200173.drop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
function c99200173.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200173.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99200173.cfilter,1,nil)
end
function c99200173.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1113,1)
end
function c99200173.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200173.filter2(c)
	return c:IsSetCard(0xda3790) and c:IsAbleToHand()
end
function c99200173.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsCanRemoveCounter(tp,0x1113,3,REASON_COST)
		and Duel.IsExistingMatchingCard(c99200173.filter1,tp,LOCATION_MZONE,0,1,nil)
	local b2=e:GetHandler():IsCanRemoveCounter(tp,0x1113,5,REASON_COST)
		and Duel.IsExistingMatchingCard(c99200173.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(99200173,1),aux.Stringid(99200173,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(99200173,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(99200173,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:GetHandler():RemoveCounter(tp,0x1113,3,REASON_COST)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:GetHandler():RemoveCounter(tp,0x1113,5,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c99200173.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(c99200173.filter1,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c99200173.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c99200173.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200173.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99200173.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end