--Accel Vocaloid Aoki Lapiz
function c41045207.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,34602088),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--synchro summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41045207,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c41045207.eqcon)
	e2:SetTarget(c41045207.eqtg)
	e2:SetOperation(c41045207.eqop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(41045207,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c41045207.drtg)
	e3:SetOperation(c41045207.drop)
	c:RegisterEffect(e3)
end
function c41045207.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c41045207.equipfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(3) and not c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TUNER)
end
function c41045207.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c41045207.equipfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c41045207.equipfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c41045207.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c41045207.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c41045207.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--control
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--tuner
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_TUNER)
		c:RegisterEffect(e3)
		--race
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(RACE_MACHINE)
		c:RegisterEffect(e4)
		--Destroy
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EVENT_LEAVE_FIELD_P)
		e5:SetOperation(c41045207.checkop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetOperation(c41045207.desop)
		e6:SetReset(RESET_EVENT+0x17e0000)
		e6:SetLabelObject(e5)
		c:RegisterEffect(e6)
	end
end
function c41045207.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c41045207.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c41045207.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c41045207.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
