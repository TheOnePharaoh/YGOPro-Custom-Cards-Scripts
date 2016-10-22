--Erebos, Shaderune of Darkness
function c6666685.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,3)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c6666685.condition)
	e1:SetTarget(c6666685.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c6666685.rmcon)
	e2:SetTarget(c6666685.rmtarget)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(6666685)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(c6666685.checktg)
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c6666685.descon)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetDescription(aux.Stringid(6666685,1))
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c6666685.cost)
	e5:SetTarget(c6666685.target)
	e5:SetOperation(c6666685.operation)
	c:RegisterEffect(e5)
	--Immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c6666685.imcon)
	e6:SetValue(c6666685.efilter)
	c:RegisterEffect(e6)
end
function c6666685.condition(e)
    return e:GetHandler():GetOverlayCount()>1
end
function c6666685.disable(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c6666685.rmtarget(e,c)
	return not c:IsLocation(0x80)
end
function c6666685.checktg(e,c)
	return not c:IsPublic()
end
function c6666685.rmcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c6666685.descfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c6666685.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c6666685.descfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil):GetCount()==0
end
function c6666685.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6666685.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsCode(6666685)
end
function c6666685.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c6666685.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c6666685.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c6666685.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    Duel.BreakEffect()
    local lp=Duel.GetLP(tp)
    if lp<=ct*500 then
    	Duel.SetLP(tp,0)
    else
    	Duel.SetLP(tp,lp-ct*500)
    end
end
function c6666685.ofilter(c)
	return c:IsCode(6666684)
end
function c6666685.imcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(c6666685.ofilter,1,nil)
end
function c6666685.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end