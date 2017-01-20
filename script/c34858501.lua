--Mariaveil
function c34858501.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c34858501.atkcon)
	e2:SetTarget(c34858501.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(34858501,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c34858501.cost)
	e3:SetTarget(c34858501.target1)
	e3:SetOperation(c34858501.operation1)
	c:RegisterEffect(e3)
	--Prevent Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c34858501.condition)
	e4:SetTarget(c34858501.target)
	e4:SetOperation(c34858501.operation)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c34858501.destg)
	e5:SetValue(c34858501.desval)
	e5:SetOperation(c34858501.desop)
	e5:SetCountLimit(1)
	c:RegisterEffect(e5)	
end
function c34858501.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c34858501.atktg(e,c)
	return c:IsFaceup()
	and c:IsRace(RACE_FIEND) or c:IsType(TYPE_PENDULUM)
end
function c34858501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,34858501)==0 end
	Duel.RegisterFlagEffect(tp,34858501,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c34858501.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c34858501.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c34858501.target(e,c)
	local c=e:GetHandler()
	return c:IsRace(RACE_FIEND) or c:IsType(TYPE_PENDULUM)
end
function c34858501.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c34858501.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if tp then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c34858501.tg)
		e2:SetValue(1)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
end
function c34858501.tg(e,c)
	return c:IsRace(RACE_FIEND) or c:IsType(TYPE_PENDULUM)
end
function c34858501.repfilter(c,tp)
	return (c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsRace(RACE_FIEND))
	or (c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsType(TYPE_PENDULUM))
end
function c34858501.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c34858501.repfilter,1,nil,tp) end  
	local opt = Duel.SelectYesNo(tp,aux.Stringid(34858501,0))
	if opt then e:SetLabelObject(eg:GetFirst()) end 
	return opt
end
function c34858501.desval(e,c)
	return c:IsReason(REASON_BATTLE)
end
function c34858501.desop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local b = e:GetLabelObject()	
	local a=Duel.GetAttacker()
	if not a or not a:IsRelateToBattle() or (a == b) then
		a=Duel.GetAttackTarget()
		if not a or not a:IsRelateToBattle() or (a == b) then return end
	end
end