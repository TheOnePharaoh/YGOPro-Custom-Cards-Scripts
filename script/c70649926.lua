--ADE Wyvernburg
function c70649926.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649926,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c70649926.spcon)
	e1:SetTarget(c70649926.sptg)
	e1:SetOperation(c70649926.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649926,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c70649926.destg)
	e2:SetOperation(c70649926.desop)
	c:RegisterEffect(e2)
	--self destuct
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649926,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c70649926.destg2)
	e3:SetOperation(c70649926.desop2)
	c:RegisterEffect(e3)
end
function c70649926.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c70649926.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649926.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70649926.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE)
end
function c70649926.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70649926.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c70649926.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and not tc:IsRace(RACE_DRAGON) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c70649926.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c70649926.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		if a==c then a=Duel.GetAttackTarget() end
		return a and a:IsRace(RACE_DRAGON)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c70649926.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToBattle() then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
