--ANTI-MATTER Being, Kostartr
function c1143225.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0xaf75),1)
	c:EnableReviveLimit()
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143225,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c1143225.effop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143225,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTarget(c1143225.rmtg)
	e2:SetOperation(c1143225.rmop)
	c:RegisterEffect(e2)
	--Self Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143225,5))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCountLimit(1,1143225)
	e3:SetCondition(c1143225.spcon)
	e3:SetTarget(c1143225.sptg)
	e3:SetOperation(c1143225.spop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143225,3))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,1143225)
	e4:SetCondition(c1143225.sumcon)
	e4:SetTarget(c1143225.sumtg)
	e4:SetOperation(c1143225.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	if not c1143225.global_check then
		c1143225.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143225))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143225.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143225.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143225.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143225.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143225.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c1143225.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c1143225.sfilter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct1>ct2 then ct1=ct2 end
	if ct1==0 then return end
	local t={}
	for i=1,ct1 do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1143225,2))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local g=Duel.GetDecktopGroup(1-tp,ac)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c1143225.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143225.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c1143225.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c1143225.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c1143225.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lv+clv)
end
function c1143225.spfilter(c,e,tp,lv)
	return c:IsCode(1143225) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143225.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143225.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c1143225.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c1143225.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143225.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c1143225.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
function c1143225.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1143225.specfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143225.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143225.specfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143225.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c1143225.specfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	tc=g:GetNext()
	if ft>1 and tc and Duel.SelectYesNo(tp,aux.Stringid(1143225,4)) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end