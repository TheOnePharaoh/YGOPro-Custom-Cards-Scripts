--Call to the Hellformed Darkness
function c77777777.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(77777777,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77777777.condition)
	e1:SetTarget(c77777777.target)
	e1:SetOperation(c77777777.activate)
	c:RegisterEffect(e1)
end
function c77777777.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77777777.activate(e,tp,eg,ep,ev,re,r,rp)
	local grp = Group.CreateGroup()
	local lsc = Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc = Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	grp:AddCard(lsc)
	grp:AddCard(rsc)
	if Duel.Destroy(grp,REASON_EFFECT)==2 then
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function c77777777.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0x3e7) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0x3e7)
end