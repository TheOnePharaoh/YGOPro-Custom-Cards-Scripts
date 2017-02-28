--Mir'ak, Keeper of the God's Relics
function c55438830.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--synthetic synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c55438830.syncon)
	e2:SetOperation(c55438830.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO+260)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55438830,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c55438830.thcon)
	e3:SetTarget(c55438830.thtg)
	e3:SetOperation(c55438830.thop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c55438830.efilter)
	c:RegisterEffect(e4)
	--special summon1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438830,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,55438830)
	e5:SetTarget(c55438830.target1)
	e5:SetOperation(c55438830.operation1)
	c:RegisterEffect(e5)
	--special summon2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438830,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,55438830)
	e6:SetCondition(c55438830.condition)
	e6:SetTarget(c55438830.target2)
	e6:SetOperation(c55438830.operation2)
	c:RegisterEffect(e6)
	--synthetic synchro
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_ADD_TYPE)
	e7:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e7:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e7)
	--add setcode
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_ADD_SETCODE)
	e8:SetValue(0xd72)
	c:RegisterEffect(e8)
end
function c55438830.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c55438830.customfilter(c)
	return c:IsSetCard(0xd71) or c:IsType(TYPE_NORMAL)
end
function c55438830.synfilter1(c,syncard,lv,g)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if not c:IsRace(RACE_FAIRY) or not c55438830.customfilter(c) then return false end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c55438830.synfilter2,1,nil,syncard,lv-tlv,wg)
end
function c55438830.synfilter2(c,syncard,lv,g)
	if not c:IsSetCard(0xd70) or not c:IsType(TYPE_TUNER) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	return g:IsExists(c55438830.synfilter3,1,c,syncard,lv-tlv)
end
function c55438830.synfilter3(c,syncard,lv)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return c:IsNotTuner() and (lv1==lv or lv2==lv)
end
function c55438830.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c55438830.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	if tuner then return c55438830.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c55438830.synfilter1,1,nil,c,lv,mg)
end
function c55438830.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c55438830.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c55438830.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	lv=lv-m1:GetSynchroLevel(c)
	mg:RemoveCard(m1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c55438830.synfilter2,1,1,nil,c,lv,mg)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetSynchroLevel(c)
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c55438830.synfilter3,1,1,nil,c,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
end
function c55438830.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c55438830.tdfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xd70) and c:IsAbleToDeck()
end
function c55438830.thfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c55438830.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438830.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55438830.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55438830.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c55438830.tdfilter3,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77777872,1)) then
      Duel.ConfirmCards(1-tp,g)
      local g2=Duel.SelectMatchingCard(tp,c55438830.tdfilter3,tp,LOCATION_REMOVED,0,1,5,nil)
      Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
		end
	end
end
function c55438830.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c55438830.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438830.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(10) and not c:IsCode(55438830) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438830.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438830.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438830.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438830.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438830.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438830.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438830.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438830.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end