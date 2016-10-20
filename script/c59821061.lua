--The Idol Master of Celebration Shinjou Hinaki
function c59821061.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821061.splimit)
	e2:SetCondition(c59821061.splimcon)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821061,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c59821061.discon)
	e4:SetCost(c59821061.discost)
	e4:SetTarget(c59821061.distg)
	e4:SetOperation(c59821061.disop)
	c:RegisterEffect(e4)
	--flip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821061,1))
	e5:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c59821061.flipcon)
	e5:SetTarget(c59821061.fliptg)
	e5:SetOperation(c59821061.flipop)
	c:RegisterEffect(e5)
end
function c59821061.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821061.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821061.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c59821061.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c59821061.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c59821061.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c59821061.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821061.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c59821061.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c59821061.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c59821061.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821061.flipfilter(c)
	return c:IsFacedown()
end
function c59821061.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59821061.flipfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821061.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c59821061.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c59821061.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,0,POS_FACEUP_ATTACK,0,POS_FACEUP_DEFENSE)
		if tc:IsAttackBelow(1500) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		else
			Duel.ConfirmCards(1-tc:GetControler(),tc)
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
