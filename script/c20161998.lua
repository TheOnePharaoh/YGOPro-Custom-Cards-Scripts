--Zealot Lizardfolk - Legioneer
function c20161998.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),4,2)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c20161998.valcon)
	e1:SetTarget(c20161998.valtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c20161998.tgvalue)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c20161998.descost)
	e3:SetTarget(c20161998.destg)
	e3:SetOperation(c20161998.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20161998,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,20161998)
	e4:SetTarget(c20161998.sptg)
	e4:SetOperation(c20161998.spop)
	c:RegisterEffect(e4)
end
function c20161998.valcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c20161998.valtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end
function c20161998.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c20161998.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20161998.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92)
end
function c20161998.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20161998.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		and e:GetHandler():GetFlagEffect(20161998)==0 end
	e:GetHandler():RegisterFlagEffect(20161998,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c20161998.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	if ct==0 then return end
	if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c20161998.desfilter,tp,LOCATION_MZONE,0,1,ct,e:GetHandler())
	local ct2=Duel.Destroy(dg,REASON_EFFECT)
	if ct2>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=g:Select(tp,ct2,ct2,nil)
		Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
	end
end
function c20161998.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsSetCard(0xab90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161998.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20161998.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20161998.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20161998.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and not g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

