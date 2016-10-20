--D.S. Lobster
function c29001782.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c29001782.sumop)
	c:RegisterEffect(e1)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29001782,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,29001782)
	e3:SetCondition(c29001782.sgcon)
	e3:SetTarget(c29001782.sgtg)
	e3:SetOperation(c29001782.sgop)
	c:RegisterEffect(e3)
end
function c29001782.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,29001782)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,29001782,RESET_PHASE+PHASE_END,0,1)
end
function c29001782.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c29001782.enfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
function c29001782.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29001782.enfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c29001782.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29001782.enfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end