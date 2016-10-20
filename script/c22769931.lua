--Sneak Attack
function c22769931.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c22769931.target)
	e1:SetOperation(c22769931.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769931,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22769931)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22769931.spcost)
	e2:SetTarget(c22769931.sptg)
	e2:SetOperation(c22769931.spop)
	c:RegisterEffect(e2)
end
function c22769931.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==Duel.GetAttackTarget() end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0xaa12) or d:IsSetCard(0xaa13) or d:IsSetCard(0xaa14) and d:IsCanBeEffectTarget(e)
		and d:GetAttack()<a:GetAttack() end
	Duel.SetTargetCard(d)
end
function c22769931.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		local atk=a:GetAttack()-d:GetAttack()
		if atk<0 then atk=0 end
		--Atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Equip limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c22769931.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetLabelObject(tc)
		c:RegisterEffect(e2)
	end
end
function c22769931.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22769931.rfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToRemoveAsCost()
end
function c22769931.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769931.rfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22769931.rfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22769931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22769931,0xaa12,0x11,10,1800,1800,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769931.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,22769931,0xaa12,0x11,10,1800,1800,RACE_MACHINE,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:AddMonsterAttributeComplete()
		--cannot be effect target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e2,true)
		--redirect
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x47e0000)
		e3:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
