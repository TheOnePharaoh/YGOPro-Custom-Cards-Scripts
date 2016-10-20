--Forbidden Mantra
function c512000083.initial_effect(c)
	c:SetUniqueOnField(1,1,512000083)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000380,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(511000380,1))
	e2:SetCondition(c512000083.handcon)
	e2:SetTarget(c512000083.handtg)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--act in deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c512000083.deckcon)
	e3:SetTarget(c512000083.handtg)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(511000380)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c512000083.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c512000083.fmfilter(c)
	return c:IsFaceup() and c:IsCode(511000380)
end
function c512000083.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return g:GetCount()==3 and g:IsExists(c512000083.cfilter,3,nil) 
		and not Duel.IsExistingMatchingCard(c512000083.fmfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c512000083.deckcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return g:GetCount()==5 and g:IsExists(c512000083.cfilter,5,nil) 
		and not Duel.IsExistingMatchingCard(c512000083.fmfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c512000083.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
