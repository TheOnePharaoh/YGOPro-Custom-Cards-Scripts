--The Idol Rising
function c59821016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821016,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c59821016.target1)
	e1:SetOperation(c59821016.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821016,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,59821016+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c59821016.target2)
	e2:SetOperation(c59821016.activate2)
	c:RegisterEffect(e2)
end
function c59821016.filter1(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_SYNCHRO) and c:IsAbleToHand()
end
function c59821016.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821016.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c59821016.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821016.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c59821016.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821016.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821016.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c59821016.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c59821016.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
