--The Future Gear Crusader Erina
function c99199003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199003.splimit)
	e2:SetCondition(c99199003.splimcon)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199003,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c99199003.fscon)
	e3:SetTarget(c99199003.lvtg)
	e3:SetOperation(c99199003.lvop)
	c:RegisterEffect(e3)
	--lv up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199003,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c99199003.thcon)
	e4:SetTarget(c99199003.tg)
	e4:SetOperation(c99199003.op)
	c:RegisterEffect(e4)
end
function c99199003.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199003.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199003.fscon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xff15)
end
function c99199003.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_XYZ) and c:GetLevel()>0
end
function c99199003.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99199003.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199003.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99199003.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(99199003,2))
	else op=Duel.SelectOption(tp,aux.Stringid(99199003,2),aux.Stringid(99199003,3)) end
	e:SetLabel(op)
end
function c99199003.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(2) end
		tc:RegisterEffect(e1)
	end
end

function c99199003.efftg(e,c)
	return c:GetFieldID()<=e:GetLabel() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_XYZ) and c:GetLevel()>0
end
function c99199003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199003.lvlfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_XYZ) and c:GetLevel()>0
end
function c99199003.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99199003.lvlfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c99199003.lvlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199003.lvlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c99199003.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
