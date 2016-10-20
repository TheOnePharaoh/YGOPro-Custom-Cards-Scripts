--Nebula - Song of Imagination
function c13418030.initial_effect(c)
	c:SetUniqueOnField(1,0,13418030)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recovery
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13418030,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c13418030.rectg)
	e2:SetOperation(c13418030.recop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c13418030.reptg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c13418030.aclimit)
	e4:SetCondition(c13418030.actcon)
	c:RegisterEffect(e4)
end
function c13418030.recfilter(c)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK) and c:IsRace(RACE_MACHINE) and c:GetAttack()>0 and c:GetSummonLocation()==LOCATION_EXTRA
end
function c13418030.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13418030.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13418030.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13418030.recfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c13418030.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c13418030.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
		and tc:IsRace(RACE_MACHINE) and bit.band(tc:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 end
	if Duel.SelectYesNo(tp,aux.Stringid(13418030,1)) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		return true
	else return false end
end
function c13418030.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c13418030.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x0dac401) or c:IsSetCard(0x0dac402) or c:IsSetCard(0x0dac403) or c:IsSetCard(0x0dac404) or c:IsSetCard(0x0dac405) or c:IsSetCard(0x301) and c:IsControler(tp)
end
function c13418030.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c13418030.cfilter(a,tp)) or (d and c13418030.cfilter(d,tp))
end
