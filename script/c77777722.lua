--Flight of the Witchcrafters
function c77777722.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c77777722.target)
	e1:SetOperation(c77777722.activate)
	c:RegisterEffect(e1)
end
function c77777722.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x407) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c77777722.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c77777722.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777722.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c77777722.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetChainLimit(aux.FALSE)
end


function c77777722.mfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c77777722.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	Duel.SendtoGrave(mg,REASON_EFFECT)
	local g=tc:GetMaterial():Filter(c77777722.mfilter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and g:GetCount()>0 then
		if g:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,ft,ft,nil)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		if  Duel.IsExistingMatchingCard(c77777722.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)and Duel.SelectYesNo(tp,aux.Stringid(77777722,1)) then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			local g=Duel.GetMatchingGroup(c77777722.xyzfilter,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		end
	end
end

function c77777722.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end