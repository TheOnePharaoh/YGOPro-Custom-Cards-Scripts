--Blessing from the Emperor
function c70649947.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c70649947.condition)
	e1:SetTarget(c70649947.target)
	e1:SetOperation(c70649947.activate)
	c:RegisterEffect(e1)
end
function c70649947.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c70649947.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a214) or c70649947.confilter(c)
end
function c70649947.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70649947.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c70649947.filter2(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c70649947.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c70649947.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c70649947.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c70649947.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70649947.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Damage(p,800,REASON_EFFECT)
	end
end
