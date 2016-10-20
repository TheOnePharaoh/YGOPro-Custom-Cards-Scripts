--The Glorious Alliance
function c59821071.initial_effect(c)
	c:SetUniqueOnField(1,0,59821071)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c59821071.condition)
	e1:SetOperation(c59821071.activate)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821071.splimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821071,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c59821071.effcon)
	e3:SetValue(c59821071.atkval)
	e3:SetLabel(3)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821071,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,59821071)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c59821071.effcon)
	e4:SetTarget(c59821071.mattg)
	e4:SetOperation(c59821071.matop)
	e4:SetLabel(6)
	c:RegisterEffect(e4)
	--halve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821071,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c59821071.effcon)
	e5:SetTarget(c59821071.sptg)
	e5:SetOperation(c59821071.spop)
	e5:SetLabel(9)
	c:RegisterEffect(e5)
	--LP change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821071,3))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,59821071+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c59821071.effcon)
	e6:SetCost(c59821071.lpcost)
	e6:SetOperation(c59821071.lpop)
	e6:SetLabel(12)
	c:RegisterEffect(e6)
end
function c59821071.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c59821071.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(c59821071.damagefilter))
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c59821071.damagefilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function c59821071.splimit(e,c)
	return not c:IsSetCard(0xa1a2)
end
function c59821071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821071.effcon(e)
	return Duel.GetMatchingGroup(c59821071.cfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c59821071.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end
function c59821071.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c59821071.matfilter,tp,LOCATION_GRAVE,0,1,c)
end
function c59821071.matfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ)
end
function c59821071.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821071.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c59821071.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821071.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c59821071.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c59821071.matfilter,tp,LOCATION_GRAVE,0,1,1,tc)
		if g:GetCount()>0 then
			local mg=g:GetFirst():GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			Duel.Overlay(tc,g)
		end
	end
end
function c59821071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c59821071.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c59821071.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c59821071.tgfilter,nil,e,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c59821071.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c59821071.cfilter,tp,LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)==12
end
function c59821071.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c59821071.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,500)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
