--Dark Sun Gwyndolin
--lua script by SGJin
function c12310705.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR+RACE_SPELLCASTER),6,2)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310705,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c12310705.damtg)
	e1:SetOperation(c12310705.damop)
	c:RegisterEffect(e1)
	--Negate effects (Teleports Away)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310705,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12310705.discon)
	e2:SetCost(c12310705.discost)
	e2:SetTarget(c12310705.distg)
	e2:SetOperation(c12310705.disop)
	c:RegisterEffect(e2)
	--Negate Attack Teleports Away)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310705,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c12310705.negcost)
	e3:SetOperation(c12310705.negop)
	c:RegisterEffect(e3)
end
function c12310705.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c12310705.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c12310705.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c12310705.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310705.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c12310705.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
end
function c12310705.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function c12310705.negop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end	