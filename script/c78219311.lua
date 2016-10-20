--Colossal Warrior - Sniper
function c78219311.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c78219311.repcon)
	e1:SetOperation(c78219311.repop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219311,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c78219311.spectg)
	e2:SetOperation(c78219311.specop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219311,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c78219311.spcon)
	e3:SetTarget(c78219311.sptg)
	e3:SetOperation(c78219311.spop)
	c:RegisterEffect(e3)
end
function c78219311.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219311.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219311,e,0,tp,0,0)
end
function c78219311.specfilter(c,e,tp)
	return c:IsSetCard(0x7ad30) and not c:IsCode(78219311) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78219311.spectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c78219311.specfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c78219311.specfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c78219311.specfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c78219311.specop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c78219311.splimtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c78219311.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c78219311.splimtg(e,c)
	return not c:IsSetCard(0x7ad30)
end
function c78219311.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype~=SUMMON_TYPE_XYZ
end
function c78219311.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x7ad30)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
end
function c78219311.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c78219311.cfilter,nil,tp)
	e:SetLabel(ct)
	return ct>0
end
function c78219311.spfilter(c,e,tp)
	return c:IsSetCard(0x7ad30) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78219311.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78219311.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c78219311.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>e:GetLabel() then ft=e:GetLabel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c78219311.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetValue(c78219311.xyzlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c78219311.xyzlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
