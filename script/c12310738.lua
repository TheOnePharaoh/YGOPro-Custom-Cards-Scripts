--Black Knight - Halberd
--lua script by SGJin
function c12310738.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--Position change (Sweeping Attack)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310738,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c12310738.poscon)
	e1:SetTarget(c12310738.postg)
	e1:SetOperation(c12310738.posop)
	c:RegisterEffect(e1)
	-- 2-Hit Combo (Sweeping Attack)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310738,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12310738.atkcon)
	e2:SetCost(c12310738.atkcost)
	e2:SetTarget(c12310738.atktg)
	e2:SetOperation(c12310738.atkop)
	c:RegisterEffect(e2)
end
function c12310738.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsFaceup() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c12310738.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c12310738.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c12310738.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310738.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12310738.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c12310738.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c12310738.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c12310738.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310738.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c12310738.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
