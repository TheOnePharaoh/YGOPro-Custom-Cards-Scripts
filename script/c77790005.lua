--Inel the Light, 10th Arian Guardian
function c77790005.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT))
	c:EnableReviveLimit()
	--limit attack target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(c77790005.tglimit)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77790005,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77790005.target)
	e2:SetOperation(c77790005.operation)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c77790005.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--change damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetValue(c77790005.rdval)
	c:RegisterEffect(e4)
	--attack all
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c77790005.tglimit(e,c)
	return c~=e:GetHandler()
end
function c77790005.filter(c,ec)
	return not ec:IsHasCardTarget(c) and c:IsType(TYPE_PENDULUM)
end
function c77790005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c and c77790005.filter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c77790005.filter,tp,LOCATION_SZONE,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c77790005.filter,tp,LOCATION_SZONE,0,1,1,c,c)
end
function c77790005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		tc:RegisterFlagEffect(77790005,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c77790005.indtg(e,c)
	return e:GetHandler():IsHasCardTarget(c) and c:GetFlagEffect(77790005)~=0
end
function c77790005.rdval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return val/2
	else
		return val
	end
end
