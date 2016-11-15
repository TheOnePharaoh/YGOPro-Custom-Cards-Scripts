 --Created and coded by Rising Phoenix
function c100000802.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x109),aux.NonTuner(Card.IsSetCard,0x109),1)
	c:EnableReviveLimit()
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000802,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetTarget(c100000802.tg)
	e1:SetOperation(c100000802.op)
	c:RegisterEffect(e1)
end
function c100000802.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000802.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function c100000802.filter(c)
	return (c:IsCode(100000801) or c:IsCode(100000800) or c:IsCode(100000803) or c:IsCode(100000804) or c:IsCode(100000805) or c:IsCode(100000806) or c:IsCode(100000807) or c:IsCode(100000808) or c:IsCode(100000809)) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end