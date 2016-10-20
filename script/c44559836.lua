--Shi Tien Yen Wang, Descendant of the Nirvana
function c44559836.initial_effect(c)
	c:SetUniqueOnField(1,0,44559836)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44559836,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c44559836.spcon)
	e1:SetTarget(c44559836.sptg)
	e1:SetOperation(c44559836.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44559836,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c44559836.descon)
	e2:SetTarget(c44559836.destg)
	e2:SetOperation(c44559836.desop)
	c:RegisterEffect(e2)
end
function c44559836.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c44559836.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44559836.cfilter,1,nil,1-tp)
end
function c44559836.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c44559836.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),200,tp,tp,false,false,POS_FACEUP)
	end
end
function c44559836.descon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c44559836.desfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsDestructable()
end
function c44559836.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c44559836.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c44559836.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c44559836.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
