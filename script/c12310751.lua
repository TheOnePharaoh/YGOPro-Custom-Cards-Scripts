--The Fair Lady
--lua script by SGJin
function c12310751.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk bonus for Chaos Servant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310751,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c12310751.tgcon)
	e2:SetTarget(c12310751.tgtg)
	e2:SetOperation(c12310751.tgop)
	c:RegisterEffect(e2)
	--Atk & Def while on Field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c12310751.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	--Protection while on Field
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetCondition(c12310751.ccon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Indestructible with Chaos Servant
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetCondition(c12310751.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--lv change while on Field
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_UPDATE_LEVEL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c12310751.lvval)
	c:RegisterEffect(e7)
end
function c12310751.adval(e,c)
	return c:GetLevel()*400
end
function c12310751.lvval(e,c)
	local batk=Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,12310712)
	local twinatk=Duel.GetMatchingGroupCount(c12310751.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)
	local total=batk+twinatk
	if total+e:GetHandler():GetLevel()>=12 then
		total=12-e:GetHandler():GetLevel()
	end
	return total
end
function c12310751.filter2(c)
	return c:IsCode(12310712) and c:IsHasEffect(12310713)
end
function c12310751.atkval(e,c)
	local batk=Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,12310712)*200
	local twinatk=Duel.GetMatchingGroupCount(c12310751.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)*200
	return batk + twinatk
end	
function c12310751.scval(e,c)
	local batk=Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,12310712)
	local twinatk=Duel.GetMatchingGroupCount(c12310751.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)
	local total=batk+twinatk
	if c:GetSequence()==6 then
		return total + e:GetHandler():GetLeftScale()
	else
		return total + e:GetHandler():GetRightScale()
	end
end
function c12310751.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function c12310751.tgcon(e) 
	return e:GetHandler():GetCardTargetCount()<=0
end
function c12310751.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12310751.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c12310751.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LSCALE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetValue(c12310751.scval)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CHANGE_RSCALE)
		e3:SetValue(c12310751.scval)
		c:RegisterEffect(e3)
	end
end
function c12310751.indcon(e)
	return e:GetHandler():GetCardTargetCount()>0
end
