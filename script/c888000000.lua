--Evil HERO Zero Degrees
function c888000000.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000000.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c888000000.atkup)
	c:RegisterEffect(e2)
	--send
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000000,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c888000000.sencon)
	e3:SetTarget(c888000000.sentg)
	e3:SetOperation(c888000000.senop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
end
c888000000.dark_calling=true
function c888000000.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000000.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c888000000.atkup(e,c)
	return Duel.GetMatchingGroupCount(c888000000.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
function c888000000.senfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c888000000.sencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c888000000.sentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c888000000.senfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c888000000.senop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c888000000.senfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	local d=ct*400
	if d>0 then
		Duel.Damage(1-tp,d,REASON_EFFECT)
	end
end
