--Assaulter of the Arch Beetle
function c78330025.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),4,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330025,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e1:SetCondition(c78330025.damcon)
	e1:SetCost(c78330025.damcost)
	e1:SetTarget(c78330025.damtg)
	e1:SetOperation(c78330025.damop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330025,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c78330025.imcon)
	c:RegisterEffect(e2)
end
function c78330025.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c78330025.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c78330025.damfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_INSECT) and c:IsAbleToRemove()
end
function c78330025.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c78330025.damfilter,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
	end
end
function c78330025.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c78330025.damfilter,tp,0,LOCATION_GRAVE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
function c78330025.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end