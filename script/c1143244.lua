--ANTI-MATTER Twisted Being, Kkhajr
function c1143244.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1143244.efilter)
	c:RegisterEffect(e1)
	--base attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c1143244.atkval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1143244.spcost)
	e3:SetTarget(c1143244.sptg)
	e3:SetOperation(c1143244.spop)
	c:RegisterEffect(e3)
	--Self Synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143244,0))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCountLimit(1,1143244)
	e4:SetCondition(c1143244.syncon)
	e4:SetTarget(c1143244.syntg)
	e4:SetOperation(c1143244.synop)
	c:RegisterEffect(e4)
	if not c1143244.global_check then
		c1143244.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143244))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143244.efilter(e,re,rp,c)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c1143244.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143244.atkval(e,c)
	return Duel.GetMatchingGroupCount(c1143244.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*500
end
function c1143244.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1143244.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function c1143244.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c1143244.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143244.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1143244.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	local ct=Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c1143244.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143244.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c1143244.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c1143244.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c1143244.synfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lv+clv)
end
function c1143244.synfilter(c,e,tp,lv)
	return c:IsCode(1143289) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143244.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143244.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c1143244.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c1143244.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143244.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c1143244.synfilter,tp,LOCATION_REMOVED,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
