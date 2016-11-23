--May-Raias Zero - Tengaku God
function c87002902.initial_effect(c)
	c:EnableReviveLimit()
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c87002902.immfilter)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c87002902.tgfilter)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87002902,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,87002902)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c87002902.remcost)
	e3:SetTarget(c87002902.remtg)
	e3:SetOperation(c87002902.remop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c87002902.desreptg)
	c:RegisterEffect(e4)
end
function c87002902.immfilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c87002902.tgfilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c87002902.remcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe291ca) and c:IsDiscardable()
end
function c87002902.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87002902.remcostfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c87002902.remcostfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c87002902.tfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk and c:IsAbleToRemove()
end
function c87002902.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c87002902.tfilter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c87002902.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c87002902.tfilter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*400)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c87002902.repfilter(c)
	return c:IsSetCard(0xe291ca) and c:IsAbleToRemoveAsCost()
end
function c87002902.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c87002902.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(87002902,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c87002902.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		return true
	else return false end
end
