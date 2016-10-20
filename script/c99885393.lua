--Rank-Up-Magic Time Magic Force
function c99885393.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99885393,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99885393.target)
	e1:SetOperation(c99885393.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99885393,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99885393)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c99885393.thcost)
	e2:SetTarget(c99885393.thtg)
	e2:SetOperation(c99885393.thop)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x95)
	c:RegisterEffect(e3)
end
function c99885393.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c99885393.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c99885393.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsSetCard(0x0dac404) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99885393.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99885393.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c99885393.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99885393.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99885393.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99885393.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)then
			local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
			if tc:GetCount()>0 then
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c99885393.thfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(99885393) and c:IsAbleToRemoveAsCost()
end
function c99885393.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99885393.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99885393.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99885393.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99885393.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
