--The Legendary Iron Golem
function c66165074.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165074,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c66165074.postg)
	e1:SetOperation(c66165074.posop)
	c:RegisterEffect(e1)
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c66165074.condition)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c66165074.target)
	c:RegisterEffect(e2)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(c66165074.sumlimit)
	c:RegisterEffect(e4)
	--sprestrict
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66165074,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCountLimit(1,66165074)
	e5:SetCondition(c66165074.rescon)
	e5:SetOperation(c66165074.resop)
	c:RegisterEffect(e5)
end
function c66165074.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c66165074.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c66165074.condition(e)
	return e:GetHandler():IsDefensePos()
end
function c66165074.target(e,c)
	return c:IsAttackAbove(1500) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c66165074.sumlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165074.rescon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165074.resop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c66165074.spsumcon)
	e1:SetTarget(c66165074.spsumlimit)
	e1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c66165074.spsumcon(e)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c66165074.spsumlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end