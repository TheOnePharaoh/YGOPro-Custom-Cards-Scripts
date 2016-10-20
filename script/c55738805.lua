--Malefic Psycho Dragon
function c55738805.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,55738804),aux.FilterBoolFunction(Card.IsSetCard,0x23),true)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,55738805)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c55738805.descon)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c55738805.atkop)
	c:RegisterEffect(e2)
	--banish&search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55738805,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c55738805.thtg)
	e3:SetOperation(c55738805.thop)
	c:RegisterEffect(e3)
end
function c55738805.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c55738805.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c55738805.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c55738805.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c55738805.tgfilter(c,tp)
	return c:IsSetCard(0x23) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c55738805.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c55738805.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c55738805.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55738805.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55738805.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55738805.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c55738805.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
