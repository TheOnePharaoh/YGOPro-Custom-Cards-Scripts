--Michelle the End, 8th Arian Guardian
function c77790007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetTarget(c77790007.target)
	e1:SetOperation(c77790007.activate)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTarget(c77790007.tg)
	e2:SetValue(LOCATION_DECK)
	c:RegisterEffect(e2)
	--decrease scales
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c77790007.slcon)
	e3:SetOperation(c77790007.slop)
	c:RegisterEffect(e3)
	--fragment
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77790007.cost)
	e4:SetTarget(c77790007.ftg)
	e4:SetOperation(c77790007.fop)
	c:RegisterEffect(e4)
	--double battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetValue(c77790007.rdval)
	c:RegisterEffect(e5)
end
function c77790007.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77790007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77790007.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c77790007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77790007.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP_ATTACK,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c77790007.tg(e,c)
	return c:IsSetCard(0x100f)
end
function c77790007.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c77790007.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	Duel.RaiseSingleEvent(c,EVENT_SCALE_UP,e,0,0,0,0,0)
end
function c77790007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c77790007.ffilter(c)
	return c:IsSetCard(0x90a) and c:IsAbleToHand()
end
function c77790007.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77790007.ffilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c77790007.fop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c77790007.ffilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c77790007.rdval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return val*2
	else
		return val
	end
end
