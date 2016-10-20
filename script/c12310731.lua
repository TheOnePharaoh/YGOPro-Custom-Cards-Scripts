--Quelana of Izalith
--lua script by SGJin
function c12310731.initial_effect(c)
	--Destroy (Fire Tempest)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310731,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(0)
	e1:SetCost(c12310731.descost)
	e1:SetTarget(c12310731.destg)
	e1:SetOperation(c12310731.desop)
	c:RegisterEffect(e1)
	--ATK Boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12310731.val)
	c:RegisterEffect(e2)
end
function c12310731.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310731.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12310731.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():GetOriginalCode(12310713) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12310731.costfilter(c)
	return c:IsCode(12310712) and c:IsAbleToDeckAsCost()
end
function c12310731.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c12310731.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310731.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310731.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=e:GetLabel()+1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12310731.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetLevel()*200)
end
function c12310731.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	local fire=e:GetHandler():GetLevel()*200
	if Duel.Destroy(dg,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,fire,REASON_EFFECT)
	end
end
function c12310731.filter2(c)
	return c:IsCode(12310712) and c:IsHasEffect(12310713)
end
function c12310731.val(e,c)
	local batk=Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,12310712)*200
	local twinatk=Duel.GetMatchingGroupCount(c12310731.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)*200
	return batk + twinatk
end
