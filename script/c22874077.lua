--Intercepting Unit
function c22874077.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c22874077.condition)
	e1:SetTarget(c22874077.target)
	e1:SetOperation(c22874077.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c22874077.condition)
	e2:SetTarget(c22874077.target)
	e2:SetOperation(c22874077.activate)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetValue(c22874077.cval)
	c:RegisterEffect(e3)
	--race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(RACE_MACHINE)
	c:RegisterEffect(e4)
	--add setcode
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetValue(0x0dac405)
	c:RegisterEffect(e5)
	--equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c22874077.eqlimit)
	c:RegisterEffect(e6)
end
function c22874077.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22874077.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and not c:IsType(TYPE_XYZ)
end
function c22874077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22874077.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22874077.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22874077.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c22874077.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
	end
end
function c22874077.cval(e,c)
	return e:GetHandlerPlayer()
end
function c22874077.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end