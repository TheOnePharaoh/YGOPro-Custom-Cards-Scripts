--Vocaloid Momone Momo
function c61401427.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c61401427.efilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(61401427,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c61401427.target)
	e3:SetOperation(c61401427.operation)
	c:RegisterEffect(e3)
end
function c61401427.efilter(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c61401427.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c61401427.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13574687.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61401427.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c61401427.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c61401427.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		end
	end
end
