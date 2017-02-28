--The Idol's Triagram Formation
function c59821119.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,59821119)
	e1:SetCondition(c59821119.condition)
	e1:SetTarget(c59821119.target)
	e1:SetOperation(c59821119.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c59821119.handcon)
	c:RegisterEffect(e2)
end
function c59821119.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c59821119.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821119.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c59821119.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c59821119.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToDeck()
end
function c59821119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821119.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59821119.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c59821119.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821119.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end