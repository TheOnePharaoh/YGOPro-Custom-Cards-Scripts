--Electric Angel
function c91382639.initial_effect(c)
	c:SetUniqueOnField(1,0,91382639)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91382639,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c91382639.drcon)
	e2:SetTarget(c91382639.drtg)
	e2:SetOperation(c91382639.drop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c91382639.sdcon)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(91382639,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,91382639)
	e4:SetCost(c91382639.thcost)
	e4:SetTarget(c91382639.thtg)
	e4:SetOperation(c91382639.thop)
	c:RegisterEffect(e4)
end
function c91382639.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402)
end
function c91382639.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c91382639.filter,1,nil)
end
function c91382639.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c91382639.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c91382639.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c91382639.sdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and not Duel.IsExistingMatchingCard(c91382639.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c91382639.thfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c91382639.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91382639.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c91382639.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c91382639.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c91382639.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end