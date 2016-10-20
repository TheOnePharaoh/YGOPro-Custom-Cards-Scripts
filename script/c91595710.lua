--Spellbook of Secret Arts
--lua script by SGJin
function c91595710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c91595710.target)
	e1:SetOperation(c91595710.operation)
	c:RegisterEffect(e1)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c91595710.value)
	c:RegisterEffect(e2)
	--Def Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c91595710.value)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c91595710.eqlimit)
	c:RegisterEffect(e4)
	--Level + 1 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_LEVEL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Burn damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(91595710,0))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c91595710.damcon)
	e6:SetTarget(c91595710.damtg)
	e6:SetOperation(c91595710.damop)
	c:RegisterEffect(e6)
end 
function c91595710.eqlimit(e,c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0
end
function c91595710.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0
end
function c91595710.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c53610653.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91595710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c91595710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c91595710.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c91595710.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsRelateToBattle()
end
function c91595710.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(c91595710.filter2,tp,LOCATION_GRAVE,0,nil)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c91595710.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		local dam=Duel.GetMatchingGroupCount(c91595710.filter2,tp,LOCATION_GRAVE,0,nil)*300
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function c91595710.value(e,c)
	return Duel.GetMatchingGroupCount(c91595710.filter2,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*300
end
function c91595710.filter2(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL)
end
