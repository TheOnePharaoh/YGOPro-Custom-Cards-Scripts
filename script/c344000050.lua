--Equip
function c344000050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c344000050.target)
	e1:SetOperation(c344000050.operation)
	c:RegisterEffect(e1)
	--atk target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c344000050.atkcon)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c344000050.atktg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c344000050.eqlimit)
	c:RegisterEffect(e3)
end
function c344000050.eqlimit(e,c)
	return c:IsSetCard(0x444a)
end
function c344000050.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x444a)
end
function c344000050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c344000050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c344000050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c344000050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c344000050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c344000050.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,ec)
end
function c344000050.atktg(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
