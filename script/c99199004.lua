--The Future Gear Cosmic Dragon Nix
function c99199004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199004.splimit)
	e2:SetCondition(c99199004.splimcon)
	c:RegisterEffect(e2)
	--tuner related
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99199004.tunercon)
	e3:SetTarget(c99199004.tunertg)
	e3:SetOperation(c99199004.tunerop)
	c:RegisterEffect(e3)
	--spsummon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,99199004)
	e4:SetCondition(c99199004.condition)
	e4:SetTarget(c99199004.target)
	e4:SetOperation(c99199004.operation)
	c:RegisterEffect(e4)
	--scale
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CHANGE_LSCALE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c99199004.sccon)
	e5:SetValue(4)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e6)
end
function c99199004.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199004.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199004.tunerfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199004.tunercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199004.tunerfilter1,1,nil,tp)
end
function c99199004.tunerfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0xff15)) and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ)
end
function c99199004.tunertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199004.tunerfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199004.tunerfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199004.tunerfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99199004.tunerop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end
function c99199004.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199004.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199004.tuningfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xff15)) and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ) and not c:IsCode(99199004)
end
function c99199004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199004.tuningfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199004.tuningfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199004.tuningfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99199004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end
