--Legia the Darkness, 11th Arian Guardian
function c77790004.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,3)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77790004.up)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c77790004.batfilter)
	c:RegisterEffect(e2)
	--detach 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77790004,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c77790004.cost)
	e3:SetCondition(c77790004.con)
	e3:SetTarget(c77790004.target)
	e3:SetOperation(c77790004.operation)
	c:RegisterEffect(e3)
	--detach2
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(77790004,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetTarget(c77790004.target2)
	e4:SetOperation(c77790004.operation2)
	c:RegisterEffect(e4)
end
function c77790004.upfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x100f) and c:IsType(TYPE_MONSTER)
end
function c77790004.up(e,c)
	return Duel.GetMatchingGroupCount(c77790004.upfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*1000
end
function c77790004.batfilter(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c77790004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77790004.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(77790004)==0
end
function c77790004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77790004.eqlimit(e,c)
	return e:GetOwner()==c
end
function c77790004.rhfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c77790004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then		 
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			if tc:IsFacedown() or atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(77790004,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c77790004.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c77790004.rhfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c77790004.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c77790004.rhfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77790004.rhfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77790004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end