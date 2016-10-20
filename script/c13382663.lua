--Voca-Buster
function c13382663.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c13382663.target)
	e1:SetOperation(c13382663.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13382663,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c13382663.negcon)
	e2:SetCost(c13382663.negcost)
	e2:SetTarget(c13382663.negtg)
	e2:SetOperation(c13382663.negop)
	c:RegisterEffect(e2)
end
function c13382663.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function c13382663.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13382663.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13382663.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13382663.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c13382663.mgfilter(c,e,tp,sync)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x80008)~=0x80008 or c:GetReasonCard()~=sync
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c13382663.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local sumable=true
	local sumtype=tc:GetSummonType()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)==0 or sumtype~=SUMMON_TYPE_SYNCHRO or mg:GetCount()==0 
		or mg:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)
		or mg:IsExists(c13382663.mgfilter,1,nil,e,tp,tc) then
		sumable=false
	end
	if sumable and Duel.SelectYesNo(tp,aux.Stringid(13382663,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c13382663.negfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c13382663.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c13382663.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c13382663.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13382663.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13382663.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
