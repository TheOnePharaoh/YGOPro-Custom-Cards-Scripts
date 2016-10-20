--Marching Through the Darkness
function c77628922.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77628922.target)
	e1:SetOperation(c77628922.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628922,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,77628922)
	e2:SetTarget(c77628922.target2)
	e2:SetOperation(c77628922.operation2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628922,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,77628922)
	e3:SetCondition(c77628922.spcon)
	e3:SetCost(c77628922.spcost)
	e3:SetTarget(c77628922.sptg)
	e3:SetOperation(c77628922.spop)
	c:RegisterEffect(e3)
end
function c77628922.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsAbleToGrave()
end
function c77628922.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628922.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77628922.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77628922.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c77628922.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsDiscardable()
end
function c77628922.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c77628922.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c77628922.rfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(77628922)==0
		and Duel.IsExistingMatchingCard(c77628922.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c77628922.rfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77628922.rfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(77628922,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77628922.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c77628922.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c77628922.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628922.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628922.grafilter,tp,LOCATION_GRAVE,0,5,nil)
end
function c77628922.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77628922.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628922.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77628922.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c77628922.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77628922.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
