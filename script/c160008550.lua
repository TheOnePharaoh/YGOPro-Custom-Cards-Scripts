--Number C26: Mail Skull Psychic King
function c160008550.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c160008550.con)
	e2:SetCost(c160008550.cost)
	e2:SetTarget(c160008550.target)
	e2:SetOperation(c160008550.operation)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160008550,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c160008550.atkcon)
	e3:SetOperation(c160008550.atkop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(160008550,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c160008550.spcon)
	e4:SetCost(c160008550.spcost)
	e4:SetTarget(c160008550.sptg)
	e4:SetOperation(c160008550.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c160008550.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c160008550.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c160008550.spfilter(c,e,tp)
	return c:IsSetCard(0xc81) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c160008550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160008550.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c160008550.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160008550.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
function c160008550.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,160004002)
end
function c160008550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c160008550.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c160008550.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160008550.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160008550.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c160008550.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c160008550.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)  and not tc:IsDisabled() and tc:IsControler(1-tp) then
		c:SetCardTarget(tc)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end
function c160008550.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetCardTarget():GetCount()>0
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,160004002)
end
function c160008550.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetCardTarget()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-400)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c160008550.rcon)
		tc:RegisterEffect(e1,true)
		tc=g:GetNext()
	end
end
function c160008550.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end