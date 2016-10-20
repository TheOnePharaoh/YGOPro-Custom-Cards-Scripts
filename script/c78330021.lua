--AB Blader
function c78330021.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c78330021.spcon)
	c:RegisterEffect(e1)
	--overlay capture
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330021,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c78330021.cost)
	e2:SetTarget(c78330021.target)
	e2:SetOperation(c78330021.operation)
	c:RegisterEffect(e2)
end
function c78330021.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c78330021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c78330021.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c78330021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,0,1)~=0
		and Duel.IsExistingMatchingCard(c78330021.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c78330021.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetOverlayGroup(tp,0,1)
	local g2=Duel.GetMatchingGroup(c78330021.filter,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(78330021,2))
	local mg=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(78330021,1))
	local tc=g2:Select(tp,1,1,nil):GetFirst()
	local oc=mg:GetFirst():GetOverlayTarget()
	Duel.Overlay(tc,mg)
	Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
