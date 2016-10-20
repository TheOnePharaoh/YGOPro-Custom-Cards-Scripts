--The Future Gear Demon's Bane
function c99199038.initial_effect(c)
	c:SetSPSummonOnce(99199038)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199038.splimit)
	e2:SetCondition(c99199038.splimcon)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c99199038.actcon)
	e3:SetOperation(c99199038.actop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	--lv mod
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199038,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c99199038.lvop)
	c:RegisterEffect(e5)
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99199038.sccon)
	e6:SetValue(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7)
	--set
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCondition(aux.bdocon)
	e8:SetTarget(c99199038.settg)
	e8:SetOperation(c99199038.setop)
	c:RegisterEffect(e8)
end
function c99199038.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199038.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199038.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199038.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(4)
		c:RegisterEffect(e1)
	end
end
function c99199038.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xff15) and bit.band(tc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99199038.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c99199038.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c99199038.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99199038.setfilter(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c99199038.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99199038.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c99199038.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c99199038.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99199038.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end

