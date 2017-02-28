--Zhong Kui, Death God of the Sky Nirvanay Nirvana
function c44559837.initial_effect(c)
	c:SetUniqueOnField(1,0,44559837)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c44559837.fuscon)
	e1:SetOperation(c44559837.fusop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c44559837.tgvalue)
	c:RegisterEffect(e4)
	--Set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559837,3))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EFFECT_DISABLE_FIELD)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1)
	e5:SetCondition(c44559837.setcon)
	e5:SetTarget(c44559837.settg)
	e5:SetOperation(c44559837.setop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c44559837.sptg)
	e6:SetOperation(c44559837.spop)
	c:RegisterEffect(e6)
end
function c44559837.ffilter1(c)
	return (c:IsFusionSetCard(0x2016) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c44559837.ffilter2(c)
	if c:IsHasEffect(6205579) then return false end
	return c:IsHasEffect(511002961) or c:IsRace(RACE_FIEND) or c:IsHasEffect(44559838)
end
function c44559837.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c44559837.check1(c,mg,sg,chkf,tp)
	local g=mg:Clone()
	if sg:IsContains(c) then g:Sub(sg) end
	return g:IsExists(c44559837.check2,1,c,c,chkf,tp)
end
function c44559837.check2(c,c2,chkf,tp)
	local g=Group.FromCards(c,c2)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,tp) then return false end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if c44559837.ffilter1(tc) or tc:IsHasEffect(511002961) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if c44559837.ffilter2(tc) or tc:IsHasEffect(511002961) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2c,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2c,1,nil,g2) end
end
function c44559837.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(44559840) and fc:IsCanRemoveCounter(tp,0x1117,3,REASON_EFFECT) then
		sg=Duel.GetMatchingGroup(c44559837.exfilter,tp,0,LOCATION_MZONE,nil,g)
		mg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c44559837.check1(gc,mg,sg,chkf)
	end
	return mg:IsExists(c44559837.check1,1,nil,mg,sg,chkf)
end
function c44559837.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local c=e:GetHandler()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	if fc and fc:IsHasEffect(44559840) and fc:IsCanRemoveCounter(tp,0x1117,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c44559837.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,c44559837.check2,1,1,gc,gc,chkf)
		local tc1=g1:GetFirst()
		if c44559837.exfilter(tc1,eg) then
			fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT)
		end
		if sfhchk then Duel.ShuffleHand(tp) end
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(p,c44559837.check1,1,1,nil,mg,exg,chkf)
	local tc1=g1:GetFirst()
	if c44559837.exfilter(tc1,eg) then
		fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT)
		mg:Sub(exg)
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(p,c44559837.check2,1,1,tc1,tc1,chkf)
	if c44559837.exfilter(g2:GetFirst(),eg) then fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT) end
	g1:Merge(g2)
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end
function c44559837.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559837.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559837.setfil(c,st)
  return c:IsType(st) and c:IsSetCard(0x2016) and not c:IsType(TYPE_MONSTER) and c:IsSSetable()
end
function c44559837.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c44559837.setfil,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
end
function c44559837.setop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
  local ops={}
  local opval={}
  ops[1]=aux.Stringid(44559837,1)
  ops[2]=aux.Stringid(44559837,2)
  opval[0]=TYPE_SPELL
  opval[1]=TYPE_TRAP
  Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(44559837,0))
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	local mg=Duel.GetMatchingGroup(c44559837.setfil,tp,LOCATION_DECK,0,nil,opval[op])
	if mg:GetCount()>0 then
	  local sc=mg:Select(tp,1,1,nil)
	  Duel.SSet(tp,sc:GetFirst())
		Duel.ConfirmCards(1-tp,sc)
	end
end
function c44559837.spefilter(c,e,tp)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c44559837.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44559837.spefilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c44559837.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44559837.spefilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
