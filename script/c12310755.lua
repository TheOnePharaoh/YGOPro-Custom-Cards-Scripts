--Dragonslayer Orstein
--Lua script by SGJin
function c12310755.initial_effect(c)
	--Dragon Slayer
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12310755.val)
	c:RegisterEffect(e1)
	--Lighting Damage / Peirce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310755,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,12310755)
	e4:SetCost(c12310755.eqcost)
	e4:SetTarget(c12310755.eqtg)
	e4:SetOperation(c12310755.eqop)
	c:RegisterEffect(e4)
	--Equiped effects same as above ^
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(c12310755.val)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
end
function c12310755.val(e,c)
	return Duel.GetMatchingGroupCount(c12310755.filter,0,0x14,0x14,nil)*300
end
function c12310755.filter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c12310755.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function c12310755.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310755.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12310755.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12310755.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(6)
end
function c12310755.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12310755.filter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c12310755.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12310755.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12310755.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c12310755.eqlimit)
	c:RegisterEffect(e1)
end
function c12310755.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
