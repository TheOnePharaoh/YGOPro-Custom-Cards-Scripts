--Rank-up-Magic: Brunette's Change
function c160002144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c160002144.target)
	e1:SetOperation(c160002144.activate)
	c:RegisterEffect(e1)
end
function c160002144.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and (c:IsSetCard(0x89b) or c:IsSetCard(0x48))
		and Duel.IsExistingMatchingCard(c160002144.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk,c:GetCode())
end
function c160002144.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160002144.filter2(c,e,tp,mc,rk,code)
	if c.rum_limit_code and code~=c.rum_limit_code then return false end
	return (c:GetRank()==rk+1 or c:GetRank()==rk+2) and c:IsSetCard(0x89b) and mc:IsCanBeXyzMaterial(c,true)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c160002144.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c160002144.filter1(chkc,e,tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c160002144.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c160002144.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c160002144.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160002144.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local sog=Duel.GetMatchingGroup(c160002144.filter,tp,0,LOCATION_ONFIELD,nil)
	if sog:GetCount()>0 then
		local sg=sog:Select(tp,1,2,nil)
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.Overlay(sc,sg)
	end
end
