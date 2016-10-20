--Skar the Mystical Blue Dragon
function c89990025.initial_effect(c)
    c:EnableReviveLimit()
	--handdes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c89990025.condition)
	e1:SetTarget(c89990025.target)
	e1:SetOperation(c89990025.operation)
	c:RegisterEffect(e1)
end
function c89990025.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c89990025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,0,LOCATION_HAND)
end
function c89990025.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,g)
	local dg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.ShuffleHand(1-tp)
end
