--Underworld Circle
function c512000007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c512000007.condition)
	e1:SetTarget(c512000007.target)
	e1:SetOperation(c512000007.activate)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(512000007,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetTarget(c512000007.sptg)
	e2:SetOperation(c512000007.spop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)	
	e3:SetOperation(c512000007.banop)
	c:RegisterEffect(e3)
end
function c512000007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000
end
function c512000007.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c512000007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000007.filter,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,1,nil) 
		or Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(c512000007.filter,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
end
function c512000007.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c512000007.filter,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
	local tg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c512000007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_GRAVE)
end
function c512000007.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER) 
end
function c512000007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(62742651,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c512000007.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummonStep(g1:GetFirst(),0,tp,tp,true,false,POS_FACEUP)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000007.spfilter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
		and Duel.SelectYesNo(1-tp,aux.Stringid(62742651,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(1-tp,c512000007.spfilter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
		Duel.SpecialSummonStep(g2:GetFirst(),0,1-tp,1-tp,true,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c512000007.banfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(512000007)==0
end
function c512000007.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local wg=Duel.GetMatchingGroup(c512000007.banfilter,c:GetControler(),0xff,0xff,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c512000007.recon)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
		wbc:RegisterEffect(e1)
		wbc:RegisterFlagEffect(512000007,EVENT_ADJUST,0,1) 	
		wbc=wg:GetNext()
	end		
end
function c512000007.recon(e)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
