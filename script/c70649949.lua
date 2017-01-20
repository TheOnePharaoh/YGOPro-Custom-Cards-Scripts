--ADE Ar'Khin
function c70649949.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c70649949.splimit)
	e1:SetCondition(c70649949.splimcon)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649949,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,70649949)
	e2:SetCondition(c70649949.pencon)
	e2:SetTarget(c70649949.pentg)
	e2:SetOperation(c70649949.penop)
	c:RegisterEffect(e2)
	--non-tuner
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649949,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,70649949)
	e3:SetTarget(c70649949.tuntg)
	e3:SetOperation(c70649949.tunop)
	c:RegisterEffect(e3)
end
function c70649949.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c70649949.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c70649949.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd0a214)
end
function c70649949.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c70649949.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70649949.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c70649949.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c70649949.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c70649949.tunfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsSetCard(0xd0a214)
end
function c70649949.tuntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70649949.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70649949.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c70649949.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c70649949.tunop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c70649949.tunfilter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end