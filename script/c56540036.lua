function c56540036.initial_effect(c)
	--xyz summon
	
aux.AddXyzProcedure(c,nil,8,2)

	c:EnableReviveLimit()
		--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56540036,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c56540036.reptg)
	e1:SetOperation(c56540036.repop)
	c:RegisterEffect(e1)
	--destroy opponent's monsters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56540036,2))
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c56540036.cost)
	e3:SetTarget(c56540036.destg)
	e3:SetOperation(c56540036.desop)
	c:RegisterEffect(e3)
end
function c56540036.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(56540036,0))
end
function c56540036.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function c56540036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c56540036.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c56540036.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end