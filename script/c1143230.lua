--ANTI-MATTER Dark Being, Kkost
function c1143230.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143230.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c1143230.indes)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c1143230.thcon)
	e4:SetTarget(c1143230.thtg)
	e4:SetOperation(c1143230.thop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1143230,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,1143230)
	e5:SetTarget(c1143230.sptg)
	e5:SetOperation(c1143230.spop)
	c:RegisterEffect(e5)
	if not c1143230.global_check then
		c1143230.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143230))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143230.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143230.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143230.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143230.indes(e,re,rp)
	return re:GetOwner():IsSetCard(0xaf75)
end
function c1143230.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c1143230.thfilter(c)
	return c:IsSetCard(0xaf75) and c:GetCode()~=1143230 and c:IsAbleToHand()
end
function c1143230.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c1143230.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143230.thfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1143230.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c1143230.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c1143230.spfilter1(c,e,tp)
	return c:IsSetCard(0xaf75) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1143230.spfilter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp,c:GetCode())
end
function c1143230.spfilter2(c,e,tp,code)
	return c:IsSetCard(0xaf75) and c:IsLevelBelow(4) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143230.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143230.spfilter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c1143230.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c1143230.spfilter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1143230.spfilter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
