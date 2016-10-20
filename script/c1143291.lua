--ANTI-MATTER Dark Being, Zoohgtf
function c1143291.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143291.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--remove&damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143291,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c1143291.tdcost)
	e4:SetTarget(c1143291.tdtg)
	e4:SetOperation(c1143291.tdop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1143291,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,1143291)
	e5:SetTarget(c1143291.sptg)
	e5:SetOperation(c1143291.spop)
	c:RegisterEffect(e5)
	if not c1143291.global_check then
		c1143291.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143291))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143291.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143291.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143291.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143291.costfilter(co)
	return co:IsSetCard(0xaf75) and not co:IsCode(1143291) and co:IsAbleToRemoveAsCost()
end
function c1143291.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143291.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1143291.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1143291.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c1143291.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c1143291.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143291.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1143291.tdfilter,tp,0,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c1143291.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c1143291.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143291.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c1143291.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143291.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local ft=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	ft=math.min(ft,Duel.GetLocationCount(tp,LOCATION_MZONE))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1143291.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c1143291.thfilter(c)
	return c:IsSetCard(0xaf75) and not c:IsCode(1143291) and c:IsAbleToHand()
end
function c1143291.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(c1143291.thfilter,tp,LOCATION_REMOVED,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1143291,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				sg=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleDeck(tp)
		end
	end
end
