--Number Cxyz9: Chaos End Dyson Sphere
function c98408518.initial_effect(c)
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98408518,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98408518.target)
	e1:SetOperation(c98408518.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98408518,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98408518.damcon)
	e3:SetCost(c98408518.endcost)
	e3:SetOperation(c98408518.endop)
	c:RegisterEffect(e3)
  local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e12)
local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetCode(EVENT_CHAIN_SOLVING)
	e16:SetRange(LOCATION_MZONE)
	e16:SetOperation(c98408518.disop)
	c:RegisterEffect(e16)
end
c98408518.xyz_number=9
function c98408518.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,e:GetHandler()) 
			  end
end
function c98408518.filter(c,s)
	return not c:IsLocation(LOCATION_MZONE+LOCATION_SZONE+LOCATION_PZONE) and c~=s
end
function c98408518.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xe,e:GetHandler())
	if g:GetCount()>0
	then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Overlay(e:GetHandler(),g)
	end
end

function c98408518.damcon(e,tp,eg,ep,ev,re,r,rp)
local p=e:GetHandler():GetControler()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32559361) and (Duel.GetLP(1-p)>100)
end
function c98408518.endcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,10,REASON_COST) end
e:GetHandler():RemoveOverlayCard(tp,10,10,REASON_COST)
end
function c98408518.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,100)
end
function c98408518.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_MONSTER) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
	end
end