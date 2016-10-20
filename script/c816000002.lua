--Seaciun, Tsuiho Leviathan
function c816000002.initial_effect(c)
	--return to grave/negate spells
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38045887,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,81600002)
	e1:SetCondition(c816000002.negcon)
	e1:SetCost(c816000002.negcost)
	e1:SetTarget(c816000002.negtg)
	e1:SetOperation(c816000002.negop)
	c:RegisterEffect(e1)
	--negate normal spells
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38045887,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81600002)
	e2:SetCondition(c816000002.negcon2)
	e2:SetCost(c816000002.negcost2)
	e2:SetTarget(c816000002.negtg)
	e2:SetOperation(c816000002.negop)
	c:RegisterEffect(e2)
	--end turn/order and banish deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(816000001,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c816000002.etcon)
	e3:SetTarget(c816000002.ettg)
	e3:SetOperation(c816000002.etop)
	c:RegisterEffect(e3)
end
function c816000002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x330)
end
function c816000002.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsChainDisablable(ev) then return false end
	return Duel.IsExistingMatchingCard(c816000002.cfilter,tp,LOCATION_MZONE,0,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_EQUIP+TYPE_FIELD+TYPE_CONTINUOUS+TYPE_QUICKPLAY)
end
function c816000002.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c816000002.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c816000002.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c816000002.negcon2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsChainDisablable(ev) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL
end
function c816000002.negcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c816000002.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c816000002.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c816000002.etop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.SortDecktop(tp,tp,3)
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
