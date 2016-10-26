--The Idol Master of Celebration Shinjou Hinaki
function c59821117.initial_effect(c)
	aux.EnableDualAttribute(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821117.splimit)
	e2:SetCondition(c59821117.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821117.atkuptg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(59821061)
	c:RegisterEffect(e4)
	--flip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821117,0))
	e5:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c59821117.flipcon)
	e5:SetTarget(c59821117.fliptg)
	e5:SetOperation(c59821117.flipop)
	c:RegisterEffect(e5)
	--salvage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetDescription(aux.Stringid(72056560,0))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(aux.IsDualState)
	e6:SetCost(c59821117.cost)
	e6:SetTarget(c59821117.target)
	e6:SetOperation(c59821117.operation)
	c:RegisterEffect(e6)
end
function c59821117.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821117.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821117.atkuptg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821117.flipcon(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsDualState(e) then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c59821117.flipfilter(c)
	return c:IsFacedown()
end
function c59821117.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59821117.flipfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821117.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c59821117.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c59821117.flipop(e,tp,eg,ep,ev,re,r,rp)
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
function c59821117.costfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c59821117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821117.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c59821117.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c59821117.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c59821117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c59821117.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821117.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c59821117.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c59821117.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
