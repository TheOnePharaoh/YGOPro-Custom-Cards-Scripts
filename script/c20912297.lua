--The Sword of Hatred Igneas
function c20912297.initial_effect(c)
	c:SetUniqueOnField(1,0,20912297)
	aux.AddEquipProcedure(c,0,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(-500)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c20912297.eqlimit)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetCountLimit(1)
	e5:SetValue(c20912297.valcon)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20912297,0))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c20912297.eqcon)
	e6:SetCost(c20912297.eqcost)
	e6:SetTarget(c20912297.eqtg)
	e6:SetOperation(c20912297.operation)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(20912297,1))
	e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetCondition(c20912297.adcon)
	e7:SetOperation(c20912297.adop)
	c:RegisterEffect(e7)
end
function c20912297.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c20912297.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c20912297.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)
end
function c20912297.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c20912297.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2)
end
function c20912297.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912297.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20912297.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20912297.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20912297.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		e:GetHandler():RegisterFlagEffect(20912297,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
		return true
	else return false end
end
function c20912297.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20912297)~=0
end
function c20912297.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:GetEquipTarget():RegisterEffect(e1)
end
