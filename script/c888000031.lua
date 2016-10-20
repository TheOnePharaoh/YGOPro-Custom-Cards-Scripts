--The Nekroz Armor of Skull Servant
function c888000031.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000031,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x11e0)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c888000031.cost)
	e2:SetTarget(c888000031.target)
	e2:SetOperation(c888000031.operation)
	c:RegisterEffect(e2)
	--immunity
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c888000031.spcon)
	e3:SetOperation(c888000031.spop)
	c:RegisterEffect(e3)
	--gain atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c888000031.atkop)
	c:RegisterEffect(e4)
end
function c888000031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c888000031.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsControlerCanBeChanged()
end
function c888000031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c888000031.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c888000031.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c888000031.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c888000031.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetTurnPlayer()==tp then
			if not Duel.GetControl(tc,tp,PHASE_END,3) then
				if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		else
			if not Duel.GetControl(tc,tp,PHASE_END,2) then
				if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end
function c888000031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c888000031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function c888000031.atkfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c888000031.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local c=e:GetHandler()
	local atk=Duel.GetMatchingGroupCount(c888000031.atkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end
