--The Nekroz Armor of Recipro Dragonfly
function c88800027.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--negate & destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88800027,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,88800027)
	e2:SetCondition(c88800027.negcon)
	e2:SetCost(c88800027.negcost)
	e2:SetTarget(c88800027.negtg)
	e2:SetOperation(c88800027.negop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88800027,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c88800027.target)
	e5:SetOperation(c88800027.operation)
	c:RegisterEffect(e5)
end
function c88800027.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c88800027.cofilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToRemoveAsCost()
end
function c88800027.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetFlagEffect(tp,88800027)==0 
		and Duel.IsExistingMatchingCard(c88800027.cofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88800027.cofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,88800027,RESET_PHASE+PHASE_END,0,1)
end
function c88800027.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c88800027.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c88800027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL)
end
function c88800027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c88800027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88800027.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c88800027.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c88800027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local sumable=false
	local sumtype=tc:GetSummonType()
	local btg=mg:IsExists(c88800027.btgfilter,1,nil,tp)
	local gts=mg:IsExists(c88800027.gtsfilter,1,nil,e,tp)
	local gtd=mg:IsExists(c88800027.egtdfilter,1,nil,tp)
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and sumtype==SUMMON_TYPE_RITUAL and mg:GetCount()~=0
		and (btg or gts or gtd) then
		sumable=true
	end
	if sumable and Duel.SelectYesNo(tp,aux.Stringid(88800027,2)) then
		Duel.BreakEffect()
		local op=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88800027,3))
		if btg and gts and gtd then
			op=Duel.SelectOption(tp,aux.Stringid(88800027,4),aux.Stringid(88800027,5),aux.Stringid(88800027,6))
		elseif btg and gts then
			op=Duel.SelectOption(tp,aux.Stringid(88800027,4),aux.Stringid(88800027,5))
		elseif btg and gtd then
			op=Duel.SelectOption(tp,aux.Stringid(88800027,4),aux.Stringid(88800027,6))
			if op==1 then op=2 end
		elseif gts and gtd then
			op=Duel.SelectOption(tp,aux.Stringid(88800027,5),aux.Stringid(88800027,6))
			op=op+1
		elseif btg then
			Duel.SelectOption(tp,aux.Stringid(88800027,4))
			op=0
		elseif gts then
			Duel.SelectOption(tp,aux.Stringid(88800027,5))
			op=1
		else
			Duel.SelectOption(tp,aux.Stringid(88800027,6))
			op=2
		end
		if op==0 then
			mg=mg:Filter(c88800027.btgfilter,nil,tp)
			Duel.SendtoGrave(mg,REASON_EFFECT+REASON_RETURN)
		elseif op==1 then
			mg=mg:Filter(c88800027.gtsfilter,nil,e,tp)
			Duel.SpecialSummon(mg,0,tp,tp,true,false,POS_FACEUP)
		else
			mg=mg:Filter(c88800027.egtdfilter,nil,tp)
			Duel.SendtoDeck(mg,nil,2,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(c88800027.cfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(88800027,7)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c88800027.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c88800027.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function c88800027.btgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()
		and (bit.band(c:GetReason(),0x100008)==0x100008 or bit.band(c:GetReason(),0x100048)==0x100048)
end
function c88800027.gtsfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and (bit.band(c:GetReason(),0x100008)==0x100008 or bit.band(c:GetReason(),0x100048)==0x100048) 
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c88800027.egtdfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck() and (c:GetSummonLocation()==LOCATION_EXTRA or c:IsPreviousLocation(LOCATION_EXTRA)) 
		and (bit.band(c:GetReason(),0x100008)==0x100008 or bit.band(c:GetReason(),0x100048)==0x100048) 
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
