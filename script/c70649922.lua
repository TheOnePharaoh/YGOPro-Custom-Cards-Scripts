--ADE Salamander
function c70649922.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649922,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c70649922.spcon)
	e1:SetTarget(c70649922.sptg)
	e1:SetOperation(c70649922.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c70649922.descon)
	e2:SetTarget(c70649922.destg)
	e2:SetOperation(c70649922.desop)
	c:RegisterEffect(e2)
end
function c70649922.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c70649922.filter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649922.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70649922.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c70649922.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70649922.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c70649922.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649922.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c70649922.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
