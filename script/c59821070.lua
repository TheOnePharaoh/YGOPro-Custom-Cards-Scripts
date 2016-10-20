--RDM－Constellation Stall
function c59821070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c59821070.target)
	e1:SetOperation(c59821070.activate)
	c:RegisterEffect(e1)
	--Attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821070,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821070)
	e2:SetCost(c59821070.atcost)
	e2:SetTarget(c59821070.attg)
	e2:SetOperation(c59821070.atop)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x95)
	c:RegisterEffect(e3)
end
function c59821070.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c59821070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk-1,c:GetAttribute(),c:GetCode())
end
function c59821070.filter2(c,e,tp,mc,rk,att,code)
	return c:GetRank()==rk and c:IsAttribute(att) and (c:IsSetCard(0xa1a2)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c59821070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821070.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c59821070.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c59821070.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821070.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821070.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()-1,tc:GetAttribute(),tc:GetCode())
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
		if Duel.GetOverlayCount(tp,0,1)~=0 then
			Duel.BreakEffect()
			local g1=Duel.GetOverlayGroup(tp,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59821070,0))
			local mg2=g1:Select(tp,1,1,nil)
			local oc=mg2:GetFirst():GetOverlayTarget()
			Duel.Overlay(sc,mg2)
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
	end
end
function c59821070.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821070.attfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c59821070.attfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ)
end
function c59821070.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c59821070.attfilter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c59821070.attfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c59821070.attfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59821070.attfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59821070.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsFacedown() or not tc1:IsRelateToEffect(e) then return end
	local og=tc1:GetOverlayGroup()
	if og:GetCount()==0 then return end
	if Duel.SendtoGrave(og,REASON_EFFECT)~=0 and tc2:IsFaceup() and tc2:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc2,Group.FromCards(c))
	end
end
