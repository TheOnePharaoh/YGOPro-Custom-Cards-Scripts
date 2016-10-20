--Gun Brunette
function c160005658.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160005658,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c160005658.descost)
	e1:SetTarget(c160005658.destg)
	e1:SetOperation(c160005658.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--cannot be set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c160005658.setcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c160005658.efilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e5)
end
function c160005658.costfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)  and c:IsAbleToRemoveAsCost()
end
function c160005658.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160005658.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160005658.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160005658.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160005658.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c160005658.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160005658.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c160005658.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c160005658.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c160005658.setcon(e,c)
	if not c then return true end
	return false
end
function c160005658.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
