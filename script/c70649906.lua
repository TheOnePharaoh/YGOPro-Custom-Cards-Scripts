--ADE Palageni
function c70649906.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649906,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c70649906.sumtg)
	e1:SetOperation(c70649906.sumop)
	c:RegisterEffect(e1)
	--self destruct
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649906,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c70649906.descon)
	e2:SetTarget(c70649906.destg)
	e2:SetOperation(c70649906.desop)
	c:RegisterEffect(e2)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70649906,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c70649906.sgcon)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c70649906.sgtg)
	e4:SetOperation(c70649906.sgop)
	c:RegisterEffect(e4)
end
function c70649906.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649906.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70649906.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c70649906.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c70649906.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c70649906.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c70649906.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
		and e:GetHandler():GetTurnID()==Duel.GetTurnCount()
end
function c70649906.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c70649906.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c70649906.filter2(c)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(70649906) and c:IsAbleToGrave()
end
function c70649906.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649906.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c70649906.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c70649906.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c70649906.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end