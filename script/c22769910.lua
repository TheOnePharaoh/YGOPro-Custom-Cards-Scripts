--Dreadnought Mark - 010 Dragon
function c22769910.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c22769910.hspcon)
	e1:SetOperation(c22769910.hspop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769910,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c22769910.sptg)
	e2:SetOperation(c22769910.spop)
	c:RegisterEffect(e2)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetTarget(c22769910.syntg)
	e3:SetValue(1)
	e3:SetOperation(c22769910.synop)
	c:RegisterEffect(e3)
	--cannot be effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c22769910.hspfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsCode(22769910)
end
function c22769910.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c22769910.hspfilter,1,nil)
end
function c22769910.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c22769910.hspfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22769910.spfilter(c,e,tp)
	return c:GetLevel()==10 and c:IsSetCard(0xaa12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769910.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c22769910.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22769910.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22769910.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22769910.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c22769910.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c22769910.dreadnoughtsynlevel(c)
	return 4
end
function c22769910.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c22769910.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv4=syncard:GetLevel()-c22769910.dreadnoughtsynlevel(c)
	if lv<=0 and lv4<=0 then return false end
	local g=Duel.GetMatchingGroup(c22769910.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c22769910.dreadnoughtsynlevel,lv4,minc,maxc)
	return res or res2
end
function c22769910.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv4=syncard:GetLevel()-c22769910.dreadnoughtsynlevel(c)
	local g=Duel.GetMatchingGroup(c22769910.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c22769910.dreadnoughtsynlevel,lv4,minc,maxc)
	local sg=nil
	if (res2 and res and Duel.SelectYesNo(tp,aux.Stringid(22769910,1)))
		or (res2 and not res) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,c22769910.dreadnoughtsynlevel,lv4,minc,maxc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	end
	Duel.SetSynchroMaterial(sg)
end