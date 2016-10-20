--Corrupted Vocaloid Yuzuki Yukari Type - 22
function c76973431.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c76973431.syncon)
	e1:SetOperation(c76973431.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76973431,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c76973431.sptg)
	e2:SetOperation(c76973431.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c76973431.descon)
	e3:SetTarget(c76973431.destg)
	e3:SetOperation(c76973431.desop)
	c:RegisterEffect(e3)
end
function c76973431.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c76973431.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c76973431.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
	return g1:IsExists(c76973431.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c76973431.synfilter3,1,nil,lv-tlv)
	end	
end
function c76973431.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c76973431.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c76973431.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973431.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c76973431.synfilter1,1,nil,lv,g1,g2)
end
function c76973431.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c76973431.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973431.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c76973431.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c76973431.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c76973431.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973431,1))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973431,2))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973431,3))
end
function c76973431.specfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsLevelAbove(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c76973431.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76973431.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c76973431.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76973431.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c76973431.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function c76973431.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c76973431.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
