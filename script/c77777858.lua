--Mystic Fauna Guidance
function c77777858.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c77777858.target)
	e1:SetOperation(c77777858.activate)
	c:RegisterEffect(e1)
end
function c77777858.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x40a) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c77777858.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c77777858.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777858.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c77777858.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetChainLimit(aux.FALSE)
end


function c77777858.mfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c77777858.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	Duel.SendtoGrave(mg,REASON_EFFECT)
		local tc2=mg:GetFirst()
		while tc2 do
			Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
			tc2=mg:GetNext()
		end
		Duel.SpecialSummonComplete()
    if Duel.SelectYesNo(tp,aux.Stringid(77777858,1)) then
    local te=Effect.CreateEffect(tc)
		te:SetType(EFFECT_TYPE_SINGLE)
		te:SetCode(77777858)
		tc:RegisterEffect(te)
		local tg=tc.target
		local op=tc.operation
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		tc:CreateEffectRelation(te)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
function c77777858.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end