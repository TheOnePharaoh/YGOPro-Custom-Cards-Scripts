--Dark Android Gearman
function c99200154.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99200154.efilter)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99200154,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c99200154.spcon)
	e2:SetTarget(c99200154.sptg)
	e2:SetOperation(c99200154.spop)
	c:RegisterEffect(e2)
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c99200154.attg)
	e3:SetOperation(c99200154.atop)
	c:RegisterEffect(e3)
end
function c99200154.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200154.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99200154.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99200154.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99200154.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3790)
end
function c99200154.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99200154.atfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99200154.atfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99200154.atfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99200154.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
