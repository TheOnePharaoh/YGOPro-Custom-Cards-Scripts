--Moonlight Greatsword
function c12310750.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c12310750.target)
	e1:SetOperation(c12310750.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c12310750.atkval)
	c:RegisterEffect(e2)
	--equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12310750.eqlimit)
	c:RegisterEffect(e3)
	--battle damage to effect damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
	c:RegisterEffect(e4)
	--destroy&damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c12310750.damcon)
	e5:SetTarget(c12310750.damtg)
	e5:SetOperation(c12310750.damop)
	c:RegisterEffect(e5)
end
function c12310750.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER)
end
function c12310750.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER)
end
function c12310750.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310750.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310750.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12310750.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12310750.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c12310750.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*200
end
function c12310750.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsRelateToBattle()
end
function c12310750.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)*200
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c12310750.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)*300
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
