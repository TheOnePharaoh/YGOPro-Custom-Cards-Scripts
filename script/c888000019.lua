--Volcano Guardian
function c888000019.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c888000019.syncon)
	e1:SetOperation(c888000019.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000019,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c888000019.cost)
	e2:SetTarget(c888000019.target)
	e2:SetOperation(c888000019.operation)
	c:RegisterEffect(e2)
	--banish (grave)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000019,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c888000019.bantg)
	e3:SetOperation(c888000019.banop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000019,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_STANDBY_PHASE)
	e4:SetCondition(c888000019.spcon)
	e4:SetTarget(c888000019.sptg)
	e4:SetOperation(c888000019.spop)
	c:RegisterEffect(e4)
end
function c888000019.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c888000019.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c888000019.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(888000019)==0 then	
	return g1:IsExists(c888000019.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c888000019.synfilter3,1,nil,lv-tlv)
	end	
end
function c888000019.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c888000019.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c888000019.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000019.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c888000019.synfilter1,1,nil,lv,g1,g2)
end
function c888000019.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c888000019.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000019.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c888000019.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(888000019)==0 then	
		local t1=g1:FilterSelect(tp,c888000019.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c888000019.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000019,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000019,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000019,4))
end
function c888000019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c888000019.filter(c)
	return c:IsAbleToRemove()
end
function c888000019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c888000019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888000019.filter,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.IsExistingTarget(c888000019.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c888000019.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local g2=Duel.SelectTarget(tp,c888000019.filter,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c888000019.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c888000019.banfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c888000019.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c888000019.banfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function c888000019.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local hg=Duel.SelectMatchingCard(tp,c888000019.banfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if hg:GetCount()>0 then
		hg:AddCard(c)
		Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)	
	end
end
function c888000019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function c888000019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c888000019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
