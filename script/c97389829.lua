--Hold and Release - Three Ways of Destruction
function c97389829.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,97389829)
	e1:SetCondition(c97389829.condition)
	e1:SetTarget(c97389829.target)
	e1:SetOperation(c97389829.operation)
	c:RegisterEffect(e1)
end
function c97389829.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405) and c:IsType(TYPE_SYNCHRO)
end
function c97389829.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c97389829.cfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c97389829.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c97389829.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then return
	elseif sg:GetCount()==2 then
		Duel.Destroy(sg,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,2-tp,HINTMSG_DESTROY)
		local dg=sg:Select(2-tp,1,2,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
