--The Future Gear Lockhart the Dimension Traveler
function c99199047.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--composition material
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c99199047.concon)
	e0:SetOperation(c99199047.conop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+330)
	c:RegisterEffect(e0)
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xff17)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199047,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99199047.condition)
	e3:SetTarget(c99199047.target)
	e3:SetOperation(c99199047.operation)
	c:RegisterEffect(e3)
	--copy effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199047,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_XMDETACH)
	e4:SetCountLimit(1)
	e4:SetCondition(c99199047.copycon)
	e4:SetCost(c99199047.copycost)
	e4:SetTarget(c99199047.copytg)
	e4:SetOperation(c99199047.copyop)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(c99199047.atcon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e6:SetCondition(c99199047.atcon)
	d:RegisterEffect(e6)
end
function c99199047.atcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c99199047.spfilter1(c,tp)
	return c:IsFaceup() and c:GetLevel()==6 and c:IsSetCard(0xff16) and Duel.IsExistingMatchingCard(c99199046.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c99199047.spfilter2(c)
	return c:IsFaceup() and c:GetLevel()==6 and not c:IsSetCard(0xff16)
end
function c99199047.concon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c99199047.spfilter1,tp,LOCATION_MZONE,0,2,nil,tp)
end
function c99199047.conop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199047,2))
	local g1=Duel.SelectMatchingCard(tp,c99199047.spfilter1,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199047,3))
	local g2=Duel.SelectMatchingCard(tp,c99199047.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local tc=g2:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g2:GetNext()
	end
	Duel.Overlay(c,g1)
	Duel.Release(g2,REASON_COST+REASON_MATERIAL)
end
function c99199047.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+330
end
function c99199047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c99199047.chainlm)
end
function c99199047.chainlm(e,rp,tp)
	return tp==rp
end
function c99199047.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c99199047.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99199047.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99199047.copycon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c99199047.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99199047.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c99199047.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsType(TYPE_EFFECT) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler(),TYPE_EFFECT) 
		and e:GetHandler():GetFlagEffect(99199049)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler(),TYPE_EFFECT)
end
function c99199047.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCode()
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
		if not tc:IsType(TYPE_TRAPMONSTER) then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			c:RegisterFlagEffect(99199049,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		end
	end
end