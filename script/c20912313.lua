--The Sword of Beast Slaying Hrrunting
function c20912313.initial_effect(c)
	c:SetUniqueOnField(1,0,20912313)
	aux.AddEquipProcedure(c,0,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20912313,0))
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetTarget(c20912313.drtg)
	e4:SetOperation(c20912313.drop)
	c:RegisterEffect(e4)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c20912313.eqlimit)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20912313,1))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c20912313.eqcon)
	e6:SetCost(c20912313.eqcost)
	e6:SetTarget(c20912313.eqtg)
	e6:SetOperation(c20912313.operation)
	c:RegisterEffect(e6)
end
function c20912313.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c20912313.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c20912313.damfil(c,tp)
	return c:IsControler(tp) and c:IsAbleToGrave() and c:IsType(TYPE_EQUIP)
end
function c20912313.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c20912313.damfil,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,tp,LOCATION_HAND)
end
function c20912313.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local dc=eg:Filter(c20912313.damfil,nil,tp):Select(tp,1,1,nil)
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(dc,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
	end
end
function c20912313.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)
end
function c20912313.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c20912313.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2)
end
function c20912313.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912313.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20912313.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20912313.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
