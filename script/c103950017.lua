--Twilight Dragon
function c103950017.initial_effect(c)

	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	
	--Attribute Dark
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950017,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	
	--Banish destroyed monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950017,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c103950017.remcon)
	e2:SetTarget(c103950017.remtgt)
	e2:SetOperation(c103950017.remop)
	c:RegisterEffect(e2)
	
	--Effect immunity
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103950017,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c103950017.immcost)
	e3:SetOperation(c103950017.immoperation)
	c:RegisterEffect(e3)
end
-- Banish condition
function c103950017.remcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():GetOverlayCount()>0
end
-- Banish target
function c103950017.remtgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
-- Banish operation
function c103950017.remop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
-- Immunity cost
function c103950017.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and
							e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) end
	local m = e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO):Select(tp,1,1,nil)
	Duel.SendtoGrave(m,REASON_COST)
end
-- Immunity operation
function c103950017.immoperation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end