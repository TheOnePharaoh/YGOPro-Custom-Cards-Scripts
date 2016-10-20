--Creation God of the Bound Creator
function c11478407.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11478407.splimit)
	c:RegisterEffect(e1)
	--indes eff
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c11478407.indes)
	c:RegisterEffect(e3)
	--atk modify
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11478407,0))
	e4:SetCategory(CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c11478407.condition)
	e4:SetTarget(c11478407.target)
	e4:SetOperation(c11478407.operation)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11478407,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c11478407.sumlimitcon)
	e5:SetCost(c11478407.sumlimitcost)
	e5:SetOperation(c11478407.sumlimitop)
	c:RegisterEffect(e5)
end
function c11478407.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c11478407.indes(e,c)
	return not c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c11478407.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c11478407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11478407.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local dice=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(dice*300)
		c:RegisterEffect(e1)
	end
end
function c11478407.sumlimitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c11478407.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11478407.sumlimitop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c11478407.sumlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c11478407.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsAttribute(ATTRIBUTE_DEVINE)
end
