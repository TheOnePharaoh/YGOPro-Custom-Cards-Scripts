--Daxus
function c89990003.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c89990003.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c89990003.condition)
	e3:SetTarget(c89990003.target)
	e3:SetOperation(c89990003.operation)
	c:RegisterEffect(e3)
end
function c89990003.val(e,c)
	return Duel.GetMatchingGroupCount(c89990003.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*400
end
function c89990003.filter(c)
	return c:IsFaceup() and (c:IsCode(89990007) or c:IsCode(89990031))
end
function c89990003.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c89990003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end
function c89990003.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
