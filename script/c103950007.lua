--Overlay-Magic Startune Force
function c103950007.initial_effect(c)
	
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103950007.target)
	e1:SetOperation(c103950007.operation)
	c:RegisterEffect(e1)
	
end

--Gets the number of XYZ Materials on the card
function c103950007.numMaterials(c)
	if not _G then return 0 end
	local mt=_G["c" .. c:GetOriginalCode()]
	if mt and mt.xyz_count then return mt.xyz_count else return 0 end
end

--Returns true if the card meets the non-synchro condition
function c103950007.nonSynchroCondition(c)
	return not c:IsType(TYPE_SYNCHRO) and c:GetLevel() > 0
end

--Filter for non-synchro targets
function c103950007.nonSynchroTargetFilter(c,e,tp)
	if not c103950007.nonSynchroCondition(c) or not c:IsFaceup() then return false end
	local count = Duel.GetMatchingGroup(c103950007.synchroTargetFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c,e,tp,c:GetLevel()):GetCount()
	return count > 0 and Duel.IsExistingMatchingCard(c103950007.xyzFilter,tp,LOCATION_EXTRA,0,1,c,e,tp,c:GetLevel(),count+1)
end

--Filter for synchro targets of a certain level or higher
function c103950007.synchroTargetFilter(c,e,tp,lvl)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:GetLevel() >= lvl
end

--Filter for XYZ monsters of a certain rank, that require a certain number of XYZ materials or lower
function c103950007.xyzFilter(c,e,tp,rank,count)
	if c:IsType(TYPE_XYZ) and c:GetRank() == rank and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then
		local mats = c103950007.numMaterials(c)
		if mats > 0 and mats <= count then return true end
	end	
	return false
end

--Special Summon target
function c103950007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and (chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_GRAVE)) end
	if chk==0 then return Duel.IsExistingMatchingCard(c103950007.nonSynchroTargetFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c103950007.nonSynchroTargetFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc = g1:GetFirst()
	
	local count = Duel.GetMatchingGroup(c103950007.synchroTargetFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tc,e,tp,tc:GetLevel()):GetCount()
	local g2 = Duel.GetMatchingGroup(c103950007.xyzFilter,tp,LOCATION_EXTRA,0,tc,e,tp,tc:GetLevel(),count+1)
	local minimum = count
	local num = 0
	local xyz = g2:GetFirst()
	while xyz do
		num = c103950007.numMaterials(xyz)
		if num > 0 and num-1 < minimum then minimum = num-1 end
		xyz = g2:GetNext()
	end
	if minimum <= 0 then minimum = 1 end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c103950007.synchroTargetFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,minimum,count,tc,e,tp,tc:GetLevel())
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

--Special Summon operation
function c103950007.operation(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	count = g:GetCount()
	if count < 2 then return end
	
	local tc = g:Filter(c103950007.nonSynchroCondition,nil):GetFirst()
	if not tc then return end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount() <= 0 then return end
	
	local sg=Duel.SelectMatchingCard(tp,c103950007.xyzFilter,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc:GetLevel(),count)
	local sc = sg:GetFirst()
	if not sc then return end
	
	Duel.Overlay(sc,g)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end