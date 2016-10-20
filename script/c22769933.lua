--Dreadnought Mark - 012 Vajra
function c22769933.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769933,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,22769933)
	e1:SetTarget(c22769933.sptg)
	e1:SetOperation(c22769933.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c22769933.sumsuc)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c22769933.efcon)
	e4:SetOperation(c22769933.efop)
	c:RegisterEffect(e4)
end
function c22769933.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769933.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769933.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c22769933.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22769933.actlimit(e,te,tp)
	return te:GetHandler():IsType(TYPE_COUNTER)
end
function c22769933.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22769933.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22769933,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c22769933.atkfilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769933,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c22769933.damcon)
	e2:SetCost(c22769933.damcost)
	e2:SetOperation(c22769933.damop)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e3,true)
	end
end
function c22769933.atkfilter(e,c)
	return c:IsPosition(POS_DEFENSE)
end
function c22769933.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c22769933.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22769933.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2500,REASON_EFFECT)
end
