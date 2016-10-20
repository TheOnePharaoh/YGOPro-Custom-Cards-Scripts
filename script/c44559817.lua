--Lei Kun, Thunder God of the Sky Nirvana
function c44559817.initial_effect(c)
	c:SetUniqueOnField(1,0,44559817)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559817,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c44559817.condition)
	e4:SetTarget(c44559817.target)
	e4:SetOperation(c44559817.operation)
	c:RegisterEffect(e4)
  --Indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c44559817.efilter)
	c:RegisterEffect(e5)
end
function c44559817.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c44559817.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44559817.cfilter,1,nil,tp)
end
function c44559817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c44559817.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=tg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c44559817.efilter(e,re,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end