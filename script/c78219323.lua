--Colossal Assault
function c78219323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c78219323.cost)
	e1:SetTarget(c78219323.target)
	e1:SetOperation(c78219323.activate)
	c:RegisterEffect(e1)
	--place card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219323,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,78219323)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c78219323.sgcost)
	e2:SetTarget(c78219323.sgtg)
	e2:SetOperation(c78219323.sgop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219323,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c78219323.drcon)
	e3:SetTarget(c78219323.drtg)
	e3:SetOperation(c78219323.drop)
	c:RegisterEffect(e3)
end
function c78219323.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsAbleToGraveAsCost()
end
function c78219323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219323.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c78219323.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c78219323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c78219323.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c78219323.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c78219323.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219323.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219323.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219323.sgop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219323.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,78219323,e,0,tp,0,0)
	end
end
function c78219323.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c78219323.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c78219323.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
