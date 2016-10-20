--Draguld, Tsuiho Gladiator
function c816000004.initial_effect(c)
	--banished effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(816000004,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,81600004)
	e1:SetCondition(c816000004.atcon)
	e1:SetCost(c816000004.atcost)
	e1:SetTarget(c816000004.attg)
	e1:SetOperation(c816000004.atop)
	c:RegisterEffect(e1)
	--banish opponent monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73899678,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81600004)
	e2:SetCost(c816000004.rmcost)
	e2:SetTarget(c816000004.rmtg)
	e2:SetOperation(c816000004.rmop)
	c:RegisterEffect(e2)
	--end turn/order and banish deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(816000004,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c816000004.etcon)
	e3:SetTarget(c816000004.ettg)
	e3:SetOperation(c816000004.etop)
	c:RegisterEffect(e3)
end
function c816000004.atcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsSetCard(0x330) and at:IsControler(tp)
end
function c816000004.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c816000004.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c816000004.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c816000004.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c816000004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c816000004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c816000004.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c816000004.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c816000004.etop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.SortDecktop(tp,tp,3)
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
