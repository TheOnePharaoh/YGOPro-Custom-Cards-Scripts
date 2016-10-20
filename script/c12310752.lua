--Anastacia of Astora
--lua script by SGJin
function c12310752.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Bonfire Respawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310752,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12310752.thtg)
	e2:SetOperation(c12310752.thop)
	c:RegisterEffect(e2)
	--Offer Humanity (Pendulum scale)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310752,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c12310752.cost)
	e3:SetOperation(c12310752.operation)
	c:RegisterEffect(e3)
end
function c12310752.filter(c)
	local t=Duel.GetTurnCount()
	return bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:IsAbleToHand() and c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER) 
			and c:GetTurnID()<=t and (t - c:GetTurnID())<=0
end
function c12310752.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c12310752.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12310752.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c12310752.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12310752.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c12310752.cfilter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsDiscardable()
end
function c12310752.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310752.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12310752.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c12310752.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetLeftScale()<8 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(c:GetLeftScale()*2)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetValue(c:GetRightScale()*2)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
