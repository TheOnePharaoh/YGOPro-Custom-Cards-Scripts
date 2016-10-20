--Zhong Kui, Death God of the Sky Nirvanay Nirvana
function c44559837.initial_effect(c)
	c:SetUniqueOnField(1,0,44559837)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559837.tgvalue)
	c:RegisterEffect(e3)
	--Set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559837,3))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c44559837.setcon)
	e4:SetTarget(c44559837.settg)
	e4:SetOperation(c44559837.setop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c44559837.sptg)
	e5:SetOperation(c44559837.spop)
	c:RegisterEffect(e5)
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
