--Daemon Quasar Dragon
function c999902.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c999902.syncon)
	e1:SetOperation(c999902.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c999902.atkval)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Special Summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(999902,1))
	e7:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c999902.sumcon)
	e7:SetTarget(c999902.sumtg)
	e7:SetOperation(c999902.sumop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e9)
	--cannot special summon
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_SPSUMMON_CONDITION)
	e10:SetValue(aux.synlimit)
	c:RegisterEffect(e10)
end
function c999902.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c999902.matfilter2(c,syncard)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard)
end
function c999902.synfilter1(c,syncard,lv,g1,g2)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c999902.synfilter2,1,nil,syncard,lv-tlv,g1,g2,f1,c)
end
function c999902.synfilter2(c,syncard,lv,g1,g2,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if c==tuner1 then return false end
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if g2:IsExists(c999902.synfilternt,1,nil,syncard,lv-tlv,f1,f2) then return true end
	return g1:IsExists(c999902.synfilter3,1,nil,syncard,lv-tlv,g1,g2,f1,f2,tuner1,c)
end
function c999902.synfilter3(c,syncard,lv,g1,g2,f1,f2,tuner1,tuner2)
	local tlv=c:GetSynchroLevel(syncard)
	if c==tuner1 or c==tuner2 then return false end
	if lv-tlv<=0 then return false end
	local f3=c.tuner_filter
	if (f1 and not f1(c)) or (f2 and not f2(c)) or (f3 and not f3(tuner1)) or (f3 and not f3(tuner2)) then return false end
	if g2:IsExists(c999902.synfilternt,1,nil,syncard,lv-tlv,f1,f2,f3) then return true end
	return g1:IsExists(c999902.synfilter4,1,nil,syncard,lv-tlv,g1,g2,f1,f2,f3,tuner1,tuner2,c)
end
function c999902.synfilter4(c,syncard,lv,g1,g2,f1,f2,f3,tuner1,tuner2,tuner3)
	local tlv=c:GetSynchroLevel(syncard)
	if c==tuner1 or c==tuner2 or c==tuner3 then return false end
	if lv-tlv<=0 then return false end
	local f4=c.tuner_filter
	if (f1 and not f1(c)) or (f2 and not f2(c)) or (f3 and not f3(c)) or (f4 and not f4(tuner1)) or (f4 and not f3(tuner2)) 
		or (f4 and not f4(tuner3)) then return false end
	if g2:IsExists(c999902.synfilternt,1,nil,syncard,lv-tlv,f1,f2,f3,f4) then return true end
	return --g1:IsExists(c999902.synfilter5,1,nil,syncard,lv-tlv,g1,g2,f1,f2,f3,f4,tuner1,tuner2,tuner3,c) - for future usage
	false
end
function c999902.synfilternt(c,syncard,lv,f1,f2,f3,f4,f5,f6,f7,f8,f9)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c)) and (not f3 or f3(c)) and (not f4 or f4(c)) 
		 and (not f5 or f5(c)) and (not f6 or f6(c)) and (not f7 or f7(c)) and (not f8 or f8(c)) and (not f9 or f9(c))
end
function c999902.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c999902.matfilter1,nil,c)
		g2=mg:Filter(c999902.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c999902.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c999902.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c999902.synfilter2,1,nil,c,lv-tlv,g1,g2,f1,tuner)
		else
			return c999902.synfilter2(pe:GetOwner(),c,lv-tlv,g1,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c999902.synfilter1,1,nil,c,lv,g1,g2)
	else
		return c999902.synfilter1(pe:GetOwner(),c,lv,g1,g2)
	end
end
function c999902.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c999902.matfilter1,nil,c)
		g2=mg:Filter(c999902.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c999902.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c999902.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		lv=lv-tuner:GetSynchroLevel(c)
		if not pe then
			local t2=g1:FilterSelect(tp,c999902.synfilter2,1,1,nil,c,lv,g1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		lv=lv-tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local sg=Group.CreateGroup()
		if g2:IsExists(c999902.synfilternt,1,nil,c,lv,f1,f2) then
			sg:Merge(g2:Filter(c999902.synfilternt,nil,c,lv,f1,f2))
		end
		if g1:IsExists(c999902.synfilter3,1,nil,c,lv,g1,g2,f1,f2,tuner1,tuner2) then
			sg:Merge(g1:Filter(c999902.synfilter3,nil,c,lv,g1,g2,f1,f2,tuner1,tuner2))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mat3=sg:Select(tp,1,1,nil)
		g:Merge(mat3)
		if not mat3:GetFirst():IsNotTuner() then
			local tuner3=mat3:GetFirst()
			lv=lv-tuner3:GetSynchroLevel(c)
			local f3=tuner3.tuner_filter
			sg:Clear()
			if g2:IsExists(c999902.synfilternt,1,nil,c,lv,f1,f2,f3) then
				sg:Merge(g2:Filter(c999902.synfilternt,nil,c,lv,f1,f2,f3))
			end
			if g1:IsExists(c999902.synfilter4,1,nil,c,lv,g1,g2,f1,f2,f3,tuner1,tuner2,tuner3) then
				sg:Merge(g1:Filter(c999902.synfilter4,nil,c,lv,g1,g2,f1,f2,f3,tuner1,tuner2,tuner3))
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mat4=sg:Select(tp,1,1,nil)
			g:Merge(mat4)
			local tuner4=mat4:GetFirst()
			if not tuner4:IsNotTuner() then
				lv=lv-tuner4:GetSynchroLevel(c)
				local f4=tuner4.tuner_filter
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local m5=g2:FilterSelect(tp,c999902.synfilternt,1,1,nil,c,lv,f1,f2,f3,f4)
				g:Merge(m5)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c999902.synfilter1,1,1,nil,c,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		lv=lv-tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c999902.synfilter2,1,1,nil,c,lv,g1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		lv=lv-tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local sg=Group.CreateGroup()
		if g2:IsExists(c999902.synfilternt,1,nil,c,lv,f1,f2) then
			sg:Merge(g2:Filter(c999902.synfilternt,nil,c,lv,f1,f2))
		end
		if g1:IsExists(c999902.synfilter3,1,nil,c,lv,g1,g2,f1,f2,tuner1,tuner2) then
			sg:Merge(g1:Filter(c999902.synfilter3,nil,c,lv,g1,g2,f1,f2,tuner1,tuner2))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mat3=sg:Select(tp,1,1,nil)
		g:Merge(mat3)
		if not mat3:GetFirst():IsNotTuner() then
			local tuner3=mat3:GetFirst()
			lv=lv-tuner3:GetSynchroLevel(c)
			local f3=tuner3.tuner_filter
			sg:Clear()
			if g2:IsExists(c999902.synfilternt,1,nil,c,lv,f1,f2,f3) then
				sg:Merge(g2:Filter(c999902.synfilternt,nil,c,lv,f1,f2,f3))
			end
			if g1:IsExists(c999902.synfilter4,1,nil,c,lv,g1,g2,f1,f2,f3,tuner1,tuner2,tuner3) then
				sg:Merge(g1:Filter(c999902.synfilter4,nil,c,lv,g1,g2,f1,f2,f3,tuner1,tuner2,tuner3))
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mat4=sg:Select(tp,1,1,nil)
			g:Merge(mat4)
			local tuner4=mat4:GetFirst()
			if not tuner4:IsNotTuner() then
				lv=lv-tuner4:GetSynchroLevel(c)
				local f4=tuner4.tuner_filter
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local m5=g2:FilterSelect(tp,c999902.synfilternt,1,1,nil,c,lv,f1,f2,f3,f4)
				g:Merge(m5)
			end
		end
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c999902.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*1000
end
function c999902.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999902.filter(c,e,tp)
	return c:IsCode(97489701) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999902.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999902.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c999902.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999902.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
