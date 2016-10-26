--Brainwasher of the Arch Beetle
function c78330027.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c78330027.syntg)
	e1:SetValue(1)
	e1:SetOperation(c78330027.synop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330027,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c78330027.spcon)
	e2:SetTarget(c78330027.sptg)
	e2:SetOperation(c78330027.spop)
	c:RegisterEffect(e2)
	--special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78330027,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c78330027.spcon2)
	e3:SetTarget(c78330027.sptg2)
	e3:SetOperation(c78330027.spop2)
	c:RegisterEffect(e3)
end
function c78330027.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c78330027.synfilter2(c,syncard,tuner,f)
	return c:IsRace(RACE_INSECT) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c78330027.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c78330027.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_INSECT) then
		local exg=Duel.GetMatchingGroup(c78330027.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
function c78330027.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c78330027.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_INSECT) then
		local exg=Duel.GetMatchingGroup(c78330027.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c78330027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():IsLocation(LOCATION_REMOVED) and r==REASON_SYNCHRO
end
function c78330027.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78330027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78330027.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c78330027.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2):Filter(c78330027.spfilter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>0 then
		if ft<=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif ft>=g:GetCount() then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,ft,ft,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c78330027.dfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c78330027.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78330027.dfilter,1,nil,tp)
end
function c78330027.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78330027.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end