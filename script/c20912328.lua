--Sword Art Champion Saint Lily
function c20912328.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912328,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c20912328.attcon)
	e2:SetTarget(c20912328.atttg)
	e2:SetOperation(c20912328.attop)
	c:RegisterEffect(e2)
end
function c20912328.attcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xd0a2)
end
function c20912328.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xd0a2)
end
function c20912328.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912328.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912328.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,RACE_WARRIOR) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c20912328.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20912328.attop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,RACE_WARRIOR)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end