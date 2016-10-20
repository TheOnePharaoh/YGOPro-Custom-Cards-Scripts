--Solid Slate Warrior
function c999101.initial_effect(c)
	c:SetUniqueOnField(1,0,999101)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c999101.spcon)
	c:RegisterEffect(e1)
	--avoid damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c999101.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999101,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c999101.tdcon)
	e4:SetTarget(c999101.tdtg)
	e4:SetOperation(c999101.tdop)
	c:RegisterEffect(e4)
end
function c999101.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999101.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c999101.spfilter,c:GetControler(),LOCATION_SZONE,0,2,nil)
end
function c999101.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c999101.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c999101.filter(c)
	return c:IsType(TYPE_CONTINOS) and c:IsAbleToDeck()
end
function c999101.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c999101.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.SortDecktop(tp,tp,5)
end