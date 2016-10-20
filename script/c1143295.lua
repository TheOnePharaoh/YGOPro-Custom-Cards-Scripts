--ANTI-MATTER Dark Being, Scirrofk
function c1143295.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143295.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143295,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1143295.spcost)
	e3:SetTarget(c1143295.sptg)
	e3:SetOperation(c1143295.spop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143295,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,1143295)
	e4:SetCondition(c1143295.drcon)
	e4:SetTarget(c1143295.drtg)
	e4:SetOperation(c1143295.drop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1143295,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,1143295)
	e5:SetTarget(c1143295.thtg)
	e5:SetOperation(c1143295.thop)
	c:RegisterEffect(e5)
	if not c1143295.global_check then
		c1143295.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143295))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143295.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143295.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143295.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143295.remcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDiscardable()
end
function c1143295.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143295.remcostfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c1143295.remcostfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c1143295.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1143295.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c1143295.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143295.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143295.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c1143295.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c1143295.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1143295.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1143295.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():IsLocation(LOCATION_REMOVED) and r==REASON_SYNCHRO
end
function c1143295.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143295.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1143295.thfilter(c)
	return c:IsSetCard(0xaf75) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c1143295.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143295.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c1143295.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1143295.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
