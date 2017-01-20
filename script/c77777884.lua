--House at the end of the Glade
function c77777884.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c77777884.target)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c77777884.target)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
  --Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
  e4:SetDescription(aux.Stringid(77777884,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c77777884.settg)
	e4:SetOperation(c77777884.setop)
	c:RegisterEffect(e4)
  --Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
  e5:SetDescription(aux.Stringid(77777884,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetCountLimit(1)
  e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c77777884.fliptg)
	e5:SetOperation(c77777884.flipop)
	c:RegisterEffect(e5)
end
function c77777884.target(e,c)
	return c:IsSetCard(0x40c) and c:GetFlagEffect(77777876)~=0
end
function c77777884.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c77777884.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77777884.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777884.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c77777884.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c77777884.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end

function c77777884.filter2(c)
	return c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function c77777884.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77777884.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777884.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c77777884.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c77777884.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown() then
		Duel.ChangePosition(tc,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
