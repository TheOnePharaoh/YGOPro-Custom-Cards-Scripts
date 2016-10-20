--Nebula - Song of Freedom and Unrestraint
function c98100024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac404))
	e2:SetValue(c98100024.indval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac404))
	e3:SetValue(c98100024.efilter)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98100024,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c98100024.mattg)
	e4:SetOperation(c98100024.matop)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c98100024.mtcon)
	e5:SetOperation(c98100024.mtop)
	c:RegisterEffect(e5)
end
function c98100024.indval(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c98100024.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end

function c98100024.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98100024.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>2000 and Duel.SelectYesNo(tp,aux.Stringid(98100024,1)) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c98100024.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c98100024.matfilter,tp,LOCATION_SZONE,0,1,c)
end
function c98100024.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(98100024)
end
function c98100024.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98100024.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98100024.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98100024.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98100024.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c98100024.matfilter,tp,LOCATION_SZONE,0,1,1,tc)
		if g:GetCount()>0 then
			local mg=g:GetFirst():GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			Duel.Overlay(tc,g)
		end
	end
end
