--Number 77: The Seven Sins
function c512000021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(698785,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c512000021.cost)
	e1:SetTarget(c512000021.target)
	e1:SetOperation(c512000021.operation)
	c:RegisterEffect(e1)
	--remove from game
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(512000021,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c512000021.killcost)
	e2:SetTarget(c512000021.killtg)
	e2:SetOperation(c512000021.killop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(512000021,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCost(c512000021.endcost)
	e3:SetOperation(c512000021.endop)
	c:RegisterEffect(e3)
	if not c512000021.global_check then
		c512000021.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000021.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000021.xyz_number=77
function c512000021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c512000021.filter(c,s)
	return not c:IsLocation(LOCATION_MZONE) and c~=s
end
function c512000021.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT) then
		g=g:Filter(c512000021.filter,nil,e:GetHandler())
		if e:GetHandler():IsLocation(LOCATION_MZONE) then
			Duel.Overlay(e:GetHandler(),g)
		end
	end
end
function c512000021.killcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,REASON_COST)
end
function c512000021.killtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,2,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,2,2,nil)
end
function c512000021.killop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,-2,REASON_EFFECT)
end
function c512000021.endcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,20,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,20,20,REASON_COST)
end
function c512000021.endop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0x1F,0x1F,e:GetHandler())
	Duel.SendtoDeck(g,nil,-2,REASON_EFFECT)
	Duel.SetLP(tp,0)
	Duel.SetLP(1-tp,0)
end
function c512000021.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,62541668)
	Duel.CreateToken(1-tp,62541668)
end
