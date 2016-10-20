--Black Knight - Sword
--lua script by SGJin
function c12310721.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	-- Chip Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310721,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c12310721.damcon)
	e1:SetTarget(c12310721.damtg)
	e1:SetOperation(c12310721.damop)
	c:RegisterEffect(e1)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(12310721,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12310721.atkcost)
	e2:SetOperation(c12310721.atkop)
	c:RegisterEffect(e2)
	-- 3-hit Combo
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310721,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c12310721.tricon)
	e3:SetCost(c12310721.tricost)
	e3:SetTarget(c12310721.tritg)
	e3:SetOperation(c12310721.triop)
	c:RegisterEffect(e3)
end
function c12310721.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d==c then d=Duel.GetAttackTarget() end
	return c:IsRelateToBattle() and d:IsLocation(LOCATION_GRAVE) and d:IsReason(REASON_BATTLE) and d:IsType(TYPE_MONSTER)
end
function c12310721.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c12310721.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c12310721.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12310721)==0
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(12310721,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310721.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c12310721.tricon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c12310721.tricost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12310721)==0
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(12310721,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c12310721.tritg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c12310721.triop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end