--Returnee From The Darknes
function c21619830.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21619830,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21619830)
	e1:SetTarget(c21619830.target)
	e1:SetOperation(c21619830.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21619830,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,21619830)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c21619830.spcost)
	e2:SetTarget(c21619830.sptg)
	e2:SetOperation(c21619830.spop)
	c:RegisterEffect(e2)
end
function c21619830.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ)
end
function c21619830.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21619830.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21619830.mfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21619830.mfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c21619830.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c21619830.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21619830.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mat=Duel.GetMatchingGroup(c21619830.filter,tp,LOCATION_GRAVE,0,nil,e,tp)	
	if tc:IsRelateToEffect(e) and mat:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mat1=mat:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummon(mat1,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(mat1,mg)
			end
			Duel.Overlay(mat1,tc)
		end
	end
end
function c21619830.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c21619830.spfilter(c,e,tp)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21619830.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c21619830.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21619830.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local ft=3
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	ft=math.min(ft,Duel.GetLocationCount(tp,LOCATION_MZONE))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21619830.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c21619830.thfilter(c)
	return c:IsCode(94220427) and c:IsAbleToHand()
end
function c21619830.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(c21619830.thfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21619830,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				sg=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleDeck(tp)
		end
	end
end
