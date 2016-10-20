--Forgotten - Song of the Lost Memory and Universe
function c66652249.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c66652249.actcost)
	e1:SetTarget(c66652249.acttg)
	e1:SetOperation(c66652249.actop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c66652249.sdcon)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_DARK)
	e3:SetCondition(c66652249.attcon)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66652249,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,66652249)
	e4:SetCost(c66652249.spcost)
	e4:SetTarget(c66652249.sptg)
	e4:SetOperation(c66652249.spop)
	c:RegisterEffect(e4)
end
function c66652249.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66652249)==0 end
	Duel.RegisterFlagEffect(tp,66652249,0,0,0)
end
function c66652249.desfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)~=0 and c:IsDestructable()
end
function c66652249.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c66652249.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c66652249.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66652249.desfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c66652249.sdfilter(c)
	return not c:IsFaceup() or not c:IsRace(RACE_MACHINE)
end
function c66652249.sdcon(e)
	return Duel.IsExistingMatchingCard(c66652249.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c66652249.attfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c66652249.attcon(e)
	return Duel.IsExistingMatchingCard(c66652249.attfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,e:GetHandler())
end
function c66652249.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c66652249.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c66652249.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66652249.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c66652249.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c66652249.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function c66652249.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66652249.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66652249.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
