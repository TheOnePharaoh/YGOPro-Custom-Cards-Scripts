--Number Cxyz92: Heart-eartH Ultimate Dark Dragon
function c99409519.initial_effect(c)
aux.AddXyzProcedure(c,nil,12,4,c99409519.ovfilter,aux.Stringid(47017574,1))
	c:EnableReviveLimit()

 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99409519.condit1)
	e1:SetTarget(c99409519.reptg)
	c:RegisterEffect(e1)
 local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(99409519,0))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c99409519.condit0)
	e11:SetCost(c99409519.cost)
	e11:SetTarget(c99409519.target)
	e11:SetOperation(c99409519.operation)
	c:RegisterEffect(e11)
 local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_UPDATE_ATTACK)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c99409519.atkval)
	c:RegisterEffect(e12)
 local e13=e12:Clone()
	e13:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e13)
local e15=Effect.CreateEffect(c)
 e15:SetDescription(aux.Stringid(99409519,1))
	  e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	  e15:SetCode(EVENT_PHASE+PHASE_END)
	  e15:SetRange(LOCATION_MZONE)
	  e15:SetCountLimit(1)
	  e15:SetTarget(c99409519.mttg)
	  e15:SetOperation(c99409519.mtop)
	  c:RegisterEffect(e15)
local e14=Effect.CreateEffect(c)
   e14:SetType(EFFECT_TYPE_SINGLE)
   e14:SetCode(EFFECT_IMMUNE_EFFECT)
   e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
   e14:SetRange(LOCATION_MZONE)
   e14:SetCondition(c99409519.condit3)
   e14:SetValue(c99409519.efilter)
	c:RegisterEffect(e14)
local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e16:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTargetRange(0xff,0xff)
	e16:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e16)
end
c99409519.xyz_number=92
function c99409519.ovfilter(c)
	return c:IsFaceup() and c:IsCode(47017574)
end
function c99409519.efilter(e,te)
return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99409519.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c99409519.condit1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,97403510)
end
function c99409519.condit3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47017574)
end
function c99409519.condit0(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0
end
function c99409519.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
end
function c99409519.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99409519.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xe,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end
function c99409519.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xe,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			 Duel.SetChainLimit(aux.FALSE)
end
function c99409519.mtfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c99409519.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99409519.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil) end
end
function c99409519.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c99409519.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end