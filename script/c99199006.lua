--The Future Gear Mech Dragon
function c99199006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199006.splimit)
	e2:SetCondition(c99199006.splimcon)
	c:RegisterEffect(e2)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199006,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c99199006.ntcon)
	e3:SetOperation(c99199006.ntop)
	c:RegisterEffect(e3)
	--transform
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199006,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,99199006)
	e4:SetCondition(c99199006.condition)
	e4:SetTarget(c99199006.target)
	e4:SetOperation(c99199006.operation)
	c:RegisterEffect(e4)
	--scale
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CHANGE_LSCALE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c99199006.sccon)
	e5:SetValue(4)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e6)
end
function c99199006.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199006.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199006.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c99199006.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	--tuner related
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
end
function c99199006.condition(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0xff15)
end
function c99199006.tunfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff15) and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ)
end
function c99199006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199006.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199006.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99199006.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99199006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c99199006.tunfilter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c99199006.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
