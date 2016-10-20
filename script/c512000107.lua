--Number 70: Deadly Sin
function c512000107.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000513,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c512000107.cost)
	e1:SetTarget(c512000107.target)
	e1:SetOperation(c512000107.operation)
	e1:SetLabel(2)
	c:RegisterEffect(e1)
	--attach attacking monster as material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000517,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c512000107.nacon)
	e2:SetOperation(c512000107.naop)
	c:RegisterEffect(e2)
end
c512000107.xyz_number=70
function c512000107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:SetLabel(3)
end
function c512000107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c512000107.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c512000107.nacon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return bt:GetControler()==c:GetControler() and not at:IsType(TYPE_TOKEN)
end
function c512000107.naop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local og=at:GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(e:GetHandler(),at)
end
