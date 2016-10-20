--The Legendary Water Golem
function c66165086.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c66165086.regcon)
	e1:SetOperation(c66165086.regop)
	c:RegisterEffect(e1)
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c66165086.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(66165086,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c66165086.condition)
	e3:SetCost(c66165086.cost)
	e3:SetOperation(c66165086.operation)
	c:RegisterEffect(e3)
	--damage&return
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,66165086)
	e4:SetCondition(c66165086.tdcon)
	e4:SetTarget(c66165086.tdtg)
	e4:SetOperation(c66165086.tdop)
	c:RegisterEffect(e4)
end
function c66165086.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xea010) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c66165086.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and e:GetLabel()==1
end
function c66165086.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165086,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c66165086.distg)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c66165086.distg(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c66165086.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_EARTH) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_EARTH) and d:IsRelateToBattle())
end
function c66165086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c66165086.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(2400)
	a:RegisterEffect(e1)
end
function c66165086.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165086.tdfilter(c)
	return c:IsSetCard(0xea010) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and not c:IsCode(66165086) and c:IsAbleToDeck()
end
function c66165086.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66165086.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66165086.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66165086.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c66165086.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end