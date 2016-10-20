--ジ・エンド・オブ・ストーム
function c512000067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000067.target)
	e1:SetOperation(c512000067.activate)
	c:RegisterEffect(e1)
end
function c512000067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g1:GetCount()*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g2:GetCount()*300)
end
function c512000067.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c512000067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local ct1=g:FilterCount(c512000067.cfilter,nil,tp)
		local ct2=g:FilterCount(c512000067.cfilter,nil,1-tp)
		Duel.Damage(tp,ct1*300,REASON_EFFECT)
		Duel.Damage(1-tp,ct2*300,REASON_EFFECT)
	end
end
