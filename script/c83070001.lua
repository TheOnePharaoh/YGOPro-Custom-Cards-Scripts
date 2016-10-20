--Hydrush Leviathan
function c83070001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),7,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83070001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,83070001)
	e1:SetCost(c83070001.spcost)
	e1:SetCondition(c83070001.spcon)
	e1:SetTarget(c83070001.sptg)
	e1:SetOperation(c83070001.spop)
	c:RegisterEffect(e1)
	--unaffected
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070001,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c83070001.cost)
	e2:SetTarget(c83070001.target)
	e2:SetOperation(c83070001.operation)
	c:RegisterEffect(e2)
end
function c83070001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c83070001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c83070001.filter(c,e,tp)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c83070001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83070001.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c83070001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c83070001.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,8307,tp,tp,false,false,POS_FACEUP)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg and cg:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cg)
		end
	end
end
function c83070001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c83070001.unfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x837)
end
function c83070001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:GetControler()==tp and c83070001.unfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83070001.unfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c83070001.unfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c83070001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c83070001.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c83070001.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
