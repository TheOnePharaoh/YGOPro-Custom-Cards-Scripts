--Lizardfolk Swamp
function c20161999.initial_effect(c)
	c:SetUniqueOnField(1,0,20161999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c20161999.target)
	e1:SetOperation(c20161999.activate)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20161999,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c20161999.postg)
	e2:SetOperation(c20161999.posop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20161999,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1)
	e3:SetCondition(c20161999.tdcon)
	e3:SetTarget(c20161999.tdtg)
	e3:SetOperation(c20161999.tdop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20161999,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c20161999.spcon)
	e4:SetTarget(c20161999.sptg)
	e4:SetOperation(c20161999.spop)
	c:RegisterEffect(e4)
end
function c20161999.posfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_REPTILE)
end
function c20161999.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c20161999.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c20161999.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c20161999.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c20161999.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20161999.posfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c20161999.posfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c20161999.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20161999.posfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
end
function c20161999.tdfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xab90) or c:IsPreviousSetCard(0xab91) or c:IsPreviousSetCard(0xab92)
end
function c20161999.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20161999.tdfilter,1,nil)
end
function c20161999.filter2(c)
	return c:IsAbleToDeck()
end
function c20161999.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c20161999.filter2(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20161999.filter2,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c20161999.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c20161999.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and not e:GetHandler():IsReason(REASON_RULE) and rp==1-tp
end
function c20161999.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161999.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20161999.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c20161999.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20161999.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
