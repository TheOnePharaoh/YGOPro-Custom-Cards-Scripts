--Dreadnought Mark - 01 Gilberd
function c22769900.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22769900.spcon)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--send monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22769900,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22769900)
	e3:SetTarget(c22769900.target1)
	e3:SetOperation(c22769900.operation1)
	c:RegisterEffect(e3)
	--send trap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769900,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22769900)
	e4:SetTarget(c22769900.target2)
	e4:SetOperation(c22769900.operation2)
	c:RegisterEffect(e4)
end
function c22769900.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c22769900.tgfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==10 and c:IsSetCard(0xaa12) and c:IsAbleToGrave()
end
function c22769900.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769900.tgfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22769900.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769900.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22769900.tgfilter2(c)
	return c:IsType(TYPE_COUNTER) and c:IsSetCard(0xaa12) and c:IsAbleToGrave()
end
function c22769900.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769900.tgfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22769900.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769900.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end